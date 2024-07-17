public with sharing class Case_Trigger_Handler {

    private TriggerOperation operationType;

    public Case_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Case> cases) {
        Boolean result = true;
        if (cases != null) {
            for (Case c : cases) {
                if (String.isBlank(c.Subject)) {
                    c.Subject.addError(System.Label.CASE_SUBJECT_IS_REQUIRED);
                    result = false;
                }
            }
        }
        if (result == false) {
            if (SYS_UTILS.isBatch() || SYS_UTILS.isTest()) {
                throw new SYS_UTILS.SYS_EXCEPTION(System.Label.CASE_RECORD_DATA_IS_NOT_VALID);
            }
        }
        return result;
    }

    public void run(List<Case> oldCases, List<Case> newCases, Map<Id,Case> oldMap, Map<Id,Case> newMap) {
        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {
                updateParentAccounts(oldCases, newCases, oldMap, newMap);
                setPrimaryContact(oldCases, newCases, oldMap, newMap);
            }
            when AFTER_UPDATE {
                updateParentAccounts(oldCases, newCases, oldMap, newMap);
                setPrimaryContact(oldCases, newCases, oldMap, newMap);
            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }
        }
        updateProcessedRecordIds(this.operationType, oldCases, newCases);
    }

    private void updateParentAccounts(List<Case> oldCases, List<Case> newCases, Map<Id,Case> oldMap, Map<Id,Case> newMap) {

        Map<Id,Account> parentAccounts = new Map<Id,Account>();

        Map<Id,Integer> accountSummary = new Map<Id,Integer>();
        for (AggregateResult agr : [SELECT AccountId, COUNT(Id) cases
                                      FROM Case
                                     WHERE AccountId IN :accountIds(newCases)
                                       AND Status LIKE '%Closed%'
                                  GROUP BY AccountId

        ]) {
            Id accountId = String.valueOf(agr.get('AccountId'));
            Integer cases = Integer.valueOf(agr.get('cases'));
            accountSummary.put(accountId, cases);
        }

        for (Case c : [SELECT Id,
                              AccountId
                         FROM Case
                        WHERE AccountId IN :accountIds(newCases)
                          AND Status LIKE '%Closed%'
        ]) {
            if (!alreadyInvoked(this.operationType, c.Id)) {
                if (c.AccountId != null) {
                    accountSummary.put(c.AccountId, nvl(accountSummary.get(c.AccountId), 0) + 1);
                }
            }
        }

        for (Id accountId : accountSummary.keySet()) {
            parentAccounts.put(accountId, new Account(Id=accountId, Rating=accountRating(accountSummary.get(accountId))));
        }

        if (!parentAccounts.isEmpty()) {
            DB_UTILS.upd(parentAccounts.values());
        }
    }

    private void setPrimaryContact(List<Case> oldCases, List<Case> newCases, Map<Id,Case> oldMap, Map<Id,Case> newMap) {
        Map<Id,Account> accountsMap = new Map<Id,Account>([SELECT Id, PrimaryContact__c
                                                             FROM Account
                                                            WHERE Id IN :accountIds(newCases)
        ]);

        Map<Id,Contact> contactsMap = new Map<Id,Contact>();
        for (AggregateResult agr : [SELECT Id,
                                           AccountId,
                                           MAX(CreatedDate) MostRecentContact
                                      FROM Contact
                                     WHERE AccountId IN :accountIds(newCases)
                                  GROUP BY Id, AccountId
        ]) {
            Id accountId = (Id)(agr.get('AccountId'));
            Id contactId = (Id)(agr.get('Id'));
            contactsMap.put(accountId, new Contact(Id=contactId, AccountId=accountId));
        }

        Set<Id> updatedAccountIds = new Set<Id>();
        Set<Id> primaryContactIds = new Set<Id>();

        if (newCases != null) {
            for (Case c : newCases) {
                if (!alreadyInvoked(this.operationType, c.Id)) {
                    if (c.AccountId != null) {
                        if (accountsMap.containsKey(c.AccountId)) {
                            if (contactsMap.containsKey(c.AccountId)) {
                                Account account = accountsMap.get(c.AccountId);
                                Contact contact = contactsMap.get(c.AccountId);
                                if (account.PrimaryContact__c == null) {
                                    account.PrimaryContact__c = contact.Id;
                                    accountsMap.put(account.Id, account);
                                    updatedAccountIds.add(account.Id);
                                    primaryContactIds.add(contact.Id);
                                }
                            }
                        }
                    }
                }
            }
        }

        accountsMap = filterAccounts(accountsMap, updatedAccountIds);
        contactsMap = filterContacts(contactsMap, primaryContactIds);

        if (!accountsMap.isEmpty()) {
            DB_UTILS.upd(accountsMap.values());
            DB_UTILS.ins(createEvents(contactsMap, newCases));
        }
    }

    private Set<Id> accountIds(List<Case> cases) {
        Set<Id> results = new Set<Id>();
        if (cases != null) {
            for (Case c : cases) {
                if (c.AccountId != null) {
                    if (!results.contains(c.AccountId)) {
                        results.add(c.AccountId);
                    }
                }
            }
        }
        return results;
    }

    private Boolean alreadyInvoked(TriggerOperation to, Id caseId) {
        return Case_Trigger_Recursion.alreadyInvoked(to, caseId);
    }

    private String accountRating(Integer closedCases) {
        String result = '';
        if (closedCases > 100000) { result = 'Platinum'; } else
        if (closedCases > 10000 ) { result = 'Gold';     } else
        if (closedCases > 1000  ) { result = 'Silver';   } else
        if (closedCases > 100   ) { result = 'Bronze';   } else
        if (closedCases > 10    ) { result = 'Standard'; }
        return result;
    }

    private List<Event> createEvents(Map<Id,Contact> contactsMap, List<Case> cases) {
        List<Event> events = new List<Event>();
        if (cases != null) {
            for (Case c : cases) {
                if (c.AccountId != null) {
                    if (contactsMap.containsKey(c.AccountId)) {
                        Event e = new Event(
                            Subject = c.Subject,
                            WhoId = contactsMap.get(c.AccountId).Id,
                            StartDateTime = Datetime.now().addDays(30),
                            EndDateTime = Datetime.now().addDays(30).addHours(4)
                        );
                        events.add(e);
                    }
                }
            }
        }
        return events;
    }

    private Map<Id,Account> filterAccounts(Map<Id,Account> accountsMap, Set<Id> accountIds) {
        Map<Id,Account> results = new Map<Id,Account>();
        if (accountsMap != null) {
            for (Account a : accountsMap.values()) {
                if (accountIds.contains(a.Id)) {
                    if (!results.containsKey(a.Id)) {
                        results.put(a.Id, a);
                    }
                }
            }
        }
        return results;
    }

    private Map<Id,Contact> filterContacts(Map<Id,Contact> contactsMap, Set<Id> contactIds) {
        Map<Id,Contact> results = new Map<Id,Contact>();
        if (contactsMap != null) {
            for (Contact c : contactsMap.values()) {
                if (contactIds.contains(c.Id)) {
                    if (!results.containsKey(c.Id)) {
                        results.put(c.Id, c);
                    }
                }
            }
        }
        return results;
    }

    private void updateProcessedRecordIds(TriggerOperation to, List<Case> oldCases, List<Case> newCases) {
        Case_Trigger_Recursion.updateProcessedRecordIds(to, oldCases, newCases);
    }

    private Integer nvl(Integer i, Integer defaultValue) {
        return ((i != null) ? i : defaultValue);
    }
}
public with sharing class Case_Trigger_Handler2 {

    private TriggerOperation operationType;

    public Case_Trigger_Handler2(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Case> cases) {
        Boolean result = true;
        if (cases != null) {
            for (Case c : cases) {
                if (String.isBlank(c.CaseNumber)) {
                    c.CaseNumber.addError(System.Label.CASE_NUMBER_IS_REQUIRED);
                    result = false;
                }
            }
        }
        if (result == false) {
            if (SYS_UTILS.isBatch() || SYS_UTILS.isTest()) {
                throw new SYS_UTILS.CONTACT_TRIGGER_EXCEPTION(System.Label.CASE_RECORD_DATA_IS_NOT_VALID);
            }
        }
        return result;
    }

    public void run(List<Case> oldCases, List<Case> newCases, Map<Id,Case> oldMap, Map<Id,Case> newMap) {
        switch on this.operationType {
            when AFTER_INSERT {
                setPrimaryContact(oldCases, newCases, oldMap, newMap);
            }
            when AFTER_UPDATE {
                setPrimaryContact(oldCases, newCases, oldMap, newMap);
            }
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
 
        accountsMap = (Map<Id,Account>)filter(accountsMap, updatedAccountIds);
        contactsMap = (Map<Id,Contact>)filter(contactsMap, primaryContactIds);

        if (!accountsMap.isEmpty()) {
            DB_UTILS.upd(accountsMap.values());
            createEvents(contactsMap, newCases);
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

    private void createEvents(Map<Id,Contact> contactsMap, List<Case> cases) {
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
        if (!events.isEmpty()) {
            DB_UTILS.ins(events);
        }
    }

    private Map<Id,sObject> filter(Map<Id,sObject> recordsMap, Set<Id> recordIds) {
        Map<Id,sObject> results = new Map<Id,sObject>();
        if (recordsMap != null) {
            for (sObject o : recordsMap.values()) {
                if (recordIds.contains(o.Id)) {
                    if (!results.containsKey(o.Id)) {
                        results.put(o.Id, o);
                    }
                }
            }
        }
        return results;
    }
}
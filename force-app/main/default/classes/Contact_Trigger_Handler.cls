public with sharing class Contact_Trigger_Handler {

    private TriggerOperation operationType;

    public Contact_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Contact> contacts) {

        Boolean result = true;

        if (contacts != null) {
            for (Contact c : contacts) {
                if (c.LastName == null) {
                    c.LastName.addError(System.Label.CONTACT_LAST_NAME_IS_REQUIRED);
                    result = false;
                }
                if (c.Phone == null) {
                    c.Phone.addError(System.Label.CONTACT_PHONE_NUMBER_IS_REQUIRED);
                    result = false;
                }
            }
        }

        return result;
    }

    public void run(List<Contact> oldContacts, List<Contact> newContacts, Map<Id,Contact> oldMap, Map<Id,Contact> newMap) {

        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {
                updateParentAccountDescriptions(oldContacts, newContacts, oldMap, newMap);
                updateParentAccountSummaryFields(oldContacts, newContacts, oldMap, newMap);
            }
            when AFTER_UPDATE {
                updateParentAccountDescriptions(oldContacts, newContacts, oldMap, newMap);
            }
            when AFTER_DELETE {
                updateParentAccountSummaryFields(oldContacts, newContacts, oldMap, newMap);
            }
            when AFTER_UNDELETE {
                updateParentAccountSummaryFields(oldContacts, newContacts, oldMap, newMap);
            }
        }
    }

    private void updateParentAccountDescriptions(List<Contact> oldContacts, List<Contact> newContacts, Map<Id,Contact> oldMap, Map<Id,Contact> newMap) {

        List<Account> accounts = new List<Account>();

        Map<Id,Account> accountsMap = new Map<Id,Account>([SELECT Id,
                                                                  Name,
                                                                  Description
                                                             FROM Account
                                                            WHERE Id IN :accountIds(newContacts)
        ]);

        if (newContacts != null) {
            for (Contact c : newContacts) {
                if (newMap.get(c.Id).Description != ((oldMap != null) ? oldMap.get(c.Id).Description : null)) {
                    if (c.AccountId != null) {
                        if (newMap.get(c.Id).Description != accountsMap.get(c.AccountId).Description) {
                            accounts.add(new Account(Id = c.AccountId, Description = c.Description));
                        }
                    }
                }
            }
        }

        if (!accounts.isEmpty()) {
            update accounts;
        }
    }

    private void updateParentAccountSummaryFields(List<Contact> oldContacts, List<Contact> newContacts, Map<Id,Contact> oldMap, Map<Id,Contact> newMap) {

        List<Account> accounts = new List<Account>();

        List<Contact> contacts = ((String.valueOf(this.operationType) == 'AFTER_DELETE') ? oldContacts.clone() : newContacts.clone());
        Map<Id,Account> accountsMap = new Map<Id,Account>([SELECT Id,
                                                                  Name,
                                                                  TotalContacts__c
                                                             FROM Account
                                                            WHERE ID IN :accountIds(contacts)
        ]);

        Set<Id> duplicateAccountIds = new Set<Id>();
        if (contacts != null) {
            for (Contact c : contacts) {
                if (c.AccountId != null && !duplicateAccountIds.contains(c.AccountId)) {
                    duplicateAccountIds.add(c.AccountId);
                    Account a = accountsMap.get(c.AccountId);
                    switch on this.operationType {
                        when AFTER_INSERT {
                            a.TotalContacts__c = nvl(accountsMap.get(c.AccountId).TotalContacts__c, 0) + 1;
                        }
                        when AFTER_DELETE {
                            a.TotalContacts__c = nvl(accountsMap.get(c.AccountId).TotalContacts__c, 0) - 1;
                        }
                        when AFTER_UNDELETE {
                            a.TotalContacts__c = nvl(accountsMap.get(c.AccountId).TotalContacts__c, 0) + 1;
                        }
                    }
                    a.TotalContacts__c = ((nvl(a.TotalContacts__c, 0) < 0) ? 0 : a.TotalContacts__c);
                    accounts.add(a);
                }
            }
        }

        if (!accounts.isEmpty()) {
            update accounts;
        }
    }

    private Set<Id> accountIds(List<Contact> contacts) {

        Set<Id> results = new Set<Id>();

        if (contacts != null) {
            for (Contact c : contacts) {
                if (c.AccountId != null) {
                    if (!results.contains(c.AccountId)) {
                        results.add(c.AccountId);
                    }
                }
            }
        }

        return results;
    }

    private Decimal nvl(Decimal n, Integer defaultValue) {
        return ((n == null) ? defaultValue : n);
    }
}
public with sharing class Contact_Trigger_Handler {

    private TriggerOperation operationType;

    public Contact_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Contact> contacts) {
        Boolean result = true;
        if (contacts != null) {
            for (Contact c : contacts) {
                if (String.isBlank(c.LastName)) {
                    c.LastName.addError(System.Label.CONTACT_LAST_NAME_IS_REQUIRED);
                    result = false;
                }
                if (String.isBlank(c.Phone)) {
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
                summarizeParentAccountFields(oldContacts, newContacts, oldMap, newMap);
            }
            when AFTER_UPDATE {
                updateParentAccountDescriptions(oldContacts, newContacts, oldMap, newMap);
            }
            when AFTER_DELETE {
                summarizeParentAccountFields(oldContacts, newContacts, oldMap, newMap);
            }
            when AFTER_UNDELETE {
                summarizeParentAccountFields(oldContacts, newContacts, oldMap, newMap);
            }
        }
        updateProcessedRecordIds((newContacts != null ? newContacts : (oldContacts != null ? oldContacts : null)));
    }

    private void updateParentAccountDescriptions(List<Contact> oldContacts, List<Contact> newContacts, Map<Id,Contact> oldMap, Map<Id,Contact> newMap) {

        Map<Id,Account> accountsMap = new Map<Id,Account>([SELECT Id,
                                                                  Description
                                                             FROM Account
                                                            WHERE Id IN :accountIds(newContacts)
        ]);

        if (newContacts != null) {
            for (Contact c : newContacts) {
                if (!alreadyInvoked(this.operationType, c.Id)) {
                    if (c.AccountId != null) {
                        Contact oldContact = ((oldMap != null) ? oldMap.get(c.Id) : new Contact(Id=c.Id));
                        Contact newContact = ((newMap != null) ? newMap.get(c.Id) : new Contact(Id=c.Id));
                        if (newContact.Description != oldContact.Description) {
                            if (newContact.Description != accountsMap.get(c.AccountId).Description) {
                                if (newContact.Description != null) {
                                    accountsMap.put(c.AccountId, new Account(Id=c.AccountId, Description=c.Description));
                                }
                            }
                        }
                    }
                }
            }
        }

        if (!accountsMap.isEmpty()) {
            update accountsMap.values();
        }
    }

    private void summarizeParentAccountFields(List<Contact> oldContacts, List<Contact> newContacts, Map<Id,Contact> oldMap, Map<Id,Contact> newMap) {

        Map<Id,Account> accountsMap = new Map<Id,Account>([SELECT Id,
                                                                  TotalContacts__c
                                                             FROM Account
                                                            WHERE Id IN :accountIds(nvl(newContacts, oldContacts))
        ]);

        for (Contact c : nvl(newContacts, oldContacts)) {
            if (c.AccountId != null) {
                if (accountsMap.containsKey(c.AccountId)) {
                    accountsMap.put(c.AccountId, summarize(accountsMap.get(c.AccountId)));
                }
            }
        }

        if (!accountsMap.isEmpty()) {
            update accountsMap.values();
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

    private Boolean alreadyInvoked(TriggerOperation to, Id contactId) {
        Boolean result = false;
        if (Contact_Trigger_Recursion.PROCESSED_RECORD_IDS != null) {
            if (Contact_Trigger_Recursion.PROCESSED_RECORD_IDS.containsKey(to)) {
                result = Contact_Trigger_Recursion.PROCESSED_RECORD_IDS.get(to).contains(contactId);
            }
        }
        return result;
    }

    private Account summarize(Account a) {
        Account result = new Account();
        result.Id = a.Id;
        result.TotalContacts__c = nvl(a.TotalContacts__c, 0);
        result.TotalContacts__c += ((this.operationType == TriggerOperation.AFTER_DELETE) ? -1 : 1);
        result.TotalContacts__c = ((result.TotalContacts__c < 0) ? 0 : result.TotalContacts__c);
        return result;
    }

    private void updateProcessedRecordIds(List<Contact> contacts) {
        if (contacts != null) {
            List<Id> contactIds = nvl(Contact_Trigger_Recursion.PROCESSED_RECORD_IDS.get(this.operationType));
            for (Contact c : contacts) {
                if (c.Id != null) {
                    if (!contactIds.contains(c.Id)) {
                        contactIds.add(c.Id);
                        Contact_Trigger_Recursion.PROCESSED_RECORD_IDS.put(this.operationType, contactIds);
                    }
                }
            }
        }
    }

    private List<Id> nvl(List<Id> recordIds) {
        return ((recordIds != null) ? recordIds : new List<Id>());
    }

    private List<Contact> nvl(List<Contact> newContacts, List<Contact> oldContacts) {
        return ((this.operationType == TriggerOperation.AFTER_DELETE) ? oldContacts : newContacts);
    }

    private Decimal nvl(Decimal n, Integer defaultValue) {
        return ((n != null) ? n : Decimal.valueOf(defaultValue));
    }
}
public with sharing class Account_Trigger_Handler {

    TriggerOperation operationType;

    public Account_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Account> accounts) {

        Boolean result = true;

        if (accounts != null) {
            for (Account a : accounts) {
                if (a.Name == null) {
                    a.Name.addError(System.Label.ACCOUNT_NAME_IS_REQUIRED);
                    result = false;
                }
                if (a.Phone == null) {
                    a.Phone.addError(System.Label.ACCOUNT_PHONE_NUMBER_IS_REQUIRED);
                    result = false;
                }
            }
        }

        return true;
    }

    public void run(List<Account> oldAccounts, List<Account> newAccounts, Map<Id,Account> oldMap, Map<Id,Account> newMap) {

        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {

            }
            when AFTER_UPDATE {
                updateChildContacts(oldAccounts, newAccounts, oldMap, newMap);
            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }
        }
    }

    private void updateChildContacts(List<Account> oldAccounts, List<Account> newAccounts, Map<Id,Account> oldMap, Map<Id,Account> newMap) {

        List<Contact> contacts = new List<Contact>();

        for (Contact c : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds(newAccounts)]) {
            if (newMap.get(c.AccountId).Phone != oldMap.get(c.AccountId).Phone) {
                c.Phone = newMap.get(c.AccountId).Phone;
                contacts.add(c);
            }
        }

        if (!contacts.isEmpty()) {
            update contacts;
        }
    }

    private Set<Id> accountIds(List<Account> accounts) {

        Set<Id> results = new Set<Id>();

        if (accounts != null) {
            for (Account a : accounts) {
                if (!results.contains(a.Id)) {
                    results.add(a.Id);
                }
            }
        }

        return results;
    }
}
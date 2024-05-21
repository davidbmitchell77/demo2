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
                updateChildContacts(oldAccounts, newAccounts, oldMap, newMap);
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

        for (Contact c : [SELECT Id, Description, AccountId FROM Contact WHERE AccountId IN :accountIds(newAccounts)]) {
            if (newMap.get(c.AccountId).Description != getDescription(oldMap, c.AccountId)) {
                c.Description = newMap.get(c.AccountId).Description;
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

    private String getDescription(Map<Id,Account> accountsMap, Id accountId) {

        String result = null;

        if (accountsMap != null) {
            if (accountsMap.containsKey(accountId)) {
                result = accountsMap.get(accountId).Description;
            }
        }

        return result;
    }
}
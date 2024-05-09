public with sharing class Account_Trigger_Handler {

    private System.TriggerOperation operationType;

    public Account_Trigger_Handler(System.TriggerOperation operationType) {
        this.operationType = operationType;
    }

    public Boolean isValid(List<Account> accounts) {
        Boolean result = true;
        return result;
    }

    public void run(List<Account> oldAccounts, List<Account> newAccounts, Map<Id,Account> oldMap, Map<Id,Account> newMap) {
        switch on operationType {
            when BEFORE_DELETE {
                resetRelatedContactAccountIds(oldAccounts, newAccounts, oldMap, newMap);
            }
            when AFTER_UPDATE {
                updateRelatedContacts(oldAccounts, newAccounts, oldMap, newMap);
            }
        }
    }

    public void resetRelatedContactAccountIds(List<Account> oldAccounts, List<Account> newAccounts, Map<Id,Account> oldMap, Map<Id,Account> newMap) {

        List<Contact> contacts = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId IN :oldMap.keySet()];

        for (Contact c : contacts) {
            c.AccountId = null;
        }

        if (!contacts.isEmpty()) {
            update contacts;
        }
    }

    public void updateRelatedContacts(List<Account> oldAccounts, List<Account> newAccounts, Map<ID,Account> oldMap, Map<ID,Account> newMap) {

        List<Contact> contacts = [SELECT Id, Name, AccountId, Phone, Fax FROM Contact WHERE AccountId IN :newMap.keySet()];

        for (Contact c : contacts) {
            c.Phone = newMap.get(c.AccountId).Phone;
            c.Fax = newMap.get(c.AccountId).Fax;
        }

        if (!contacts.isEmpty()) {
            update contacts;
        }
    }    
}
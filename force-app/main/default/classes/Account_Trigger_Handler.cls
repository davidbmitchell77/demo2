public with sharing class Account_Trigger_Handler {

    private TriggerOperation operationType;

    public Account_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Account> accounts) {
        Boolean result = true;
        if (accounts != null) {
            for (Account a : accounts) {
                if (String.isBlank(a.Name)) {
                    a.Name.addError(System.Label.ACCOUNT_NAME_IS_REQUIRED);
                    result = false;
                }
                if (String.isBlank(a.Phone)) {
                    a.Phone.addError(System.Label.ACCOUNT_PHONE_NUMBER_IS_REQUIRED);
                    result = false;
                }
            }
        }
        if (result == false) {
            if (SYS_UTILS.isBatch() || SYS_UTILS.isTest()) {
                throw new SYS_UTILS.SYS_EXCEPTION(System.Label.ACCOUNT_DATA_IS_NOT_VALID);
            }
        }
        return result;
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
        updateProcessedRecordIds((newAccounts != null ? newAccounts : (oldAccounts != null ? oldAccounts : null)));
    }

    private void updateChildContacts(List<Account> oldAccounts, List<Account> newAccounts, Map<Id,Account> oldMap, Map<Id,Account> newMap) {

        List<Contact> contacts = new List<Contact>();

        for (Contact c : [SELECT Id,
                                 AccountId,
                                 Phone
                            FROM Contact
                           WHERE AccountId IN :accountIds(newAccounts)
        ]) {
            if (!alreadyInvoked(this.operationType, c.Id)) {
                Account oldAccount = ((oldMap != null) ? oldMap.get(c.AccountId) : new Account(Id=c.AccountId, Phone=null));
                Account newAccount = ((newMap != null) ? newMap.get(c.AccountId) : new Account(Id=c.AccountId, Phone=null));
                if (newAccount.Phone != oldAccount.Phone) {
                    c.Phone = newAccount.Phone;
                    contacts.add(c);
                }
            }
        }

        if (!contacts.isEmpty()) {
            DB_UTILS.upd(contacts);
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

    private Boolean alreadyInvoked(TriggerOperation to, Id accountId) {
        Boolean result = false;
        if (Account_Trigger_Recursion.PROCESSED_RECORD_IDS != null) {
            if (Account_Trigger_Recursion.PROCESSED_RECORD_IDS.containsKey(to)) {
                result = Account_Trigger_Recursion.PROCESSED_RECORD_IDS.get(to).contains(accountId);
            }
        }
        return result;
    }

    private void updateProcessedRecordIds(List<Account> accounts) {
        if (accounts != null) {
            List<Id> accountIds = nvl(Account_Trigger_Recursion.PROCESSED_RECORD_IDS.get(this.operationType));
            for (Account a : accounts) {
                if (a.Id != null) {
                    if (!accountIds.contains(a.Id)) {
                        accountIds.add(a.Id);
                        Account_Trigger_Recursion.PROCESSED_RECORD_IDS.put(this.operationType, accountIds);
                    }
                }
            }
        }
    }

    private List<Id> nvl(List<Id> recordIds) {
        return ((recordIds != null) ? recordIds : new List<Id>());
    }
}
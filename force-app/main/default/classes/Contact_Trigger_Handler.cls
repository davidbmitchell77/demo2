public with sharing class Contact_Trigger_Handler {

    private System.TriggerOperation operationType;

    public Contact_Trigger_Handler(System.TriggerOperation operationType) {
        this.operationType = operationType;
    }

    public void run(List<Contact> oldContacts, List<Contact> newContacts, Map<Id,Contact> oldMap, Map<Id,Contact> newMap) {

        switch on operationType
        {
            when BEFORE_INSERT, BEFORE_UPDATE {
                synchPhoneNumbers(oldContacts, NewContacts, oldMap, newMap);
            }
            when AFTER_INSERT, AFTER_UPDATE {
                createRelatedRecords(oldContacts, newContacts, oldMap, newMap);
            }
        }
    }

    public void createRelatedRecords(List<Contact> oldContacts, List<Contact> newContacts, Map<Id,Contact> oldMap, Map<Id,Contact> newMap) {

        Boolean createNote = false;
        List<Note> notes = new List<Note>();

        for (Contact contact : newContacts) {
            if (contact.Phone > '') {
                if (String.valueOf(operationType) == 'AFTER_INSERT') {
                    createNote = true;
                }
                if (String.valueOf(operationType) == 'AFTER_UPDATE') {
                    if (newMap.get(contact.Id).Account.Phone == oldMap.get(contact.Id).Account.Phone) {
                        createNote = true;
                    }
                }
            }
        }

        if (createNote == true) {
            Note n = new Note();
            n.ParentId = contact.Id;
            n.Title = 'Synchronization Note';
            n.Body = 'This contact\'s account information has been synchronized by phone number.';
            notes.add(n);
        }

        if (!notes.isEmpty()) {
            insert notes;
        }
    }

    public void synchPhoneNumbers(List<Contact> oldContacts, List<Contact> newContacts, Map<Id,Contact> oldMap, Map<Id,Contact> newMap) {

        Set<String> phoneNumbers = new Set<String>();
        for (Contact newContact : newContacts) {
          phoneNumbers.add(newContact.Phone);
        }

        Map<String, Account> accounts = new Map<String, Account>();
        for (Account a : matchingAccounts(phoneNumbers)) {
            accounts.put(a.Phone, a);
        }

        for (Contact c : newContacts) {
            c.Description = null;
            if (c.Phone > '') {
                if (accounts.containsKey(c.Phone)) {
                    if (c.AccountId != accounts.get(c.Phone).Id) {
                        c.AccountId = accounts.get(c.Phone).Id;
                        c.Description = 'This contact\'s account information has been synchronized by phone number.';
                    }
                }
            }
        }
    }

    public Boolean isValid(List<Contact> newContacts) {
        Boolean result = true;
        for (Contact c : newContacts) {
            switch on ((c.Phone == null) ? null : c.Phone.trim()) {
                when null {
                    c.addError('Phone', 'Phone number is required.');
                    result = false;
                }
            }
        }
        return result;
    }

    private List<Account> matchingAccounts(Set<String> phoneNumbers) {
        return [SELECT Id,
                       Name,
                       Phone
                  FROM Account
                 WHERE Phone IN :phoneNumbers
                  WITH SECURITY_ENFORCED
                 LIMIT 2000
        ];
    }
}
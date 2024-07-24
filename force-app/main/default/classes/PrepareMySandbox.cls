global class PrepareMySandbox implements SandboxPostCopy {

    private final Integer maxQuerySize = 50000;
    private Map<String,Account> accountsMap = new Map<String,Account>();

    global PrepareMySandbox() {
    }

    global void runApexClass(SandboxContext context) {
        try {
            insertAccounts();
            insertContacts();
        }
        catch(Exception e) {
            Logger.error(e.getMessage()).addTag('PrepareMySandbox').addTag('runApexClass');
            Logger.saveLog();
            throw new SYS_UTILS.APEX_EXCEPTION(e.getMessage());
        }
    }

    private void insertAccounts() {
        List<Account> accounts = new List<Account>();
        StaticResource accountStaticResource = [SELECT Body
                                                  FROM StaticResource
                                                 WHERE Name = 'Account_csv'
        ];
        String accountCsv = String.valueOf(accountStaticResource.Body);
        for (String row : accountCsv.split('\n')) {
            String[] columns = row.split(',');
            Account a = new Account(
                Name         = columns[0],
                BillingState = columns[1],
                Phone        = columns[2],
                Type         = columns[3]
            );
            if (!String.isBlank(a.Name)) {
                accounts.add(a);
            }
        }
        if (!accounts.isEmpty()) {
            DB_UTILS.ins(accounts);
            this.accountsMap = getAccountsMap();
        }
    }

    private void insertContacts() {
        List<Contact> contacts = new List<Contact>();
        StaticResource contactStaticResource = [SELECT Body
                                                  FROM StaticResource
                                                 WHERE Name = 'Contact_csv'
        ];
        String contactCsv = String.valueOf(contactStaticResource.Body);
        for (String row : contactCsv.split('\n')) {
            String[] columns = row.split(',');
            Contact c = new Contact(
                FirstName = columns[0],
                LastName  = columns[1],
                AccountId = getAccountId(columns[2]),
                Title     = columns[3],
                Phone     = columns[4],
                Email     = columns[5]
            );
            if (c.AccountId != null) {
                contacts.add(c);
            }
        }
        if (!contacts.isEmpty()) {
            DB_UTILS.ins(contacts);
        }
    }

    private Id getAccountId(String accountName) {
        Id result = null;
        if (!String.isBlank(accountName)) {
            if (this.accountsMap.containsKey(accountName)) {
                result = this.accountsMap.get(accountName).Id;
            }
        }
        return result;
    }

    private Map<String,Account> getAccountsMap() {
        Map<String,Account> results = new Map<String,Account>();
        for (Account a : [SELECT Id, Name
                            FROM Account
                           WHERE CreatedDate = LAST_N_DAYS:1
                             AND CreatedById = :UserInfo.getUserId()
                        ORDER BY Id DESC
                           LIMIT :maxQuerySize
        ]) {
            if (!String.isBlank(a.Name)) {
                if (!accountsMap.containsKey(a.Name)) {
                    accountsMap.put(a.Name, a);
                }
            }
        }
        return results;
    }
}
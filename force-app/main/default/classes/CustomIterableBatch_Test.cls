@isTest
private class CustomIterableBatch_Test {

    @isTest
    private static void testMethod01() {
        List<Account> accounts = new List<Account>();
        for (Integer i=0; i<200; i++)
        {
            Account a = new Account();
            a.Name = 'Test Account ' + i;
            a.Phone = '(555) 555-5555 x' + i;
            accounts.add(a);
        }
        insert accounts;
        List<Contact> contacts = new List<Contact>();
        for (Integer i=0; i<accounts.size(); i++)
        {
            Contact c = new Contact();
            c.FirstName = 'TestMethod01';
            c.LastName = 'Account_Trigger_Test ' + i;
            c.Phone = '(555) 555-5555 x' + i;
            c.AccountId = accounts[i].Id;
            contacts.add(c);
        }
        insert contacts;
        Test.startTest();
        String jobId = Database.executeBatch(new CustomIterableBatch(), 200);
        Test.stopTest();
        System.assertEquals(200, [SELECT Id, (SELECT AccountId FROM Contacts) FROM Account].size());
        System.assertEquals(200, [SELECT Id FROM Contact].size());
    }

    @isTest
    private static void testMethod02() {
        List<Account> accounts = new List<Account>();
        for (Integer i=0; i<200; i++)
        {
            Account a = new Account();
            a.Name = null;
            a.Phone = '(555) 555-5555 x' + i;
            accounts.add(a);
        }
        List<Database.SaveResult> saveResults = Database.insert(accounts, false);
        Test.startTest();
        CustomIterableBatch cib = new CustomIterableBatch();
        for (Database.SaveResult sr : saveResults) {
            cib.logDatabaseSaveErrors(sr.getId(), sr.getErrors());
        }
        Test.stopTest();
        System.assertEquals(0, [SELECT Id, (SELECT AccountId FROM Contacts) FROM Account].size());
    }
}
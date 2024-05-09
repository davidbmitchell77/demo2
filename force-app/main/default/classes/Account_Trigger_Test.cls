@isTest
private class Account_Trigger_Test {

    @isTest
    private static void testMethod01() {
        Account a = new Account();
        a.Name = 'Test Account 01';
        a.Phone = '(555) 555-5555';
        insert a;
        Contact c = new Contact();
        c.FirstName = 'TestMethod01';
        c.LastName = 'Account_Trigger_Test';
        c.Phone = '(555) 555-5555';
        c.AccountId = a.Id;
        insert c;
        Test.startTest();
        delete [SELECT Id FROM Account WHERE Id = :a.Id];
        Test.stopTest();
        System.assertEquals(0, [SELECT Id, (SELECT AccountId FROM Contacts) FROM Account].size());
        System.assertEquals(1, [SELECT Id FROM Contact].size());
    }

    @isTest
    private static void testMethod02() {
        Account a = new Account();
        a.Name = 'Test Account 02';
        a.Phone = '(555) 555-5555';
        insert a;
        Contact c = new Contact();
        c.FirstName = 'TestMethod02';
        c.LastName = 'Account_Trigger_Test';
        c.Phone = '(555) 555-5555';
        c.AccountId = a.Id;
        insert c;
        Test.startTest();
        a.Phone = '(888) 888-8888';
        a.Fax = '(888) 888-8860';
        update a;
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Account].size());
        System.assertEquals(1, [SELECT Id FROM Contact].size());
        Contact updatedContact = [SELECT Id, Phone, Fax FROM Contact WHERE AccountId = :a.Id][0];
        System.assertEquals(a.Phone, updatedContact.Phone);
        System.assertEquals(a.Fax, updatedContact.Fax);
    }
}
@isTest
private class Account_Trigger_Test {

    @isTest
    private static void TestMethod01() {
        Account a = new Account(
            Name = 'Account_Trigger_Test.TestMethod01',
            Phone = '(111) 111-1111',
            Description = null
        );
        insert a;

        Contact c = new Contact(
            FirstName = 'TestMethod01',
            LastName = 'Account_Trigger_Test',
            Phone = '(111) 111-1111 x111',
            Email = 'TestMethod01@AccountTriggerTest.com',
            AccountId = a.Id
        );
        insert c;

        Test.startTest();
        a.Phone = '(000) 000-0000';
        update a;
        Test.stopTest();

        System.assertEquals('(000) 000-0000', [SELECT Id, Phone FROM Contact LIMIT 1].Phone);
    }

    @isTest
    private static void TestMethod02() {
        Account a = new Account(
            Name = 'Account_Trigger_Test.TestMethod02',
            Phone = '(222) 222-2222'
        );
        
        Test.startTest();
        insert a;
        a.Name = null;
        a.Phone = null;
        try {
            update a;
        } catch(DMLException e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
        Test.stopTest();

        System.assertEquals('Account_Trigger_Test.TestMethod02', [SELECT Id, Name FROM Account LIMIT 1].Name);
    }

    @isTest
    private static void TestMethod03() {
        Account a = new Account(
            Name = 'Account_Trigger_Test.TestMethod03',
            Phone = '(333) 333-3333'
        );

        Test.startTest();
        insert a;
        System.assertEquals(1, [SELECT Id, Name FROM Account].size());
        delete a;
        System.assertEquals(0, [SELECT Id, Name FROM Account].size());
        undelete [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS];
        Test.stopTest();

        System.assertEquals(1, [SELECT Id, Name FROM Account].size());
    }
}
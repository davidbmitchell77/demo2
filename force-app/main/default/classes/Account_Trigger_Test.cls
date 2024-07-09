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

        System.debug(LoggingLevel.INFO, 'Account_Trigger_Test.TestMethod01: Test.startTest()');

        Test.startTest();
        a.Phone = '(000) 000-0000';
        update a;
        Test.stopTest();

        System.debug(LoggingLevel.INFO, 'Account_Trigger_Test.TestMethod01: Test.stopTest()');
        System.assertEquals('(000) 000-0000', [SELECT Id, Phone FROM Account LIMIT 1].Phone);
    }

    @isTest
    private static void TestMethod02() {
        Account a = new Account(
            Name = 'Account_Trigger_Test.TestMethod02',
            Phone = '(222) 222-2222'
        );

        System.debug(LoggingLevel.INFO, 'Account_Trigger_Test.TestMethod02: Test.startTest()');
 
        Test.startTest();
        insert a;
        a.Name = null;
        a.Phone = null;
        try {
            update a;
        } catch(DMLException e) {
            System.debug(LoggingLevel.ERROR, 'Account_Trigger_Test.TestMethod02: ' + e.getMessage());
        }
        Test.stopTest();

        System.debug(LoggingLevel.INFO, 'Account_Trigger_Test.TestMethod02: Test.stopTest()');
        System.assertEquals('Account_Trigger_Test.TestMethod02', [SELECT Id, Name FROM Account LIMIT 1].Name);
    }

    @isTest
    private static void TestMethod03() {
        Account a = new Account(
            Name = 'Account_Trigger_Test.TestMethod03',
            Phone = '(333) 333-3333'
        );

        System.debug(LoggingLevel.INFO, 'Account_Trigger_Test.TestMethod03: Test.startTest()');

        Test.startTest();
        insert a;
        System.assertEquals(1, [SELECT Id, Name FROM Account].size());
        delete a;
        System.assertEquals(0, [SELECT Id, Name FROM Account].size());
        undelete [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS];
        Test.stopTest();
 
        System.debug(LoggingLevel.INFO, 'Account_Trigger_Test.TestMethod03: Test.stopTest()');
        System.assertEquals(1, [SELECT Id, Name FROM Account].size());
    }

    @isTest
    private static void TestMethod04() {
        Integer maxRecordIds = Integer.valueOf(TriggerSettings.getInstance('Account').MaxRecordIds__c) + 1;
        List<Account> accounts = new List<Account>();
        for (Integer i=0; i<maxRecordIds; i++) {
            Account a = new Account(
                Name = 'Account_Trigger_Test.TestMethod04 ' + i,
                Phone = '(444) 444-4444'
            );
            accounts.add(a);
        }

        System.debug(LoggingLevel.INFO, 'Account_Trigger_Test.TestMethod04: Test.startTest()');

        Test.startTest();
        insert accounts;
        List<Contact> contacts = new List<Contact>();
        for (Account a : accounts) {
            String uuid = SYS_UTILS.uuid();
            Contact c = new Contact(
                FirstName = uuid,
                LastName = 'Account_Trigger_Test',
                Phone = '(444) 444-4444',
                Email = uuid + '@AccountTriggerTest.com',
                AccountId = a.Id
            );
            contacts.add(c);
        }
        insert contacts;
        for (Account a : accounts) {
            a.Name = a.Name + '.update';
            a.Phone = '+44' + a.Phone;
        }
        update accounts;
        Test.stopTest();

        System.debug(LoggingLevel.INFO, 'Account_Trigger_Test.TestMethod04: Test.stopTest()');
        System.assertEquals(maxRecordIds, [SELECT Id, Name FROM Account].size());
    }
}
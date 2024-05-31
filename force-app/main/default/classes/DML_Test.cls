@isTest
private class DML_Test {

    @testSetup
    private static void setup() {
        User u = new User(
            Alias = 'testda',
            Email = 'testdata@dml.test.org',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'TestData',
            LastName = 'DMTTest',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Read Only'].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = ('U' + UUID.randomUUID() + '@dml.test.org')
        );
        insert u;
    }

    @isTest
    private static void TestMethod01() {
        Account a = new Account();

        Test.startTest();
        try {
            DML.ins(new List<Account>{a});
        }
        catch(Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
        Test.stopTest();

        System.assertEquals(0, [SELECT Id, Name FROM Account].size());
    }

    @isTest
    private static void TestMethod02() {
        Account a = new Account(Name='DML_Test.TestMethod02', Phone='(222) 222-2222');

        Test.startTest();
        try {
            DML.upd(new List<Account>{a});
        }
        catch(Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
        Test.stopTest();

        System.assertEquals(0, [SELECT Id, Name FROM Account].size());
    }

    @isTest
    private static void TestMethod03() {
        Account a = new Account();

        Test.startTest();
        try {
            DML.ups(new List<Account>{a});
        }
        catch(Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
        Test.stopTest();

        System.assertEquals(0, [SELECT Id, Name FROM Account].size());
    }

    @isTest
    private static void TestMethod05() {
        Account a = new Account(Name='DML_Test.TestMethod05', Phone='(555) 555-5555');
        insert a;

        User u = [SELECT FIELDS(STANDARD) FROM User WHERE Email = 'testdata@dml.test.org' LIMIT 1];

        System.runAs(u) {
            Test.startTest();
            try {
                DML.del(new List<Account>{a});
            }
            catch(Exception e) {
                System.debug(LoggingLevel.ERROR, e.getMessage());
            }
            Test.stopTest();
        }

        System.assertEquals(1, [SELECT Id, Name FROM Account].size());
    }
}
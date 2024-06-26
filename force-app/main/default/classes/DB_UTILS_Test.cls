@isTest
private class DB_UTILS_Test {

    @testSetup
    private static void setup() {
        User u = new User(
            Alias = 'testda',
            Email = 'testdata@dbutils.test.org',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'TestData',
            LastName = 'DB_UTILS_TTest',
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
            DB_UTILS.ins(new List<Account>{a});
        }
        catch(Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
        Test.stopTest();

        System.assertEquals(0, [SELECT Id, Name FROM Account].size());
    }

    @isTest
    private static void TestMethod02() {
        Account a = new Account(Name='DB_UTILS_Test.TestMethod02', Phone='(222) 222-2222');

        Test.startTest();
        try {
            DB_UTILS.upd(new List<Account>{a});
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
            DB_UTILS.ups(new List<Account>{a});
        }
        catch(Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
        Test.stopTest();

        System.assertEquals(0, [SELECT Id, Name FROM Account].size());
    }

    @isTest
    private static void TestMethod04() {
        Account a = new Account(Name='DML_Test.TestMethod05', Phone='(444) 444-4444');
        insert a;

        User u = [SELECT FIELDS(STANDARD) FROM User WHERE Email = 'testdata@dbutils.test.org' LIMIT 1];

        System.runAs(u) {
            Test.startTest();
            try {
                DB_UTILS.del(new List<Account>{a});
            }
            catch(Exception e) {
                System.debug(LoggingLevel.ERROR, e.getMessage());
            }
            Test.stopTest();
        }

        System.assertEquals(1, [SELECT Id, Name FROM Account].size());
    }

    @isTest
    private static void TestMethod05() {
        Account a = new Account(Name='DML_Test.TestMethod05', Phone='(555) 555-5555');
        insert a;

        User u = [SELECT FIELDS(STANDARD) FROM User WHERE Email = 'testdata@dbutils.test.org' LIMIT 1];

        System.runAs(u) {
            Test.startTest();
            try {
                DB_UTILS.del(new List<Account>{a});
                DB_UTILS.und([SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS]);
            }
            catch(Exception e) {
                System.debug(LoggingLevel.ERROR, e.getMessage());
            }
            Test.stopTest();
        }

        System.assertEquals(1, [SELECT Id, Name FROM Account].size());
    }

    @isTest
    private static void TestMethod06() {
        Account a = new Account(Name='DML_Test.TestMethod06', Phone='(666) 666-6666');
        insert a;

        User u = [SELECT FIELDS(STANDARD) FROM User WHERE Email = 'testdata@dbutils.test.org' LIMIT 1];

        Test.startTest();
        try {
            DB_UTILS.del(new List<Account>{a});
            System.runAs(u) { DB_UTILS.und([SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS]); }
        }
        catch(Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
         }
        Test.stopTest();

        System.assertEquals(0, [SELECT Id, Name FROM Account].size());
    }

    @isTest
    private static void TestMethod07() {
        CustomObjectA__c objA = new CustomObjectA__c(
            Name = 'DML_Test.TestMethod07',
            ExternalId__c = String.valueOf(UUID.randomUUID())
        );
        insert obja;

        Test.startTest();
        try {
            DB_UTILS.ups(new List<CustomObjectA__c>{objA}, CustomObjectA__c.ExternalId__c);
        }
        catch(Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
        Test.stopTest();

        System.assertEquals(0, [SELECT Id, Name FROM Account].size());
    }
}
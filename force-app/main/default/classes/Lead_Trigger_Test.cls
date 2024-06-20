@isTest
private class Lead_Trigger_Test {

    @isTest
    private static void TestMethod01() {
        Lead l = new Lead(
            FirstName = 'TestMethod01',
            LastName = 'Lead_Trigger_Test',
            Phone = '(111) 111-1111',
            Email = 'TestMethod01@leadtriggertest.com',
            Company = [SELECT Id, Name FROM Organization LIMIT 1].Name
        );
        Test.startTest();
        insert l;
        Test.stopTest();
        System.assertEquals(1, [SELECT Id, Name FROM Lead].size());
    }

    @isTest
    private static void TestMethod02() {
        Lead l = new Lead(
            FirstName = 'TestMethod02',
            LastName = 'Lead_Trigger_Test',
            Phone = '(222) 222-2222',
            Email = 'TestMethod02@leadtriggertest.com',
            Company = [SELECT Id, Name FROM Organization LIMIT 1].Name
        );
        Test.startTest();
        insert l;
        l.Phone = '(222) 222-2222 ext.222';
        update l;
        Test.stopTest();
        System.assertEquals('(222) 222-2222 ext.222', [SELECT Id, Phone FROM Lead LIMIT 1].Phone);
    }

    @isTest
    private static void TestMethod03() {
        Lead l = new Lead(
            FirstName = 'TestMethod03',
            LastName = 'Lead_Trigger_Test',
            Phone = '(333) 333-3333',
            Email = 'TestMethod03@leadtriggertest.com',
            Company = [SELECT Id, Name FROM Organization LIMIT 1].Name
        );
        Test.startTest();
        insert l;
        l.Phone = null;
        try { update l; } catch(DmlException e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        Test.stopTest();
        System.assertEquals(null, [SELECT Id, Phone FROM Lead LIMIT 1].Phone);
    }

    @isTest
    private static void TestMethod04() {
        Lead l = new Lead(
            FirstName = 'TestMethod04',
            LastName = 'Lead_Trigger_Test',
            Phone = '(444) 444-4444',
            Email = 'TestMethod04@leadtriggertest.com',
            Company = [SELECT Id, Name FROM Organization LIMIT 1].Name
        );
        Test.startTest();
        insert l;
        delete l;
        Test.stopTest();
        System.assertEquals(0, [SELECT Id, Name FROM Lead].size());
    }

    @isTest
    private static void TestMethod05() {
        Lead l = new Lead(
            FirstName = 'TestMethod05',
            LastName = 'Lead_Trigger_Test',
            Phone = '(555) 555-5555',
            Email = 'TestMethod05@leadtriggertest.com',
            Company = [SELECT Id, Name FROM Organization LIMIT 1].Name
        );
        Test.startTest();
        insert l;
        delete l;
        undelete [SELECT Id FROM Lead WHERE IsDeleted = true ALL ROWS];
        Test.stopTest();
        System.assertEquals(1, [SELECT Id, Name FROM Lead].size());
    }

    @isTest
    private static void TestMethod06() {
        Lead l = new Lead(
            FirstName = 'TestMethod06',
            LastName = null,
            Phone = '(666) 666-6666',
            Email = 'TestMethod06@leadtriggertest.com',
            Company = [SELECT Id, Name FROM Organization LIMIT 1].Name
        );
        Test.startTest();
        try { insert l; } catch(DmlException e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        Test.stopTest();
        System.assertEquals(0, [SELECT Id, Name FROM Lead].size());
    }

    @isTest
    private static void TestMethod07() {
        Lead l = new Lead(
            FirstName = 'TestMethod07',
            LastName = 'Lead_Trigger_Test',
            Phone = '(777) 777-7777',
            Email = 'TestMethod07@leadtriggertest.com',
            Company = [SELECT Id, Name FROM Organization LIMIT 1].Name
        );
        Test.startTest();
        insert l;
        System.assertEquals(1, [SELECT Id, Name FROM Lead].size());
        delete l;
        System.assertEquals(0, [SELECT Id, Name FROM Lead].size());
        undelete [SELECT Id FROM Lead WHERE IsDeleted = true ALL ROWS];
        Test.stopTest();
        System.assertEquals(1, [SELECT Id, Name FROM Lead].size());
    }
}
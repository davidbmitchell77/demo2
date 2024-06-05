@isTest
private class Case_Trigger_Test {

    @isTest
    private static void TestMethod01() {
        Account a = new Account(
            Name = 'Case_Trigger_Test.TestMethod01',
            Phone = '(111) 111-1111'
        );
        insert a;

        Case c = new Case(
            Subject = a.Name,
            AccountId = a.Id
        );
        insert c;

        Test.startTest(); 
        c.Status = 'Closed';
        update c;
        Test.stopTest();

        System.assertEquals(null, [SELECT Id, Rating FROM Account LIMIT 1].Rating);       
    }

    @isTest
    private static void TestMethod02() {
        Account a = new Account(
            Name = 'Case_Trigger_Test.TestMethod02',
            Phone = '(222) 222-2222'
        );
        insert a;

        List<Case> cases = new List<Case>();
        for (Integer i=0; i<1000; i++) {
            Case c = new Case(
                Subject = (a.Name + ' ' + i),
                Status = 'Closed',
                AccountId = a.Id
            );
            cases.add(c);
        }

        Test.startTest(); 
        insert cases;
        Test.stopTest();

        System.assertEquals(1000, [SELECT Id FROM Case WHERE Status LIKE '%Closed%'].size());
        System.assertEquals('Bronze', [SELECT Id, Rating FROM Account LIMIT 1].Rating);       
    }

    @isTest
    private static void TestMethod03() {
        Account a = new Account(
            Name = 'Case_Trigger_Test.TestMethod03',
            Phone = '(333) 333-3333'
        );
        insert a;

        Case c = new Case(
            Subject = a.Name,
            AccountId = a.Id
        );
        insert c;

        Test.startTest(); 
        delete c;
        Test.stopTest();

        System.assertEquals(0, [SELECT Id FROM Case].size());       
    }

    @isTest
    private static void TestMethod04() {
        Account a = new Account(
            Name = 'Case_Trigger_Test.TestMethod04',
            Phone = '(444) 444-4444'
        );
        insert a;

        Case c = new Case(
            Subject = a.Name,
            AccountId = a.Id
        );
        insert c;

        Test.startTest(); 
        delete c;
        undelete [SELECT Id FROM Case WHERE IsDeleted = true ALL Rows];
        Test.stopTest();

        System.assertEquals(1, [SELECT Id FROM Case].size());       
    }

    @isTest
    private static void TestMethod05() {
        Account a = new Account(
            Name = 'Case_Trigger_Test.TestMethod05',
            Phone = '(555) 555-5555'
        );
        insert a;

        Case c = new Case(
            Subject = a.Name,
            Status = 'Closed',
            AccountId = a.Id
        );
        insert c;

        Test.startTest(); 
        c.Status = 'New';
        update c;
        Test.stopTest();

        System.assertEquals(null, [SELECT Id, Rating FROM Account LIMIT 1].Rating);       
    }

    @isTest
    private static void TestMethod06() {
        Account a = new Account(
            Name = 'Case_Trigger_Test.TestMethod06',
            Phone = '(666) 666-6666'
        );
        insert a;

        Case c = new Case(
            Subject = null,
            AccountId = a.Id
        );

        Test.startTest(); 
        try { insert c; } catch(DmlException e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        Test.stopTest();

        System.assertEquals(0, [SELECT Id FROM Case].size());       
    }

    @isTest
    private static void TestMethod07() {
        Account a = new Account(
            Name = 'Case_Trigger_Test.TestMethod07',
            Phone = '(777) 777-7777'
        );
        insert a;

        List<Case> cases = new List<Case>();
        for (Integer i=0; i<1000; i++) {
            Case c = new Case(
                Subject = ('Case_Trigger_Test.TestMethod07 ' + i),
                Status = 'Closed',
                AccountId = a.Id
            );
            cases.add(c);
        }

        Test.startTest(); 
        insert cases;
        Case c = new Case(
            Subject = ('Case_Trigger_Test.TestMethod07 ' + 1001),
            Status = 'Closed',
            AccountId = a.Id
        );
        insert c;
        Test.stopTest();

        System.assertEquals('Silver', [SELECT Id, Rating FROM Account LIMIT 1].Rating);       
    }

}
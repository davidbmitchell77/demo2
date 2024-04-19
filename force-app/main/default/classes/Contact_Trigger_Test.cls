@isTest
private class Contact_Trigger_Test {

    @isTest
    private static void testMethod01()
    {
        Contact contact = new Contact(
        FirstName = 'testMethod01',
        LastName = 'Contact_Trigger_Test',
        Phone = null,
        HomePhone = null
        );
        Test.startTest();
        try {
            insert contact;
        } catch(Exception e) {
        }
        Test.stopTest();
        System.assertEquals(0, [SELECT Id FROM Contact LIMIT 200].size());
    }

    @isTest
    private static void testMethod02()
    {
        Contact contact = new Contact(
        FirstName = 'testMethod02',
        LastName = 'Contact_Trigger_Test',
        Phone = '5555555555',
        HomePhone = null
        );
        Test.startTest();
        insert contact;
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Contact LIMIT 200].size());
    }

    @isTest
    private static void testMethod03()
    {
        Contact contact = new Contact(
        FirstName = 'testMethod03',
        LastName = 'Contact_Trigger_Test',
        Phone = '5555555555',
        HomePhone = null
        );
        Test.startTest();
        insert contact;
        System.assertEquals(1, [SELECT Id FROM Contact LIMIT 200].size());
        contact.HomePhone = '5555555555';
        update contact;
        Test.stopTest();
        System.assertEquals('5555555555', [SELECT Id, HomePhone FROM Contact LIMIT 200][0].HomePhone);
    }

    @isTest
    private static void testMethod04()
    {
        Contact contact = new Contact(
        FirstName = 'testMethod04',
        LastName = 'Contact_Trigger_Test',
        Phone = '555-TST-0004'
        );
        Test.startTest();
        insert contact;
        System.assertEquals(1, [SELECT Id FROM Contact LIMIT 1].size());

        Account account = new Account(
        Name = 'testMethod04',
        Phone = '5555555555'
        );
        insert account;
        System.assertEquals(1, [SELECT Id FROM Account LIMIT 1].size());

        contact.Phone = '5555555555';
        update contact;
        Test.stopTest();

        System.assertEquals(account.Id, [SELECT Id, Name, AccountId FROM Contact LIMIT 1][0].AccountId);
        System.assertEquals(account.Name, [SELECT Id, Name, AccountId, Account.Name FROM Contact LIMIT 1][0].Account.Name);
    }
}
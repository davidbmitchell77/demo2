@isTest
private class Contact_Trigger_Test {

    @isTest
    private static void TestMethod01() {
        Account a = new Account(
          Name = 'Contact_Trigger_Test.TestMethod01',
          Phone = '(111) 111-1111',
          Description = null
        );
        insert a;

       Contact c = new Contact(
           FirstName = 'TestMethod01',
           LastName = 'Contact_Trigger_Test',
           Phone = '(111) 111-1111 x111',
           Email = 'TestMethod01@ContactTriggerTest.com',
           Description = 'Hello from Contact_Trigger_Test.TestMethod01()!',
           AccountId = a.Id
       );

       Test.startTest();
       insert c;
       Test.stopTest();

       System.assertEquals('Hello from Contact_Trigger_Test.TestMethod01()!', [SELECT Id, Description FROM Account LIMIT 1].Description);
    }

    @isTest
    private static void TestMethod02() {
        Account a = new Account(
          Name = 'Contact_Trigger_Test.TestMethod02',
          Phone = '(222) 222-2222',
          Description = null
        );
        insert a;

       Contact c = new Contact(
           FirstName = 'TestMethod02',
           LastName = 'Contact_Trigger_Test',
           Phone = '(222) 222-2222 x222',
           Email = 'TestMethod02@ContactTriggerTest.com',
           Description = 'Hello from Contact_Trigger_Test.TestMethod02()!',
           AccountId = a.Id
       );

       Test.startTest();
       insert c;
       c.LastName = null;
       c.Phone = null;
       try {
           update c;
       } catch(DMLException e) {
           System.debug(LoggingLevel.ERROR, e.getMessage());
       }
       Test.stopTest();

       System.assertEquals('(222) 222-2222 x222', [SELECT Id, Phone FROM Contact LIMIT 1].Phone);
    }

    @isTest
    private static void TestMethod03() {
        Account a = new Account(
          Name = 'Contact_Trigger_Test.TestMethod03',
          Phone = '(333) 333-3333',
          Description = null
        );
        insert a;

       Contact c = new Contact(
           FirstName = 'TestMethod03',
           LastName = 'Contact_Trigger_Test',
           Phone = '(333) 333-3333 333',
           Email = 'TestMethod03@ContactTriggerTest.com',
           Description = 'Hello from Contact_Trigger_Test.TestMethod03()!',
           AccountId = a.Id
       );
       insert c;

       Test.startTest();
       System.assertEquals(1, [SELECT Id, Phone FROM Contact].size());
       delete c;
       System.assertEquals(0, [SELECT Id, Phone FROM Contact].size());
       undelete [SELECT Id FROm Contact WHERE IsDeleted = true ALL ROWS];
       Test.stopTest();

       System.assertEquals(1, [SELECT Id, Phone FROM Contact].size());
    }

    @isTest
    private static void TestMethod04() {
        Account a = new Account(
          Name = 'Contact_Trigger_Test.TestMethod04',
          Phone = '(444) 444-4444',
          Description = null
        );
        insert a;

       Contact c = new Contact(
           FirstName = 'TestMethod04',
           LastName = 'Contact_Trigger_Test',
           Phone = '(444) 444-1111 x444',
           Email = 'TestMethod04@ContactTriggerTest.com',
           Description = 'Hello from Contact_Trigger_Test.TestMethod04()!',
           AccountId = a.Id
       );

       Test.startTest();
       insert c;
       System.assertEquals('Hello from Contact_Trigger_Test.TestMethod04()!', [SELECT Id, Description FROM Account LIMIT 1].Description);
       c.Description = 'Goodbye from Contact_Trigger_Test.TestMethod04()!';
       update c;
       Test.stopTest();

       System.assertEquals('Goodbye from Contact_Trigger_Test.TestMethod04()!', [SELECT Id, Description FROM Account LIMIT 1].Description);
    }

    @isTest
    private static void TestMethod05() {
       Contact c = new Contact(
           FirstName = 'TestMethod05',
           LastName = 'Contact_Trigger_Test',
           Phone = '(555) 555-5555 x555',
           Email = 'TestMethod05@ContactTriggerTest.com',
           Description = 'Hello from Contact_Trigger_Test.TestMethod05()!'
       );

       Test.startTest();
       insert c;
       System.assertEquals(1, [SELECT Id, Name FROM Contact].size());
       delete c;
       System.assertEquals(0, [SELECT Id, Name FROM Contact].size());
       undelete [SELECT Id FROM Contact WHERE IsDeleted = true ALL ROWS];
       Test.stopTest();

       System.assertEquals(1, [SELECT Id, Name FROM Contact].size());
    }

    @isTest
    private static void TestMethod06() {
        Account a = new Account(
          Name = 'Contact_Trigger_Test.TestMethod04',
          Phone = '(666) 666-6666',
          Description = null
        );
        insert a;

       Contact c = new Contact(
           FirstName = 'TestMethod06',
           LastName = 'Contact_Trigger_Test',
           Phone = '(666) 666-6666 x666',
           Email = 'TestMethod06@ContactTriggerTest.com',
           Description = 'Hello from Contact_Trigger_Test.TestMethod06()!',
           AccountId = a.Id
       );

       Test.startTest();
       insert c;
       System.assertEquals(1, [SELECT Id, TotalContacts__c FROM Account LIMIT 1].TotalContacts__c);
       delete c;
       System.assertEquals(0, [SELECT Id, TotalContacts__c FROM Account LIMIT 1].TotalContacts__c);
       undelete [SELECT Id FROM Contact WHERE IsDeleted = true ALL ROWS];
       Test.stopTest();

       System.assertEquals(1, [SELECT Id, TotalContacts__c FROM Account LIMIT 1].TotalContacts__c);
    }

    @isTest
    private static void TestMethod07() {
        Integer maxRecordIds = Integer.valueOf(TriggerSetting__mdt.getInstance('Contact').MaxRecordIds__c) + 1;
        Account a = new Account(
          Name = 'Contact_Trigger_Test.TestMethod07',
          Phone = '(777) 777-7777',
          Description = null
        );
        insert a;

        List<Contact> contacts = new List<Contact>();
        for (Integer i=0; i<maxRecordIds; i++) {
           Contact c = new Contact(
               FirstName = 'TestMethod07 ' + i,
               LastName = 'Contact_Trigger_Test',
               Phone = '(777) 777-7777 x777' + i,
               Email = 'TestMethod07@ContactTriggerTest' + i + '.com',
               Description = 'Hello from Contact_Trigger_Test.TestMethod07! ' + i,
               AccountId = a.Id
           );
           contacts.add(c);
        }

        Test.startTest();
        insert contacts;
        for (Contact c : contacts) {
            c.FirstName = c.FirstName + ' update';
        }
        update contacts;
        Test.stopTest();

        System.assertEquals(maxRecordIds, [SELECT Id, Name FROM Contact].size());
    }
}
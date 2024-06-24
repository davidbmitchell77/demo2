@isTest
private class CampaignMember_Trigger_Test {

    @isTest
    private static void TestMethod01() {
        Account a = new Account (
            Name = 'Acme, Inc.',
            Phone = '(111) 111-1111'
        );
        insert a;
        Contact c1 = new Contact(
            FirstName = 'Robin',
            LastName = 'Koehler',
            Phone = '(111) 111-1111 x111',
            AccountId = a.Id
        );
        insert c1;
        Contact c2 = new Contact(
            FirstName = 'Paul',
            LastName = 'Stanley',
            Phone = '(111) 111-1111 x112',
            AccountId = a.Id
        );
        insert c2;

        Test.startTest();
        Campaign camp = new Campaign(
            Name = 'Test',
            Description = 'CampaignMember_Trigger_Test.TestMethod01',
            IsActive = true
        );
        insert camp;

        List<CampaignMember> members = new List<CampaignMember>();
        CampaignMember member1 = new CampaignMember(
            ContactId = c1.Id,
            Status = 'Sent',
            CampaignId = camp.Id
        );
        members.add(member1);
        CampaignMember member2 = new CampaignMember(
            ContactId = c2.Id,
            Status = 'Sent',
            CampaignId = camp.Id
        );
        members.add(member2);
        insert members;
        Test.stopTest();

        System.assertEquals(2, [SELECT Id FROM CampaignMember].size());
    }

    @isTest
    private static void TestMethod02() {
        Account a = new Account (
            Name = 'Acme, Inc.',
            Phone = '(222) 222-2222'
        );
        insert a;
        Contact c1 = new Contact(
            FirstName = 'Robin',
            LastName = 'Koehler',
            Phone = '(222) 222-2222 x222',
            AccountId = a.Id
        );
        insert c1;
        Contact c2 = new Contact(
            FirstName = 'Paul',
            LastName = 'Stanley',
            Phone = '(222) 222-2222 x2223',
            AccountId = a.Id
        );
        insert c2;

        Test.startTest();
        Campaign camp = new Campaign(
            Name = 'Test',
            Description = 'CampaignMember_Trigger_Test.TestMethod02',
            IsActive = true
        );
        insert camp;

        List<CampaignMember> members = new List<CampaignMember>();
        CampaignMember member1 = new CampaignMember(
            ContactId = c1.Id,
            Status = 'Sent',
            CampaignId = camp.Id
        );
        members.add(member1);
        CampaignMember member2 = new CampaignMember(
            ContactId = c2.Id,
            Status = 'Sent',
            CampaignId = camp.Id
        );
        members.add(member2);
        insert members;
        List<CampaignMember> members2 = new List<CampaignMember>();
        for (CampaignMember cm : members) {
            members2.add(cm);
        }
        update members2;
        Test.stopTest();

        System.assertEquals(2, [SELECT Id FROM CampaignMember].size());
    }

    @isTest
    private static void TestMethod03() {
        Account a = new Account (
            Name = 'Acme, Inc.',
            Phone = '(333) 333-3333'
        );
        insert a;
        Contact c1 = new Contact(
            FirstName = 'Robin',
            LastName = 'Koehler',
            Phone = '(333) 333-3333 x3331',
            AccountId = a.Id
        );
        insert c1;
        Contact c2 = new Contact(
            FirstName = 'Paul',
            LastName = 'Stanley',
            Phone = '(333) 333-3333 x3332',
            AccountId = a.Id
        );
        insert c2;

        Test.startTest();
        Campaign camp = new Campaign(
            Name = 'Test',
            Description = 'CampaignMember_Trigger_Test.TestMethod03',
            IsActive = true
        );
        insert camp;

        List<CampaignMember> members = new List<CampaignMember>();
        CampaignMember member1 = new CampaignMember(
            ContactId = c1.Id,
            Status = 'Sent',
            CampaignId = camp.Id
        );
        members.add(member1);
        CampaignMember member2 = new CampaignMember(
            ContactId = c2.Id,
            Status = 'Sent',
            CampaignId = camp.Id
        );
        members.add(member2);
        insert members;
        System.assertEquals(2, [SELECT Id FROM CampaignMember].size());
        delete [SELECT Id FROM CampaignMember];
        Test.stopTest();

        System.assertEquals(0, [SELECT Id FROM CampaignMember].size());
    }

    @isTest
    private static void TestMethod04() {
        Account a = new Account (
            Name = 'Acme, Inc.',
            Phone = '(444) 444-4444'
        );
        insert a;
        Contact c1 = new Contact(
            FirstName = 'Robin',
            LastName = 'Koehler',
            Phone = '(444) 444-4444 x4441',
            AccountId = a.Id
        );
        insert c1;
        Contact c2 = new Contact(
            FirstName = 'Paul',
            LastName = 'Stanley',
            Phone = '(444) 444-4444 x4442',
            AccountId = a.Id
        );
        insert c2;

        Test.startTest();
        Campaign camp = new Campaign(
            Name = 'Test',
            Description = 'CampaignMember_Trigger_Test.TestMethod04',
            IsActive = true
        );
        insert camp;

        List<CampaignMember> members = new List<CampaignMember>();
        CampaignMember member1 = new CampaignMember(
            ContactId = c1.Id,
            Status = 'Sent',
            CampaignId = camp.Id
        );
        members.add(member1);
        CampaignMember member2 = new CampaignMember(
            ContactId = c2.Id,
            Status = 'Sent',
            CampaignId = camp.Id
        );
        members.add(member2);
        insert members;
        member2.Status = null;
        try { update member2; } catch(DmlException e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        Test.stopTest();

        System.assertEquals(2, [SELECT Id FROM CampaignMember].size());
    }

    @isTest
    private static void TestMethod05() {
        Account a = new Account (
            Name = 'Acme, Inc.',
            Phone = '(555) 555-5555'
        );
        insert a;
        Contact c1 = new Contact(
            FirstName = 'Robin',
            LastName = 'Koehler',
            Phone = '(555) 555-5555 x5551',
            AccountId = a.Id
        );
        insert c1;
        Contact c2 = new Contact(
            FirstName = 'Paul',
            LastName = 'Stanley',
            Phone = '(555) 555-5555 x5552',
            AccountId = a.Id
        );
        insert c2;

        Test.startTest();
        Campaign camp = new Campaign(
            Name = 'Test',
            Description = 'CampaignMember_Trigger_Test.TestMethod05',
            IsActive = true
        );
        insert camp;

        Integer maxRecordIds = Integer.valueOf(TriggerSettings.getInstance('CampignMember').MaxRecordIds__c) + 101;
        List<Contact> contacts = new List<Contact>();
        for (Integer i=0; i<maxRecordIds; i++) {
            Contact c = new Contact(
                FirstName = 'Robin',
                LastName = 'Koehler',
                Phone = '(555) 555-5555 x5551',
                AccountId = a.Id
            );
            contacts.add(c);
        }
        insert contacts;
        List<CampaignMember> members = new List<CampaignMember>();
        for (Integer i=0; i<maxRecordIds; i++) {
            CampaignMember cm = new CampaignMember(
                ContactId = contacts[i].Id,
                Status = 'Planned',
                CampaignId = camp.Id
            );
            members.add(cm);
        }
        insert members;
        for (CampaignMember cm : members) {
            cm.Status = 'Sent';
        }
        update members;
        Test.stopTest();

        System.assertEquals(maxRecordIds, [SELECT Id FROM CampaignMember].size());
    }
}
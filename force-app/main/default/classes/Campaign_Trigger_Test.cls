@isTest
private class Campaign_Trigger_Test {

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
            Description = 'Campaign_Trigger_Test.TestMethod01',
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
            Description = 'Campaign_Trigger_Test.TestMethod02',
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
        camp.Description = 'Chaned description';
        update camp;
        Test.stopTest();

        System.assertEquals(2, [SELECT Id FROM CampaignMember].size());
    }

    @isTest
    private static void TestMethod03() {
        Campaign camp = new Campaign(
            Name = 'Test',
            Description = 'Campaign_Trigger_Test.TestMethod03',
            IsActive = true
        );
        Test.startTest();   
        insert camp;
        delete camp;
        Test.stopTest();

        System.assertEquals(0, [SELECT Id FROM Campaign].size());
    }

    @isTest
    private static void TestMethod04() {
        Campaign camp = new Campaign(
            Name = 'Test',
            Description = 'Campaign_Trigger_Test.TestMethod04',
            IsActive = true
        );
        Test.startTest();   
        insert camp;
        delete camp;
        undelete camp;
        Test.stopTest();

        System.assertEquals(1, [SELECT Id FROM Campaign].size());
    }

    @isTest
    private static void TestMethod05() {
        Campaign camp = new Campaign(
            Name = null,
            Description = null,
            IsActive = true
        );
        Test.startTest();   
        try { insert camp; } catch(DmlException e) { System.debug(LoggingLevel.INFO, e.getMessage()); }
        Test.stopTest();

        System.assertEquals(0, [SELECT Id FROM Campaign].size());
    }

    @isTest
    private static void TestMethod06() {
        Integer maxRecords = Integer.valueOf(TriggerSettings.getInstance('Campaign').MaxRecordIds__c) + 1;
        Account a = new Account (
            Name = 'Acme, Inc.',
            Phone = '(666) 666-6666'
        );
        insert a;
        List<Campaign> campaigns = new List<Campaign>();
        for (Integer i=0; i<maxRecords; i++) {
            Campaign c = new Campaign(
                Name = 'TestMethod06 ' + i,
                Description = 'Campaign_Trigger_Test.TestMethod06 ' + i,
                IsActive = true
            );
            campaigns.add(c);
        }
        Test.startTest();
        insert campaigns;
        List<Opportunity> opportunities = new List<Opportunity>();
        Integer i = 0;
        for (Campaign c : campaigns) {
            Opportunity o = new Opportunity(
                Name = 'Opportunity_Trigger_Test.TestMethod06' + i++,
                Amount = 6666666.66,
                Probability = 50,
                StageName = 'Prospecting',
                CloseDate = (System.today() + 30),
                AccountId = a.Id,
                CampaignId = c.Id
            );
            opportunities.add(o);
        }
        insert opportunities;
        for (Campaign c : campaigns) {
            c.Name = c.Name + '.updated';
            c.Description = c.Description + '.updated';
        }
        update campaigns;
        Test.stopTest();

        System.assertEquals(maxRecords, [SELECT Id FROM Campaign].size());
    }
}
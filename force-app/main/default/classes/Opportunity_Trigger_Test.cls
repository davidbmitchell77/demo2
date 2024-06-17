@isTest
private class Opportunity_Trigger_Test {

    @isTest
    private static void TestMethod01() {
        Lead l = new Lead(
            FirstName = 'TestMethod01',
            LastName = 'Opportunity_Trigger_Test',
            Company = [SELECT Name FROM Organization LIMIT 1].Name,
            Phone = '(800) 555-1234'
        );
        insert l;
        Test.startTest();
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.Id);
        lc.setOwnerId(UserInfo.getUserId());
        lc.setConvertedStatus('Closed - Converted');
        lc.setOpportunityName(l.LastName + '.' + l.FirstName + '()');
        lc.setOverwriteLeadSource(false);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        List<Opportunity> opportunities = [SELECT Id, Name FROM Opportunity LIMIT 200];
        Test.stopTest();
        System.assertEquals(1, opportunities.size());
    }

    @isTest
    private static void TestMethod02() {
        Lead l = new Lead(
            FirstName = 'TestMethod02',
            LastName = 'Opportunity_Trigger_Test',
            Company = [SELECT Name FROM Organization LIMIT 1].Name,
            Phone = '(800) 555-1234'
        );
        insert l;
        Test.startTest();
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.Id);
        lc.setOwnerId(UserInfo.getUserId());
        lc.setConvertedStatus('Closed - Converted');
        lc.setOpportunityName(l.LastName + '.' + l.FirstName + '()');
        lc.setOverwriteLeadSource(false);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        List<Opportunity> opportunities = [SELECT Id, Name, Account.Name FROM Opportunity LIMIT 200];
        for (Opportunity o : opportunities) { o.Description = 'OPP-00002'; }
        update opportunities;
        Test.stopTest();
        System.assertEquals(1, opportunities.size());
        System.assertEquals('OPP-00002', opportunities[0].Description);
    }

    @isTest
    private static void TestMethod03() {
        Account a1 = new Account(
            Name = 'Opportunity_Trigger_Test.TestMethod03()',
            Phone = '(333) 333-3333',
            MaximumExpectedOpportunityRevenue__c = 100000
        );
        insert a1;
        Account a2 = new Account(
            Name = 'Opportunity_Trigger_Test.TestMethod03()',
            Phone = '(333) 333-3333',
            MaximumExpectedOpportunityRevenue__c = 100000
        );
        insert a2;
        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add(new Opportunity(
            Name = 'Opportunity_Trigger_Test.TestMethod03() 1',
            Amount = 1000000,
            Probability = 50,
            AccountId = a1.Id,
            StageName = 'Value Proposition',
            CloseDate = (System.today() + 30)
        ));
        opportunities.add(new Opportunity(
            Name = 'Opportunity_Trigger_Test.TestMethod03() 2',
            Amount = 2000000,
            Probability = 100,
            AccountId = a1.Id,
            StageName = 'Prospecting',
            CloseDate = (System.today() + 30)
        ));
        opportunities.add(new Opportunity(
            Name = 'Opportunity_Trigger_Test.TestMethod03() 2',
            Amount = 30000,
            Probability = 100,
            AccountId = a2.Id,
            StageName = 'Prospecting',
            CloseDate = (System.today() + 30)
        ));

        Test.startTest();
        insert opportunities;
        Test.stopTest();

        System.assertEquals(2, [SELECT Id, Name, MaximumExpectedOpportunityRevenue__c FROM Account].size());
    }

    @isTest
    private static void TestMethod04() {
        Account a = new Account(
            Name = 'Opportunity_Trigger_Test.TestMethod04()',
            Phone = '(444) 444-4444',
            MaximumExpectedOpportunityRevenue__c = 100000
        );
        insert a;
        Test.startTest();
        Opportunity o = new Opportunity(
            Name = 'Opportunity_Trigger_Test.TestMethod04()',
            Amount = 1000000, Probability = 50,
            AccountId = a.Id,
            StageName = 'Prospecting',
            CloseDate = (System.today() + 30)
        );
        insert o;
        delete o;
        Test.stopTest();
        System.assertEquals(0, [SELECT Id, Name FROM Opportunity].size());
    }

    @isTest
    private static void TestMethod05() {
        Account a = new Account(
            Name = 'Opportunity_Trigger_Test.TestMethod05()',
            Phone = '(555) 555-5555',
            MaximumExpectedOpportunityRevenue__c = 100000
        );
        insert a;
        Opportunity o = new Opportunity(
            Name = 'Opportunity_Trigger_Test.TestMethod05()',
            Amount = 1000000,
            Probability = 50,
            AccountId = a.Id,
            StageName = 'Prospecting',
            CloseDate = (System.today() + 30)
        );
        insert o;
        delete o;
        Test.startTest();
        List<Opportunity> opportunities = [SELECT Id, Name FROM Opportunity WHERE Name = :o.Name ALL ROWS];
        System.assertEquals(1, opportunities.size());
        undelete opportunities;
        Test.stopTest();
        System.assertEquals(1, [SELECT Id, Name FROM Opportunity].size());
    }

    @isTest
    private static void TestMethod06() {
        Account a = new Account(
            Name = 'Opportunity_Trigger_Test.TestMethod06()',
            Phone = '(666) 666-6666',
            MaximumExpectedOpportunityRevenue__c = 100000
        );
        insert a;
        Opportunity o = new Opportunity(
            Name = 'Opportunity_Trigger_Test.TestMethod06()',
            Amount = 1000000,
            Probability = 50,
            AccountId = a.Id,
            StageName = 'Prospecting',
            CloseDate = (System.today() + 30)
        );
        insert o;
        Test.startTest();
        o.Name = 'Opportunity_Trigger_Test.TestMethod06().update';
        update o;
        o.Name = null;
        try { update o; } catch(DMLException e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        List<Opportunity> opportunities = [SELECT Id, Name FROM Opportunity];
        System.assertEquals('Opportunity_Trigger_Test.TestMethod06().update', opportunities[0].Name);
        Test.stopTest();
        System.assertEquals(1, [SELECT Id, Name FROM Opportunity].size());
    }

    @isTest
    private static void TestMethod07() {
        Integer maxRecordIds = Integer.valueOf(TriggerSettings.getInstance('Opportunity').MaxRecordIds__c + 101);
        Account a = new Account(
            Name = 'Opportunity_Trigger_Test.TestMethod07()',
            Phone = '(777) 777-7777',
            MaximumExpectedOpportunityRevenue__c = 100000
        );
        insert a;
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i=0; i<maxRecordIds; i++) {
            Opportunity o = new Opportunity(
                Name = 'Opportunity_Trigger_Test.TestMethod07(' + i + ')',
                Amount = 1000000,
                Probability = 50,
                AccountId = a.Id,
                StageName = 'Value Proposition',
                CloseDate = (System.today() + 30)
            );
            opportunities.add(o);
        }
        Test.startTest();
        insert opportunities;
        for (Opportunity o : opportunities) {
            o.Name = o.Name + '.update';
        }
        update opportunities;
        Test.stopTest();
        System.assertEquals(maxRecordIds, [SELECT Id, Subject FROM Task].size());
        System.assertEquals(maxRecordIds, [SELECT Id, Name FROM Opportunity].size());
    }
}
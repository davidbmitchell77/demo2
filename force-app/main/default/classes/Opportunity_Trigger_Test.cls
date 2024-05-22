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
        Lead l = new Lead(
            FirstName = 'TestMethod03',
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
        for (Opportunity o : opportunities) {
            o.Name = null;
        }
        try {
            update opportunities;
        } catch(DmlException e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
        Test.stopTest();

        System.assertEquals(1, opportunities.size());
    }

    @isTest
    private static void TestMethod04() {
        Lead l = new Lead(
            FirstName = 'TestMethod04',
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
        System.assertEquals(1, [SELECT Id, Name FROM Opportunity].size());
        delete [SELECT Id FROM Opportunity LIMIT 1];
        System.assertEquals(0, [SELECT Id, Name FROM Opportunity].size());
        undelete [SELECT Id FROM Opportunity WHERE Isdeleted = true ALL ROWS];
        Test.stopTest();

        System.assertEquals(1, [SELECT Id, Name FROM Opportunity].size());
    }
}
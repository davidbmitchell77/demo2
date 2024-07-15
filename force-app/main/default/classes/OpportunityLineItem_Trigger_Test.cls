@isTest
private class OpportunityLineItem_Trigger_Test {

    @isTest
    private static void TestMethod01() {
        Lead l = new Lead(
            FirstName = 'TestMethod01',
            LastName = 'OpportunityLineItem_Trigger_Test',
            Company = [SELECT Name FROM Organization LIMIT 1].Name,
            Phone = '(800) 555-1234'
        );
        insert l;

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.Id);
        lc.setOwnerId(UserInfo.getUserId());
        lc.setConvertedStatus('Closed - Converted');
        lc.setOpportunityName(l.LastName + '.' + l.FirstName + '()');
        lc.setOverwriteLeadSource(false);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Opportunity o = [SELECT Id, Name FROM Opportunity LIMIT 1];

        Product2 p2 = new Product2(
            Name = 'Product01 ',
            ProductCode = 'Pro-1',
            isActive = true
        );
        insert p2;

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = p2.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbe;

        Test.startTest();
        OpportunityLineItem li = new OpportunityLineItem(
            OpportunityId = o.Id,
            Quantity = 111,
            PricebookEntryId = pbe.Id,
            TotalPrice = (11 * pbe.UnitPrice)
        );
        insert li;
        Test.stopTest();

        System.assertEquals(1, [SELECT Id FROM OpportunityLineItem].size());
    }
}
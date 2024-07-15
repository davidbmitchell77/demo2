@isTest
private class OpportunityLineItem_Trigger_Test {

    @isTest
    private static void TestMethod01() {
        Product2 p2 = new Product2(
            Name = 'Product01',
            ProductCode = 'Pro-1',
            IsActive = true
        );
        insert p2;
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = p2.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbe;
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

        Test.startTest();
        OpportunityLineItem li = new OpportunityLineItem(
            OpportunityId = o.Id,
            Quantity = 100.00,
            PricebookEntryId = pbe.Id,
            TotalPrice = (100.00 * pbe.UnitPrice)
        );
        insert li;
        Test.stopTest();

        System.assertEquals(1, [SELECT Id FROM OpportunityLineItem].size());
    }

    @isTest
    private static void TestMethod02() {
        Product2 p2 = new Product2(
            Name = 'Product02',
            ProductCode = 'Pro-2',
            IsActive = true
        );
        insert p2;
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = p2.Id,
            UnitPrice = 222.22,
            IsActive = true
        );
        insert pbe;
        Lead l = new Lead(
            FirstName = 'TestMethod02',
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

        Test.startTest();
        OpportunityLineItem li = new OpportunityLineItem(
            OpportunityId = o.Id,
            Quantity = 200.00,
            PricebookEntryId = pbe.Id,
            TotalPrice = (200.00 * pbe.UnitPrice)
        );
        insert li;
        li.Quantity = 2.00;
        li.TotalPrice = (pbe.UnitPrice * li.Quantity);
        update li;
        li.Quantity = 0.00;
        li.TotalPrice = (pbe.UnitPrice * li.Quantity);
        try { update li; } catch(DmlException e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        Test.stopTest();

        System.assertEquals(2.00, [SELECT Id, Quantity FROM OpportunityLineItem].Quantity);
    }

    @isTest
    private static void TestMethod03() {
        Product2 p2 = new Product2(
            Name = 'Product03',
            ProductCode = 'Pro-3',
            IsActive = true
        );
        insert p2;
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = p2.Id,
            UnitPrice = 333.33,
            IsActive = true
        );
        insert pbe;
        Lead l = new Lead(
            FirstName = 'TestMethod03',
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

        Test.startTest();
        OpportunityLineItem li = new OpportunityLineItem(
            OpportunityId = o.Id,
            Quantity = 300.00,
            PricebookEntryId = pbe.Id,
            TotalPrice = (300.00 * pbe.UnitPrice)
        );
        insert li;
        System.assertEquals(1, [SELECT Id, Quantity FROM OpportunityLineItem].Size());
        delete li;
        Test.stopTest();

        System.assertEquals(0, [SELECT Id, Quantity FROM OpportunityLineItem].Size());
    }

    @isTest
    private static void TestMethod04() {
        Product2 p2 = new Product2(
            Name = 'Product04',
            ProductCode = 'Pro-4',
            IsActive = true
        );
        insert p2;
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = p2.Id,
            UnitPrice = 400.00,
            IsActive = true
        );
        insert pbe;
        Lead l = new Lead(
            FirstName = 'TestMethod04',
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

        Integer maxRecordIds = Integer.valueOf(TriggerSettings.getInstance('OpportunityLineItem').MaxRecordIds__c + 101);
        
        Test.startTest();
        List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
        for (Integer i=0; i<maxRecordIds; i++) {
            OpportunityLineItem li = new OpportunityLineItem(
                OpportunityId = o.Id,
                Quantity = 400.00,
                PricebookEntryId = pbe.Id,
                TotalPrice = (400.00 * pbe.UnitPrice)
            );
            lineItems.add(li);
        }
        insert lineItems;
        for (OpportunityLineItem li : lineItems) {
            li.Description = '.update';
        }
        update lineItems;
        Test.stopTest();

        System.assertEquals(maxRecordIds, [SELECT Id FROM OpportunityLineItem].size());
    }
}
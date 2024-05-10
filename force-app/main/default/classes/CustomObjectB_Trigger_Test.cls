@isTest
private class CustomObjectB_Trigger_Test {

    @isTest
    private static void TestMethod_01() {
        CustomObjectB__c cobjb = new CustomObjectB__c(
            FieldA__c = 500000,
            FieldB__c = 1000000
        );
        Test.startTest();
        insert cobjb;
        Test.stopTest();
        List<CustomObjectB__c> cobjbList = [SELECT Id, Name, FieldA__c, FieldB__c, ExternalId__c FROM CustomObjectB__c LIMIT 200];
        List<CustomObjectA__c> cobjaList = [SELECT Id, Name, FieldA__c, FieldB__c, ExternalId__c FROM CustomObjectA__c LIMIT 200];
        System.assertEquals(1, cobjbList.size());
        System.assertEquals(1, cobjaList.size());
        System.assertEquals(cobjbList[0].FieldA__c, cobjaList[0].FieldA__c);
        System.assertEquals(cobjbList[0].FieldB__c, cobjaList[0].FieldB__c);
    }

    @isTest
    private static void TestMethod_02() {
        CustomObjectB__c cobjb = new CustomObjectB__c(
            FieldA__c = 500000,
            FieldB__c = 1000000
        );
        Test.startTest();
        insert cobjb;
        cobjb.FieldA__c = 75000;
        update cobjb;
        Test.stopTest();
        List<CustomObjectB__c> cobjbList = [SELECT Id, Name, FieldA__c, FieldB__c, ExternalId__c FROM CustomObjectB__c LIMIT 200];
        List<CustomObjectA__c> cobjaList = [SELECT Id, Name, FieldA__c, FieldB__c, ExternalId__c FROM CustomObjectA__c LIMIT 200];
        System.assertEquals(1, cobjbList.size());
        System.assertEquals(1, cobjaList.size());
        System.assertEquals(cobjbList[0].FieldA__c, cobjaList[0].FieldA__c);
        System.assertEquals(cobjaList[0].FieldA__c, cobjb.FieldA__c);
    }

    @isTest
    private static void TestMethod_03() {
        CustomObjectB__c cobjb = new CustomObjectB__c(
            FieldA__c = 500000,
            FieldB__c = 1000000
        );
        Test.startTest();
        insert cobjb;
        cobjb.FieldB__c = 125000000;
        update cobjb;
        Test.stopTest();
        List<CustomObjectB__c> cobjbList = [SELECT Id, Name, FieldA__c, FieldB__c, ExternalId__c FROM CustomObjectB__c LIMIT 200];
        List<CustomObjectA__c> cobjaList = [SELECT Id, Name, FieldA__c, FieldB__c, ExternalId__c FROM CustomObjectA__c LIMIT 200];
        System.assertEquals(1, cobjbList.size());
        System.assertEquals(1, cobjaList.size());
        System.assertEquals(cobjbList[0].FieldB__c, cobjaList[0].FieldB__c);
        System.assertEquals(cobjaList[0].FieldB__c, cobjb.FieldB__c);
    }
}
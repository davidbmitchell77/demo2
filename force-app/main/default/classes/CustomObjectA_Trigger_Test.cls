@isTest
private class CustomObjectA_Trigger_Test {

    @isTest
    private static void TestMethod_01() {
        CustomObjectA__c cobja = new CustomObjectA__c(
            FieldA__c = 500000,
            FieldB__c = 1000000
        );
        Test.startTest();
        insert cobja;
        Test.stopTest();
        List<CustomObjectA__c> cobjaList = [SELECT Id, Name, FieldA__c, FieldB__c, ExternalId__c FROM CustomObjectA__c LIMIT 200];
        List<CustomObjectB__c> cobjbList = [SELECT Id, Name, FieldA__c, FieldB__c, ExternalId__c FROM CustomObjectB__c LIMIT 200];
        System.assertEquals(1, cobjaList.size());
        System.assertEquals(1, cobjbList.size());
        System.assertEquals(cobjaList[0].FieldA__c, cobjbList[0].FieldA__c);
        System.assertEquals(cobjaList[0].FieldB__c, cobjbList[0].FieldB__c);
    }

    @isTest
    private static void TestMethod_02() {
        CustomObjectA__c cobja = new CustomObjectA__c(
            FieldA__c = 500000,
            FieldB__c = 1000000
        );
        Test.startTest();
        insert cobja;
        cobja.FieldA__c = 75000;
        update cobja;
        Test.stopTest();
        List<CustomObjectA__c> cobjaList = [SELECT Id, Name, FieldA__c, FieldB__c, ExternalId__c FROM CustomObjectA__c LIMIT 200];
        List<CustomObjectB__c> cobjbList = [SELECT Id, Name, FieldA__c, FieldB__c, ExternalId__c FROM CustomObjectB__c LIMIT 200];
        System.assertEquals(1, cobjaList.size());
        System.assertEquals(1, cobjbList.size());
        System.assertEquals(cobjaList[0].FieldA__c, cobjbList[0].FieldA__c);
        System.assertEquals(cobjbList[0].FieldA__c, cobja.FieldA__c);
    }

    @isTest
    private static void TestMethod_03() {
        CustomObjectA__c cobja = new CustomObjectA__c(
            FieldA__c = 500000,
            FieldB__c = 1000000
        );
        Test.startTest();
        insert cobja;
        cobja.FieldB__c = 125000000;
        update cobja;
        Test.stopTest();
        List<CustomObjectA__c> cobjaList = [SELECT Id, Name, FieldA__c, FieldB__c, ExternalId__c FROM CustomObjectA__c LIMIT 200];
        List<CustomObjectB__c> cobjbList = [SELECT Id, Name, FieldA__c, FieldB__c, ExternalId__c FROM CustomObjectB__c LIMIT 200];
        System.assertEquals(1, cobjaList.size());
        System.assertEquals(1, cobjbList.size());
        System.assertEquals(cobjaList[0].FieldB__c, cobjbList[0].FieldB__c);
        System.assertEquals(cobjbList[0].FieldB__c, cobja.FieldB__c);
    }
}
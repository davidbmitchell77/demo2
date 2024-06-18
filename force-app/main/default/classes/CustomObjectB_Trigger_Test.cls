@isTest
private class CustomObjectB_Trigger_Test {

    @isTest
    private static void TestMethod01() {
        UUID uuid = UUID.randomUUID();
        CustomObjectB__c objB = new CustomObjectB__c(
            Name = 'CustomObjectB_Trigger_Test.TestMethod01',
            FieldA__c = null,
            FieldB__c = null,
            ExternalId__c = String.valueOf(uuid)
        );
        insert objB;
        CustomObjectA__c objA = new CustomObjectA__c(
            Name = 'CustomObjectB_Trigger_Test.TestMethod01',
            FieldA__c = null,
            FieldB__c = null,
            ExternalId__c = String.valueOf(uuid)
        );
        insert objA;

        Test.startTest();
        objB.FieldA__c = 1.11;
        objB.FieldB__c = 1.11;
        update objB;
        Test.stopTest();

        System.assertEquals(1.11, [SELECT Id, FieldA__c FROM CustomObjectB__c].FieldA__c);
        System.assertEquals(1.11, [SELECT Id, FieldB__c FROM CustomObjectB__c].FieldB__c);
        System.assertEquals(1.11, [SELECT Id, FieldA__c FROM CustomObjectA__c].FieldA__c);
        System.assertEquals(1.11, [SELECT Id, FieldB__c FROM CustomObjectA__c].FieldB__c);
    }

    @isTest
    private static void TestMethod02() {
        UUID uuid = UUID.randomUUID();
        CustomObjectB__c objB = new CustomObjectB__c(
            Name = 'CustomObjectB_Trigger_Test.TestMethod02',
            FieldA__c = 2.22,
            FieldB__c = 2.22,
            ExternalId__c = String.valueOf(uuid)
        );
        insert objB;

        Test.startTest();
        delete [SELECT Id FROM CustomObjectB__c];
        System.assertEquals(0, [SELECT Id, FieldA__c FROM CustomObjectB__c].size());
        undelete [SELECT Id FROM CustomObjectB__c WHERE IsDeleted = true ALL ROWS];
        Test.stopTest();

        System.assertEquals(1, [SELECT Id, FieldA__c FROM CustomObjectB__c].size());
    }

    @isTest
    private static void TestMethod03() {
        UUID uuid = UUID.randomUUID();
        CustomObjectB__c objB = new CustomObjectB__c(
            Name = 'CustomObjectB_Trigger_Test.TestMethod03',
            FieldA__c = 3.33,
            FieldB__c = 3.33,
            ExternalId__c = String.valueOf(uuid)
        );
        insert objB;

        Test.startTest();
        objB.Name = '';
        try { update objB; } catch(DmlException e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        Test.stopTest();

        System.assertEquals('CustomObjectB_Trigger_Test.TestMethod03', [SELECT Id, Name FROM CustomObjectB__c].Name);
    }
}
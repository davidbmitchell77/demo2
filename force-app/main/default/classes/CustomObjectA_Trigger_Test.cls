@isTest
private class CustomObjectA_Trigger_Test {

    @isTest
    private static void TestMethod01() {
        UUID uuid = UUID.randomUUID();
        CustomObjectA__c objA = new CustomObjectA__c(
            Name = 'CustomObjectA_Trigger_Test.TestMethod01',
            FieldA__c = null,
            FieldB__c = null,
            ExternalId__c = String.valueOf(uuid)
        );
        insert objA;
        CustomObjectB__c objB = new CustomObjectB__c(
            Name = 'CustomObjectA_Trigger_Test.TestMethod01',
            FieldA__c = null,
            FieldB__c = null,
            ExternalId__c = String.valueOf(uuid)
        );
        insert objB;

        Test.startTest();
        objA.FieldA__c = 1.11;
        objA.FieldB__c = 1.11;
        update objA;
        Test.stopTest();

        System.assertEquals(1.11, [SELECT Id, FieldA__c FROM CustomObjectA__c].FieldA__c);
        System.assertEquals(1.11, [SELECT Id, FieldB__c FROM CustomObjectA__c].FieldB__c);
        System.assertEquals(1.11, [SELECT Id, FieldA__c FROM CustomObjectB__c].FieldA__c);
        System.assertEquals(1.11, [SELECT Id, FieldB__c FROM CustomObjectB__c].FieldB__c);
    }

    @isTest
    private static void TestMethod02() {
        UUID uuid = UUID.randomUUID();
        CustomObjectA__c objA = new CustomObjectA__c(
            Name = 'CustomObjectA_Trigger_Test.TestMethod02',
            FieldA__c = 2.22,
            FieldB__c = 2.22,
            ExternalId__c = String.valueOf(uuid)
        );
        insert objA;

        Test.startTest();
        delete [SELECT Id FROM CustomObjectA__c];
        System.assertEquals(0, [SELECT Id, FieldA__c FROM CustomObjectA__c].size());
        undelete [SELECT Id FROM CustomObjectA__c WHERE IsDeleted = true ALL ROWS];
        Test.stopTest();

        System.assertEquals(1, [SELECT Id, FieldA__c FROM CustomObjectA__c].size());
    }

    @isTest
    private static void TestMethod03() {
        UUID uuid = UUID.randomUUID();
        CustomObjectA__c objA = new CustomObjectA__c(
            Name = 'CustomObjectA_Trigger_Test.TestMethod03',
            FieldA__c = 3.33,
            FieldB__c = 3.33,
            ExternalId__c = String.valueOf(uuid)
        );
        insert objA;

        Test.startTest();
        objA.Name = '';
        try { update objA; } catch(DmlException e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        Test.stopTest();

        System.assertEquals('CustomObjectA_Trigger_Test.TestMethod03', [SELECT Id, Name FROM CustomObjectA__c].Name);
    }

    @isTest
    private static void TestMethod04() {
        Integer maxRecordIds = Integer.valueOf(TriggerSettings.getInstance('CustomObjectA').MaxRecordIds__c + 101);
        List<CustomObjectA__c> aRecords = new List<CustomObjectA__c>();
        for (Integer i=0; i<maxRecordIds; i++) {
            UUID uuid = UUID.randomUUID();
            CustomObjectA__c a = new CustomObjectA__c(
                Name = 'CustomObjectA_Trigger_Test.TestMethod04 ' + i,
                FieldA__c = 4.44,
                FieldB__c = 4.44,
                ExternalId__c = String.valueOf(uuid)
            );
            aRecords.add(a);
        }

        Test.startTest();
        insert aRecords;
        for (CustomObjectA__c a : aRecords) {
            a.Name = a.Name + '.update';
        }
        update aRecords;
        Test.stopTest();

        System.assertEquals(maxRecordIds, [SELECT Id, Name FROM CustomObjectA__c].size());
    }
}
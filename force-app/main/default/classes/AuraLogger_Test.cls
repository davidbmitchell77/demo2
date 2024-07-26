@isTest
private class AuraLogger_Test {

    @isTest
    private static void TestDebug() {
        Test.startTest();
        AuraLogger.debug('AuraLogger_Test.TestDebug');
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Log__c].size());
    }

    @isTest
    private static void TestError() {
        Integer maxTags = 5;
        
        List<String> tags = new List<String>();
        for (Integer i=0; i<(maxTags + 10); i++) {
            tags.add('tag' + i);
        }

        Test.startTest();
        AuraLogger.error('AuraLogger_Test.TestError', tags);
        Test.stopTest();

        System.assertEquals(1, [SELECT Id FROM Log__c].size());
        System.assertEquals(maxTags, [SELECT Id FROM LoggerTag__c].size());
    }
    
    @isTest
    private static void TestFine() {
        Test.startTest();
        AuraLogger.fine('AuraLogger_Test.TestFine');
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Log__c].size());
    }
    
    @isTest
    private static void TestFiner() {
        Test.startTest();
        AuraLogger.finer('AuraLogger_Test.TestFiner');
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Log__c].size());
    }
    
    @isTest
    private static void TestFinest() {
        Test.startTest();
        AuraLogger.finest('AuraLogger_Test.TestFinest');
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Log__c].size());
    }
    
    @isTest
    private static void TestInfo() {
        Test.startTest();
        AuraLogger.info('AuraLogger_Test.TestInfo');
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Log__c].size());
    }
}

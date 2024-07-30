@isTest
private class AuraLogger_Test {

    @isTest
    private static void TestDebug() {
        List<String> messages = new List<String>{ 'AuraLogger_Test.TestDebug' };
        Test.startTest();
        AuraLogger.debug(messages);
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Log__c].size());
    }

    @isTest
    private static void TestError() {
        List<String> messages = new List<String>{
            'AuraLogger_Test.TestError[0]',
            'AuraLogger_Test.TestError[1]'
        };
            
        Integer maxTags = 5;
        List<String> tags = new List<String>();
        for (Integer i=0; i<(maxTags + 10); i++) {
            tags.add('tag' + i);
        }

        Test.startTest();
        AuraLogger.error(messages, tags);
        Test.stopTest();

        System.assertEquals(1, [SELECT Id FROM Log__c].size());
        System.assertEquals(maxTags, [SELECT Id FROM LoggerTag__c].size());
    }
    
    @isTest
    private static void TestFine() {
        List<String> messages = new List<String>{ 'AuraLogger_Test.TestFine' };
        Test.startTest();
        AuraLogger.fine(messages);
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Log__c].size());
    }
    
    @isTest
    private static void TestFiner() {
        List<String> messages = new List<String>{ 'AuraLogger_Test.TestFiner' };
        Test.startTest();
        AuraLogger.finer(messages);
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Log__c].size());
    }
    
    @isTest
    private static void TestFinest() {
        List<String> messages = new List<String>{ 'AuraLogger_Test.TestFinest' };
        Test.startTest();
        AuraLogger.finest(messages);
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Log__c].size());
    }
    
    @isTest
    private static void TestInfo() {
        List<String> messages = new List<String>{ 'AuraLogger_Test.TestInfo' };
        Test.startTest();
        AuraLogger.info(messages);
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Log__c].size());
    }
}

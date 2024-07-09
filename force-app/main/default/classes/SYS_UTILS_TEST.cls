@isTest
private class SYS_UTILS_TEST {

    @isTest
    private static void Test_isBatch() {
        Test.startTest();
        Boolean result = SYS_UTILS.isBatch();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.isBatch(): '+ result);
        System.assertEquals(false, result);
    }

    @isTest
    private static void Test_isBulkApi() {
        Test.startTest();
        Boolean result = SYS_UTILS.isBulkApi();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.isBulkApi(): ' + result);
        System.assertEquals(false, result);
    }

    @isTest
    private static void Test_isFuture() {
        Test.startTest();
        Boolean result = SYS_UTILS.isFuture();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.isFuture(): '+ result);
        System.assertEquals(false, result);
    }

    @isTest
    private static void Test_isQueueable() {
        Test.startTest();
        Boolean result = SYS_UTILS.isQueueable();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.isQueueable(): '+ result);
        System.assertEquals(false, result);
    }

    @isTest
    private static void Test_isScheduled() {
        Test.startTest();
        Boolean result = SYS_UTILS.isScheduled();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.isScheduled(): '+ result);
        System.assertEquals(false, result);
    }

    @isTest
    private static void Test_isTest() {
        Test.startTest();
        Boolean result = SYS_UTILS.isTest();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.isTest(): '+ result);
        System.assertEquals(true, result);
    }

    @isTest
    private static void Test_guid() {
        Test.startTest();
        String result = SYS_UTILS.guid();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.guid(): '+ result);
        System.assertEquals(36, result.length());
    }

    @isTest
    private static void Test_uuid() {
        Test.startTest();
        String result = SYS_UTILS.uuid();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.uuid(): '+ result);
        System.assertEquals(36, result.length());
    }

    @isTest
    private static void Test_SYS_EXCEPTION() {
        Test.startTest();
        try {
            throw new SYS_UTILS.SYS_EXCEPTION('SYS_UTILS_TEST.SYS_EXCEPTION');
        }
        catch(Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
        Test.stopTest();
    }
}
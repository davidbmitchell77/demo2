@isTest
private class SYS_UTILS_TEST {

    @isTest
    private static void TestMethod01() {
        Test.startTest();
        Boolean result = SYS_UTILS.isBatch();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.isBatch(): '+ result);
        System.assertEquals(false, result);
    }

    @isTest
    private static void TestMethod02() {
        Test.startTest();
        Boolean result = SYS_UTILS.isTest();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.isTest(): '+ result);
        System.assertEquals(true, result);
    }

    @isTest
    private static void TestMethod03() {
        Test.startTest();
        String guid = SYS_UTILS.guid();
        String uuid = SYS_UTILS.uuid();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.guid(): '+ guid);
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.uuid(): '+ uuid);
        System.assertEquals(36, guid.length());
        System.assertEquals(36, uuid.length());
    }

    @isTest
    private static void TestMethod04() {
        Test.startTest();
        try {
            throw new SYS_UTILS.SYS_EXCEPTION('SYS_UTILS_TEST.TestMethod04');
        }
        catch(Exception e) {
            System.debug(LoggingLevel.ERROR, String.valueOf(e));
        }
        Test.stopTest();
    }
}
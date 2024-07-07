@isTest
private class SYS_UTILS_TEST {

    @isTest
    private static void TestMethod01() {
        Test.startTest();
        Boolean result = SYS_UTILS.isBatch();
        Test.stopTest();
        System.assertEquals(false, result);
    }

    @isTest
    private static void TestMethod02() {
        Test.startTest();
        Boolean result = SYS_UTILS.isTest();
        Test.stopTest();
        System.assertEquals(true, result);
    }

    @isTest
    private static void TestMethod03() {
        Test.startTest();
        try {
            throw new SYS_UTILS.SYS_EXCEPTION('SYS_UTILS_TEST.TestMethod03');
        }
        catch(Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
        Test.stopTest();
    }
}
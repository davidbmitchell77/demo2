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
}
@isTest
private class PrepareMySandbox_Test {

    @isTest
    private static void TestMethod01() {
        Test.startTest();
        Test.testSandboxPostCopyScript(new PrepareMySandbox(), UserInfo.getOrganizationId(), UserInfo.getOrganizationId(), UserInfo.getOrganizationName());
        Test.stopTest();

        System.assertEquals(50,  [SELECT COUNT() FROM Account]);
        System.assertEquals(300, [SELECT COUNT() FROM Contact WHERE AccountId != null]);
    }
}
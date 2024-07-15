@isTest
private class SYS_UTILS_TEST {

    @isTest
    private static void Test_isAura() {
        Test.startTest();
        Boolean result = SYS_UTILS.isAura();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.isAura(): '+ result);
        System.assertEquals(false, result);
    }

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
    private static void Test_isRest() {
        Test.startTest();
        Boolean result = SYS_UTILS.isRest();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.isRest(): '+ result);
        System.assertEquals(false, result);
    }

    @isTest
    private static void Test_isSoap() {
        Test.startTest();
        Boolean result = SYS_UTILS.isSoap();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.isSoap(): '+ result);
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
    private static void Test_isVisualforce() {
        Test.startTest();
        Boolean result = SYS_UTILS.isVisualforce();
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.Test_isVisualforce(): '+ result);
        System.assertEquals(false, result);
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
    private static void Test_base64() {
        String s1 = SYS_UTILS.guid();
        Test.startTest();
        String base64 = SYS_UTILS.base64Encode(s1);
        String s2 = SYS_UTILS.base64DEcode(base64);
        Test.stopTest();
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.base64Encode(\'' + s1 + '\'): '+ base64);
        System.debug(LoggingLevel.INFO, 'SYS_UTILS.base64Decode(\'' + base64 + '\'): '+ s2);
        System.assertEquals(36, s2.length());
        System.assertEquals(s1, s2);
    }

    @isTest
    private static void Test_exceptions() {
        Test.startTest();
        try { throw new SYS_UTILS.ACCOUNT_TRIGGER_EXCEPTION('ACCOUNT_TRIGGER_EXCEPTION');                 } catch(Exception e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        try { throw new SYS_UTILS.CASE_TRIGGER_EXCEPTION('CASE_TRIGGER_EXCEPTION');                       } catch(Exception e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        try { throw new SYS_UTILS.CAMPAIGN_TRIGGER_EXCEPTION('CAMAPIGN_TRIGGER_EXCEPTION');               } catch(Exception e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        try { throw new SYS_UTILS.CAMPAIGN_MEMBER_TRIGGER_EXCEPTION('CAMAPIGN_MEMBER_TRIGGER_EXCEPTION'); } catch(Exception e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        try { throw new SYS_UTILS.CUSTOM_OBJECT_A_TRIGGER_EXCEPTION('CUSTOM_OBJECT_A_TRIGGER_EXCEPTION'); } catch(Exception e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        try { throw new SYS_UTILS.CUSTOM_OBJECT_B_TRIGGER_EXCEPTION('CUSTOM_OBJECT_B_TRIGGER_EXCEPTION'); } catch(Exception e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        try { throw new SYS_UTILS.LEAD_TRIGGER_EXCEPTION('ACCOUNT_TRIGGER_EXCEPTION');                    } catch(Exception e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        try { throw new SYS_UTILS.OPPORTUNITY_TRIGGER_EXCEPTION('OPPORTUNITY_TRIGGER_EXCEPTION');         } catch(Exception e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        try { throw new SYS_UTILS.APEX_EXCEPTION('SYS_UTILS.APEX_EXCEPTION');                             } catch(Exception e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        try { throw new SYS_UTILS.DML_EXCEPTION('SYS_UTILS.DML_EXCEPTION');                               } catch(Exception e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        try { throw new SYS_UTILS.SYS_EXCEPTION('SYS_UTILS.SYS_EXCEPTION');                               } catch(Exception e) { System.debug(LoggingLevel.ERROR, e.getMessage()); }
        Test.stopTest();
    }
}
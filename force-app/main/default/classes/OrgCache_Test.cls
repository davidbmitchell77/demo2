@isTest
private class OrgCache_Test {

    @isTest
    private static void testMethod01() {
        OrgCache orgCache = new OrgCache();
        orgCache.put('testMethod01', new Time[] {
            Time.newInstance(0,0,0,0),
            Time.newInstance(17,17,17,17)
        });
        Time[] cache = orgCache.get('testMethod01');
        System.assertEquals(2, cache.size());
    }

    @isTest
    private static void testMethod02() {
        OrgCache orgCache = new OrgCache('local.Default');
        orgCache.put('testMethod02', new Time[] {
            Time.newInstance(0,0,0,0),
            Time.newInstance(17,17,17,17)
        }, 300);
        Time[] cache = orgCache.get('testMethod02');
        System.assertEquals(2, cache.size());
    }

    @isTest
    private static void testMethod03() {
        OrgCache orgCache = new OrgCache('local.Default');
        Time[] cache = orgCache.get('testMethod03');
        System.assertEquals(null, cache);
    }
}
@isTest
private class OrgCache_Test {

    @isTest
    private static void testMethod01() {
        OrgCache orgCache = new OrgCache('local.BusSchedule');
        orgCache.put('testMethod01', new Time[] {
            Time.newInstance(0,0,0,0),
            Time.newInstance(17,17,17,17)
        });
        Time[] cache = orgCache.get('testMethod01');
        System.assertEquals(2, cache.size());
    }

    @isTest
    private static void testMethod02() {
        OrgCache orgCache = new OrgCache('local.BusSchedule');
        Time[] cache = orgCache.get('testMethod02');
        System.assertEquals(null, cache);
    }
}
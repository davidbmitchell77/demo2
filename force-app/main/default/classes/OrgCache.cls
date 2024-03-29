public class OrgCache
{
    private Cache.OrgPartition partition;

    public OrgCache(String partitionName) {
        partition = Cache.Org.getPartition(partitionName);
    }

    public void put(String keyName, Time[] keyValue) {
        partition.put(keyName, keyValue);
    }

    public Time[] get(String keyName)
    {
        Time[] cache = (Time[])partition.get(keyName);

        if (cache == null) {
            logCacheMiss(keyName);
        }

        return ((cache != null) ? cache : null);
    }
    
    private void logCacheMiss(String keyName) {
            System.debug(LoggingLevel.WARN, 'Cached value not found for key "' + keyName + '" in org partition ' + partition.getName() + '.');
            Logger.warn('Cached value not found for key "' + keyName + '" in org partition ' + partition.getName() + '.');
            Logger.saveLog();
    }
}
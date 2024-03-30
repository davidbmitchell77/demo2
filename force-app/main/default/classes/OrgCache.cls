public class OrgCache
{
    private Cache.OrgPartition partition;
    private final Integer default_ttl = 2700;
    private final Integer minimum_ttl = 300;

    public OrgCache() {
    }

    public OrgCache(String partitionName) {
        partition = Cache.Org.getPartition(partitionName);
    }

    public void put(String keyName, Time[] keyValue) {
        if (partition != null) { partition.put(keyName, keyValue, default_ttl); }
        if (partition == null) { Cache.Org.put(keyName, keyValue, default_ttl); }
    }

    public void put(String keyName, Time[] keyValue, Integer seconds) {
        if (partition != null) { partition.put(keyName, keyValue, ((seconds >= minimum_ttl) ? seconds : default_ttl)); }
        if (partition == null) { Cache.Org.put(keyName, keyValue, ((seconds >= minimum_ttl) ? seconds : default_ttl)); }
    }

    public Time[] get(String keyName)
    {
        Time[] cache = ((partition != null) ? (Time[])partition.get(keyName) : (Time[])Cache.Org.get(keyName));

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
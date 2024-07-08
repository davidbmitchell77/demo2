public class Campaign_Trigger_Recursion {

    public static Boolean BEFORE_INSERT_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_UPDATE_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_DELETE_ALREADY_INVOKED  = false;
    public static Boolean AFTER_INSERT_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UPDATE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_DELETE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UNDELETE_ALREADY_INVOKED = false;

    public static Map<TriggerOperation,List<Id>> PROCESSED_RECORD_IDS = new Map<TriggerOperation,List<Id>>();

    private static Integer MAX_RECORD_IDS = (Integer)TriggerSettings.getInstance('Campaign').MaxRecordIds__c;
    private static Integer SAVE_HASH_CODE;

    public static void reset(List<Campaign> oldCampaigns, List<Campaign> newCampaigns) {
        Integer hashCode = (newCampaigns != null ? newCampaigns.hashCode() : (oldCampaigns != null ? oldCampaigns.hashCode() : null));
        if (hashCode != SAVE_HASH_CODE) {
            if (SYS_UTILS.isBatch() || SYS_UTILS.isTest()) {
                BEFORE_INSERT_ALREADY_INVOKED  = false;
                BEFORE_UPDATE_ALREADY_INVOKED  = false;
                BEFORE_DELETE_ALREADY_INVOKED  = false;
                AFTER_INSERT_ALREADY_INVOKED   = false;
                AFTER_UPDATE_ALREADY_INVOKED   = false;
                AFTER_DELETE_ALREADY_INVOKED   = false;
                AFTER_UNDELETE_ALREADY_INVOKED = false;
                SAVE_HASH_CODE = hashCode;
                for (TriggerOperation to : PROCESSED_RECORD_IDS.keySet()) {
                    PROCESSED_RECORD_IDS.put(to, reduce(PROCESSED_RECORD_IDS.get(to), MAX_RECORD_IDS));
                }
            }
        }
    }

    public static Boolean alreadyInvoked(TriggerOperation to, Id campaignId) {
        Boolean result = false;
        if (PROCESSED_RECORD_IDS != null) {
            if (PROCESSED_RECORD_IDS.containsKey(to)) {
                result = PROCESSED_RECORD_IDS.get(to).contains(campaignId);
            }
        }
        return result;
    }

    public static void updateProcessedRecordIds(TriggerOperation to, List<Campaign> oldCampaigns, List<Campaign> newCampaigns) {
        List<Campaign> campaigns = (newCampaigns != null ? newCampaigns : oldCampaigns);
        if (campaigns != null) {
            List<Id> campaignIds = nvl(PROCESSED_RECORD_IDS.get(to));
            for (Campaign c : campaigns) {
                if (c.Id != null) {
                    if (!campaignIds.contains(c.Id)) {
                        campaignIds.add(c.Id);
                        PROCESSED_RECORD_IDS.put(to, campaignIds);
                    }
                }
            }
        }
    }

    private static List<Id> reduce(List<Id> recordIds, Integer maxSize) {
        List<Id> results = new List<Id>();
        if (recordIds != null) {
            results = recordIds.clone();
            while (results.size() > maxSize) {
                results.remove(results.size() - 1);
            }
        }
        return results;
    }

    private static List<Id> nvl(List<Id> recordIds) {
        return ((recordIds != null) ? recordIds : new List<Id>());
    }
}
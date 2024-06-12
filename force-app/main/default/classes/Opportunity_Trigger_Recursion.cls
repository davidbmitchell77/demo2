public without sharing class Opportunity_Trigger_Recursion {

    public static Boolean BEFORE_INSERT_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_UPDATE_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_DELETE_ALREADY_INVOKED  = false;
    public static Boolean AFTER_INSERT_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UPDATE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_DELETE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UNDELETE_ALREADY_INVOKED = false;

    public static Map<TriggerOperation,List<Id>> PROCESSED_RECORD_IDS = new Map<TriggerOperation,List<Id>>();

    private static Integer SAVE_HASH_CODE;

    public static void reset(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities) {
        Integer hashCode = (newOpportunities != null ? newOpportunities.hashCode() : (oldOpportunities != null ? oldOpportunities.hashCode() : null));
        if (hashCode != SAVE_HASH_CODE) {
            BEFORE_INSERT_ALREADY_INVOKED  = false;
            BEFORE_UPDATE_ALREADY_INVOKED  = false;
            BEFORE_DELETE_ALREADY_INVOKED  = false;
            AFTER_INSERT_ALREADY_INVOKED   = false;
            AFTER_UPDATE_ALREADY_INVOKED   = false;
            AFTER_DELETE_ALREADY_INVOKED   = false;
            AFTER_UNDELETE_ALREADY_INVOKED = false;
            SAVE_HASH_CODE = hashCode;
            for (TriggerOperation to : PROCESSED_RECORD_IDS.keySet()) {
                PROCESSED_RECORD_IDS.put(to, reduce(PROCESSED_RECORD_IDS.get(to)));
            }
        }
    }

    private static List<Id> reduce(List<Id> recordIds) {
        List<Id> results = new List<Id>();
        if (recordIds != null) {
            results = recordIds.clone();
            while (results.size() > 1200) {
                results.remove(results.size() - 1);
            }
        }
        return results;
    }
}
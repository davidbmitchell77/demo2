public class Opportunity_Trigger_Recursion {

    public static Boolean BEFORE_INSERT_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_UPDATE_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_DELETE_ALREADY_INVOKED  = false;
    public static Boolean AFTER_INSERT_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UPDATE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_DELETE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UNDELETE_ALREADY_INVOKED = false;

    public static Map<TriggerOperation,List<Id>> PROCESSED_RECORD_IDS = new Map<TriggerOperation,List<Id>>();

    private static Integer MAX_RECORD_IDS = (Integer)TriggerSettings.getInstance('Opportunity').MaxRecordIds__c;
    private static Integer SAVE_HASH_CODE;

    public static void reset(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities) {
        Integer hashCode = (newOpportunities != null ? newOpportunities.hashCode() : (oldOpportunities != null ? oldOpportunities.hashCode() : null));
        if (hashCode != SAVE_HASH_CODE) {
            if (SYS_UTILS.isBatch() || SYS_UTILS.isTest()) {
                BEFORE_INSERT_ALREADY_INVOKED  = false;
                BEFORE_UPDATE_ALREADY_INVOKED  = false;
                BEFORE_DELETE_ALREADY_INVOKED  = false;
                AFTER_INSERT_ALREADY_INVOKED   = false;
                AFTER_UPDATE_ALREADY_INVOKED   = false;
                AFTER_DELETE_ALREADY_INVOKED   = false;
                AFTER_UNDELETE_ALREADY_INVOKED = false;
                for (TriggerOperation to : PROCESSED_RECORD_IDS.keySet()) {
                    PROCESSED_RECORD_IDS.put(to, reduce(PROCESSED_RECORD_IDS.get(to), MAX_RECORD_IDS));
                }
            }
            SAVE_HASH_CODE = hashCode;
        }
    }

    public static Boolean alreadyInvoked(TriggerOperation to, Id opportunityId) {
        Boolean result = false;
        if (PROCESSED_RECORD_IDS != null) {
            if (PROCESSED_RECORD_IDS.containsKey(to)) {
                result = PROCESSED_RECORD_IDS.get(to).contains(opportunityId);
            }
        }
        return result;
    }

    public static void updateProcessedRecordIds(TriggerOperation to, List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities) {
        List<Opportunity> opportunities = ((newOpportunities != null) ? newOpportunities : oldOpportunities);
        if (opportunities != null) {
            List<Id> opportunityIds = nvl(PROCESSED_RECORD_IDS.get(to));
            for (Opportunity o : opportunities) {
                if (o.Id != null) {
                    if (!opportunityIds.contains(o.Id)) {
                        opportunityIds.add(o.Id);
                        PROCESSED_RECORD_IDS.put(to, opportunityIds);
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
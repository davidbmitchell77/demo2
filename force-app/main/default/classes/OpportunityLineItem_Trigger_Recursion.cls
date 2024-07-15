public class OpportunityLineItem_Trigger_Recursion {

    public static Boolean BEFORE_INSERT_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_UPDATE_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_DELETE_ALREADY_INVOKED  = false;
    public static Boolean AFTER_INSERT_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UPDATE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_DELETE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UNDELETE_ALREADY_INVOKED = false;

    public static Map<TriggerOperation,List<Id>> PROCESSED_RECORD_IDS = new Map<TriggerOperation,List<Id>>();

    private static Integer MAX_RECORD_IDS = (Integer)TriggerSettings.getInstance('OpportunityLineItem').MaxRecordIds__c;
    private static Integer SAVE_HASH_CODE;

    public static void reset(List<OpportunityLineItem> oldLineItems, List<OpportunityLineItem> newLineItems) {
        Integer hashcode = (newLineItems != null ? newLineItems.hashCode() : (oldLineItems != null ? oldLineItems.hashCode() : null));
        if (hashcode != SAVE_HASH_CODE) {
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

    public static void updateProcessedRecordIds(TriggerOperation to, List<OpportunityLineItem> oldLineItems, List<OpportunityLineItem> newLineItems) {
        List<OpportunityLineItem> lineItems = ((newLineItems != null) ? newLineItems : oldLineItems);
        if (lineItems != null) {
            List<Id> lineItemIds = nvl(PROCESSED_RECORD_IDS.get(to));
            for (OpportunityLineItem li : lineItems) {
                if (li.Id != null) {
                    if (!lineItemIds.contains(li.Id)) {
                        lineItemIds.add(li.Id);
                        PROCESSED_RECORD_IDS.put(to, lineItemIds);
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
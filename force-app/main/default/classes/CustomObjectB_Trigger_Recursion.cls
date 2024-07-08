public without sharing class CustomObjectB_Trigger_Recursion {

    public static Boolean BEFORE_INSERT_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_UPDATE_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_DELETE_ALREADY_INVOKED  = false;
    public static Boolean AFTER_INSERT_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UPDATE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_DELETE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UNDELETE_ALREADY_INVOKED = false;

    public static Map<TriggerOperation,List<Id>> PROCESSED_RECORD_IDS = new Map<TriggerOperation,List<Id>>();

    private static Integer MAX_RECORD_IDS = (Integer)TriggerSettings.getInstance('CustomObjectB').MaxRecordIds__c;
    private static Integer SAVE_HASH_CODE;

    public static void reset(List<CustomObjectB__c> oldRecords, List<CustomObjectB__c> newRecords) {
        Integer hashCode = (newRecords != null ? newRecords.hashCode() : (oldRecords != null ? oldRecords.hashCode() : null));
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

    public static Boolean alreadyInvoked(TriggerOperation to, Id recordId) {
        Boolean result = false;
        if (PROCESSED_RECORD_IDS != null) {
            if (PROCESSED_RECORD_IDS.containsKey(to)) {
                result = PROCESSED_RECORD_IDS.get(to).contains(recordId);
            }
        }
        return result;
    }

    public static void updateProcessedRecordIds(TriggerOperation to, List<CustomObjectB__c> oldRecords, List<CustomObjectB__c> newRecords) {
        List<CustomObjectB__c> records = ((newRecords != null) ? newRecords : oldRecords);
        if (records != null) {
            List<Id> recordIds = nvl(PROCESSED_RECORD_IDS.get(to));
            for (CustomObjectB__c objb : records) {
                if (objb.Id != null) {
                    if (!recordIds.contains(objb.Id)) {
                        recordIds.add(objb.Id);
                        PROCESSED_RECORD_IDS.put(to, recordIds);
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
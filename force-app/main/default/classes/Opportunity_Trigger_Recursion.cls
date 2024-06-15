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
    private static Integer MAX_RECORD_IDS = (Integer)TriggerSettings.getInstance('Opportunity').MaxRecordIds__c;

    public static void reset(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities) {
        Integer hashCode = (newOpportunities != null ? newOpportunities.hashCode() : (oldOpportunities != null ? oldOpportunities.hashCode() : null));
        if (hashCode != SAVE_HASH_CODE) {
            if (isBatchJob() || isTest()) {
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
    }

    private static Boolean isBatchJob() {
        Boolean result = false;
        switch on Request.getCurrent().getQuiddity() {
            when BATCH_ACS            { result = true; }
            when BATCH_APEX           { result = true; }
            when BATCH_CHUNK_PARALLEL { result = true; }
            when BATCH_CHUNK_SERIAL   { result = true; }
            when BULK_API             { result = true; }
            when QUEUEABLE            { result = true; }
        }
        return result;
    }

    private static Boolean isTest() {
        Boolean result = false;
        switch on Request.getCurrent().getQuiddity() {
            when RUNTEST_DEPLOY               { result = true; }
            when RUNTEST_SYNC, RUNTEST_ASYNC  { result = true; }
        }
        return result;
    }


    private static List<Id> reduce(List<Id> recordIds) {
        List<Id> results = new List<Id>();
        if (recordIds != null) {
            results = recordIds.clone();
            while (results.size() > MAX_RECORD_IDS) {
                results.remove(results.size() - 1);
            }
        }
        return results;
    }
}
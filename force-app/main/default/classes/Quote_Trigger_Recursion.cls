public class Quote_Trigger_Recursion {

    public static Boolean BEFORE_INSERT_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_UPDATE_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_DELETE_ALREADY_INVOKED  = false;
    public static Boolean AFTER_INSERT_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UPDATE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_DELETE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UNDELETE_ALREADY_INVOKED = false;

    public static Map<TriggerOperation,List<Id>> PROCESSED_RECORD_IDS = new Map<TriggerOperation,List<Id>>();

    private static Integer MAX_RECORD_IDS = (Integer)TriggerSettings.getInstance('Quote').MaxRecordIds__c;
    private static Integer SAVE_HASH_CODE;

    public static void reset(List<Quote> oldQuotes, List<Quote> newQuotes) {
        Integer hashCode = (newQuotes != null ? newQuotes.hashCode() : (oldQuotes != null ? oldQuotes.hashCode() : null));
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

    public static Boolean alreadyInvoked(TriggerOperation to, Id QuoteId) {
        Boolean result = false;
        if (PROCESSED_RECORD_IDS != null) {
            if (PROCESSED_RECORD_IDS.containsKey(to)) {
                result = PROCESSED_RECORD_IDS.get(to).contains(QuoteId);
            }
        }
        return result;
    }

    public static void updateProcessedRecordIds(TriggerOperation to, List<Quote> oldQuotes, List<Quote> newQuotes) {
        List<Quote> quotes = ((newQuotes != null) ? newQuotes : oldQuotes);
        if (quotes != null) {
            List<Id> QuoteIds = nvl(PROCESSED_RECORD_IDS.get(to));
            for (Quote q : quotes) {
                if (q.Id != null) {
                    if (!QuoteIds.contains(q.Id)) {
                        QuoteIds.add(q.Id);
                        PROCESSED_RECORD_IDS.put(to, QuoteIds);
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
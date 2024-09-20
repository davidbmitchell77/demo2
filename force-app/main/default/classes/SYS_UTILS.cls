public class SYS_UTILS {

    public static Boolean isAura() {
        return (Request.getCurrent().getQuiddity() == Quiddity.AURA);
    }

    public static Boolean isBatch() {
        Boolean result = false;
        switch on Request.getCurrent().getQuiddity() {
            when BATCH_ACS            { result = true; }
            when BATCH_APEX           { result = true; }
            when BATCH_CHUNK_PARALLEL { result = true; }
            when BATCH_CHUNK_SERIAL   { result = true; }
            when BULK_API             { result = true; }
        }
        return result;
    }

    public static Boolean isBulkApi() {
        return (Request.getCurrent().getQuiddity() == Quiddity.BULK_API);
    }

    public static Boolean isFuture() {
        return (Request.getCurrent().getQuiddity() == Quiddity.FUTURE);
    }

    public static Boolean isQueueable() {
        return (Request.getCurrent().getQuiddity() == Quiddity.QUEUEABLE);
    }

    public static Boolean isRest() {
        return (Request.getCurrent().getQuiddity() == Quiddity.REST);
    }

    public static Boolean isSoap() {
        return (Request.getCurrent().getQuiddity() == Quiddity.SOAP);
    }

    public static Boolean isScheduled() {
        return (Request.getCurrent().getQuiddity() == Quiddity.SCHEDULED);
    }

    public static Boolean isTest() {
        Boolean result = false;
        switch on Request.getCurrent().getQuiddity() {
            when RUNTEST_DEPLOY              { result = true; }
            when RUNTEST_SYNC, RUNTEST_ASYNC { result = true; }
        }
        return result;
    }

    public static Boolean isVisualforce() {
        return (Request.getCurrent().getQuiddity() == Quiddity.VF);
    }

    public static String guid() {
        return String.valueOf(UUID.randomUUID()).toUpperCase();
    }

    public static String uuid() {
        return String.valueOf(UUID.randomUUID()).toLowerCase();
    }

    public static String base64Encode(String s) {
        return String.valueOf(EncodingUtil.base64Encode(Blob.valueOf(s)));
    }

    public static String base64Decode(String s) {
        return EncodingUtil.base64Decode(s).toString();
    }

    public class ACCOUNT_TRIGGER_EXCEPTION                extends Exception {}
    public class CAMPAIGN_TRIGGER_EXCEPTION               extends Exception {}
    public class CAMPAIGN_MEMBER_TRIGGER_EXCEPTION        extends Exception {}
    public class CASE_TRIGGER_EXCEPTION                   extends Exception {}
    public class CONTACT_TRIGGER_EXCEPTION                extends Exception {}
    public class CUSTOM_OBJECT_A_TRIGGER_EXCEPTION        extends Exception {}
    public class CUSTOM_OBJECT_B_TRIGGER_EXCEPTION        extends Exception {}
    public class LEAD_TRIGGER_EXCEPTION                   extends Exception {}
    public class OPPORTUNITY_TRIGGER_EXCEPTION            extends Exception {}
    public class OPPORTUNITY_LINE_ITEM_TRIGGER_EXCEPTION  extends Exception {}
    public class APEX_EXCEPTION                           extends Exception {}
    public class DML_EXCEPTION                            extends Exception {}
    public class SYS_EXCEPTION                            extends Exception {}
}
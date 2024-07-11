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
            when QUEUEABLE            { result = true; }
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

    public class SYS_EXCEPTION extends Exception {}
}
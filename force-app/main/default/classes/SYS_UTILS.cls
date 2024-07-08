public class SYS_UTILS {

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

    public static Boolean isTest() {
        Boolean result = false;
        switch on Request.getCurrent().getQuiddity() {
            when RUNTEST_DEPLOY              { result = true; }
            when RUNTEST_SYNC, RUNTEST_ASYNC { result = true; }
        }
        return result;
    }

    public static String guid() {
        return uuid().toUppercase();
    }

    public static String uuid() {
        return String.valueOf(UUID.randomUUID());
    }

    public class SYS_EXCEPTION extends Exception {}
}
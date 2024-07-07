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

    public static void log(LoggingLevel logLevel, String msg, List<sObject> oldObjects, List<sObject> newObjects, String tag) {
        List<sObject> recs = ((newObjects != null) ? newObjects : oldObjects);
        switch on logLevel {
            when DEBUG  { Logger.debug(msg,  recs);             }
            when INFO   { Logger.info(msg,   recs);             }
            when WARN   { Logger.warn(msg,   recs);             }
            when ERROR  { Logger.error(msg,  recs).addTag(tag); }
            when FINE   { Logger.fine(msg,   recs);             }
            when FINER  { Logger.finer(msg,  recs);             }
            when FINEST { Logger.finest(msg, recs);             }
        }
        Logger.saveLog();
    }

    public class SYS_EXCEPTION extends Exception {}
}
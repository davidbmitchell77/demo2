public class AuraLogger {

    @AuraEnabled(cacheable=false)
    public static void debug(String msg) {
        if (!String.isBlank(msg)) {
            Logger.debug(msg);
            Logger.saveLog();
        }
    }

    @AuraEnabled(cacheable=false)
    public static void error(String msg, List<String> tags) {
        Integer i = ((tags != null) ? tags.size() : 0);
        switch on i {
            when 0    { Logger.error(msg); }
            when 1    { Logger.error(msg).addTag(tags[0]); }
            when 2    { Logger.error(msg).addTag(tags[0]).addTag(tags[1]); }
            when 3    { Logger.error(msg).addTag(tags[0]).addTag(tags[1]).addTag(tags[2]); }
            when 4    { Logger.error(msg).addTag(tags[0]).addTag(tags[1]).addTag(tags[2]).addTag(tags[3]); }
            when 5    { Logger.error(msg).addTag(tags[0]).addTag(tags[1]).addTag(tags[2]).addTag(tags[3]).addTag(tags[4]); }
            when else { Logger.error(msg).addTag(tags[0]).addTag(tags[1]).addTag(tags[2]).addTag(tags[3]).addTag(tags[4]); }
        }
        if (i > 0) {
            if (!String.isEmpty(msg)) {
                Logger.saveLog();
            }
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static void fine(String msg) {
        if (!String.isBlank(msg)) {
            Logger.fine(msg);
            Logger.saveLog();
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static void finer(String msg) {
        if (!String.isBlank(msg)) {
            Logger.finer(msg);
            Logger.saveLog();
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static void finest(String msg) {
        if (!String.isBlank(msg)) {
            Logger.finest(msg);
            Logger.saveLog();
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static void info(String msg) {
        if (!String.isBlank(msg)) {
            Logger.info(msg);
            Logger.saveLog();
        }
    }
}

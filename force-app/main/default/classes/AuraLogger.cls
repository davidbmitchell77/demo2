public class AuraLogger {

    @AuraEnabled(cacheable=false)
    public static void debug(String s) {
        if (!String.isBlank(s)) {
            Logger.debug(s);
            Logger.saveLog();
        }
    }

    @AuraEnabled(cacheable=false)
    public static void error(String s, List<String> tags) {
        Integer i = ((tags != null) ? tags.size() : 0);
        switch on i {
            when 0    { Logger.error(s); }
            when 1    { Logger.error(s).addTag(tags[0]); }
            when 2    { Logger.error(s).addTag(tags[0]).addTag(tags[1]); }
            when 3    { Logger.error(s).addTag(tags[0]).addTag(tags[1]).addTag(tags[2]); }
            when 4    { Logger.error(s).addTag(tags[0]).addTag(tags[1]).addTag(tags[2]).addTag(tags[3]); }
            when 5    { Logger.error(s).addTag(tags[0]).addTag(tags[1]).addTag(tags[2]).addTag(tags[3]).addTag(tags[4]); }
            when else { Logger.error(s).addTag(tags[0]).addTag(tags[1]).addTag(tags[2]).addTag(tags[3]).addTag(tags[4]); }
        }
        if (i > 0) {
            Logger.saveLog();
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static void fine(String s) {
        if (!String.isBlank(s)) {
            Logger.fine(s);
            Logger.saveLog();
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static void finer(String s) {
        if (!String.isBlank(s)) {
            Logger.finer(s);
            Logger.saveLog();
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static void finest(String s) {
        if (!String.isBlank(s)) {
            Logger.finest(s);
            Logger.saveLog();
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static void info(String s) {
        if (!String.isBlank(s)) {
            Logger.info(s);
            Logger.saveLog();
        }
    }
}

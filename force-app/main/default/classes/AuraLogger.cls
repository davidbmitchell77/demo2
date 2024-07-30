public class AuraLogger {

    @AuraEnabled(cacheable=false)
    public static void debug(List<String> messages) {
        Integer messageCount = 0;
        if (messages != null) {
            if (!messages.isEmpty()) {
                for (String msg : messages) {
                    if (!String.isBlank(msg)) {
                        Logger.debug(msg);
                        messageCount++;
                    }
                }
            }
        }
        if (messageCount > 0) {
            Logger.saveLog();
        }
    }

    @AuraEnabled(cacheable=false)
    public static void error(List<String> messages, List<String> tags) {
        Integer messageCount = 0;
        if (messages != null) {
            if (!messages.isEmpty()) {
                for (String msg : messages) {
                    if (!String.isBlank(msg)) {
                        switch on ((tags != null) ? tags.size() : 0) {
                            when 0    { Logger.error(msg); }
                            when 1    { Logger.error(msg).addTag(tags[0]); }
                            when 2    { Logger.error(msg).addTag(tags[0]).addTag(tags[1]); }
                            when 3    { Logger.error(msg).addTag(tags[0]).addTag(tags[1]).addTag(tags[2]); }
                            when 4    { Logger.error(msg).addTag(tags[0]).addTag(tags[1]).addTag(tags[2]).addTag(tags[3]); }
                            when 5    { Logger.error(msg).addTag(tags[0]).addTag(tags[1]).addTag(tags[2]).addTag(tags[3]).addTag(tags[4]); }
                            when else { Logger.error(msg).addTag(tags[0]).addTag(tags[1]).addTag(tags[2]).addTag(tags[3]).addTag(tags[4]); }
                        }
                    }
                    messageCount++;
                }
            }
        }
        if (messageCount > 0) {
            Logger.saveLog();
        }
    }

    @AuraEnabled(cacheable=false)
    public static void fine(List<String> messages) {
        Integer messageCount = 0;
        if (messages != null) {
            if (!messages.isEmpty()) {
                for (String msg : messages) {
                    if (!String.isBlank(msg)) {
                        Logger.fine(msg);
                        messageCount++;
                    }
                }
            }
        }
        if (messageCount > 0) {
            Logger.saveLog();
        }
    }

    @AuraEnabled(cacheable=false)
    public static void finer(List<String> messages) {
        Integer messageCount = 0;
        if (messages != null) {
            if (!messages.isEmpty()) {
                for (String msg : messages) {
                    if (!String.isBlank(msg)) {
                        Logger.finer(msg);
                        messageCount++;
                    }
                }
            }
        }
        if (messageCount > 0) {
            Logger.saveLog();
        }
    }


    @AuraEnabled(cacheable=false)
    public static void finest(List<String> messages) {
        Integer messageCount = 0;
        if (messages != null) {
            if (!messages.isEmpty()) {
                for (String msg : messages) {
                    if (!String.isBlank(msg)) {
                        Logger.finest(msg);
                        messageCount++;
                    }
                }
            }
        }
        if (messageCount > 0) {
            Logger.saveLog();
        }
    }
    @AuraEnabled(cacheable=false)
    public static void info(List<String> messages) {
        Integer messageCount = 0;
        if (messages != null) {
            if (!messages.isEmpty()) {
                for (String msg : messages) {
                    if (!String.isBlank(msg)) {
                        Logger.info(msg);
                        messageCount++;
                    }
                }
            }
        }
        if (messageCount > 0) {
            Logger.saveLog();
        }
    }
}

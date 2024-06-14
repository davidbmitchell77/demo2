public class Lead_Trigger_Recursion {

    public static Boolean BEFORE_INSERT_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_UPDATE_ALREADY_INVOKED  = false;
    public static Boolean BEFORE_DELETE_ALREADY_INVOKED  = false;
    public static Boolean AFTER_INSERT_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UPDATE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_DELETE_ALREADY_INVOKED   = false;
    public static Boolean AFTER_UNDELETE_ALREADY_INVOKED = false;

    private static Integer SAVE_HASH_CODE;

    public static void reset(List<Lead> oldLeads, List<Lead> newLeads) {
        Integer hashCode = (newLeads != null ? newLeads.hashCode() : (oldLeads != null ? oldLeads.hashCode() : null));
        if (hashCode != SAVE_HASH_CODE) {
            BEFORE_INSERT_ALREADY_INVOKED  = false;
            BEFORE_UPDATE_ALREADY_INVOKED  = false;
            BEFORE_DELETE_ALREADY_INVOKED  = false;
            AFTER_INSERT_ALREADY_INVOKED   = false;
            AFTER_UPDATE_ALREADY_INVOKED   = false;
            AFTER_DELETE_ALREADY_INVOKED   = false;
            AFTER_UNDELETE_ALREADY_INVOKED = false;
            SAVE_HASH_CODE = hashCode;
        }
    }
}
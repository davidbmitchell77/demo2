public class TriggerSettings {

    public static TriggerSetting__mdt getInstance(String objectName) {
        return (SYS_UTILS.isTest() ? TriggerSetting__mdt.getInstance('Test') : TriggerSetting__mdt.getInstance(objectName));
    } 
}
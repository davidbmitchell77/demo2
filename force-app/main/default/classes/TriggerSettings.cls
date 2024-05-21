public class TriggerSettings {

    public static TriggerSetting__mdt getInstance(String objectName) {
        return (Test.isRunningTest() ? TriggerSetting__mdt.getInstance('Test') : TriggerSetting__mdt.getInstance(objectName));
    } 
}
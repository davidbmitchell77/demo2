public class MyExtendsClass extends MyVirtualClass {

    public MyExtendsClass(String s) {
        System.debug(LoggingLevel.INFO, String.valueOf(this).split(':')[0] + '.s: ' + s);
    }

    public override Datetime now() {
        return Datetime.now().addDays(1);
    }
}
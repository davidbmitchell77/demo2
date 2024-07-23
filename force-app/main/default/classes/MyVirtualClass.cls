public virtual class MyVirtualClass {

    public final Decimal e  = Math.E;
    public final Decimal pi = Math.PI;

    public MyVirtualClass() {
        System.debug(LoggingLevel.INFO, 'Request Id: ' + Request.getCurrent().getRequestId());
    }

    public virtual Datetime now() {
        return Datetime.now();
    } 
}
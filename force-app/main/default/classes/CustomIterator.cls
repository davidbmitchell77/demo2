public class CustomIterator implements Iterator<Account> {

   private List<Account> accounts;
   private Integer i;

   public CustomIterator(List<Account> accounts) {
       this.accounts = accounts;
       this.i = 0;
   }

   public Boolean hasNext() {
       return ((i >= accounts.size()) ? false : true);
   }

   public Account next() {
       Account result = new Account();
       if (hasNext() == true) {
           result = accounts[i++];
       }
       return result;
   }
}
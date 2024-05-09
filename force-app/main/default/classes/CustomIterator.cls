public class CustomIterator implements Iterator<Account> {

   private List<Account> accounts;
   private Integer currentIndex;

   public CustomIterator(List<Account> accounts) {
       this.accounts = accounts;
       this.currentIndex = 0;
   }

   public Boolean hasNext() {
       return ((accounts.size() - 1) > currentIndex);
   }

   public Account next() {
       Account result = new Account();
       if (hasNext() == true) {
           result = accounts[++currentIndex];
       }
       return result;
   }
}
public class CustomIterable implements Iterable<Account> {

   private final Integer maxQuerySize = 200;

   public Iterator<Account> iterator() {
      List<Account> accounts = [SELECT Id,
                                       Name,
                                       NumberOfEmployees 
                                  FROM Account
                                 LIMIT :maxQuerySize
      ];
      return (new CustomIterator(accounts));
   }
}
public with sharing class AccountController
{
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList()
    {
        List<Account> results = new List<Account>();

        try
        {
            results =
            [
                SELECT Id,
                       Name,
                       Type,
                       Industry
                  FROM Account
                 WHERE Type != null
                 ORDER BY Name ASC
                 LIMIT 5
            ];
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return results;
    }
}

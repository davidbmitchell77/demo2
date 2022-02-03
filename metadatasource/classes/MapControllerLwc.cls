public with sharing class MapControllerLwc
{
    private static Integer cacheSize = 10;

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts()
    {
        List<Account> results = new List<Account>();

        results = [SELECT Id,
                          Name,
                          Description,
                          BillingStreet,
                          BillingCountry,
                          BillingCity,
                          BillingState,
                          BillingPostalCode
                     FROM Account
                 ORDER BY Name
                    LIMIT :cacheSize
        ];

        return results;
   }
}
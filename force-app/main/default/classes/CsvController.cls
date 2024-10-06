public with sharing class CsvController {
    private static final Integer cacheSize = 20;

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id,
                       Name,
                       Phone,
                       AnnualRevenue,
                       Industry
                  FROM Account
                 LIMIT :cacheSize
        ];
    }
}
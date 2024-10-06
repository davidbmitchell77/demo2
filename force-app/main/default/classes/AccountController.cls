public with sharing class AccountController {
    private static final Integer maxRecords = 5;

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        List<Account> results = new List<Account>();
        try {
            results = [SELECT Id,
                              Name,
                              Type,
                              Industry
                         FROM Account
                     ORDER BY Name ASC
                        LIMIT :maxRecords
            ];
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountListByType(String type) {
        List<Account> results = new List<Account>();
        try {
            results = [SELECT Id,
                              Name,
                              Type,
                              Industry
                         FROM Account
                        WHERE Type = :type
                        LIMIT :maxRecords
            ];
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountListBySearchKey(String searchKey) {
        List<Account> results = new List<Account>();
        try {
            results = [SELECT Id,
                              Name,
                              Type,
                              Industry
                         FROM Account
                        WHERE Name LIKE :('%' + searchKey + '%')
                        LIMIT :maxRecords
            ];
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return results;
    }
}
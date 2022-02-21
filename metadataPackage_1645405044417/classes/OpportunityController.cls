public with sharing class OpportunityController
{
    private static Integer cacheSize = 1024;

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities() {
        return [SELECT StageName FROM Opportunity LIMIT :cacheSize];
    }
}
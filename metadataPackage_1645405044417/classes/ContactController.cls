public with sharing class ContactController
{
    private static Integer cacheSize = 50;

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList()
    {
        return [SELECT Id,
                       Name,
                       Title,
                       Email
                  FROM Contact
                 LIMIT :cacheSize
        ];
    }
}
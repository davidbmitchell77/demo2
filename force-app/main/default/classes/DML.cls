public with sharing class DML {

    public static void del(List<sObject> sObjects) {
        if (sObjects != null) {
            Savepoint sp = Database.setSavepoint();
            try {
                delete sObjects;
            }
            catch(DmlException e) {
                rollback(sp, sObjects, e);
            }
            finally {
                Database.releaseSavepoint(sp);
            }
        }
    }

    public static void ins(List<sObject> sObjects) {
        if (sObjects != null) {
            Savepoint sp = Database.setSavepoint();
            try {
                insert sObjects;
            }
            catch(DmlException e) {
                rollback(sp, sObjects, e);
            }
            finally {
                Database.releaseSavepoint(sp);
            }
        }
    }

    public static void upd(List<sObject> sObjects) {
        if (sObjects != null) {
            Savepoint sp = Database.setSavepoint();
            try {
                update sObjects;
            }
            catch(DmlException e) {
                rollback(sp, sObjects, e);
            }
            finally {
                Database.releaseSavepoint(sp);
            }
        }
    }

    public static void ups(List<sObject> sObjects) {
        if (sObjects != null) {
            Savepoint sp = Database.setSavepoint();
            try {
                upsert sObjects;
            }
            catch(DmlException e) {
                rollback(sp, sObjects, e);
            }
            finally {
                Database.releaseSavepoint(sp);
            }
        }
    }

    public static void ups(List<sObject> sObjects, Schema.SObjectField externalIdField) {
        String objType = sObjects[0].getSobjectType().getDescribe().getName();
        if (objType == 'Account') upsert (List<Account>)sObjects; //externalIdField;
    }

    public static void ups(List<Account> accounts, Schema.SObjectField externalIdField) {

        Set<String> externalIds = new Set<String>();
        for (Account a : accounts) {
            if (a.Name != null) {
                if (!externalIds.contains(a.Name)) {
                    externalIds.add(a.Name);
                }
            }
        }

        List<Account> insRecords = new List<Account>();
        List<Account> updRecords = new List<Account>();

        for (Account a : [SELECT Id, Name FROM Account WHERE Name IN :externalIds]) {
        if (a.Name != null) {
                if (externalIds.contains(a.Name)) {
                    updRecords.add(a);
                } else {
                    insRecords.add(a);
                }
            }
        }

        Savepoint sp = Database.setSavepoint();
        try {
            if (!updRecords.isEmpty()) { update updRecords; }
            if (!insRecords.isEmpty()) { insert insRecords; }
        }
        catch(DmlException e) {
            rollback(sp, accounts, e);
        }
        finally {
            Database.releaseSavepoint(sp);
        }
    }

    private static void rollback(SavePoint sp, List<sObject> sObjects, DmlException e) {
        Database.rollback(sp);
        System.debug(LoggingLevel.ERROR, e.getMessage());
        Logger.error(e.getMessage(), sObjects);
        Logger.saveLog();
        throw new AuraHandledException(e.getMessage());
    }
}
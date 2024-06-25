public with sharing class DB_UTILS {

    public static void del(List<sObject> sObjects) {
        if (sObjects != null) {
            Savepoint sp = Database.setSavepoint();
            try {
                delete sObjects;
            }
            catch(dmlException e) {
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
            catch(dmlException e) {
                rollback(sp, sObjects, e);
            }
            finally {
                Database.releaseSavepoint(sp);
            }
        }
    }

    public static void upd(List<sObject> sObjects) {
        Savepoint sp = Database.setSavepoint();
        if (sObjects != null) {
            try {
                update sObjects;
            }
            catch(dmlException e) {
                rollback(sp, sObjects, e);
            }
            finally {
                Database.releaseSavepoint(sp);
            }
        }
    }

/*
    public static void ups(List<sObject> sObjects, Schema.SObjectField externalIdField) {
        Set<String> externalIds = new Set<String>();

        for (sObject o : sObjects) {
            if (o.externalIdField != null) {
                if (!externalIds.contains(o.externalIdField)) {
                    externalIds.add(o.externalIdField);
                }
            }
        }

        List<sObject> insRecords = new List<sObject>();
        List<sObject> updRecords = new List<sObject>();

        for (sObject o : (List<sObject>)[SELECT Id, Name FROM Account WHERE Name IN :externalIds]) {
        if (o.Name != null) {
                if (externalIds.contains(a.Name)) {
                    updRecords.add(o);
                } else {
                    insRecords.add(o);
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
    */

    public static void ups(List<sObject> sObjects) {
        if (sObjects != null) {
            Savepoint sp = Database.setSavepoint();
            try {
                upsert sObjects;
            }
            catch(dmlException e) {
                rollback(sp, sObjects, e);
            }
            finally {
                Database.releaseSavepoint(sp);
            }
        }
    }

    public static void und(List<sObject> sObjects) {
        if (sObjects != null) {
            Savepoint sp = Database.setSavepoint();
            try {
                undelete sObjects;
            }
            catch(dmlException e) {
                rollback(sp, sObjects, e);
            }
            finally {
                Database.releaseSavepoint(sp);
            }
        }
    }

    private static void rollback(SavePoint sp, List<sObject> sObjects, DmlException e) {
        Database.rollback(sp);
        Logger.error(e.getMessage(), sObjects);
        Logger.saveLog();
        throw new AuraHandledException(e.getMessage());
    }
}
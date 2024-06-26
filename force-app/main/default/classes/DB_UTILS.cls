public with sharing class DB_UTILS {

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

    public static void und(List<sObject> sObjects) {
        if (sObjects != null) {
            Savepoint sp = Database.setSavepoint();
            try {
                undelete sObjects;
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
        Savepoint sp = Database.setSavepoint();
        if (sObjects != null) {
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

    public static void ups(List<sObject> sObjects, Schema.SObjectField externalIdField) {
        if (sObjects != null) {
            String objectApiName = String.valueOf(externalIdField.getDescribe().getSObjectType());
            String externalIdFieldName = String.valueOf(externalIdField.getDescribe().getName());
            String q = 'SELECT ' + externalIdFieldName + ' FROM ' + objectApiName + ' WHERE ' + externalIdFieldName + ' IN(' + csv(externalIds(sObjects, externalIdField)) + ')';
            Set<String> existingExternalIds = externalIds(Database.query(q), externalIdField);
            List<sObject> insRecords = new List<sObject>();
            List<sObject> updRecords = new List<sObject>();
            for (sObject o : sObjects) {
                String externalId = String.valueOf(o.get(externalIdField));
                if (existingExternalIds.contains(externalId)) {
                    updRecords.add(o);
                } else {
                    insRecords.add(o);
                }
            }
            Savepoint sp = Database.setSavepoint();
            try {
                if (!updRecords.isEmpty()) { update updRecords; }
                if (!insRecords.isEmpty()) { insert insRecords; }
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

    private static String csv(Set<String> externalIds) {
        String result = '';
        if (externalIds != null) {
            String comma = '';
            for (String s : externalIds) {
                result += comma + '\'' + s + '\'';
                comma = ',';
            }
        }
        return result;
    }

    private static Set<String> externalIds(List<sObject> sObjects, Schema.SObjectField externalIdField) {
        Set<String> results = new Set<String>();
        if (sObjects != null) {
            for (sObject o : sObjects) {
                String externalId = String.valueOf(o.get(externalIdField));
                if (!String.isEmpty(externalId)) {
                    if (!results.contains(externalId)) {
                        results.add(externalId);
                    }
                }
            }
        }
        return results;
    }

    private static void rollback(SavePoint sp, List<sObject> sObjects, DmlException e) {
        Database.rollback(sp);
        Logger.error(e.getMessage(), sObjects);
        Logger.saveLog();
        throw new AuraHandledException(e.getMessage());
    }
}
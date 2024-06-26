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
            Set<String> newExternalIds = new Set<String>();
            for (sObject o : sObjects) {
                String externalId = String.valueOf(o.get(externalIdField));
                if (!String.isEmpty(externalId)) {
                    if (!newExternalIds.contains(externalId)) {
                        newExternalIds.add(externalId);
                    }
                }
            }
            String objectApiName = String.valueOf(externalIdField.getDescribe().getSObjectType());
            String externalIdFieldName = String.valueOf(externalIdField.getDescribe().getName());
            String q = 'SELECT ' + fieldNames(objectApiName) + ' FROM ' + objectApiName + ' WHERE ' + externalIdFieldName + ' IN(' + csv(newExternalIds) + ')';
            Set<String> existingExternalIds = new Set<String>();
            for (sObject o : Database.query(q)) {
                String externalId = String.valueOf(o.get(externalIdField));
                if (!String.isEmpty(externalId)) {
                    if (!existingExternalIds.contains(externalId)) {
                        existingExternalIds.add(externalId);
                    }
                }
            }
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

    private static String fieldNames(String objectApiName) {
        String result = '';
        if (!String.isEmpty(objectApiName)) {
            String comma = '';
            Map<String,Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap();
            for(String fieldName : fieldMap.keyset()) {
                result += comma + fieldName;
                comma = ', ';
            }
        }
        return result;
    }

    private static void rollback(SavePoint sp, List<sObject> sObjects, DmlException e) {
        Database.rollback(sp);
        Logger.error(e.getMessage(), sObjects);
        Logger.saveLog();
        throw new AuraHandledException(e.getMessage());
    }
}
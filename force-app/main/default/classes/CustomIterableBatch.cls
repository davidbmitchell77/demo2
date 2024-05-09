public class CustomIterableBatch implements Database.Batchable<Account> {

    public Iterable<Account> start(Database.BatchableContext bc) {
        return new CustomIterable();
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {

        List<Account> accounts = new List<Account>();

        for(Account a : scope) {
            a.NumberOfEmployees = ((a.NumberOfEmployees == null) ? 100 : (a.NumberOfEmployees * 10));
            accounts.add(a);
        }

        if (!accounts.isEmpty())
        {
            List<Database.SaveResult> saveResults = Database.update(accounts, false);
            for (Database.SaveResult sr : saveResults)
            {
                if (sr.isSuccess() ) { logDatabaseSaveSuccess(sr.getId());                }
                if (!sr.isSuccess()) { logDatabaseSaveErrors(sr.getId(), sr.getErrors()); }
            }
        }
    }

    public void logDatabaseSaveSuccess(String recordId) {
        System.debug(LoggingLevel.INFO, 'Successfully updated account record (Id: ' + recordId + ').');
    }

    public void logDatabaseSaveErrors(String recordId, List<Database.Error> errors) {
        System.debug(LoggingLevel.ERROR, 'Error updating account record (Id: ' + recordId + ').');
        for (Database.Error e : errors) {
            System.debug(LoggingLevel.ERROR, 'Status code ' + e.getStatusCode() + ': ' + e.getMessage());
            System.debug(LoggingLevel.ERROR, 'Account fields that affected this error: ' + e.getFields());
        }
    }

    public void finish(Database.BatchableContext bc) {

        AsyncApexJob job = [SELECT Id,
                                   Status,
                                   NumberOfErrors,
                                   JobItemsProcessed,
                                   TotalJobItems,
                                   CreatedBy.Email
                              FROM AsyncApexJob
                             WHERE Id = :bc.getJobId()
                             LIMIT 1
        ];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>{ job.CreatedBy.Email };
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Apex Job CustomIterableBatchClass ' + job.Status);
        mail.setPlainTextBody('The batch apex job ' + bc.getJobId() + ' processed ' + job.TotalJobItems + ' batches with ' + job.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { mail });
    }
}
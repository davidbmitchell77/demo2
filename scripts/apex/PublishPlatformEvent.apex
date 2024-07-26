List<LightningWebComponent__e> lwcEvents = new List<LightningWebComponent__e>();
lwcEvents.add(new LightningWebComponent__e(Message__c='Math.E: '  + Math.E ));
lwcEvents.add(new LightningWebComponent__e(Message__c='Math.PI: ' + Math.PI));

List<Database.SaveResult> saveResults = EventBus.publish(lwcEvents);

for (Database.SaveResult sr : saveResults) {
    if (!sr.isSuccess()) {
        for (Database.Error e : sr.getErrors()) {
            Logger.error(JSON.serialize(e)).addTag('LightningWebComponent__e');
            Logger.saveLog();
        }
    }       
}

trigger IntegrationOrderTrigger on Integration_Order__c (before insert, after insert) {

    if (Trigger.isBefore && Trigger.isInsert) {
        IntegrationOrderTriggerHandler.beforeInsert(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        IntegrationOrderTriggerHandler.afterInsert(Trigger.new);
    }

}
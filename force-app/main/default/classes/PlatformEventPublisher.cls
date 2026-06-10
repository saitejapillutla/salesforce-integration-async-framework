public with sharing class PlatformEventPublisher {

    public static void publishEvent(
        String eventType,
        Id orderId,
        String message
    ) {
        Integration_Event__e eventRecord = new Integration_Event__e();
        eventRecord.Event_Type__c = eventType;
        eventRecord.Order_Id__c =String.valueOf(orderId);
        eventRecord.Message__c = message;
        eventRecord.Timestamp__c = System.now();

        Database.SaveResult result =EventBus.publish(eventRecord);
        if (!result.isSuccess()) {
            System.debug('Platform Event publish failed');
        }
    }
}
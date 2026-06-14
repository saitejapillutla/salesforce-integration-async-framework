public with sharing class OrderSyncQueueable 
    implements Queueable, Database.AllowsCallouts {

    private Id integrationOrderId;
    private String payload;

    public OrderSyncQueueable(Id integrationOrderId , String payload) {
        this.integrationOrderId = integrationOrderId;
        this.payload = payload;
    }
    public void execute(QueueableContext context) {
        Integration_Order__c orderRec = [SELECT Id,Name,Order_Number__c,Status__c,Payload__c,Retry_Count__c,Response__c,Last_Error__c FROM Integration_Order__c WHERE Id = :integrationOrderId LIMIT 1];
        try {
            HttpResponse response = ERPCalloutService.sendOrder(orderRec);
            
            Integer statusCode = response.getStatusCode();
            if (statusCode == 200 || statusCode == 201) {
                orderRec.Status__c = 'Success';
                orderRec.Response__c = response.getBody();
                orderRec.Payload__c = JSON.serialize(payload);
                orderRec.Last_Error__c = null;
                update orderRec;

                PlatformEventPublisher.publishEvent(
                    'SUCCESS',
                    orderRec.Id,
                    'Order synced successfully'
                );
            } else {
                handleFailure(
                    orderRec,
                    'HTTP Error: ' + statusCode
                );
            }

        } catch (Exception ex) {
            handleFailure(orderRec,ex.getMessage());
        }
    }
    private void handleFailure(Integration_Order__c orderRec,String errorMessage) {

        Integer retryCount =
            Integer.valueOf(orderRec.Retry_Count__c);
        retryCount++;

        orderRec.Retry_Count__c = retryCount;
        orderRec.Last_Error__c = errorMessage;

        if (retryCount < 3) {

            orderRec.Status__c = 'Retrying';
            update orderRec;

            PlatformEventPublisher.publishEvent(
                'RETRY',
                orderRec.Id,
                'Retry attempt #' + retryCount
            );
            System.enqueueJob(new OrderSyncQueueable(orderRec.Id, orderRec.Payload__c));
        } else {
            orderRec.Status__c = 'Failed';
            update orderRec;

            PlatformEventPublisher.publishEvent(
                'FAILURE',
                orderRec.Id,
                errorMessage
            );
        }
    }
}
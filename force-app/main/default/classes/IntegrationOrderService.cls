public with sharing class IntegrationOrderService {
    public IntegrationOrderService() {

    }
    public static void processOrders(List<Integration_Order__c> orders) {

        List<Integration_Order__c> ordersToUpdate = new List<Integration_Order__c>();

        for (Integration_Order__c orderRec : orders) {

            Map<String, Object> payloadMap = new Map<String, Object>();

            payloadMap.put('name', orderRec.Order_Number__c);
            payloadMap.put('source', 'Salesforce');
            payloadMap.put('timestamp', System.now());
            payloadMap.put('data', new Map<String, Object>{
                'year' => Date.today().year(),
                'price' => orderRec.Order_Number__c,
                'CPU model' => 'Intel Core i9',
                'Hard disk size' => '1 TB'});
            orderRec.Payload__c = JSON.serialize(payloadMap);

            orderRec.Status__c = 'New';

            if (orderRec.Retry_Count__c == null) {
                orderRec.Retry_Count__c = 0;
            }

            ordersToUpdate.add(orderRec);
        }

        if (!ordersToUpdate.isEmpty()) {
            update ordersToUpdate;
        }

        // Enqueue async processing
        for (Integration_Order__c updatedOrder : ordersToUpdate) {
            System.enqueueJob(new OrderSyncQueueable(updatedOrder.Id));
        }
    }

    public static void setPayload(Integration_Order__c orderRec, String payload) {
        orderRec.Payload__c = payload;
        update orderRec;
    }

}

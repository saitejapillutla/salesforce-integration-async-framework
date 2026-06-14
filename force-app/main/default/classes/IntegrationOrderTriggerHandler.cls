public with sharing class IntegrationOrderTriggerHandler {

    public static void beforeInsert(List<Integration_Order__c> newOrders) {
        if (newOrders == null || newOrders.isEmpty()) {
            return;
        }

        for (Integration_Order__c orderRec : newOrders) {
            Map<String, Object> payloadMap = new Map<String, Object>();
            payloadMap.put('name', orderRec.Order_Number__c);
            payloadMap.put('source', 'Salesforce');
            payloadMap.put('timestamp', System.now());
            payloadMap.put('data', new Map<String, Object>{
                'year' => Date.today().year(),
                'price' => orderRec.Order_Number__c,
                'CPU model' => 'Intel Core i9',
                'Hard disk size' => '1 TB'
            });

            orderRec.Payload__c = JSON.serialize(payloadMap);
            orderRec.Status__c = 'New';
            if (orderRec.Retry_Count__c == null) {
                orderRec.Retry_Count__c = 0;
            }
        }
    }

    public static void afterInsert(List<Integration_Order__c> newOrders) {  
        if (newOrders == null || newOrders.isEmpty()) {
            return;
        }

        for (Integration_Order__c orderRec : newOrders) {
            System.enqueueJob(new OrderSyncQueueable(orderRec.Id, orderRec.Payload__c));
        }
    }
}

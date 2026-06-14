public with sharing class IntegrationDashboardController {
    public IntegrationDashboardController() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Integration_Order__c> getOrders() {
    
        return [
            SELECT Id,
                   Name,
                   Order_Number__c,
                   Status__c,
                   Retry_Count__c,
                   Last_Error__c,
                   CreatedDate
            FROM Integration_Order__c
            ORDER BY CreatedDate DESC
            LIMIT 100
        ];
    }
}
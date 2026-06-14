@IsTest(SeeAllData=false)
private class OrderSyncQueueableTest {

    @IsTest
    static void testExecuteSuccessUpdatesOrder() {
        Test.setMock(HttpCalloutMock.class, new ERPCalloutMock());

        Integration_Order__c orderRec = new Integration_Order__c(
            Order_Number__c = 'TEST-QUEUE-001'
        );
        insert orderRec;

        orderRec = [SELECT Id, Payload__c FROM Integration_Order__c WHERE Id = :orderRec.Id];

        Test.startTest();
        new OrderSyncQueueable(orderRec.Id, orderRec.Payload__c).execute(null);
        Test.stopTest();

        orderRec = [SELECT Status__c, Response__c, Last_Error__c, Retry_Count__c FROM Integration_Order__c WHERE Id = :orderRec.Id];

        System.assertEquals('Success', orderRec.Status__c);
        System.assertEquals('{"status":"SUCCESS"}', orderRec.Response__c);
        System.assertEquals(null, orderRec.Last_Error__c);
        System.assertEquals(0, orderRec.Retry_Count__c);
    }

    @IsTest
    static void testExecuteFailureRetriesOrder() {
        Test.setMock(HttpCalloutMock.class, new ERPFailureMock());

        Integration_Order__c orderRec = new Integration_Order__c(
            Order_Number__c = 'TEST-QUEUE-002'
        );
        insert orderRec;

        orderRec = [SELECT Id, Payload__c FROM Integration_Order__c WHERE Id = :orderRec.Id];

        Test.startTest();
        new OrderSyncQueueable(orderRec.Id, orderRec.Payload__c).execute(null);
        Test.stopTest();

        orderRec = [SELECT Status__c, Last_Error__c, Retry_Count__c FROM Integration_Order__c WHERE Id = :orderRec.Id];

        System.assertEquals('Retrying', orderRec.Status__c);
        System.assertNotEquals(null, orderRec.Last_Error__c);
        System.assertEquals(1, orderRec.Retry_Count__c);
    }
}

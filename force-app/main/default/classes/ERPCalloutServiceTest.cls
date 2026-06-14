@IsTest(SeeAllData=false)
private class ERPCalloutServiceTest {

    @IsTest
    static void testSendOrderSuccess() {
        Test.setMock(HttpCalloutMock.class, new ERPCalloutMock());

        Integration_Order__c orderRec = new Integration_Order__c(
            Order_Number__c = 'TEST-001'
        );
        insert orderRec;

        orderRec = [SELECT Id, Payload__c FROM Integration_Order__c WHERE Id = :orderRec.Id];

        Test.startTest();
        HttpResponse response = ERPCalloutService.sendOrder(orderRec);
        Test.stopTest();

        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('{"status":"SUCCESS"}', response.getBody());
    }

    @IsTest
    static void testSendOrderFailure() {
        Test.setMock(HttpCalloutMock.class, new ERPFailureMock());

        Integration_Order__c orderRec = new Integration_Order__c(
            Order_Number__c = 'TEST-002'
        );
        insert orderRec;

        orderRec = [SELECT Id, Payload__c FROM Integration_Order__c WHERE Id = :orderRec.Id];

        Test.startTest();
        HttpResponse response = ERPCalloutService.sendOrder(orderRec);
        Test.stopTest();

        System.assertEquals(500, response.getStatusCode());
        System.assertEquals('{"status":"FAILED"}', response.getBody());
    }
}

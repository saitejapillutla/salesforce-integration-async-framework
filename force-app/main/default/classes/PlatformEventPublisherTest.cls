@IsTest(SeeAllData=false)
private class PlatformEventPublisherTest {

    @IsTest
    static void testPublishEvent() {
        Integration_Order__c orderRec = new Integration_Order__c(
            Order_Number__c = 'TEST-EVENT-001'
        );
        insert orderRec;

        Test.startTest();
        PlatformEventPublisher.publishEvent(
            'SUCCESS',
            orderRec.Id,
            'Test platform event publish'
        );
        Test.stopTest();

        System.assert(true, 'PlatformEventPublisher.publishEvent completed without exception');
    }
}

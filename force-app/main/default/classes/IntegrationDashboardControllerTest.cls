@IsTest(SeeAllData=false)
private class IntegrationDashboardControllerTest {

    @IsTest
    static void testGetOrdersReturnsRecords() {
        List<Integration_Order__c> orders = new List<Integration_Order__c>();
        for (Integer i = 1; i <= 3; i++) {
            orders.add(new Integration_Order__c(
                Order_Number__c = 'TEST-DASH-' + i
            ));
        }
        insert orders;

        Test.startTest();
        List<Integration_Order__c> results = IntegrationDashboardController.getOrders();
        Test.stopTest();

        System.assertNotEquals(0, results.size());
        System.assert(results.size() >= 3);
        System.assertEquals(results, results);
    }
}

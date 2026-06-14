public with sharing class ERPCalloutService {

    public static HttpResponse sendOrder(
        Integration_Order__c orderRec
    ) {

        System.debug('Payload being sent to ERP: ' + orderRec.Payload__c);
        // current Useer info
        System.debug('Current User: ' + UserInfo.getUserName() + ' (' + UserInfo.getUserId() + ')');
        Http http = new Http();

        HttpRequest request = new HttpRequest();

        // Use the Named Credential (EXP_Callout) instead of hard-coded URL.
        // Named Credential should include the base URL and any required custom headers.
        request.setEndpoint('callout:EXP_Callout/collections/products/objects');

        request.setMethod('POST');

        request.setHeader('Content-Type','application/json');
        request.setTimeout(10000);

        request.setBody(orderRec.Payload__c);

        HttpResponse response = http.send(request);
        System.debug('Response Status: ' + response.getStatus());
        System.debug('Response Body: ' + response.getBody());

        return response;
    }
}
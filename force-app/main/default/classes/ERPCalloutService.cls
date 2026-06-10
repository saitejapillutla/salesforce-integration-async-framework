public with sharing class ERPCalloutService {

    public static HttpResponse sendOrder(
        Integration_Order__c orderRec
    ) {

        Http http = new Http();

        HttpRequest request = new HttpRequest();

        request.setEndpoint(
            'https://api.restful-api.dev/collections/products/objects'
        );

        request.setMethod('POST');

        request.setHeader('Content-Type','application/json');
        request.setHeader('x-api-key', 'd4613234-2e97-4437-b37c-d9c5234b598a');
        request.setTimeout(10000);

        request.setBody(orderRec.Payload__c);

        HttpResponse response = http.send(request);

        return response;
    }
}
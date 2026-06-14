@IsTest
global class ERPCalloutMock
implements HttpCalloutMock {

    global HttpResponse respond(
        HttpRequest request
    ) {

        HttpResponse response =
            new HttpResponse();

        response.setStatusCode(200);

        response.setBody(
            '{"status":"SUCCESS"}'
        );

        return response;
    }
}
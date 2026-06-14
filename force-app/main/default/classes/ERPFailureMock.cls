@IsTest
global class ERPFailureMock
implements HttpCalloutMock {

    global HttpResponse respond(
        HttpRequest request
    ) {

        HttpResponse response =
            new HttpResponse();

        response.setStatusCode(500);

        response.setBody(
            '{"status":"FAILED"}'
        );

        return response;
    }
}
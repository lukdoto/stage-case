@isTest
public class MockCnpjFail implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(404);
        res.setBody('{"message":"CNPJ não encontrado"}');
        return res;
    }
}
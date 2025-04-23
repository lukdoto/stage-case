@isTest
public class MockCnpjSuccess implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('{"razao_social":"Empresa Teste Ltda","nome_fantasia":"Teste"}');
        return res;
    }
}
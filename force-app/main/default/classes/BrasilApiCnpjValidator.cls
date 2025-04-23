public class BrasilApiCnpjValidator implements ICnpjValidator {

    private static final String BASE_URL = 'https://brasilapi.com.br/api/cnpj/v1/';

    public Boolean isValid(String cnpj) {
        HttpResponse res = makeRequest(cnpj);
        return res.getStatusCode() == 200;
    }

    public Map<String, String> getCompanyData(String cnpj) {
        HttpResponse res = makeRequest(cnpj);
        if (res.getStatusCode() != 200) {
            return new Map<String, String>();
        }
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        return new Map<String, String>{
            'Razao_Social__c' => String.valueOf(data.get('razao_social')),
            'Nome_Fantasia__c' => String.valueOf(data.get('nome_fantasia'))
        };
    }

    private HttpResponse makeRequest(String cnpj) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(BASE_URL + cnpj);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('User-Agent', 'SalesforceIntegration/1.0'); // Evita erro 403
        return new Http().send(req);
    }
}
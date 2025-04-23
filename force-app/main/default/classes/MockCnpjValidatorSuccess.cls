@isTest
public class MockCnpjValidatorSuccess implements ICnpjValidator {
    public Boolean isValid(String cnpj) {
        return true;
    }

    public Map<String, String> getCompanyData(String cnpj) {
        return new Map<String, String>{
            'Razao_Social__c' => 'Empresa Teste',
            'Nome_Fantasia__c' => 'Teste LTDA'
        };
    }
}
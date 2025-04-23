@isTest
public class MockCnpjValidatorFail implements ICnpjValidator {
    public Boolean isValid(String cnpj) {
        return false;
    }

    public Map<String, String> getCompanyData(String cnpj) {
        return new Map<String, String>();
    }
}
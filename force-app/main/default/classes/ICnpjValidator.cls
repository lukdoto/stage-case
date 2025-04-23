public interface ICnpjValidator {
    Boolean isValid(String cnpj);
    Map<String, String> getCompanyData(String cnpj);
}
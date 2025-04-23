trigger ValidateUniqueProjectAllocation on Project_Developer__c (before insert, before update) {
    Set<String> compositeKeys = new Set<String>();

    for (Project_Developer__c pd : Trigger.new) {
        if (pd.Developer__c != null && pd.Project__c != null) {
            compositeKeys.add(pd.Developer__c + '-' + pd.Project__c);
        }
    }

    List<Project_Developer__c> existing = [
        SELECT Id, Developer__c, Project__c
        FROM Project_Developer__c
        WHERE Developer__c != null AND Project__c != null
    ];

    for (Project_Developer__c pd : Trigger.new) {
        for (Project_Developer__c e : existing) {
            if (
                pd.Id != e.Id &&
                pd.Developer__c == e.Developer__c &&
                pd.Project__c == e.Project__c
            ) {
                pd.addError('Este desenvolvedor já está alocado neste projeto.');
            }
        }
    }
}
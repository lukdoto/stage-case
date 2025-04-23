public with sharing class AllocateIntelligentController {

    @AuraEnabled
    public static Map<String, Object> loadContext(Id recordId) {
        Map<String, Object> result = new Map<String, Object>();

        String objType = recordId.getSObjectType().getDescribe().getName();
        result.put('recordType', objType);

        String tecnologia;
        Id oppId;
        Id projectId;

        if (objType == 'Opportunity') {
            Opportunity opp = [
                SELECT Id, Tecnologia__c
                FROM Opportunity
                WHERE Id = :recordId
                LIMIT 1
            ];
            tecnologia = opp.Tecnologia__c;
            oppId = opp.Id;

            List<Project__c> relatedProjects = [
                SELECT Id
                FROM Project__c
                WHERE Oportunidade__c = :oppId
                LIMIT 1
            ];

            if (!relatedProjects.isEmpty()) {
                projectId = relatedProjects[0].Id;
            }

        } else if (objType == 'Project__c') {
            Project__c proj = [
                SELECT Id, Tecnologia__c, Oportunidade__c
                FROM Project__c
                WHERE Id = :recordId
                LIMIT 1
            ];
            tecnologia = proj.Tecnologia__c;
            projectId = proj.Id;
            oppId = proj.Oportunidade__c;
        }

        result.put('tecnologia', tecnologia);
        result.put('opportunityId', oppId);
        result.put('projectId', projectId);

        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<Developer__c> getCompatibleDevelopers(String tecnologia) {
        Set<String> requiredTechs = new Set<String>();
        if (String.isNotBlank(tecnologia)) {
            requiredTechs = new Set<String>(tecnologia.split(';'));
        }

        List<Developer__c> devs = [
            SELECT Id, Name, Tecnologia__c, Senioridade__c
            FROM Developer__c
        ];

        List<Developer__c> valid = new List<Developer__c>();

        for (Developer__c d : devs) {
            if (String.isBlank(d.Tecnologia__c)) continue;

            Set<String> devTechs = new Set<String>(d.Tecnologia__c.split(';'));
            if (devTechs.containsAll(requiredTechs)) {
                valid.add(d);
            }
        }

        return valid;
    }

    @AuraEnabled
    public static void allocate(Id opportunityId, Id projectId, List<Id> developerIds) {
        List<Opportunity_Developer__c> oppDevs = new List<Opportunity_Developer__c>();
        List<Project_Developer__c> projDevs = new List<Project_Developer__c>();

        for (Id devId : developerIds) {
            if (opportunityId != null) {
                oppDevs.add(new Opportunity_Developer__c(
                    Oportunidade__c = opportunityId,
                    Desenvolvedor__c = devId
                ));
            }
            if (projectId != null) {
                projDevs.add(new Project_Developer__c(
                    Project__c = projectId,
                    Developer__c = devId
                ));
            }
        }

        insert oppDevs;
        insert projDevs;
    }
}
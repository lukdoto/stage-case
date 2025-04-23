import { LightningElement, track } from 'lwc';
import getDevelopersByProject from '@salesforce/apex/ProjectDevelopersController.getDevelopersByProject';

export default class ProjectDevelopers extends LightningElement {
    @track projectId;
    @track developers;
    @track error;

    columns = [
        { label: 'Nome', fieldName: 'Name' },
        { label: 'Tecnologias', fieldName: 'Tecnologia__c' },
        { label: 'Senioridade', fieldName: 'Senioridade__c' },
        { label: 'Disponível', fieldName: 'Disponivel__c', type: 'boolean' }
    ];

    handleChange(event) {
        this.projectId = event.target.value;
        getDevelopersByProject({ projectId: this.projectId })
            .then(result => {
                this.developers = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error.body.message;
                this.developers = undefined;
            });
    }
}
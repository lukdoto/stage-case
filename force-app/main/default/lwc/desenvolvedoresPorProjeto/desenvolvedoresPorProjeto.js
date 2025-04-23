import { LightningElement, track } from 'lwc';
import getProjetos from '@salesforce/apex/DesenvolvedoresPorProjetoController.getProjetos';
import getDesenvolvedores from '@salesforce/apex/DesenvolvedoresPorProjetoController.getDesenvolvedores';
import { NavigationMixin } from 'lightning/navigation';

export default class DesenvolvedoresPorProjeto extends NavigationMixin(LightningElement) {
  @track projectOptions = [];
  @track selectedProject = '';
  @track developers = [];

  columns = [
    { label: 'Nome', fieldName: 'Name' },
    { label: 'Tecnologias', fieldName: 'Tecnologia__c' },
    { label: 'Senioridade', fieldName: 'Senioridade__c' },
    {
      type: 'button',
      typeAttributes: {
        label: 'Ver Desenvolvedor',
        name: 'verDev',
        title: 'Ver Desenvolvedor',
        variant: 'brand'
      }
    }
  ];

  connectedCallback() {
    getProjetos().then(result => {
      this.projectOptions = result.map(p => ({
        label: p.Name,
        value: p.Id
      }));
    });
  }

  handleProjectChange(event) {
    this.selectedProject = event.detail.value;
    getDesenvolvedores({ projectId: this.selectedProject }).then(result => {
      this.developers = result;
    });
  }

  handleRowAction(event) {
    const row = event.detail.row;
    this[NavigationMixin.Navigate]({
      type: 'standard__recordPage',
      attributes: {
        recordId: row.Id,
        objectApiName: 'Developer__c',
        actionName: 'view'
      }
    });
  }
}
import { LightningElement, api, track } from 'lwc';
import loadContext from '@salesforce/apex/AllocateIntelligentController.loadContext';
import getCompatibleDevelopers from '@salesforce/apex/AllocateIntelligentController.getCompatibleDevelopers';
import allocate from '@salesforce/apex/AllocateIntelligentController.allocate';

export default class AllocateDevelopers extends LightningElement {
  @api recordId;

  @track developers = [];
  @track selectedRows = [];
  @track technologies;
  @track error;
  opportunityId;
  projectId;

  columns = [
    { label: 'Nome', fieldName: 'Name' },
    { label: 'Tecnologias', fieldName: 'Tecnologia__c' },
    { label: 'Senioridade', fieldName: 'Senioridade__c' }
  ];

  connectedCallback() {
    this.loadAll();
  }

  async loadAll() {
    try {
      const context = await loadContext({ recordId: this.recordId });

      this.technologies = context.tecnologia;
      this.opportunityId = context.opportunityId;
      this.projectId = context.projectId;

      const result = await getCompatibleDevelopers({ tecnologia: this.technologies });
      this.developers = result;
    } catch (e) {
      this.error = 'Erro ao carregar contexto: ' + this.extractError(e);
    }
  }

  handleSelection(event) {
    this.selectedRows = event.detail.selectedRows.map(row => row.Id);
  }

  async handleAllocate() {
    try {
      await allocate({
        opportunityId: this.opportunityId,
        projectId: this.projectId,
        developerIds: this.selectedRows
      });
      this.error = null;
      this.dispatchEvent(new CustomEvent('success', {
        detail: '✅ Desenvolvedores alocados com sucesso!'
      }));
    } catch (e) {
      this.error = 'Erro ao alocar desenvolvedores: ' + this.extractError(e);
    }
  }

  extractError(error) {
    if (error && error.body && error.body.message) return error.body.message;
    if (typeof error === 'string') return error;
    return JSON.stringify(error);
  }
}
import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import cloneOpportunity from '@salesforce/apex/Oppcr.cloneOpportunity';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Opportunity.Name';

export default class CloneOpportunity extends NavigationMixin(LightningElement) {
    @api recordId; // The ID of the current opportunity
    @track opportunityName = '';
    @track isLoading = false;
    @track errorMessage = '';

    @wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            this.opportunityName = data.fields.Name.value;
        } else if (error) {
            this.errorMessage = 'Error loading opportunity name: ' + error.body.message;
        }
    }

    handleNameChange(event) {
        this.opportunityName = event.target.value;
    }

    handleCloneOpportunity() {
        this.isLoading = true;
        this.errorMessage = '';

        cloneOpportunity({ oppId: this.recordId, newName: this.opportunityName })
            .then(result => {
                // Redirect to the new opportunity record page
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: result.Id,
                        objectApiName: 'Opportunity',
                        actionName: 'view'
                    }
                });
                this.isLoading = false;
            })
            .catch(error => {
                // Handle error
                this.errorMessage = 'Error cloning opportunity: ' + error.body.message;
                this.isLoading = false;
            });
    }
}
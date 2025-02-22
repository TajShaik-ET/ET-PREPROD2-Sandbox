import { LightningElement, track, api } from 'lwc';
import getGoodsIssueLines from '@salesforce/apex/ETT_MaterialReturnNoteController.getGoodsIssueLines';
import createMaterialReturnLines from '@salesforce/apex/ETT_MaterialReturnNoteController.createMaterialReturnLines';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Backend from "@salesforce/resourceUrl/backend";
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { CloseActionScreenEvent } from 'lightning/actions';


export default class ETT_Add_Material_Note_Item extends LightningElement {
    ginMasterId;
    @api recordId; // Record ID of Material_Return_Note__c
    @track goodsIssueLines = [];
    selectedRecords = new Set(); // Use a Set to track selected records
    updatedQuantities = {}; // Object to store quantities for selected records

    // Handle the lookup selection
    handleSelectedLookup(event) {
        this.ginMasterId = event.detail;
        this.fetchGoodsIssueLines();
    }

    // Fetch the Goods Issue Lines based on the selected Goods Issue Note
    fetchGoodsIssueLines() {
        getGoodsIssueLines({ ginId: this.ginMasterId })
            .then((result) => {
                // Add 'isSelected' property to each line to track checkbox status
                this.goodsIssueLines = result.map((line, index) => ({
                    ...line,
                    rowNumber: index + 1,
                    isSelected: false
                }));
            })
            .catch((error) => {
                console.error('Error fetching goods issue lines:', error);
                this.showToast('Error', 'Error fetching goods issue lines', 'error');
            });
    }
   

    // Handle row selection using the checkbox
    handleRowSelection(event) {
        const rowId = event.target.dataset.id;
        const isSelected = event.target.checked;

        if (isSelected) {
            this.selectedRecords.add(rowId); // Add the selected row to the Set
        } else {
            this.selectedRecords.delete(rowId); // Remove the deselected row from the Set
        }
        console.log('Selected Records:', Array.from(this.selectedRecords)); // Log selected records
    }

    // Handle quantity input change
    handleInputChange(event) {
        const rowId = event.target.dataset.id;
        const quantity = event.target.value;

        if (this.selectedRecords.has(rowId)) {
            this.updatedQuantities[rowId] = quantity; // Update the quantity for the selected row
        }
        console.log('quantity Records:', this.updatedQuantities);
    }

    // Create Material Return Lines based on selected records
    createMaterialReturnLines() {
        
        if (this.selectedRecords.size === 0) { // Check if no records are selected
            this.showToast('Error', 'Please select at least one record', 'error');
           
            return;
        }

        const goodsIssueLineData = Array.from(this.selectedRecords).map(recordId => ({
            id: recordId,
            quantity: this.updatedQuantities[recordId] || 0 // Get the quantity or default to 0
        }));

        createMaterialReturnLines({
            goodsIssueLineData: goodsIssueLineData, // Pass the array of record IDs and quantities
            materialReturnNoteId: this.recordId // Pass the Material_Return_Note__c ID
        })
            .then(() => {
                this.showToast('Success', 'Material Return Lines created successfully', 'success');
                // Clear the selection and refresh data if needed
                this.selectedRecords.clear();
                this.updatedQuantities = {};
                this.fetchGoodsIssueLines();
                 this.reloadPage();// Optionally refetch the lines
            })
            .catch((error) => {
                console.error('Error creating Material Return Lines:', error);
                this.showToast('Error', 'Error creating Material Return Lines', 'error');
            });
    }

    // Show a toast message
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(evt);
    }


    renderedCallback() {
        Promise.all([
            loadStyle(this, Backend)

        ])
            .then(() => {
                console.log("All scripts and CSS are loaded. perform any initialization function.")
            })
            .catch(error => {
                console.log("failed to load the scripts");
            });
    }

     reloadPage() {
        window.location.reload();
    }

}
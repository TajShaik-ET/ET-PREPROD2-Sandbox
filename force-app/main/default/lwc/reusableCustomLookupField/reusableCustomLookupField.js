import { LightningElement, api, track } from 'lwc';
import searchRecords from '@salesforce/apex/LookupLWCController.searchRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


const DELAY = 350;


export default class Lookup extends LightningElement {
  @api
  filters
  @api objectApiName;
  showPill = false;
  @api
  multiSelect = false;
  @api
  label;
  @track
  records = null
  @api selectedIds;
  @api iconName;
  @track
  selectedRecords = [];
  @track
  searchKey;
  loading = false;
  noRecords = false;
  @api disableInput;
  @api requiredInput;

  
  
handleKeyChange(event) {

      const keyChange = new CustomEvent("keychangeevent", {
          detail: null
      });
      this.dispatchEvent(keyChange);

    window.clearTimeout(this.delayTimeout);
    if (event.target.value) {
      this.loading = true;
      this.noRecords = true;
      const searchKey = event.target.value;
      const objectApiName = this.objectApiName;
      const selectedIds = this.selectedIds;
      const filter = this.filters;
     /*  console.log(JSON.stringify(filter));
      console.log('selectedIds',selectedIds) */
      console.log('objectname',objectApiName)
      //console.log('searchKey',searchKey)
      this.delayTimeout = setTimeout(() => {
        searchRecords({ searchKey: searchKey, objectApiName: objectApiName, selectedIds: selectedIds, filters: filter })
          .then((result) => {
            if (result && result.length) {
              this.noRecords = false;
              this.loading = false;
              this.records = result;
              this.error = undefined;
            } else {
              this.loading = false;
              this.records = null;
            }
          })
          .catch((ex) => {
            this.loading = false;
            const toastEvent = new ShowToastEvent({
              title: 'Error',
              message: ex.body.message,
            });
            this.dispatchEvent(toastEvent);
            this.error = ex;
            this.records = null;
          });
      }, DELAY);
    } else {
      this.records = null;
      this.noRecords = false;
      this.loading = false;
    }
  }

  addToSelected(event) {
    var selectedId = event.target.getAttribute('data-id');
    console.log(selectedId)
    this.records.map(record => {
      if (record.Id == selectedId) {
        if (this.multiSelect) {
          this.selectedRecords.push(record);
          this.selectedIds.push(record.Id);
        } else {
          this.selectedRecord = record;
          this.showPill = true;
          this.records = null;
        }
      }
    })

    const addRec = new CustomEvent("selectedrecordevent", {
        detail: this.selectedRecord
    });
    this.dispatchEvent(addRec);
  }
  handleRemove(event) {
    var toRemove = event.detail.name;
    if (this.selectedIds.includes(toRemove)) {
      this.selectedRecords.splice(this.selectedIds.indexOf(toRemove), 1);
      this.selectedIds.splice(this.selectedIds.indexOf(toRemove), 1);
    }
    const selectedEvent = new CustomEvent('recordupdated', { detail: this.selectedRecords });
    this.dispatchEvent(selectedEvent);
  }
  @api
  clear(event) {
    this.selectedRecord = null;
    this.showPill = false;
    const selectedEvent = new CustomEvent('recordupdated', { detail: this.selectedRecord });
    this.dispatchEvent(selectedEvent);
    
  }
}
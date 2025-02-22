import { LightningElement, track, wire, api } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { loadStyle } from 'lightning/platformResourceLoader';
import ET_inspectionExternalStyle from '@salesforce/resourceUrl/ET_inspectionExternalStyle'

export default class ETI_InspectionReceiptCodes extends LightningElement {
   searchInputCodes = '';
   activeSection;
   @api activeSections = [];
   @api inspCodes = [];
   @api allCodes = [];
   isCodesUpdated = false;
   filterCodes = [];
   @api defectsMap = new Map();
   @api defectsArray = [];
   @api tabName = '';

   renderedCallback() {
      Promise.all([
         loadStyle(this, ET_inspectionExternalStyle)
      ])
         .then(() => {
            //console.log("All scripts and CSS are loaded. perform any initialization function.")
         })
         .catch(error => {
            //console.log("failed to load the scripts");
         });
   }

   handleToggleSection(event) {
      //console.log('openSections >>> ',event.detail.openSections);
      this.activeSections = event.detail.openSections;
      if (event.detail.openSections.length > 0)
         this.activeSection = event.detail.openSections[0];
      this.dispatchEvent(new CustomEvent('togglesection', {
         detail: {
            activeSections: this.activeSections,
            tabName: this.tabName
         }
      }));
   }

   searchCodes(event) {
      const fieldElement = this.template.querySelector('[data-id="searchInputCodesId"]');
      if (fieldElement) {
         this.searchInputCodes = fieldElement.value;
      }
      //console.log('searchInputCodes: ', this.searchInputCodes);
      if (this.searchInputCodes != '' && this.searchInputCodes != null) {
         var allCodesValue = [],
            allCodes = [];
         for (var key1 in this.inspCodes) {
            allCodesValue.push(this.inspCodes[key1].inspCodeDetails);
         }
         for (var key2 in allCodesValue) {
            allCodes.push.apply(allCodes, allCodesValue[key2]);
         }
         var term = this.searchInputCodes,
            regex;
         try {
            regex = new RegExp(term, "i");
            //console.log(regex);
            this.filterCodes = allCodes.filter(
               row =>
                  regex.test(row.recordVDT.Id__c) ||
                  regex.test(row.recordVDT.Test_Type_Name_En__c.toString())
            );
         } catch (e) {
            console.log(e);
            console.log('error in search');
         }
         //console.log('filterCodes: ', this.filterCodes);
      }
   }

   closeCodesModal() {
      this.dispatchEvent(new CustomEvent('closemodal', {
         detail: {
            isCodesModalOpen: false
         }
      }));
   }

   get disableSave() {
      //console.log('disableSave ', this.tabName);
      if (this.allCodes.length > 0 && this.isCodesUpdated == true)
         return false;
      else
         return true;
   }

   get disableCancel() {
      //console.log('disableCancel');
      if (this.allCodes.length > 0 && this.isCodesUpdated == true)
         return true;
      else
         return false;
   }

   handleInputChange(event) {
      var secCodes = JSON.parse(JSON.stringify(this.inspCodes));;
      //console.log('target name : ' + event.target.name);
      var codes = [];
      //console.log('secCodes - ', secCodes);
      for (var key1 in secCodes) {
         if (secCodes[key1].key == event.target.name) {
            codes = secCodes[key1].inspCodeDetails;
            break;
         }
      }
      //console.log('codes - ', codes);
      for (var key2 in codes) {
         if (codes[key2].recordVDT.Id__c == event.target.dataset.id) {
            codes[key2].remarks = event.detail.value; //'test'; //event.detail.value;
            this.isCodesUpdated = true;
            break;
         }
      }
      this.inspCodes = secCodes;
      this.handleCodesInput(JSON.parse(JSON.stringify(this.allCodes)), event.target.dataset.id, event.detail.value);
      const allCodes = [...this.allCodes];
      this.dispatchEvent(new CustomEvent('codeschange', {
         detail: {
            tabName: this.tabName,
            inspCodes: this.inspCodes,
            allCodes: allCodes,
            defectsMap: this.defectsMap,
            defectsArray: this.defectsArray,
            activeSections: this.activeSections
         }
      }));
   }

   handleSeverityChange(event) {
      var secCodes = JSON.parse(JSON.stringify(this.inspCodes));;
      //console.log('target name : ' + event.target.name);
      var codes = [];
      for (var key1 in secCodes) {
         if (secCodes[key1].key == event.target.name) {
            codes = secCodes[key1].inspCodeDetails;
            break;
         }
      }
      //console.log('codes - ', codes);
      var defectsMap = this.defectsMap;
      var defectsArray = JSON.parse(JSON.stringify(this.defectsArray));
      for (var key2 in codes) {
         if (codes[key2].recordVDT.Id__c == event.target.dataset.id) {
            if (event.detail.value == 'Major Defect' || event.detail.value == 'Minor Defect') {
               if (!defectsArray.includes(event.target.dataset.id)) {
                  defectsArray.push(event.target.dataset.id);
                  if (!defectsMap.has(codes[key2].recordVDT.Type__c)) {
                     defectsMap.set(codes[key2].recordVDT.Type__c, 1);
                  } else {
                     defectsMap.set(codes[key2].recordVDT.Type__c, defectsMap.get(codes[key2].recordVDT.Type__c) + 1);
                  }
               }
            } else if (event.detail.value == 'Qualified') {
               if (defectsArray.includes(event.target.dataset.id)) {
                  if (defectsMap.has(codes[key2].recordVDT.Type__c)) {
                     const index = defectsArray.indexOf(event.target.dataset.id);
                     if (index > -1)
                        defectsArray.splice(index, 1);
                     if (defectsMap.get(codes[key2].recordVDT.Type__c) - 1 >= 0)
                        defectsMap.set(codes[key2].recordVDT.Type__c, defectsMap.get(codes[key2].recordVDT.Type__c) - 1);
                  }
               }
            }
            codes[key2].selectedOption = event.detail.value; //'test'; //event.detail.value;
            this.handleCodesSeverity(JSON.parse(JSON.stringify(this.allCodes)), event.target.dataset.id, event.detail.value, codes[key2].recordVDT);
            this.isCodesUpdated = true;
            break;
         }
      }
      this.defectsMap = defectsMap;
      this.defectsArray = defectsArray;
      for (var key3 in secCodes) {
         if (defectsMap.has(secCodes[key3].key)) {
            secCodes[key3].defectCount = defectsMap.get(secCodes[key3].key);
            secCodes[key3].label = secCodes[key3].key + ' (' + secCodes[key3].defectCount + '/' + secCodes[key3].inspCodeDetails.length + ')';
         }
      }
      this.inspCodes = secCodes;
      //console.log('inspCodes : ', this.inspCodes);
      //console.log('udpated inspCodes : ',this.inspCodes);
      this.dispatchEvent(new CustomEvent('codeschange', {
         detail: {
            tabName: this.tabName,
            inspCodes: this.inspCodes,
            allCodes: this.allCodes,
            defectsMap: this.defectsMap,
            defectsArray: this.defectsArray,
            activeSections: this.activeSections
         }
      }));
   }

   handleCodesInput(allCodes, datasetId, value) {
      //console.log('allCodes : '+JSON.stringify(allCodes));
      //console.log(datasetId + ' removeElement ' + value);
      if (value != 'Major Defect' && value != 'Minor Defect') {
         for (var key in allCodes) {
            if (allCodes[key].code == datasetId) {
               allCodes[key].remarks = value;
            }
         }
         this.allCodes = allCodes;
         //console.log('allCodes : ',this.allCodes);
      }
   }

   handleCodesSeverity(allCodes, datasetId, value, record) {
      //console.log('allCodes : '+JSON.stringify(allCodes));
      //console.log(datasetId + ' removeElement ' + value);
      if (value == 'Major Defect')
         allCodes.push({
            code: datasetId,
            defect: 'Major',
            record: record
         });
      if (value == 'Minor Defect')
         allCodes.push({
            code: datasetId,
            defect: 'Minor',
            record: record
         });
      for (var key in allCodes) {
         if (value == 'Major Defect') {
            if (allCodes[key].code == datasetId && allCodes[key].defect == 'Minor') {
               if (key != -1)
                  allCodes.splice(key, 1);
            }
         } else if (value == 'Minor Defect') {
            if (allCodes[key].code == datasetId && allCodes[key].defect == 'Major') {
               if (key != -1)
                  allCodes.splice(key, 1);
            }
         } else if (value == 'Qualified') {
            if (allCodes[key].code == datasetId && (allCodes[key].defect == 'Major' || allCodes[key].defect == 'Minor')) {
               if (key != -1)
                  allCodes.splice(key, 1);
            }
         }
      }
      this.allCodes = allCodes;
      //console.log('allCodes : ',this.allCodes);
   }

}
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

   /*handleInputChange(event) {
      console.log('inspCodes Array --> ', JSON.stringify(this.inspCodes));
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
   }*/

   handleInputChange(event) {
      const datasetId = event.target.dataset.id;
      const sectionKey = event.target.name;
      const remarksValue = event.detail.value;
      console.log(
         '[handleInputChange]',
         'tabName:', this.tabName,
         '| datasetId:', datasetId,
         '| sectionKey:', sectionKey,
         '| remarksValue:', remarksValue
      );

      // Clone current state
      let secCodes = JSON.parse(JSON.stringify(this.inspCodes));
      let allCodes = JSON.parse(JSON.stringify(this.allCodes));

      // Update remarks in matching section/detail
      const section = secCodes.find(sec => sec.key === sectionKey);
      if (section) {
         const detail = section.inspCodeDetails.find(d => d.recordVDT.Id__c === datasetId);
         if (detail) {
            detail.remarks = remarksValue || '';
            this.isCodesUpdated = true;
         }
      }

      // Update local state
      this.inspCodes = secCodes;
      console.log('handleInputChange Updated inspCodes:', this.inspCodes);

      // Update entry in allCodes
      this.handleCodesInput(allCodes, datasetId, remarksValue);

      // Dispatch updated values to parent
      this.dispatchEvent(new CustomEvent('codeschange', {
         detail: {
            tabName: this.tabName,              // parent uses this to determine inspType
            inspCodes: this.inspCodes,
            allCodes: allCodes,
            defectsMap: this.defectsMap,
            defectsArray: this.defectsArray,
            activeSections: this.activeSections
         }
      }));
   }

   /*handleCodesInput(allCodes, datasetId, value) {
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
   }*/

   handleCodesInput(allCodes, datasetId, value) {
      // Only update remarks if not a severity type
      if (value !== 'Major Defect' && value !== 'Minor Defect') {
         allCodes.forEach(entry => {
            if (entry.code === datasetId) {
               entry.remarks = value;
            }
         });
         this.allCodes = allCodes;
         console.log('handleCodesInput Updated allCodes:', this.allCodes);
      }
   }

   /*handleSeverityChange(event) {
      var secCodes = JSON.parse(JSON.stringify(this.inspCodes));;
      //console.log('target name : ' + event.target.name);
      var codes = [];
      for (var key1 in secCodes) {
         if (secCodes[key1].key == event.target.name) {
            codes = secCodes[key1].inspCodeDetails;
            break;
         }
      }
      console.log('codes - ', codes);
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
      console.log('defectsMap : ', this.defectsMap);
      console.log('defectsArray : ', this.defectsArray);
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
   }*/
   
   handleSeverityChange(event) {
      const datasetId = event.target.dataset.id;
      const sectionKey = event.target.name;
      const selectedValue = event.detail.value;

      console.log(
         '[handleSeverityChange]',
         'tabName:', this.tabName,
         '| datasetId:', datasetId,
         '| sectionKey:', sectionKey,
         '| selectedValue:', selectedValue
      );

      let secCodes = JSON.parse(JSON.stringify(this.inspCodes));
      let allCodes = JSON.parse(JSON.stringify(this.allCodes));
      let defectsMap = this.defectsMap;
      let defectsArray = JSON.parse(JSON.stringify(this.defectsArray));

      // Update selectedOption in matching section/detail
      const section = secCodes.find(sec => sec.key === sectionKey);
      console.log('handleSeverityChange section:', section);
      if (section) {
         const detail = section.inspCodeDetails.find(d => d.recordVDT.Id__c === datasetId);
         console.log('handleSeverityChange detail:', detail);
         if (detail) {
            detail.selectedOption = selectedValue;
            this.isCodesUpdated = true;

            const typeKey = detail.recordVDT.Type__c;

            if (selectedValue === 'Major Defect' || selectedValue === 'Minor Defect') {
               if (!defectsArray.includes(datasetId)) {
                  defectsArray.push(datasetId);
                  defectsMap.set(typeKey, (defectsMap.get(typeKey) || 0) + 1);
               }
            } else if (selectedValue === 'Qualified') {
               const index = defectsArray.indexOf(datasetId);
               if (index > -1) {
                  defectsArray.splice(index, 1);
                  if (defectsMap.has(typeKey)) {
                     const newCount = defectsMap.get(typeKey) - 1;
                     defectsMap.set(typeKey, Math.max(newCount, 0));
                  }
               }
            }

            this.handleCodesSeverity(allCodes, datasetId, selectedValue, detail.recordVDT);
         }
      }

      // Recalculate defectCount and label per section
      secCodes.forEach(section => {
         const count = defectsMap.get(section.key) || 0;
         section.defectCount = count;
         section.label = `${section.key} (${count}/${section.inspCodeDetails.length})`;
      });

      // Set updated state
      this.inspCodes = secCodes;
      this.defectsMap = defectsMap;
      this.defectsArray = defectsArray;

      console.log(
         '[handleSeverityChange Updated]',
         'tabName:', this.tabName,
         '| inspCodes:', this.inspCodes,
         '| defectsMap:', this.defectsMap,
         '| defectsArray:', this.defectsArray
      );

      // Dispatch changes to parent
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


   /*handleCodesSeverity(allCodes, datasetId, value, record) {
      console.log('tabName: ' + this.tabName);
      console.log('allCodes : ' + JSON.stringify(allCodes));
      console.log(datasetId + ' removeElement ' + value);
      let inspTypeTab = '';
      switch (this.tabName) {
         case 'inspTabBreak':
            inspTypeTab = 'Break Inspection';
            break;
         case 'inspTabVisual':
            inspTypeTab = 'Visual Inspection';
            break;
      }
      if (value == 'Major Defect')
         allCodes.push({
            code: datasetId,
            defect: 'Major',
            inspType: inspTypeTab,
            record: record
         });
      if (value == 'Minor Defect')
         allCodes.push({
            code: datasetId,
            defect: 'Minor',
            inspType: inspTypeTab,
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
      console.log('allCodes : ', this.allCodes);
   }*/

   handleCodesSeverity(allCodes, datasetId, value, record) {
      console.log(
         '[handleCodesSeverity]',
         'tabName:', this.tabName,
         '| datasetId:', datasetId,
         '| value:', value,
         '| record:', record,
         '| Initial allCodes:', allCodes
      );

      let inspTypeTab = '';
      switch (this.tabName) {
         case 'inspTabBreak':
            inspTypeTab = 'Break Inspection';
            break;
         case 'inspTabVisual':
            inspTypeTab = 'Visual Inspection';
            break;
         default:
            console.warn('Unsupported tabName:', this.tabName);
            return;
      }

      // Push new entry if value is Major or Minor
      if (value === 'Major Defect' || value === 'Minor Defect') {
         const defectType = value === 'Major Defect' ? 'Major' : 'Minor';
         allCodes.push({
            code: datasetId,
            defect: defectType,
            inspType: inspTypeTab,
            record: record
         });
      }

      // Clean up conflicting or obsolete entries
      for (let i = allCodes.length - 1; i >= 0; i--) {
         const entry = allCodes[i];
         if (entry.code === datasetId && entry.inspType === inspTypeTab) {
            const isConflict =
               (value === 'Major Defect' && entry.defect === 'Minor') ||
               (value === 'Minor Defect' && entry.defect === 'Major') ||
               (value === 'Qualified' && (entry.defect === 'Major' || entry.defect === 'Minor'));

            if (isConflict) {
               allCodes.splice(i, 1);
            }
         }
      }

      this.allCodes = allCodes;
      console.log('handleCodesSeverity Updated allCodes:', this.allCodes);
   }

}
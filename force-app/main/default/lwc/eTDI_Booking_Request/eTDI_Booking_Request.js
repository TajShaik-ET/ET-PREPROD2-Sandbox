import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import BOOKING_REQUEST_OBJECT from '@salesforce/schema/ETDI_Booking_Request__c';
import getBRRecords from '@salesforce/apex/ETDIBookingRequest.getBRRecords';
import getEmployeeList from '@salesforce/apex/ETDIBookingRequest.getEmployeeList';
import createBooking from '@salesforce/apex/ETDIBookingRequest.createBookingReq';
import getBranches from '@salesforce/apex/ETDIBookingRequest.getBranches';
import getProgramNames from '@salesforce/apex/ETDIBookingRequest.getProgramNames';
import LWCImages from "@salesforce/resourceUrl/LWCImages";
import getSlotValues from '@salesforce/apex/ETDIBookingRequest.getSlotValues';
import getAvailableOptions from '@salesforce/apex/ETDIBookingRequest.getAvailableOptions';


import { loadStyle, loadScript } from 'lightning/platformResourceLoader';


let ArrayFields = [];

export default class ETDI_Booking_Request extends LightningElement {
  ObjectApiName = BOOKING_REQUEST_OBJECT;
  @track showChildComponent = false;
  @track showButton = true;
  @track selectedEmployees = [];
  showSpinner = false;
  hasBrRecordData = false;
  ReqDate = '';
  hasEmployees = false;
  @track showModal = false;
  @track depotNames = [];
  @track showFileName = false;
  @track todaysDate;
  @track columns = [
    { label: 'Booking Ref No.', fieldName: 'ReqName', type: 'text' },
    { label: 'Program Name', fieldName: 'ProgramName' },
    { label: 'Branch', fieldName: 'Branch' },
    { label: 'Depot', fieldName: 'Depot' },
    { label: 'Language', fieldName: 'Language' },
    //{ label: 'Location', fieldName: 'Location__c' },
    { label: 'Status', fieldName: 'Status' },
    {
      label: 'Requested Date', fieldName: 'RequestedDate', type: 'date', typeAttributes: {
        year: "numeric",
        month: "short",
        day: "2-digit"

      }
    },
    {
      label: 'Created Date', fieldName: 'CreatedDate', type: 'date', typeAttributes: {
        year: "numeric",
        month: "short",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
        hour12: true

      }
    }
  ];
  @track BRRecordList;
  filesUploaded = [];
  @track fileName = '';
  fileReader;
  fileContents;
  content;
  MAX_FILE_SIZE = 1500000;
  previewColumns;
  @track data = [];
  searchValue = '';
  @track AccountRecord;
  BRRecordList;
  @track Branches = [];
  @track depotList = [];
  @track depotNames = [];
  @track allBranches = [];
  @track selectedBranch;
  @track depotCapacityList = [];
  @track selectedDepot;
  @track selectedDepotCapacityList = [];
  @track depotCapacity;
  @track programNames = [];
  @track selectedProgram;
  @track availableSlot = [];
  @track availableOptions = [];
  @track selectedOption;
  @track selectedSlot;
  @track emplength = 0;
  @track fileLength = 0;
  @track totalLength = 0;
  //new
  @track isExternal = false;
  @track extractedData = [];
  @track selectedItems = new Set();
  @track areAllSelected = false;
  @track selectedData = [];


  connectedCallback() {
    this.getBookingRequest();
    this.getAllBranches();
    this.getAllProgramNames();
    this.getAllSlots();
    this.getAllAvailableValues();
    //this.todaysDate=new Date().toISOString().split('T')[0]
    //console.log('todays date:'+this.todaysDate);
  }

  renderedCallback() {

    Promise.all([

      loadStyle(this, LWCImages + '/LWC-Images/css/ETExternalStyle.css')
    ])

  }

  getBookingRequest() {

    getBRRecords()
      .then(result => {
        let tempData1 = [];
        result.forEach(item => {
          let dataline1 = {};
          //let ids=[];
          dataline1.Id = item.Id;
          dataline1.ReqName = item.Name
          dataline1.ProgramName = item.Program_Name__r.Name;
          dataline1.Branch = item.Branch__r.Name;
          dataline1.Depot = item.Depot__r.Name;
          dataline1.Language = item.Language__c;
          dataline1.Status = item.Status__c;
          dataline1.RequestedDate = item.Requested_Date__c;
          dataline1.CreatedDate = item.CreatedDate;
          tempData1.push(dataline1);

        });
        this.BRRecordList = tempData1;

        //this.BRRecordList = result;
        if (this.BRRecordList.length > 0)
          this.hasBrRecordData = true;
        console.log(result);
      })
      .catch(error => {
        console.log(error);
      });
  }

  getAllProgramNames() {
    getProgramNames()
      .then(result => {
        result.forEach(item => this.programNames.push({ label: item.Name, value: item.Id }));
      })
      .catch(error => {
        console.log(error);
      });
  }

  handleProgramSelect(event) {
    this.selectedProgram = event.detail.value;
    console.log('this.selectedProgram in program select:' + this.selectedProgram);
  }

  handleSlotSelect(event) {
    this.selectedSlot = event.detail.value;
  }

  handleExamReq(event) {
    this.selectedOption = event.detail.value;
  }

  getAllSlots() {
    getSlotValues()
      .then(result => {

        result.forEach(item => this.availableSlot.push({ label: item, value: item }));
      })
      .catch(error => {
        console.log(error);
      });
  }

  getAllAvailableValues() {
    getAvailableOptions()
      .then(result => {

        result.forEach(item => this.availableOptions.push({ label: item, value: item }));
      })
      .catch(error => {
        console.log(error);
      });

  }

  getAllBranches() {
    getBranches()
      .then(result => {
        this.allBranches = result;
        result.forEach(item => this.Branches.push({ label: item.Name, value: item.Id }));
      })
      .catch(error => {
        console.log(error);
      });
  }

  handleBranchSelect(event) {
    this.selectedBranch = event.detail.value;
    if (this.allBranches) {

      this.allBranches.forEach(element => {

        if (element.Id === this.selectedBranch) {
          this.depotList = element.ETDI_Training_Centers__r;
          this.depotNames = this.depotList.map(({ Name: label, Id: value }) => ({
            label,
            value,
          }));
        }

      });
      this.depotList.forEach(item => this.depotCapacityList.push({ name: item.Name, capacity: item.Capacity__c, id: item.Id }));
    }

  }

  handleDepotSelect(event) {

    this.selectedDepot = event.detail.value;
    this.selectedDepotCapacityList = this.depotCapacityList.filter(item => item.id === this.selectedDepot);
    this.depotCapacity = this.selectedDepotCapacityList[0].capacity;
    console.log('Capacity:' + this.depotCapacity);

  }

  cancel() {
    this.showModal = false;

  }
  handleNewReq(event) {
    this.showModal = true;
    this.data = [];
    this.fileName = null;
    this.selectedEmployees = [];
    this.AccountRecord = [];
    this.searchValue = null;
    this.ReqDate = null;
  }

  searchKeyword(event) {

    this.searchValue = event.target.value;

  }

  handleSearchKeyword() {

    if (this.searchValue != '') {

      getEmployeeList({
        searchKey: this.searchValue
      })
        .then(result => {
          // set @track contacts variable with return contact list from server  
          this.AccountRecord = result;
          if (result.length > 0)
            this.hasEmployees = true;
        })
        .catch(error => {

          const event = new ShowToastEvent({
            title: 'Error',
            variant: 'error',
            message: error.body.message,
          });
          this.dispatchEvent(events);
          // reset contacts var with null   
          this.AccountRecord = null;
        });
    } else {
      // fire toast event if input field is blank
      const event = new ShowToastEvent({
        title: 'Data not found',
        variant: 'error',
        message: 'please enter a valid name'
      });
      this.dispatchEvent(events);
    }
    if (this.AccountRecord == null) {
      const event = new ShowToastEvent({
        title: 'Data not found',
        variant: 'error',
        message: 'please enter a valid name'
      });
    }
  }

  handleCheckboxChange(event) {

    if (event.target.checked) {
      console.log(this.selectedEmployees.length);
      this.emplength = this.selectedEmployees.length;
      this.totalLength = this.emplength + this.fileLength;
      console.log('total:' + this.totalLength);
      if (this.selectedEmployees.length >= this.depotCapacity || this.totalLength >= this.depotCapacity) {
        event.target.checked = false;
        const events = new ShowToastEvent({
          title: "Warning",
          message: "Depot capacity exceeded. Cannot add more employees",
          variant: 'Warning'
        });
        this.dispatchEvent(events);
      }
      else {
        event.target.checked = true;

        let nameVal = event.target.name;
        this.AccountRecord.forEach(item => {
          if (item.Id == nameVal)
            this.selectedEmployees.push(item);

        })
      }

    }

  }
  onEmpRemove(event) {
    let selEmp = event.target.name;
    const removeIndex = this.selectedEmployees.findIndex(item => item.Id == selEmp.Id);
    this.selectedEmployees.splice(removeIndex, 1);
    this.hasEmployees = false;


  }
  handleOnSubmit(event) {
    console.log('entered handleOnSubmit');
    event.preventDefault();
    let fields = event.detail.fields;
    console.log('this.selectedEmployees.length' + this.selectedEmployees.length);
    console.log('this.data.length' + this.data.length);
    console.log('this.selectedData length:' + this.selectedData.length);
    console.log('this.selectedData content:' + JSON.stringify(this.selectedData));
    console.log(this.selectedProgram);

    if (this.selectedEmployees.length !== 0 || this.data.length !== 0 || this.selectedData.length !== 0) {
      this.showSpinner = true;
      let bkngOBj = {
        sobjectType: 'ETDI_Booking_Request__c',
        Requested_Date__c: fields['Requested_Date__c'],
        Language__c: fields['Language__c'],
        Branch__c: this.selectedBranch,
        Depot__c: this.selectedDepot,
        Program_Name__c: fields['Program_Name__c'],
        Exam_Required__c: this.selectedOption
      };
      const selectedDataString = JSON.stringify(this.selectedData);
      console.log('selectedDataString:' + selectedDataString);


      createBooking({
        bkngReq: bkngOBj,
        empList: this.selectedEmployees,
        empData: JSON.stringify(this.data),
        isExternal: this.isExternal,
        selectedData: selectedDataString
      })
        .then(result => {
          console.log('result:', result);
          if (result === 'SUCCESS') {
            this.showSpinner = false;
            this.showModal = false;
            this.ReqDate = '';
            this.dispatchEvent(new ShowToastEvent({
              title: "Successful",
              message: "Booking Request Successfully Created",
              variant: 'success'
            }));
            this.getBookingRequest();
          } else {
            this.showSpinner = false;
            this.dispatchEvent(new ShowToastEvent({
              title: "Error",
              message: "Please check with system admin",
              variant: 'error'
            }));
          }
        })
        .catch(error => {
          console.log('Error during createBooking:' + error);
          this.showSpinner = false; // Ensure spinner is hidden on error
        });
    } else {
      this.dispatchEvent(new ShowToastEvent({
        title: "Warning",
        message: "At least one employee is required.",
        variant: 'Warning'
      }));
    }
  }
  handleOnError(event) {

  }
  handleIsExternalChange(event) {//new
    this.isExternal = event.target.checked;
  }

  handleSelectAll(event) {
    this.areAllSelected = event.target.checked;
    this.selectedItems.clear();

    if (this.areAllSelected) {
      this.extractedData.forEach(item => {
        this.selectedItems.add(item.name);
      });
    }
  }
  handleCheckboxChange1(event) {
    const itemId = event.target.dataset.id; // Get the item ID from the checkbox
    console.log('Checkbox changed for itemId: ' + itemId); // Log the checkbox ID

    // Ensure extractedData is populated before proceeding
    if (!this.extractedData || this.extractedData.length === 0) {
      console.warn('Extracted data is empty. Cannot process checkbox change.');
      return; // Exit if extractedData is not available
    }

    // Find the item in extractedData that matches itemId
    const selectedItem = this.extractedData.find(item => item.id == itemId); // Use loose equality for string comparison
    console.log('Selected item: ' + JSON.stringify(selectedItem)); // Log the selected item

    if (!selectedItem) {
      console.warn('No selected item found for itemId: ' + itemId);
      return; // Exit if selectedItem is not found
    }

    const index = this.selectedData.findIndex(item => item.id === itemId);

    // If the checkbox is checked and the item is not already selected, add it to selectedData
    if (event.target.checked && index === -1) {
      this.selectedData.push(selectedItem);
    }
    // If the checkbox is unchecked and the item is in selectedData, remove it
    else if (!event.target.checked && index !== -1) {
      this.selectedData.splice(index, 1);
    }

    console.log('Current selectedData: ' + JSON.stringify(this.selectedData)); // Log the current selected data

    // Update the selectedItems set for tracking all selected items
    if (event.target.checked) {
      this.selectedItems.add(itemId);
    } else {
      this.selectedItems.delete(itemId);
    }

    // Check if all items are selected
    this.areAllSelected = this.selectedItems.size === this.extractedData.length;
  }
  handleUploadFile(event) {

    if (event.target.files.length > 0) {
      //new begin
      const file = event.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = () => {
          const data = reader.result;
          this.parseCSVData(data);
        };
        reader.readAsText(file);
      }//new end

      this.filesUploaded = event.target.files;
      this.fileName = event.target.files[0].name;
      this.file = this.filesUploaded[0];

      this.fileReader = new FileReader();

      this.fileReader.onloadend = (() => {

        this.fileContents = this.fileReader.result;

        this.readAttachedFile();
      });
      this.fileReader.readAsText(this.file);
    }

  }
  parseCSVData(data) {
    const rows = data.split('\n');
    this.extractedData = rows.slice(1).map((row, index) => {
      const columns = row.split(',');
      return {
        id: index, // Assign a unique id for each item if not present
        name: columns[1],
        trafficFile: columns[2],
        license: columns[3],
        company: columns[4],
        nationality: columns[5],
        franchise: columns[6],
        remarks: columns[7],
        registrationLocation: columns[8],
        group: columns[9],
      };
    }).filter(item => item.name && item.trafficFile);

    // Log the extracted data to verify
    console.log('Extracted Data: ' + JSON.stringify(this.extractedData));
  }
  readAttachedFile() {
    console.log(JSON.stringify(this.fileContents))
    const lines = this.fileContents.split(/\r\n|\n/);
    console.log('length of lines:' + lines.length / 2);
    this.fileLength = lines.length / 2;
    this.totalLength = this.emplength + this.fileLength;
    console.log('total:' + this.totalLength);
    if (lines.length / 2 >= this.depotCapacity + 1 || this.totalLength >= this.depotCapacity + 1) {
      const events = new ShowToastEvent({
        title: "Warning",
        message: "Depot capacity exceeded. Only " + this.depotCapacity + " employee(s) can be added in total",
        variant: 'Warning'
      });
      this.dispatchEvent(events);
      this.showFileName = false;
    }

    else {
      this.showFileName = true;
      const headers = lines[0].split(',');
      this.previewColumns = headers.map((header) => {
        return { label: header, fieldName: header };
      });
      const data = [];

      lines.forEach((line, i) => {
        if (i === 0 || i === lines.length - 1) return;
        const obj = {};

        const currentline = line.split(',');

        for (let j = 0; j < headers.length; j++) {
          obj[headers[j]] = currentline[j];
        }

        data.push(obj);
      });

      this.data = data;
    }


  }


  /*  handleDateChange(event) {
     let selectedDate = new Date(event.target.value);
     let currentDate = new Date();
     //this.ReqDate=event.target.value;
     console.log('selectedDate:'+selectedDate);
     console.log('currentdate:'+currentDate);
     console.log('before:'+event.target.value);
     if (selectedDate!=null && selectedDate < currentDate) {
     //event.target.value = ''; // Clear the input value
     this.ReqDate='';
     // You can also show a toast or an error message using a library like lightning-platform-show-toast-event
     const events = new ShowToastEvent({
       title: "Warning",
       message: "Past dates are not allowed.",
       variant: 'Warning'
     });
     
     this.dispatchEvent(events);
     console.log('after:'+event.target.value);
     console.log('after this.ReqDate:'+this.ReqDate);
     //console.error('Past dates are not allowed.');
     return;
     }
     } */



  DownloadTemplate() {
    var jsonStr = '{"rows":[{"vals":[{"val":"Test Employee"},{"val":"1241323"}]}],"headers":[{"title":"EmployeeName"},{"title":"Traffic File"}]}';
    var jsonData = JSON.parse(jsonStr);

    var gridData = jsonData;
    // Spliting headers form table.
    var gridDataHeaders = gridData["headers"];
    // Spliting row form table.
    var gridDataRows = gridData["rows"];
    //  CSV download.
    var csv = '';
    for (var i = 0; i < gridDataHeaders.length; i++) {
      csv += (i === (gridDataHeaders.length - 1)) ? gridDataHeaders[i]["title"] : gridDataHeaders[i]["title"] + ',';
    }
    csv += "\n";
    var data = [];
    for (var i = 0; i < gridDataRows.length; i++) {
      var gridRowIns = gridDataRows[i];
      var gridRowInsVals = gridRowIns["vals"];
      var tempRow = [];
      for (var j = 0; j < gridRowInsVals.length; j++) {
        var tempValue = gridRowInsVals[j]["val"];
        if (tempValue.includes(',')) {
          tempValue = "\"" + tempValue + "\"";
        }
        tempValue = tempValue.replace(/(\r\n|\n|\r)/gm, "");
        tempRow.push(tempValue);
      }
      data.push(tempRow);
    }
    data.forEach(function (row) {
      csv += row.join(',');
      csv += "\n";
    });
    // 6. To download table in CSV format.
    var hiddenElement = document.createElement('a');
    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
    hiddenElement.target = '_blank';
    hiddenElement.download = 'EmployeeUploadTemplate' + '.csv';
    hiddenElement.click();
  }
}
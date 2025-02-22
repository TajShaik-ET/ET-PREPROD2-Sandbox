import { LightningElement, track, api, wire } from "lwc";
import saveFile from "@salesforce/apex/ET_overTimeAutomationController.saveRecords";
import getOvertimeRecords from "@salesforce/apex/ET_overTimeAutomationController.getOvertimeRecords";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import uploadFileToApex from "@salesforce/apex/ET_overTimeAutomationController.uploadFileToApex";
import getOTSrecords from '@salesforce/apex/ET_overTimeAutomationController.getOTSrecords';
import { refreshApex } from '@salesforce/apex';

const columnsApi = [
    { label: "Employee No", fieldName: "Employee_No__c", initialWidth: 150, sortable: true },
    { label: "Employee Name", fieldName: "Employee_Name__c", initialWidth: 150, sortable: true },
    {
        label: "Time In",
        fieldName: "Time_In__c",
        type: "datetime",
        initialWidth: 100,
    },
    {
        label: "Time Out",
        fieldName: "Time_Out__c",
        type: "datetime",
        initialWidth: 120,
    },
    {
        label: "Date",
        fieldName: "Date__c",
        initialWidth: 150,
    },

];

const Sheetcolumns = [
    {
        label: "Name",
        fieldName: "Name",
        type: "button",
        sortable: true,
        typeAttributes: { label: { fieldName: "Name" } },
    },
    { label: "OverTime Uploader", fieldName: "OverTime_Uploader__c" },
    { label: "Uploaded Date", fieldName: "Uploaded_Date__c" },
    {
        type: "button-icon",
        typeAttributes: {
            iconName: "action:upload",
            iconPosition: "left",
            label: "Upload",
            variant: "brand",
            fixedWidth: 100,
        },
    },
];

export default class ET_overTimeAuto extends LightningElement {
    @api recordid;
    @track showLoadingSpinner = false;
    @track fileName = "";
    @track UploadFile = "Save";
    filesUploaded = [];
    file;
    fileContents;
    fileReader;
    MAX_FILE_SIZE = 1500000;

    @track eT_overTimeAutoLWCcomp = true;
    @track error;
    @track isTrue = false;
    @track showButtons = false;
    @track activeTab = "OverTime_Sheet";
    Show_dataTable_Upload = false;
    @track OT_CSVlines = [];
    @track OT_CSVColumns = columnsApi;
    @track OT_STrecordId;
    @track OT_columns = [];
    @track OT_Sheetcolumns = Sheetcolumns;
    @track OT_RecColumns = columnsApi;
    @track OT_Sheets_Data;
    @track OT_Sheets;
    @track OT_Records;
    //sorting
    sortedRecords;
    sortedBy;
    sortDirection;
    wiredOTSrecordResult

    @wire(getOTSrecords)
    wiredOTSrecords(result) {
        this.wiredOTSrecordResult = result;
        if (result.data) {
            this.OT_columns = this.OT_Sheetcolumns;
            this.OT_Sheets = result.data;
            this.OT_Sheets_Data = this.OT_Sheets;

            this.onHandleSort();
            console.log()
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            console.log('this.error :' + this.error);
        }
    }


    handleTabSelect(event) {
        this.activeTab = event.target.value;
    }
    handleRowAction(event) {
        const rowId = event.detail.row.Id;
        const uploadicon = event.detail.action.label;
        console.log(JSON.stringify(uploadicon));
        if (uploadicon === "Upload" && uploadicon !== undefined) {
            this.OT_STrecordId = rowId;
            this.template.querySelector("input").click();
        } else {
            this.fetchOvertimeRecords(rowId);
        }
    }
    fetchOvertimeRecords(SheetId) {
        this.showLoadingSpinner = true;

        getOvertimeRecords({ sheetId: SheetId })
            .then((result) => {
                if (SheetId) {
                    //line Item
                    this.OT_columns = [];
                    this.OT_columns = this.OT_RecColumns;
                    this.OT_Records = result;
                    this.OT_Sheets_Data = this.OT_Records;
                    this.showLoadingSpinner = false;
                    this.onHandleSort();

                }
                console.log("fetchOvertimeRecords " + JSON.stringify(result));
            })
            .catch((error) => {
                this.error = error;
            });
    }

    handleFilesChange(event) {
        if (event.target.files.length > 0) {
            this.filesUploaded = event.target.files;
            this.fileName = event.target.files[0].name;
            if (this.filesUploaded.length > 0) {
                this.PasrseCSV();
            } else {
                this.fileName = "Please select a CSV file to upload!!";
            }
        }
    }

    PasrseCSV() {
        this.file = this.filesUploaded[0];
        if (this.file.size > this.MAX_FILE_SIZE) {
            window.console.log("File Size is to long");
            return;
        }
        this.showLoadingSpinner = true;

        this.fileReader = new FileReader();
        this.fileReader.onloadend = () => {
            this.fileContents = this.fileReader.result;
            const lines = this.fileContents.split("\n");
            this.headers = lines[0].split(",");
            this.OT_CSVlines = [];

            for (let i = 1; i < lines.length; i++) {
                const row = lines[i].split(",");
                //console.log('Processing row:', row);

                if (row.length > 1) {
                    let line;
                    line = {
                        Employee_No__c: row[0],
                        Employee_Name__c: row[1],
                        Time_In__c: row[2],
                        Time_Out__c: row[3],
                        Date__c: row[4],
                        /* Contract_No__c: row[5],
                        Cust_Name__c: row[6],
                        Cost_Recovery__c: row[7],
                        Location__c: row[8],
                        Category__c: row[9],
                        Activity__c: row[10],
                        Total_Rate__c: row[11],
                        Type__c: row[12], */
                    };
                    if (line) {
                        this.OT_CSVlines.push(line);
                        this.Show_dataTable_Upload = true;
                        this.showButtons = true;
                        this.isTrue = false;
                        this.showLoadingSpinner = false;
                    }
                }
            }
        };
        this.fileReader.readAsText(this.file);
    }

    handleSave() {
        this.showLoadingSpinner = true;

        saveFile({ overtimeRecords: this.OT_CSVlines })
            .then((result) => {
                window.console.log("saveToFile result ====> ");
                window.console.log(result);
                this.fileName = "Uploaded Successfully";
                this.isTrue = true;
                this.showButtons = false;
                this.Show_dataTable_Upload = false;
                this.showLoadingSpinner = false;
                this.refreshData();
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success!!",
                        message: this.file.name + " - Uploaded Successfully!!!",
                        variant: "success",
                    })
                );
            })
            .catch((error) => {
                window.console.log(error);
                let errorMessage;
                if (error.body) {
                    errorMessage = error.body.message;
                } else {
                    errorMessage = 'An unknown error occurred';
                }
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "error",
                        message: errorMessage,
                        variant: "error",
                    })
                );
            });
    }
    handleReset() {
        // Reset the datatable and related state
        this.lines = [];
        this.fileName = "";
        this.Show_dataTable_Upload = false;
        this.showButtons = false;
    }
    refreshData() {
        return refreshApex(this.wiredOTSrecordResult);
    }
    handleBackButtonClick() {
        this.OT_columns = this.OT_Sheetcolumns;
        this.OT_Sheets_Data = this.OT_Sheets;
        this.onHandleSort();

    }
    handleFileUpload(event) {
        const file = event.target.files[0];
        if (file) {
            this.showLoadingSpinner = true;
            const reader = new FileReader();
            reader.onload = () => {
                const base64 = reader.result.split(",")[1];
                this.uploadFileToServer(base64, file.name, this.OT_STrecordId);
            };
            reader.onerror = () => {
                console.error("Error reading file");
                this.showLoadingSpinner = false;
            };
            reader.readAsDataURL(file);
        }
    }
    uploadFileToServer(base64, fileName, recordId) {
        uploadFileToApex({
            base64Data: base64,
            fileName: fileName,
            recordId: recordId,
        })
            .then((result) => {
                console.log("File uploaded successfully:", result);
                this.showLoadingSpinner = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success!!",
                        message: "Uploaded Successfully!!!",
                        variant: "success",
                    })
                );
            })
            .catch((error) => {
                console.error("Error uploading file:", error);
                this.showLoadingSpinner = false;
            });
    }
    onHandleSort(event) {
        console.log('this.OT_Sheets_Data' + JSON.stringify(this.OT_Sheets_Data));
        this.sortDirection = 'desc';
        this.OT_Sheets_Data.forEach((record) => {
            if (record.Name) {
                this.sortedBy = 'Name';
                console.log('Name exists: ' + this.sortedBy);

            } else {
                this.sortedBy = 'Employee_Name__c';
            }
        });
        this.sortData(this.sortedBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.OT_Sheets_Data));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.OT_Sheets_Data = parseData;

    }

}
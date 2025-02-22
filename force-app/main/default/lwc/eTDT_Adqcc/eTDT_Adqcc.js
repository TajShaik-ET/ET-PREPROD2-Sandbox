import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; // Import toast event
import getBRRecords from '@salesforce/apex/ETDIBookingRequest.getBRRecordsForADQCC';
import updateTrainee from '@salesforce/apex/ETDIBookingRequest.updateTraineeADQCC';

export default class ETDT_Adqcc extends LightningElement {
    @track columns = [
        { label: 'Booking Ref No.', fieldName: 'ReqName', type: 'text' },
        { label: 'Emirates ID', fieldName: 'EmiratesID', type: 'text' },
        { label: 'Employee Name', fieldName: 'EmployeeName', type: 'text' },
        { label: 'Program Name', fieldName: 'ProgramName', type: 'text' },
        { label: 'Joining Date', fieldName: 'JoiningDate', type: 'date', typeAttributes: { year: "numeric", month: "short", day: "2-digit" } },
        { label: 'Job Name', fieldName: 'JobName', type: 'text' },
        { label: 'Organization', fieldName: 'Organization', type: 'text' },
        { label: 'Location', fieldName: 'Location', type: 'text' },
        { label: 'Gender', fieldName: 'Gender', type: 'text' },
        { label: 'Nationality', fieldName: 'Nationality', type: 'text' },
        { label: 'Price', fieldName: 'Price', type: 'currency', typeAttributes: { currencyCode: 'AED' } },
        {
            type: 'button',
            typeAttributes: {
                label: 'Edit',
                name: 'edit',
                title: 'Edit',
                variant: 'destructive',
                iconName: 'utility:edit',
                iconPosition: 'left'
            }
        }
    ];

    @track BRRecordList = [];
    @track hasBrRecordData = false;
    @track isModalOpen = false;
    @track selectedRowData = {
        RequestNo: '',
        Submitted_Date__c: ''
    };
    @track typeOptions = [
        { label: 'New', value: 'New' },
        { label: 'Renewal', value: 'Renewal' }
    ];

    connectedCallback() {
        this.getBRRecordsForADQCC();
    }

    getBRRecordsForADQCC() {
        getBRRecords()
            .then(result => {
                let tempData = [];
                result.forEach(record => {
                    let parentRecord = {
                        Id: record.Id,
                        ReqName: record.Name,
                        Price: record.Program_Name__r ? record.Program_Name__r.Price__c : null,
                        ProgramName: record.Program_Name__r ? record.Program_Name__r.Name : null,
                    };

                    if (record.ETDI_Trainees__r) {
                        record.ETDI_Trainees__r.forEach(child => {
                            let combinedRecord = { ...parentRecord };
                            combinedRecord.TraineeId = child.Id; // Add Trainee Id
                            combinedRecord.EmiratesID = child.Employee__r ? child.Employee__r.ET_Emirates_Id__c : '';
                            combinedRecord.EmployeeName = child.Employee__r ? child.Employee__r.Name : '';
                            combinedRecord.EmployeeNumber = child.Employee_Number__c;
                            combinedRecord.JoiningDate = child.Employee__r ? child.Employee__r.ETIN_Joining_Date__c : null;
                            combinedRecord.JobName = child.Employee__r ? child.Employee__r.ETIN_Job_Name__c : '';
                            combinedRecord.Organization = child.Organization_Name__c;
                            combinedRecord.Location = child.Location__c;
                            combinedRecord.Gender = child.Employee__r ? child.Employee__r.ETST_Gender__c : '';
                            combinedRecord.Nationality = child.Employee__r ? child.Employee__r.ET_Nationality__c : '';
                            combinedRecord.PermitType = child.Permit_Type__c;
                            combinedRecord.ADQCCFees = child.ADQCC_Fees__c;
                            combinedRecord.RequestNo = child.Request_No__c;
                            combinedRecord.Submitted_Date__c = child.Submitted_Date__c;
                            combinedRecord.Payment_Referance__c = child.Payment_Referance__c;
                            combinedRecord.Receipt_No__c = child.Receipt_No__c;
                            combinedRecord.Payment_Date__c = child.Payment_Date__c;
                            tempData.push(combinedRecord);
                        });
                    }
                });
                this.BRRecordList = tempData;
                this.hasBrRecordData = this.BRRecordList.length > 0;
            })
            .catch(error => {
                console.error('Error fetching booking requests:', error);
            });
    }


    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'edit') {
            this.openEditModal(row);
        }
    }

    openEditModal(row) {
        this.selectedRowData = { ...row };
        this.isModalOpen = true;
        console.log('Selected Row Data:', this.selectedRowData);
    }

    closeEditModal() {
        this.isModalOpen = false;
        this.selectedRowData = {};
    }

    handleInputChange(event) {
        const fieldName = event.target.dataset.field;
        this.selectedRowData[fieldName] = event.target.value;
        if (fieldName === 'RequestNo' && this.selectedRowData.RequestNo) {
            this.selectedRowData.Submitted_Date__c = new Date().toISOString().split('T')[0];
        }
        if (fieldName === 'Payment_Referance__c' && this.selectedRowData.Payment_Referance__c) {
            this.selectedRowData.Payment_Date__c = new Date().toISOString().split('T')[0];
        }
    }

    handleSave() {
        console.log('this.selectedRowData.TraineeId', this.selectedRowData.TraineeId);

        updateTrainee({ traineeId: this.selectedRowData.TraineeId, empNo: this.selectedRowData.EmployeeNumber, type: this.selectedRowData.Type, payRef: this.selectedRowData.Payment_Referance__c, payDate: this.selectedRowData.Payment_Date__c, reqNo: this.selectedRowData.RequestNo, rptNo: this.selectedRowData.Receipt_No__c, subdate: this.selectedRowData.Submitted_Date__c })
            .then(() => {
                console.log('Trainee record updated successfully');

                // Show success toast message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Trainee record updated successfully!',
                        variant: 'success'
                    })
                );

                this.closeEditModal(); // Close the modal after successful update
                this.getBRRecordsForADQCC(); // Refresh the list
            })
            .catch(error => {
                console.error('Error updating trainee record:', error);

                // Show error toast message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Failed to update the trainee record.',
                        variant: 'error'
                    })
                );
            });
    }
}
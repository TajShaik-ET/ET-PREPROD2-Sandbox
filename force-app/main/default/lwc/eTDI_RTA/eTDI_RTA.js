import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getBRRecords from '@salesforce/apex/ETDIBookingRequest.getBRRecordsForRTA';
import updateTrainee from '@salesforce/apex/ETDIBookingRequest.updateTrainee';

export default class ETDT_Adqcc extends LightningElement {
    @track columns = [
        { label: 'Booking Ref No.', fieldName: 'ReqName', type: 'text' },
        { label: 'External Name', fieldName: 'ExternalName', type: 'text' },
       // { label: 'Traffic File', fieldName: 'TrafficFile', type: 'text' },
        { label: 'Company', fieldName: 'Company', type: 'text' },
        { label: 'Program Name', fieldName: 'ProgramName', type: 'text' },
        { label: 'Nationality', fieldName: 'Nationality', type: 'text' },
        { label: 'Franchise/Limo', fieldName: 'FranchiseLimo', type: 'text' },
        { label: 'Registration Location', fieldName: 'RegistrationLocation', type: 'text' },
        { label: 'Group', fieldName: 'Group', type: 'text' },
        { label: 'Attendance Date', fieldName: 'AttendanceDate', type: 'text' },
        { label: 'Absent Date', fieldName: 'AbsentDate', type: 'text' },
        { label: 'Remarks', fieldName: 'Remarks', type: 'text' },
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
        Submitted_Date__c: '',
        Receipt_No__c: '',
        RTA_Receipt__c: '',
        Traffic__c: ''
    };

    connectedCallback() {
        this.getBRRecordsForRTA();
    }

    getBRRecordsForRTA() {
        getBRRecords()
            .then(result => {
                let tempData = [];
                result.forEach(wrapper => {
                    let parentRecord = {
                        Id: wrapper.bookingRequest.Id,
                        ReqName: wrapper.bookingRequest.Name,
                        Price: wrapper.bookingRequest.Program_Name__r
                            ? wrapper.bookingRequest.Program_Name__r.Price__c
                            : null,
                        ProgramName: wrapper.bookingRequest.Program_Name__r
                            ? wrapper.bookingRequest.Program_Name__r.Name
                            : null
                    };

                    let combinedRecord = { ...parentRecord };
                    combinedRecord.TraineeId = wrapper.trainee.Id;
                    combinedRecord.Receipt_No__c = wrapper.trainee.Receipt_No__c;
                    combinedRecord.RTA_Receipt__c = wrapper.trainee.RTA_Receipt__c;
                    combinedRecord.ExternalName = wrapper.trainee.External_Name__c;
                    combinedRecord.Nationality = wrapper.trainee.Nationality__c;
                    combinedRecord.Traffic__c = wrapper.trainee.Traffic__c;
                    combinedRecord.Company = wrapper.trainee.Company__c;
                    combinedRecord.FranchiseLimo = wrapper.trainee.Franchise_Limo__c;
                    combinedRecord.RegistrationLocation = wrapper.trainee.Registration_Location__c;
                    combinedRecord.Group = wrapper.trainee.Group__c;
                    combinedRecord.Remarks = wrapper.trainee.Remarks__c;
                    combinedRecord.AttendanceDate = wrapper.daysPresent;
                    combinedRecord.AbsentDate = wrapper.daysAbsent;

                    if (wrapper.trainerSchedule) {
                        console.log('Trainer Schedule:', wrapper.trainerSchedule);
                        combinedRecord.Schedule_Date_Time__c = wrapper.trainerSchedule.Schedule_Date_Time__c;
                        combinedRecord.TrainerName = wrapper.trainerSchedule.Trainer__r
                            ? wrapper.trainerSchedule.Trainer__r.Name
                            : null;
                    } else {
                        combinedRecord.Schedule_Date_Time__c = null;
                        combinedRecord.TrainerName = null;
                    }

                    tempData.push(combinedRecord);
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

    handleInputChange(event) {
        const field = event.target.dataset.field;
        this.selectedRowData[field] = event.target.value;
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

    handleSave() {
        const updatedTraineeData = {
            Id: this.selectedRowData.TraineeId, // Use TraineeId for update
            Receipt_No__c: this.selectedRowData.Receipt_No__c,
            RTA_Receipt__c: this.selectedRowData.RTA_Receipt__c,
            Traffic__c: this.selectedRowData.Traffic__c
        };

        updateTrainee({ traineeId: this.selectedRowData.TraineeId, ReceiptNo: this.selectedRowData.Receipt_No__c, RTAReceiptNo: this.selectedRowData.RTA_Receipt__c, TrafficFile: this.selectedRowData.Traffic__c })
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
                this.getBRRecordsForRTA(); // Refresh the list
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
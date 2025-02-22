import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import convertLead from '@salesforce/apex/MOTO_VehInspectionCtrl.convertLeadAndGetOpportunityId';
import saveLeadRecord from '@salesforce/apex/MOTO_VehInspectionCtrl.saveLeadRecord';
//getpicklistvalues from apex MOTO_VehInspectionCtrl-->
import LEADSOURCE_FIELD from '@salesforce/apex/MOTO_VehInspectionCtrl.LEADSOURCE_FIELDOptions';
import LIST_OF_REQUIRED_SERVICE_FIELD from '@salesforce/apex/MOTO_VehInspectionCtrl.LIST_OF_REQUIRED_SERVICE_FIELDOptions';


import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import LEAD_OBJECT from '@salesforce/schema/Lead';


export default class MotoVehLeadForm extends LightningElement {

    recordTypeId;
    @wire(getObjectInfo, { objectApiName: LEAD_OBJECT })
    getobjectInfo(result) {
        if (result.data) {
            const rtis = result.data.recordTypeInfos;
            this.recordTypeId = Object.keys(rtis).find((rti) => rtis[rti].name === 'Automotive Service Center & Body Shop');
            console.log('this.recordTypeId', this.recordTypeId)
        }
    }





    //spiner
    loaded;

    @track selectedRecordTypeId = '$recordTypeId';
    @track objectApiName = 'Vehicle_Model_Master__c';
    @track vehModelRecordId;
    @track vehBrandRecordId;
    @track vehCampaignRecordId;
    @track workshopLocationRecId;
    @track disabled = true;
    @track isBrandIdTrue;

    //filtercondition to cutom lookup
    @track filterCondition;
    //input values used in html
    mobilization = 'Full delivery'; //hidden field
    @track firstName = '';
    lastName = '';
    mobilePhone = '';
    email = '';
    descripton = '';
    leadSource = '';
    Typeofcustomer = '';
    vehicleBrand = '';
    vehicleModel = '';
    etmVehicleModel = '';
    listOfRequiredServices = '';
    TypeOfServices = '';
    campaign = '';
    //form selection 
    @api selectedForm;
    @track theRecord = {};
    @track leadId;
    @api oppRec;
    CampaignField = true;
    requiredCampain = true;



    // Picklist values from apex
    @track VehicleModelYearOptions = [];
    @track VehicleModelYearMap = [];

    @track VehLeadSourceOptions = [];
    @track VehLeadSourceMap = [];

    @track VehtypeOfCustomerOptions = [];
    @track VehtypeOfCustomerMap = [];

    @track VehtypeOfServicesWalkinOptions = [];
    @track VehtypeOfServicesWalkinMap = [];

    @track VehtypeOfServiceInsurancesOptions = [];
    @track VehtypeOfServiceInsurancesMap = [];

    @track VehtypeOfServicesInternalOptions = [];
    @track VehtypeOfServicesInternalMap = [];

    @track VehlistOfRequiredServicesOptions = [];
    @track VehlistOfRequiredServicesMap = [];











    connectedCallback() {
        console.log(this.selectedForm)
        if (this.selectedForm == "walk-in") {
            this.requiredCampain = false;
        } else if (this.selectedForm == "Insurance") {
            this.CampaignField = false;
        } else if (this.selectedForm == "Internal") {

        }

        // picklist values-from apex
        LEADSOURCE_FIELD({
            objObject: 'Lead',
            fld: 'LeadSource'
        })
            .then((result) => {
                result.forEach(item => this.VehLeadSourceMap.push({ label: item, value: item }));
                this.VehLeadSourceOptions = this.VehLeadSourceMap.map(({ label: label, value: value }) => ({
                    label,
                    value,
                }));
            })
            .catch(error => {
                console.log(error)
            });

      
        LIST_OF_REQUIRED_SERVICE_FIELD({
            objObject: 'Lead',
            fld: 'List_of_Required_Services__c'
        })
            .then((result) => {
                result.forEach(item => this.VehlistOfRequiredServicesMap.push({ label: item, value: item }));
                this.VehlistOfRequiredServicesOptions = this.VehlistOfRequiredServicesMap.map(({ label: label, value: value }) => ({
                    label,
                    value,
                }));
            })
            .catch(error => {
                console.log(error)
            });

    }

  

    // hard coded valus for picklist
    get leadsourceoptions() {
        return [
            { label: 'Website', value: 'Website' },
            { label: 'Email', value: 'Email' },
            { label: 'Nanoz', value: 'Nanoz' },
            { label: 'WhatsApp', value: 'WhatsApp' },
            { label: 'Facebook', value: 'Facebook' },
            { label: 'Instagram', value: 'Instagram' },
            { label: 'Linkedin', value: 'Linkedin' },
            { label: 'Dubizzle', value: 'Dubizzle' },
            { label: 'Referral', value: 'Referral' },
            { label: 'Google', value: 'Google' },
            { label: 'Staff Offer', value: 'Staff Offer' },
            { label: 'Inbound Call', value: 'Inbound Call' },
            { label: 'Outbound Call', value: 'Outbound Call' },
            { label: 'Dubicars', value: 'Dubicars' },
            { label: 'Fazaa', value: 'Fazaa' },
            { label: 'Esaad', value: 'Esaad' },
            { label: 'Outdoor Ads', value: 'Outdoor Ads' },
            { label: 'SMS', value: 'SMS' },
            { label: 'Contracted Insurance', value: 'Contracted Insurance' },
            { label: 'Bing', value: 'Bing' },
            { label: 'Snapchat', value: 'Snapchat' },
            { label: 'TikTok', value: 'TikTok' },
            { label: 'YallaMotors', value: 'YallaMotors' },

        ];
    }

    get ModelYearOptions() {
        // Generate the years array with values ranging from 2000 to 2025
        for (let i = 2005; i <= 2025; i++) {
            this.VehicleModelYearOptions.push({ label: i.toString(), value: i.toString() });
        }
        return this.VehicleModelYearOptions;
    }



    handleFormInputChange(event) {
        console.log('event.target.value>>>>>' + event.target.value)
        this.theRecord[event.target.name] = event.target.value;
    }

    handleSubmit() {
        this.loaded = true;
     
        this.theRecord["Vehicle_Brand__c"] = this.vehBrandRecordId;
        this.theRecord["Moto_Vehicle_Model__c"] = this.vehModelRecordId;
        this.theRecord["Campaign__c"] = this.vehCampaignRecordId;
        this.theRecord["Workshop_Location__c"] = this.workshopLocationRecId;
        this.theRecord["sobjectType"] = "Lead";
        this.theRecord["RecordTypeId"] = '0123z000000Z5nxAAC';
        this.theRecord["OwnerId"] = '0053z00000CWqXlAAL';
        this.theRecord["Mobilization_type__c"] = this.mobilization;
        //console.log('List_of_Required_Services__c>>>>>>>', this.theRecord.List_of_Required_Services__c);
        if (this.theRecord) {
            if ( !this.theRecord.FirstName || !this.theRecord.LastName || !this.theRecord.MobilePhone || !this.theRecord.Email || !this.theRecord.ETM_Vehicle_Model__c || !this.theRecord.Vehicle_Brand__c || !this.theRecord.Moto_Vehicle_Model__c || !this.theRecord.Description_for_Service_Request__c) {
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'error',
						message: 'Enter All Required Fields',
						variant: 'error',
					}),
				);
             this.loaded = false;

			}else{
                const leadFormRecord = this.theRecord;
                console.log(leadFormRecord)
                saveLeadRecord({ leadFormRecord })
                    .then((result) => {
                        console.log('Record saved with ID:', result);
                        this.leadId = result;
                        this.handleSuccess();
                    })
                    .catch(error => {
                        console.log(error)
                    });
            }
        }

    }

    handleSuccess(event) {
        let leadId = [];
        leadId = this.leadId;
        console.log(leadId)
        console.log(this.theRecord.MobilePhone)
        convertLead({ leadId })
            .then(result => {
                this.oppRec = result;

                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!',
                    message: 'Lead converted successfully.',
                    variant: 'success'
                }));
                this.loaded = false;
                this.eventHanlderAppointment();
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error!',
                    message: 'An error occurred while converting the Lead.',
                    variant: 'error'
                }));
                console.log(error)
            });
    }

    backbButtonHanlder(event) {
        const backButtonEvent = new CustomEvent("backbuttonclickwalkin", {
            detail: null
        });
        this.dispatchEvent(backButtonEvent);
    }

    getvehBrandRecordDetails(event) {
        let vehicleBrandDetail = event.detail;
        this.vehBrandRecordId = vehicleBrandDetail.Id;
        console.log(this.vehBrandRecordId)
        this.isBrandIdTrue = Boolean(this.vehBrandRecordId);
        if (this.isBrandIdTrue == true) {
            this.disabled = false;
        } else {
            this.disabled = true;
        }
    }
    // remove vehicle model record if brand record is removed
    clearvehModelRecordDetails(event) {
        this.vehBrandRecordId = event.detail;
        console.log(this.vehBrandRecordId)
        this.isBrandIdTrue = Boolean(this.vehBrandRecordId);
        if (this.isBrandIdTrue == true) {
            this.disabled = false;
        } else {
            this.disabled = true;
            const childComponent = this.template.querySelector('[data-id="vehicle-model"]');
            childComponent.clear();
        }
    }
    getVehModelRecordDetails(event) {
        this.vehModelRecordId = event.detail.Id;
    }
    getCampaignRecordDetails(event) {
        this.vehCampaignRecordId = event.detail.Id;
    }
    getWorkshopRecordDetails(event) {
        this.workshopLocationRecId = event.detail.Id;
        console.log('this.workshopLocationRecId>>>>>' , this.workshopLocationRecId);
    }
    SearchKeyHandler(event) {
        this.filterCondition = 'Vehicle_Brand__r.Id = \'' + this.vehBrandRecordId + '\'';
    }
    eventHanlderAppointment(event) {
        const oppRec = this.oppRec;
        const leadEvent = new CustomEvent("eventleadforms", {
            detail: { oppRec }
        });
        this.dispatchEvent(leadEvent);
    }
    handleError(event) {
        console.log('An error occurred while saving the record: ', event.detail.message);
    }
}
import { LightningElement, wire, api, track } from 'lwc';
import getLeads from '@salesforce/apex/MOTO_VehInspectionCtrl.getLeads';
import getOpportunities from '@salesforce/apex/MOTO_VehInspectionCtrl.getOpportunities';
import convertLead from '@salesforce/apex/MOTO_VehInspectionCtrl.convertLeadAndGetOpportunityId';
import getOpportunityData from '@salesforce/apex/MOTO_VehInspectionCtrl.getOpportunityData';
import getWorkshopLocation from '@salesforce/apex/MOTO_VehInspectionCtrl.getWorkshopLocation';

import getVehicle from '@salesforce/apex/MOTO_VehInspectionCtrl.getVehicle';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import LIST_OF_REQUIRED_SERVICE_FIELD from '@salesforce/apex/MOTO_VehInspectionCtrl.LIST_OF_REQUIRED_SERVICE_FIELDOptions';
import PAYMENTMODE_FIELD from '@salesforce/apex/MOTO_VehInspectionCtrl.PAYMENTMODE_FIELDOptions';
import DISCOUNTAPPLICABLE_FIELD from '@salesforce/apex/MOTO_VehInspectionCtrl.DISCOUNTAPPLICABLE_FIELDOptions';
import VEHICLEMILEAGE_FIELD from '@salesforce/apex/MOTO_VehInspectionCtrl.VEHICLEMILEAGE_FIELDOptions';
import INSURANCE_COMPANY_FIELD from '@salesforce/apex/MOTO_VehInspectionCtrl.INSURANCE_COMPANY_FIELDOptions';


//import PLATE_COLOR_FIELD from '@salesforce/apex/MOTO_VehInspectionCtrl.PLATE_COLOR_FIELDOptions';
import getPicklistValues from '@salesforce/apex/MOTO_VehInspectionCtrl.getPicklistValues';
//import PLATE_SOURCE_FIELD from '@salesforce/apex/MOTO_VehInspectionCtrl.PLATE_SOURCE_FIELDOptions';

import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';

import updateOpportunityRecord from '@salesforce/apex/MOTO_VehInspectionCtrl.updateOpportunityRecord';
import CreateOpportunityforInternalVehicle from '@salesforce/apex/MOTO_VehInspectionCtrl.CreateOpportunityforInternalVehicle';
import CreateOpportunityReturn from '@salesforce/apex/MOTO_VehInspectionCtrl.CreateOpportunityReturn';
import saveAccountRecord from '@salesforce/apex/MOTO_VehInspectionCtrl.saveAccountRecord';

import CreateAccountinERP from '@salesforce/apex/MOTO_CICO_AccountInERP.sendAccToERP';
import GetVehicleDetails from '@salesforce/apex/MOTO_CICO_GetVehicleDetails.GetVehicleDetails';
import CreateVehicle from '@salesforce/apex/MOTO_CICO_CreatePrivateVehicle.CreatePrivateVehicle';

import getInternalNumber from '@salesforce/apex/MOTO_VehInspectionCtrl.getInternalNumber';
import getServiceReqInfo from '@salesforce/apex/MOTO_VehInspectionCtrl.getServiceReqInfo';
import CreateCheckoutforInteral from '@salesforce/apex/MOTO_VehInspectionCtrl.CreateCheckoutforInteral';
import NAME_FIELD from '@salesforce/schema/Opportunity.Name';
import PHONE_FIELD from '@salesforce/schema/Opportunity.Account.PersonMobilePhone';
import EMAIL_FIELD from '@salesforce/schema/Opportunity.Account.PersonEmail';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
import INTERNAL_NO_FIELD from '@salesforce/schema/Opportunity.Vehicle_Internal_Number__c';
import MILEAGE_FIELD from '@salesforce/schema/Opportunity.Vehicle_Mileage_number__c';
import SERVICE_NO_FIELD from '@salesforce/schema/Opportunity.Service_Number__c';
import DOC_NO_FIELD from '@salesforce/schema/Opportunity.Doc_No__c';
import CREATED_DATE_FIELD from '@salesforce/schema/Opportunity.CreatedDate';


const FIELDS = [NAME_FIELD, PHONE_FIELD, EMAIL_FIELD, STAGE_FIELD, INTERNAL_NO_FIELD, MILEAGE_FIELD, SERVICE_NO_FIELD, DOC_NO_FIELD, CREATED_DATE_FIELD];


export default class MOTO_VehicleInspectionHome extends LightningElement {

	

	//integration
	GetCustomerandVehicleInfo = false;
	AccountNumberInERP;
	@track checkInForm = true;
	@track checkOutForm = false; 
	currentTarget;
	validationCheck = false;
	PrivateVehicle;
	CreatePrivateVehicle = true;
	ChassiNo;
	CreateAccountinERP = true;
	CreateServiceReq = true;
	//disableNext = false;
	isupdateOpportunity = false;
	recallingMethod;
	InsuranceCompanyField = false;
	InternalPage;
	PlateNumberPage;
	InternalNumberPage;
	InternalNum;
	@track showNext;
	@track ShowNextPlate;
	@track checkFor = 'Maintenance';
	@track checkboxValidation = false;
	get checkForInternal() {
        return [
            { label: 'Internal Assignments', value: 'Internal Assignments' },
            {label: 'Maintenance', value: 'Maintenance'},
            {label: 'Vehicle Rental', value: 'Vehicle Rental'},
            {label: 'Vehicle Transfer', value: 'Vehicle Transfer'},
        ];
    }

	opportunityData = [];
    columns = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
		{ label: 'Phone', fieldName: 'PersonMobilePhone', type: 'text' },
        { label: 'Email', fieldName: 'PersonEmail', type: 'text' },
        //{ label: 'Stage', fieldName: 'StageName', type: 'text' },
		{ label: 'Internal Number', fieldName: 'Vehicle_Internal_Number__c', type: 'text' },
		//{ label: 'Mileage Number', fieldName: 'Vehicle_Mileage_number__c', type: 'text' },
		{ label: 'Service Number', fieldName: 'Service_Number__c', type: 'text' },
		{ label: 'Doc Number', fieldName: 'Doc_No__c', type: 'text' },
		{ label: 'Craetion Date', fieldName: 'CreatedDate', type: 'text' },
    ];

    @wire(getOpportunityData)
    wiredOpportunityData({ error, data }) {
		console.log('data>>>>>>>>>', data);
        if (data) {
            this.opportunityData = data.map(opportunity => ({
                Id: opportunity.Id,
                Name: opportunity.Name,
                PersonMobilePhone: opportunity.Account.PersonMobilePhone,
                PersonEmail: opportunity.Account.PersonEmail,
                StageName: opportunity.StageName,
				Vehicle_Internal_Number__c: opportunity.Vehicle_Internal_Number__c,
				Vehicle_Mileage_number__c: opportunity.Vehicle_Mileage_number__c,
				Service_Number__c: opportunity.Service_Number__c,
				Doc_No__c: opportunity.Doc_No__c,
				CreatedDate: opportunity.CreatedDate,
            }));
        } else if (error) {
            console.error('Error fetching Opportunity data', error);
        }
    }

	@track selectedRadioButton;
	radioOptionsPlateNumber = [
		{ label: 'PlateNumber', value: 'PlateNumber' },
	];
	radioOptionsInternalNumber = [
		{ label: 'InternalNumber', value: 'InternalNumber' },
	];
	PlateNextButton;
	InternalNextButton;
	handleChange(event) {
		this.selectedRadioButton = event.detail.value;
		console.log('Selectedradiobutton', this.selectedRadioButton);
		if (this.selectedRadioButton == "PlateNumber") {
			this.PlateNumberPage = true;
			this.PlateNextButton = true;
			this.InternalNumberPage = false;
			this.InternalNextButton = false;
			this.ShowNextPlate = true;
			this.serviceDocNo = '';
			this.showNext = true;


		}
		if (this.selectedRadioButton == "InternalNumber") {
			this.InternalNumberPage = true;
			this.InternalNextButton = true;
			this.PlateNumberPage = false;
			this.PlateNextButton = false;
			this.InternalNumberT = false;
			this.serviceDocNo = '';
			this.showNext = true;


		}

	}
	//

	leadforms;
	// new changes
	loaded;
	showPage3 = false;
	showPage4 = false;
	AccidentRepair = false;
	ServiceContract = false;
	ServiceonDemand = false;
	listOfRequiredServices = [];
	Campaign = false;
	@api theRecord = {};
	@api theOppRecord = {};
	@track vehCampaignRecordId;
	@track vehBrandRecordId;
	@track vehModelRecordId;
	@track vehMasterId;
	@track vehMasterName;
	@track theCheckIn = {};
	Vat__c;
	Parts_Material_Price__c;
	Labor_Hrs_sold__c;
	Service_Estimation_Line__c;
	@track objTempRec;
	@track estimationRecId;
	@track updatedOppRec;
	@track updatedOppRecList;
	@track checkIn = false;
	@track checkOut = false;
	@track ExtRet = false;
	@track IntRet = false;
	showTabHome = true;
	showHomePage = false;
	showInternalPage;
	showSearchPage = false;
	selectedType = 'Vehicle Receiving';
	showVehReceivingForm = false;
	showVehLeadForm = false;
	@track show36InspectionForm = false;
	@track show111POintsCheck = false;
	@api mobileNumber = null;
	@track chassisNum;
	@api emailValue = null;
	@api oppList;
	@track oppListRF;
	@track oppListRT;
	@track vehListRT;
	@track vehListRF;
	@track leadSourceOpp;
	@track typeCustomer;
	@api selectedOpp;
	@track checkOutId;
	@track selectedButton;
	@track InsuranceCompanyTF;
	@track serviceDocNo;
	@track checkInHome;
	@track returnTab;
	@track theaccRecord = {};
	@track theretoppRecord = {};
	@track accPage;
	@track vehmileage;
	@track oppPage;
	// dynamic recordtypeID
	recordTypeId;
	@wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
	getobjectInfo(result) {
		if (result.data) {
			const rtis = result.data.recordTypeInfos;
			this.recordTypeId = Object.keys(rtis).find((rti) => rtis[rti].name === 'Automotive Service Center & Body Shop');
			console.log(this.recordTypeId)
		}
	}

	VehlistOfRequiredServicesOptions = [];
	VehlistOfRequiredServicesMap = [];

	PaymentMadeOptions = [];
	PaymentMadeMap = [];

	DiscountapplicableOptions = [];
	DiscountapplicableMap = [];

	VehicleMileageOptions = [];
	VehicleMileageMap = [];

	InsuranceCompanyOptions = [];
	InsuranceCompanyMap = [];


	// plate picklists

	PlateColorOptions = [];
	PlateColorMap = [];

	PlateTypeOptions = [];
	PlateTypeMap = [];

	PlateSourceOptions = [];
	PlateSourceMap = [];

	
	// new 
	PlateSurceInternal = [];
	PlateTypeInternal = [];
	PlatecolorInternal = [];

	get leadsourceoptions() {
        return [
            { label: 'Website', value: 'Website' },
            { label: 'Email', value: 'Email' },
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

	get typecustomeroptions() {
        return [
            { label: 'Walk-In', value: 'Walk-In' },
            { label: 'Insurance', value: 'Insurance' },
            { label: 'Booked Appointment', value: 'Booked Appointment' },
    
		];
    }
	get typeserviceoptions() {
        return [
            { label: 'Accident Repair', value: 'Accident Repair' },
            { label: 'Service on Demand', value: 'Service on Demand' },
            { label: 'Service Contract', value: 'Service Contract' },
			{ label: 'Campaign', value: 'Campaign' },
		];
    }

	connectedCallback() {

		this.loaded = true;
		LIST_OF_REQUIRED_SERVICE_FIELD({
            objObject: 'Opportunity',
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

		PAYMENTMODE_FIELD({
			objObject: 'Opportunity',
			fld: 'Payment_Made__c'
		})
			.then((result) => {
				result.forEach(item => this.PaymentMadeMap.push({ label: item, value: item }));
				this.PaymentMadeOptions = this.PaymentMadeMap.map(({ label: label, value: value }) => ({
					label,
					value,
				}));
			})
			.catch(error => {
				console.log(error)
			});

		DISCOUNTAPPLICABLE_FIELD({
			objObject: 'Opportunity',
			fld: 'Discount_applicable__c'
		})
			.then((result) => {
				result.forEach(item => this.DiscountapplicableMap.push({ label: item, value: item }));
				this.DiscountapplicableOptions = this.DiscountapplicableMap.map(({ label: label, value: value }) => ({
					label,
					value,
				}));
			})
			.catch(error => {
				console.log(error)
			});

		VEHICLEMILEAGE_FIELD({
			objObject: 'Opportunity',
			fld: 'Vehicle_Mileage__c'
		})
			.then((result) => {
				result.forEach(item => this.VehicleMileageMap.push({ label: item, value: item }));
				this.VehicleMileageOptions = this.VehicleMileageMap.map(({ label: label, value: value }) => ({
					label,
					value,
				}));
			})
			.catch(error => {
				console.log(error)
			});

		INSURANCE_COMPANY_FIELD({
			objObject: 'Opportunity',
			fld: 'Insurance_Company__c'
		})
			.then((result) => {
				result.forEach(item => this.InsuranceCompanyMap.push({ label: item, value: item }));
				this.InsuranceCompanyOptions = this.InsuranceCompanyMap.map(({ label: label, value: value }) => ({
					label,
					value,
				}));
			})
			.catch(error => {
				console.log(error)
			});



		// plate picklists
		getPicklistValues({
			objObject: 'Opportunity',
			fld: 'Plate_Color_Master__c'
		})
			.then((result) => {
				for (var key in result) {
					this.PlateColorOptions.push({ label: key, value: result[key] });
					this.PlatecolorInternal.push({ label: key, value: key });
				}
			})
			.catch(error => {
				console.log(error)
			});

		getPicklistValues({
			objObject: 'Opportunity',
			fld: 'Plate_Type_Master__c'
		})
			.then((result) => {
				for (var key in result) {
					this.PlateTypeOptions.push({ label: key, value: result[key] });
					this.PlateTypeInternal.push({ label: key, value: key });

				}
			})
			.catch(error => {
				console.log(error)
			});

		getPicklistValues({
			objObject: 'Opportunity',
			fld: 'Plate_Source_Master__c'
		})
			.then((result) => {
				for (var key in result) {
					this.PlateSourceOptions.push({ label: key, value: result[key] });
					this.PlateSurceInternal.push({ label: key, value: key });
				}
			})
			.catch(error => {
				console.log(error)
			});

			getPicklistValues({
				objObject: 'Opportunity',
				fld: 'Plate_Source_Master__c'
			})
				.then((result) => {
					for (var key in result) {
						this.PlateSourceOptions.push({ label: key, value: result[key] });
						this.PlateSurceInternal.push({ label: key, value: key });
						
					}
				})
				.catch(error => {
					console.log(error)
				});

				
		this.loaded = false;
	}


	handleClickAccidentRepair() {
		console.log('In Accident Repair ');
		this.theRecord.Type_of_Service__c = 'Accident Repair';
		this.AccidentRepair = true;
		this.ServiceonDemand = false;
		this.Campaign = false;
		this.showPage3 = false;
		this.InsuranceCompanyTF = this.selectedOpp.Insurance__c;

	}
	handleClickServiceContract() {
		//this.showVehReceivingForm = true;
		console.log('In Service Contract ');
		this.theRecord.Type_of_Service__c = 'Service Contract';
		this.showPage4 = true;
		console.log('showPage4>>>>>>>> ', this.showPage4);

		this.showPage3 = false;
		this.AccidentRepair = false;
		this.ServiceonDemand = false;
		this.Campaign = false;

	}
	handleClickServiceonDemand() {
		/* console.log(this.selectedOpp.List_of_Required_Services__c)
		this.listOfRequiredServices = Array.from(this.selectedOpp.List_of_Required_Services__c); */
		console.log('In Service on Demand ');
		this.theRecord.Type_of_Service__c = 'Service on Demand';
		this.ServiceonDemand = true;
		console.log('ServiceonDemand>>>>>>>> ', this.ServiceonDemand);
		this.AccidentRepair = false;
		this.Campaign = false;
		this.showPage3 = false;

	}

	handleClickCampaign() {
		console.log('In Campaign ');
		this.theRecord.Type_of_Service__c = 'Campaign';
		this.ServiceonDemand = false;
		this.AccidentRepair = false;
		this.Campaign = true;
		console.log('Campaign>>>>>>>> ', this.Campaign);
		this.showPage3 = false;

	}
	getCampaignRecordDetails(event) {
		this.vehCampaignRecordId = event.detail.Id;
	}
	
	getvehBrandRecordDetails(event) {
        let vehicleBrandDetail = event.detail;
        this.vehBrandRecordId = vehicleBrandDetail.Id;
        console.log('this.vehBrandRecordId>>>>>>>>>', this.vehBrandRecordId)
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
		console.log('this.vehModelRecordId>>>>>>>>>', this.vehModelRecordId)
    }
	
	SearchKeyHandler(event) {
        this.filterCondition = 'Vehicle_Brand__r.Id = \'' + this.vehBrandRecordId + '\'';
    }

	NextvehicleformHandelerAccidentRepair(event) {
		//this.showVehReceivingForm = true;
		console.log('In Accident Repair 2');
		this.theRecord.Type_of_Service__c = 'Accident Repair';
		this.showPage4 = true;
		this.showPage3 = false;
		this.ServiceonDemand = false;
		this.AccidentRepair = false;
		this.Campaign = false;

	}
	NextvehicleformHandelerServiceonDemand(event) {
		this.theRecord.Type_of_Service__c = 'Service on Demand';
		console.log('this.theRecord.Type_of_Service__c>>>', this.theRecord.Type_of_Service__c);
		// console.log('selectedOpp.Chassis_Number__c>>>>>>>> ', this.selectedOpp.Chassis_Number__c);
		// console.log('this.chassisNum>>>>>>>> ', this.chassisNum);
		// if(!this.selectedOpp.Chassis_Number__c)
		// {  
		// 	this.selectedOpp.Chassis_Number__c = this.chassisNum;
		// }
		
		//	this.showVehReceivingForm = true;
		this.showPage4 = true;
		this.showPage3 = false;
		this.ServiceonDemand = false;
		this.AccidentRepair = false;
		this.Campaign = false;

	}
	NextvehicleformHandelerCampaign(event) {
		//  this.showVehReceivingForm = true;
		console.log('In Campaign 2');
		this.theRecord.Type_of_Service__c = 'Campaign';
		this.showPage4 = true;
		this.showPage3 = false;
		this.ServiceonDemand = false;
		this.AccidentRepair = false;
		this.Campaign = false;

	}
	BackHandelerAccidentRepair(event) {
		this.showPage3 = true;
		this.ServiceonDemand = false;
		this.AccidentRepair = false;
		this.Campaign = false;

	}
	BackHandelerServiceonDemand(event) {
		this.showPage3 = true;
		this.ServiceonDemand = false;
		this.AccidentRepair = false;
		this.Campaign = false;

	}
	BackHandelerCampaign(event) {
		this.showPage3 = true;
		this.ServiceonDemand = false;
		this.AccidentRepair = false;
		this.Campaign = false;

	}
	getvehicleMasterRecordDetails(event) {
		this.vehMasterId = event.detail.Id;
		this.vehMasterName = event.detail.Name;
		console.log('Vname', this.vehMasterName);
	}
	getloopkupInternalNum(event) {

		if (event.target.checked) {
			this.selectedInternalNum = event.target.name;
			console.log(this.selectedInternalNum);
			this.checkboxValidation = true;
		}
	}
	@track make;
	@track model;
	@track year;
	CreateOppforInternalCheckIn(){
		console.log('this.theCheckIn>>>>>>>>', this.theCheckIn);
		if(this.theCheckIn.Vehicle_Mileage_number__c){
			if(this.theCheckIn.Workshop_Location__c){
				this.loaded = true;
				CreateOpportunityforInternalVehicle({
				
					vehMasterInternalNum: this.oppInternalNum,
					checkRec: this.theCheckIn,
				}).then(result => {
					this.loaded = false;

					console.log('CreateOpportunityforInternalVehicle', result)
					this.selectedOpp = result[0];
					this.showVehReceivingForm = true;
					this.showPage3 = false;
					this.showPage4 = false;
					this.InternalPage = false;
					if(this.selectedOpp.Vehicle_Brand__r.Name)
					{
						this.make = this.selectedOpp.Vehicle_Brand__r.Name;
					}
					if(this.selectedOpp.Vehicle_Brand__r.Name)
					{
						this.model = this.selectedOpp.Vehicle_Model__r.Name;
					}
					if(this.selectedOpp.Vehicle_Brand__r.Name)
					{
					this.year = this.selectedOpp.Vehicle_Model_Year__c;
					}
					/* this.updatedOppRecList = result;
					this.updatedOppRecList.forEach((item) => {
						let oppId = item.Id;
						if (item.Id == oppId) {
							this.updatedOppRec = item;
						}
					}); */

				})
				.catch(error => {
						// Handle the error response
						//alert(error)
					let errorMessage = 'An error occurred.';
					if (error.body && error.body.pageErrors && error.body.pageErrors.length > 0) {
						errorMessage = error.body.pageErrors[0].message;
					}
					this.dispatchEvent(new ShowToastEvent({
					title: 'Error!',
					message: errorMessage,
					variant: 'error'
					}));
					console.log(error)
					this.loaded = false;
					});
			}
			else{
				console.log('IN Else>>>>>>>>');
				this.dispatchEvent(new ShowToastEvent({
					title: 'Error',
					message: 'Please fill all the fields in the form',
					variant: 'error'
				}));
				
			}
		}
		else{
			console.log('IN Else>>>>>>>>');
			this.dispatchEvent(new ShowToastEvent({
				title: 'Error',
				message: 'Please fill all the fields in the form',
				variant: 'error'
			}));
		}
	}
	BacktoCheckInHome()
	{
		this.showHomePage = false;
		this.showTabHome = false;
		this.checkInHome = true;
		this.accPage =false;
		this.ExtRet = false;
	}
	BacktoHome()
	{
		this.showHomePage = false;
		this.showTabHome = false;
		this.checkInHome = false;
		this.accPage =false;
		this.ExtRet = false;
		this.returnTab = true;
	}
	BackCheckout()
	{
		this.showTabHome = true;
		this.showPage3 = false;
		this.showPage4 = false;
		this.InternalPage = false;
		this.PlateNumberPage = false;
		this.InternalNumberPage = false;
		this.checkoutback = false;
	}
	handleCheckInBtn()
	{
		this.checkInHome = true;
		this.showTabHome = false;
		this.checkIn = true;
		this.checkOut = false;
	}
	handleNewBtn()
	{
		this.showHomePage = true;
		this.checkInHome = false;
		this.returnTab = false;
		this.lastCheckIn = false;
	}
	handleBackBtnTable()
	{
		this.lastCheckIn = false;
		this.checkInHome = true;
	}
	handleReturnBtn()
	{
		this.returnTab = true;
		this.checkInHome = false;
		this.showHomePage = false;
	}
	handleExtrlBtn()
	{
		this.ExtRet = true;
		this.returnTab = false;
		this.checkInHome = false;
		this.showHomePage = false;
	}
	handleIntrlBtn()
	{
		this.ExtRet = true;
		this.returnTab = false;
		this.checkInHome = false;
		this.showHomePage = false;
	}
	InternalPagegoToHomeHandeler() {
		this.showTabHome = true;
		this.showPage3 = false;
		this.showPage4 = false;
		this.InternalPage = false;
		this.PlateNumberPage = false;
		this.InternalNumberPage = false;
	}
	InternalPageBackButtonHandeler() {
		this.showHomePage = false;
		this.checkInHome = true;
		this.showPage3 = false;
		this.showPage4 = false;
		this.InternalPage = false;
		this.PlateNumberPage = false;
		this.InternalNumberPage = false;

	}
	parseData;
	CheckoutforInternal()
	{
		if(this.theCheckIn.Vehicle_Mileage_number__c){
			if(this.theCheckIn.Workshop_Location__c){
		this.loaded = true;
		
		CreateCheckoutforInteral(
			{
				checkRec : this.theCheckIn
			
			}).then(result => {
			console.log('CreateCheckoutforInteral>>>>>>', result);
			
			this.parseData = JSON.parse(result);
			console.log('this.parseData.status>>>>>>', this.parseData.status);
			 if (this.parseData.Status == 'S') {
				
				this.selectedOpp = this.parseData.oppId;
				this.checkOutId = this.parseData.checkOutId;
				this.InternalPage = false;
				this.showVehReceivingForm = true;
				this.showPage3 = false;
				this.showPage4 = false;
				this.showNext = true;
				
				this.loaded = false;
			}
			else{
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'error',
						message: 'Checkout Record Not created',
						variant: 'error',
					}),
				);
				this.loaded = false;
			}

		}).catch(error => {
			console.log(error);
			alert(error)

		});
	}
	else{
		console.log('IN Else>>>>>>>>');
		this.dispatchEvent(new ShowToastEvent({
			title: 'Error',
			message: 'Please fill all the fields in the form',
			variant: 'error'
		}));
		
	}
}
else{
	console.log('IN Else>>>>>>>>');
	this.dispatchEvent(new ShowToastEvent({
		title: 'Error',
		message: 'Please fill all the fields in the form',
		variant: 'error'
	}));
}
	}

	@track workshopCode;
	@track workshopId;
	@track workshopName;
	@track isLocation = false;
	InternalPageNextButtonHandeler() {
		//	const checkboxValid = this.template.querySelector('[data-id="checkbox-Id"]');

		this.loaded = true;
		if (this.vehMasterName) {
			this.InternalNum = this.vehMasterName;
			this.oppInternalNum = this.vehMasterName;
		} else {
			this.InternalNum = this.selectedInternalNum;
			this.oppInternalNum = this.selectedInternalNum;
			if (this.checkboxValidation == false) {
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'warning',
						message: 'Please Select Internal Number',
						variant: 'warning',
					}),
				);
				this.loaded = false;

				return
			}
		}

		console.log('InternalNum>>>>>>', this.InternalNum);
		console.log('checkFor>>>>>>>>', this.checkFor);
		console.log('internalType>>>>>>>', this.internalType);
		//this.showNext = false;
		//this.loaded = false;
		getServiceReqInfo({

			internalNo: this.InternalNum,
			checkFor: this.checkFor,
			checkType: this.internalType,

		}).then(result => {
			console.log('getServiceReqInfo', result);
			let res = JSON.parse(result);
			if (res.Status === 'S') {
				if(this.internalType == 'CheckOut')
				{
					if (res.PreCheckOutInfo.DocNo) {

						console.log('oppInternalNum', this.oppInternalNum);
						this.serviceDocNo = res.PreCheckOutInfo.DocNo;
						this.theCheckIn.Service_Number__c = this.serviceDocNo;
						if(this.serviceDocNo){
							this.showNext = false;
							//this.PlateNumberPage = true;
							this.PlateNextButton = false;
							this.InternalNextButton = true;
						}
						this.loaded = false;
					} else {
						this.dispatchEvent(
							new ShowToastEvent({
								title: 'error',
								message: 'Documnet Number is not Created for this Internal Number',
								variant: 'error',
							}),
						);
						//this.CreateServiceReq = false;
						//this.disableNext = true;
						this.loaded = false;
						
					}
					
				}
				else
				{
					if (res.PreCheckInInfo.DocNo) {
						
						console.log('oppInternalNum', this.oppInternalNum);
						this.serviceDocNo = res.PreCheckInInfo.DocNo;
						this.theCheckIn.Service_Number__c = this.serviceDocNo;
						if(res.PreCheckInInfo.ServiceBranch)
						{
							this.isLocation = true;
							this.workshopCode = res.PreCheckInInfo.ServiceBranch;
							console.log('this.workshopCode>>>>>>>>', this.workshopCode)
							getWorkshopLocation({
								loc: this.workshopCode,
							}).then(result => {
								console.log('getLocation result>>>>>', result);
								if (result.length > 0) {
									this.workshopId = result[0].Id;
									this.workshopName = result[0].Name;
									console.log('this.workshopId>>>>>', this.workshopId);
									this.theCheckIn.Workshop_Location__c = this.workshopId;
									console.log('this.theCheckIn.Workshop_Location__c>>>>>', this.theCheckIn.Workshop_Location__c);
								}
							}).catch(error => {
								console.log(error)
							});
							//this.getLocation();
							//console.log('this.workshopId>>>>>', this.workshopId);
							//this.theCheckIn.Workshop_Location__c = this.workshopId;
							//console.log('this.theCheckIn.Workshop_Location__c>>>>>', this.theCheckIn.Workshop_Location__c);
							
						}
						else{
							this.isLocation = false;
						}
						if(this.serviceDocNo){
							this.showNext = false;
							//this.PlateNumberPage = true;
							this.PlateNextButton = false;
							this.InternalNextButton = true;
						}
						this.loaded = false;
					} else {
						this.dispatchEvent(
							new ShowToastEvent({
								title: 'error',
								message: 'Service Request is not Created for this Internal Number',
								variant: 'error',
							}),
						);
						//this.CreateServiceReq = false;
						//this.disableNext = true;
						this.loaded = false;
						
					}
				}
				

				//this.showVehReceivingForm = true;
				//this.InternalPage = false;
			} else if (res.Status === 'E') {
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'error',
						message: res.Message,
						variant: 'error',
					}),
				);
				this.loaded = false;
			}

		}).catch(error => {
			console.log(error);
			alert(error)

		});
	}

	/*getLocation() {
		console.log('this.workshopCode>>>>>>>>', this.workshopCode)
		getWorkshopLocation({
			loc: this.workshopCode,
		}).then(result => {
			console.log('getLocation result>>>>>', result);
			if (result.length > 0) {
				this.workshopId = result;
				console.log('this.workshopId>>>>>', this.workshopId);
				this.theCheckIn.Workshop_Location__c = this.workshopId;
				console.log('this.theCheckIn.Workshop_Location__c>>>>>', this.theCheckIn.Workshop_Location__c);
			}
		}).catch(error => {
			console.log(error)
		});
	}*/

	
	InternalNumberSearchBtnHandeler() {

		console.log('plateNumberSearchBtnHandeler', this.theRecord);
		getInternalNumber({
			PlateSource: this.theRecord.Plate_Source_Master__c,
			PlateCode: this.theRecord.Plate_Color_Master__c,
			plateNumber: this.theRecord.Vehicle_Plate_Number__c,
			PlateType: this.theRecord.Plate_Type_Master__c

		}).then(result => {
			console.log('getInternalNumber', result);
			if (result.length > 0) {
				this.InternalNumberResult = result;
				//console.log(result[0].Id)
				//console.log(result[0].Name)
				this.InternalNumberT = true;
				this.InternalNumberF = false;
				this.ShowNextPlate = false;
				this.checkFor = 'Maintenance';
			} else {
				this.InternalNumberF = true;
				this.InternalNumberT = false;
				this.ShowNextPlate = true;
			}
		}).catch(error => {
			//alert(error)
			let errorMessage = 'An error occurred.';
			if (error.body && error.body.pageErrors && error.body.pageErrors.length > 0) {
				errorMessage = error.body.pageErrors[0].message;
			}
			this.dispatchEvent(new ShowToastEvent({
				title: 'Error!',
				message: errorMessage,
				variant: 'error'
			}));
			this.loaded = false;
			console.log(error)
		});
	}
	updateOppinNext(){
		updateOpportunityRecord({ opportunityId: this.selectedOpp.Id, opportunityData: this.theRecord })
		.then(result => {
			
			console.log('result in update opp in next>>>>>' ,result)
			this.showVehReceivingForm = true;
			this.showPage3 = false;
			this.showPage4 = false;
			this.updatedOppRecList = result;
			this.updatedOppRecList.forEach((item) => {
				let oppId = item.Id;
				if (item.Id == oppId) {
					this.updatedOppRec = item;
				}
			});
			/* this.dispatchEvent(
				new ShowToastEvent({
					title: 'Success',
					message: 'Opportunity Record Updated Successfully ',
					variant: 'success',
				}),
			); */

			//this.goToHomeHandeler();
		})
		.catch(error => {
			// Handle the error response
			console.log('error in update opp in next>>>>>' , error);
			alert(error)
		});


}
	isFormValid = false;
	NextButtonHandeler(event) {
		const inputFields = this.template.querySelectorAll(`[data-id="valid-input"]`);
		let isValid = true;

		///validating All input fields--
		if (this.validationCheck !== true) {
			inputFields.forEach(field => {
				if (!field.value || field.value.trim() === "") {
					isValid = false;
					field.setCustomValidity('Please Complete this field');
					field.reportValidity();
					field.scrollIntoView({ behavior: 'smooth', block: 'center' });
				} else if (field.value) {
					field.setCustomValidity('');
					field.reportValidity();
				}
			});
			//
			/* //validating Appointment date field--
			if (this.leadforms == false) {
				const Appointment = this.template.querySelector('[data-id="Appointment-input"]');
				if (!Appointment.value || Appointment.value.trim() === "") {
					Appointment.setCustomValidity('Please Complete this field');
					Appointment.reportValidity();
					Appointment.scrollIntoView({ behavior: 'smooth', block: 'center' });
				}else if (Appointment.value) {
					Appointment.setCustomValidity('');
					Appointment.reportValidity();
				}
			}
			//
				*/
			//validating check boxes fields--
			console.log('this.validationCheck in next', this.validationCheck);
			const VehicleAvailable = this.template.querySelector('[data-id="Vehicle-Available"]');
			if (VehicleAvailable.checked == false) {
				isValid = false;
				this.GetCustomerandVehicleInfo = false;
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'error',
						message: 'Please create Vehicle before proceeding to next step',
						variant: 'error',
					}),
				);
				
			}
			//
			// if isFormValid-->vehiclereceivingform
			this.isFormValid = isValid;

			if (this.isFormValid) {
				if(this.selectedOpp.Vehicle_Mileage_number__c)
				{
					this.showVehReceivingForm = true;
					this.showPage3 = false;
					this.showPage4 = false;
				}
				else{
					this.updateOppinNext();
				}
				
			}
		}
		
		//
		///

		//validating only chassis number field--
		if (this.validationCheck == true) {
			inputFields.forEach(field => {
				if (field.name === "Chassis_Number__c" && (!field.value || field.value.trim() === "")) {
					isValid = false;
					field.setCustomValidity('Please Complete this field');
					field.reportValidity();
					field.scrollIntoView({ behavior: 'smooth', block: 'center' });
				} else if (field.name === "Chassis_Number__c" && field.value) {
					isValid = true;
					field.setCustomValidity('');
					field.reportValidity();
				}
				if (field.name != "Chassis_Number__c") {
					field.setCustomValidity('');
					field.reportValidity();
				}
			});
			this.isFormValid = isValid;
			this.validationCheck = false;
		}
		//

	}
	BackButtonHandeler(event) {
		this.showHomePage = false;
		this.showSearchPage = false;
		this.showPage4 = false;
		this.showPage3 = true;

	}
	
	handleCheckInHandler(event){
		const value = event.target.value;
		const checkboxvalue = event.target.checked;
		const fieldName = event.target.name;
		
		this.theCheckIn[fieldName] = value;
		console.log('this.theCheckIn.Vehicle_Mileage_number__c>>>>',this.theCheckIn.Vehicle_Mileage_number__c);
		console.log('fieldName>>>',fieldName);
		if (fieldName == 'Check_In_For__c') {
			this.checkFor = this.theCheckIn.Check_In_For__c;
			console.log('this.checkFor>>>>',this.checkFor);
		}
		else if(fieldName == 'Check_Out_For__c')
		{
			this.checkFor = this.theCheckIn.Check_Out_For__c;
			console.log('this.checkFor>>>>',this.checkFor);
		} 
		else{
			console.log('theCheckIn Field>>>>>>>', fieldName);
			this.theCheckIn[fieldName] = value;

		}
	}

	handleBtnClickAppointment(event) {
		this.theRecord.Type_of_Customer__c = 'Booked Appointment';
		console.log('Booked Appointment>>>>>>>');
		let data = event.target.label;
		this.showHomePage = false;
		this.showSearchPage = true;
		this.leadforms = false;
		this.selectedButton = "Appointment";
	}
	handleBtnClickWalkIn(event) {
		this.theRecord.Type_of_Customer__c = 'Walk-In';
		console.log('Walk-In>>>>>>>');
		let data = event.target.label;
		this.showHomePage = false;
		this.showVehLeadForm = true;
		this.selectedButton = "walk-in";
		this.leadforms = true;
	}
	handleBtnClickInsurance(event) {
		this.theRecord.Type_of_Customer__c = 'Insurance';
		this.theRecord.Type_of_Service__c = 'Accident Repair';
		console.log('Insurance>>>>>>>');
		console.log('Insurance Type of Service__c>>>>>>>', this.theRecord.Type_of_Service__c);
		let data = event.target.label;
		this.showHomePage = false;
		this.showVehLeadForm = true;
		this.selectedButton = "Insurance";
		this.leadforms = true;
		this.InsuranceCompanyField = true;
	}
	handleBtnClickInternal(event) {
		this.theRecord.Type_of_Customer__c = 'Internal';
		console.log('Internal>>>>>>>');
		let data = event.target.label;
		this.showHomePage = false;
		//this.InternalPage = true;
		this.showInternalPage = true;
		this.selectedButton = "Internal";
		//this.showVehLeadForm = true;
		//this.leadforms=true;
	}
	@track internalType;
	@track checkInNextBtn;
	@track checkOutNextBtn;
	@track showCheckInPage;
	handleBtnClickInternalCheckIn(event) {
		this.showHomePage = false;
		this.returnTab = false;
		this.internalType = 'CheckIn';
		this.checkIn = true;
		this.checkOut = false;
		this.showCheckInPage = true;
		this.checkInForm = true;
		this.checkOutForm = false;
		this.checkInNextBtn = true;
		this.checkOutNextBtn = false;
		console.log('Internal Type>>>>>>>', this.internalType);
		let data = event.target.label;
		this.showInternalPage = false;
		this.InternalPage = true;
		this.selectedButton = "Internal";
		this.showNext = true;
		this.InternalNumberT = false;
		//this.showVehLeadForm = true;
		//this.leadforms=true;
	}
	@track checkoutback =false;
	handleBtnClickInternalCheckOut(event) {
		this.internalType = 'CheckOut';
		this.checkIn = false;
		this.checkOut = true;
		this.checkInForm = false;
		this.checkOutForm = true;
		this.checkInNextBtn = false;
		this.checkOutNextBtn = true;
		this.checkoutback = true;
		console.log('Internal Type>>>>>>>', this.internalType);
		let data = event.target.label;
		this.showInternalPage = false;
		this.showTabHome = false;
		this.InternalPage = true;
		this.selectedButton = "Internal";
		this.showNext = true;
		this.InternalNumberT = false;
		
		//this.showVehLeadForm = true;
		//this.leadforms=true;
	}
	handleTypeChange(event) {
		this.selectedType = event.target.value;
	}
	handleMobileChange(event) {
		this.leadEmail = event.target.value;
	}
	handleChassisChange(event) {
		this.chassisNum = event.target.value;
	}
	backHome()
	{
		this.checkInHome = false;
		this.showTabHome = true;
	}
	goToHomeCustomer()
	{
		this.returnTab = false;
		this.checkInHome = true;
	}

	goToHomeHandeler(event) {
		this.showHomePage = true;
		this.returnTab = false;
 		this.showSearchPage = false;
		this.showPage3 = false;
		this.showPage4 = false;
		this.ServiceonDemand = false;
		this.AccidentRepair = false;
		this.Campaign = false;
		this.showVehReceivingForm = false;

	}

	InternalNumberT;
	InternalNumberF;
	InternalNumberResult;
	selectedInternalNum;


	onINNUMClick(event) {
		let InternalNum = event.currentTarget.dataset.recordid;

		console.log(InternalNum);
		this.InternalNumberResult.forEach((item) => {
			if (item.Id == InternalNum) {
				this.selectedInternalNum = item;
			}
		});
		console.log(this.selectedInternalNum);
	}

	@track retAccId = '';
	@track retVehId = '';
	@track accFirstName = '';
	@track accLastName = '';
	@track accName = '';
	@track accPhone = '';
	@track accEmail = '';
	@track nameAcc = '';
	
	searchChassisBtnHandeler(event) {
		this.loaded = true;
		console.log('Chassis Number>>>>>>>>>>', this.chassisNum);
		getVehicle({
			chasNum: this.chassisNum,
		}).then(result => {
			console.log('getVehicle result>>>>>>>', result)
			

			if (result.length > 0) {
				console.log('Account_Id__c>>>', result[0].Account_Id__c);
				//amanReceiptconsole.log('Account Id>>>', result[0].Account_Id__r.Id);
				console.log('Vehicle Id>>>', result[0].Id);
				this.vehList = result;
				this.vehListRT = true;
				this.vehListRF = false;
				this.retAccId = result[0].Account_Id__c;
				if(this.retAccId)
				{
					// if(result[0].Account_Id__r.Name)
					// {
					// 	this.accName = result[0].Account_Id__r.Name;
					// 	this.nameAcc = true;
					// }
					// else
					// {
						
						if(result[0].Account_Id__r.FirstName)
						this.accFirstName = result[0].Account_Id__r.FirstName;
						if(result[0].Account_Id__r.LastName)
						this.accLastName = result[0].Account_Id__r.LastName;
					// }
					
					if(result[0].Account_Id__r.PersonMobilePhone)
						this.accPhone = result[0].Account_Id__r.PersonMobilePhone;
					if(result[0].Account_Id__r.PersonEmail)
						this.accEmail = result[0].Account_Id__r.PersonEmail;
				}
				this.retVehId = result[0].Id;
				this.loaded = false;
			}
			else{
				this.vehListRT = false;
				this.vehListRF = true;
				this.loaded = false;
			}
		}).catch(error => {
			console.log(error)
		});
	}
	@track lastCheckIn;
	handleBtnLastCheckIn()
	{
		this.lastCheckIn = true;
		this.showHomePage = false;
		this.checkInHome = false;
	}

	@track leadEmail;
	searchleadHandeler() {
		console.log('this.leadEmail>>>>>>>>', this.leadEmail)
		getLeads({
			mail: this.leadEmail,
		}).then(result => {
			console.log('getLeads', result)
			console.log('getLeads', result[0])
			if (result.length > 0) {
				this.oppList = result;
				this.oppListRT = true;
				this.oppListRF = false;
			} else {
				this.oppListRF = true;
				this.oppListRT = false;
			}
		}).catch(error => {
			console.log(error)
		});
	}

	searchBtnHandeler(event) {

		if (this.currentTarget) {
			this.mobileNumber = this.selectedOpp.Account.PersonMobilePhone;
		}
		console.log(this.selectedType + '--' + this.mobileNumber)
		getOpportunities({
			MobNum: this.mobileNumber,
		}).then(result => {
			console.log('getOpportunities', result)

			if (result.length > 0) {
				this.oppList = result;
				this.oppListRT = true;
				this.oppListRF = false;

				///integration
				if (this.currentTarget) {
					console.log('(this.currentTarget')
					let selectedOppId = this.currentTarget;
					this.oppList.forEach((item) => {
						if (item.Id == selectedOppId) {
							this.selectedOpp = item;
							console.log("selected oppId searchhandler", this.selectedOpp)
							console.log("selected acc no in searchhandler", this.selectedOpp.Account.AccountNumber)
							console.log("selected Vehicle_Internal_Number__c no", this.selectedOpp.Vehicle_Internal_Number__c)

						}
					});

					if (this.selectedOpp.Account.AccountNumber) {
						this.AccountNumberInERP = true;
					} else if (!this.selectedOpp.Account.AccountNumber) {
						this.AccountNumberInERP = false;
					}
					if (this.selectedOpp.Vehicle_Internal_Number__c) {
						this.PrivateVehicle = true;
					} else if (!this.selectedOpp.Vehicle_Internal_Number__c) {
						this.PrivateVehicle = false;
					}
					if (this.selectedOpp.Account.AccountNumber) {
						if(this.selectedOpp.Vehicle_Internal_Number__c)
						{
							this.GetCustomerandVehicleInfo = true;
						}
						
					}
					this.loaded = false;

				}
			} else {
				this.oppListRF = true;
				this.oppListRT = false;
			}
		}).catch(error => {
			console.log(error)
		});



	}




	onvehClick(event)
	{
		this.checkInHome = false;
		this.ExtRet = false;
		this.accPage = true;
	}

	backbtnOpp()
	{
		this.accPage = true;
		this.oppPage = false;
	}

	newCustomerHandler()
	{
		this.checkInHome = false;
		this.showHomePage = true;
		this.ExtRet = false;
		//this.selectedOpp.Chassis_Number__c = this.chassisNum;
	}

	handleAccInputChangeFName(event) {
        console.log('event.target.value>>>>>' + event.target.value)
        this.accFirstName = event.target.value;
		
		console.log('this.accFirstName', this.theaccRecord[event.target.name]);
    }

	handleAccInputChangeFName(event) {
        console.log('event.target.value>>>>>' + event.target.value)
        this.accFirstName = event.target.value;
		
		console.log('this.accFirstName', this.accFirstName);
    }
	handleAccInputChangeLName(event) {
        console.log('event.target.value>>>>>' + event.target.value)
        this.accLastName = event.target.value;
		
		console.log('this.accLastName', this.accLastName);
    }
	handleAccInputChangePhone(event) {
        console.log('event.target.value>>>>>' + event.target.value)
        this.accPhone = event.target.value;
		
		console.log('this.accPhone', this.accPhone);
    }
	handleAccInputChangeEmail(event) {
        console.log('event.target.value>>>>>' + event.target.value)
        this.accEmail = event.target.value;
		
		console.log('this.accEmail', this.accEmail);
    }
	handleRetOppChange(event) {
        console.log('event.target.value>>>>>' + event.target.value)
        this.theretoppRecord[event.target.name] = event.target.value;
		
    }

	UpdateAccountHandler()
	{
		this.loaded = true;
		this.theaccRecord['Id'] = this.retAccId;
		this.theaccRecord['FirstName'] = this.accFirstName;
		this.theaccRecord['LastName'] = this.accLastName;
		this.theaccRecord['PersonMobilePhone'] = this.accPhone;
		this.theaccRecord['PersonEmail'] = this.accEmail;
		console.log('theaccRecord>>>>>>>>', this.theaccRecord);
		console.log('this.theaccRecord.FirstName>>>>>>>>', this.theaccRecord.FirstName);
		if (this.theaccRecord) {
            if (!this.theaccRecord.PersonMobilePhone || !this.theaccRecord.PersonEmail) {
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'error',
						message: 'Please fill all the fields',
						variant: 'error',
					}),
				);
             this.loaded = false;

			}else{
				console.log('In Else of what>>>>>>>>');
				console.log('this.retVehId>>>>>>>>>', this.retVehId);
                console.log('this.theaccRecord>>>>>>', this.theaccRecord);
                saveAccountRecord({
					vehicleId: this.retVehId,
					accFormRecord: this.theaccRecord })
                    .then((result) => {
                        console.log('Record saved with ID:', result);
						this.accPage = false;
						this.oppPage = true;
						this.loaded = false;
                    })
                    .catch(error => {
                        console.log(error);
						this.dispatchEvent(
							new ShowToastEvent({
								title: 'error',
								message: error,
								variant: 'error',
							}),
						);
						this.loaded = false;
                    });
            }
        }

	}

	ReturnOppHandler(){
		this.loaded = true;
		this.theretoppRecord["CampaignId"] = this.vehCampaignRecordId;
        this.theretoppRecord["Workshop_Location__c"] = this.workshopLocationRecId;
		console.log('theretoppRecord>>>>>>>>', this.theretoppRecord);
		//console.log('this.theretoppRecord.List_of_Required_Services__c>>>>>>>>', this.theretoppRecord.List_of_Required_Services__c);
		if (this.theretoppRecord) {
            if (!this.theretoppRecord.LeadSource || !this.theretoppRecord.Type_of_Customer__c || !this.theretoppRecord.Type_of_Service__c|| !this.theretoppRecord.Workshop_Location__c || !this.theretoppRecord.Description_for_Service_Request__c || !this.theretoppRecord.Vehicle_Mileage_number__c) {
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'error',
						message: 'Please fill all the fields',
						variant: 'error',
					}),
				);
             this.loaded = false;

			}else{
                
                console.log('All fields are >>>>>>', this.theretoppRecord);
                CreateOpportunityReturn({
					vehicleId: this.retVehId,
					RetOpp: this.theretoppRecord })
                    .then((result) => {
                        console.log('Record saved with ID:', result[0].Id);

						this.selectedOpp = result[0];
						console.log('this.selectedOpp>>>>>>>>', this.selectedOpp);
						console.log('this.selectedOpp>>>>>>>>', this.selectedOpp.Account.AccountNumber);
						if (this.selectedOpp.Account.AccountNumber) {
							this.AccountNumberInERP = true;
						} else if (!this.selectedOpp.Account.AccountNumber) {
							this.AccountNumberInERP = false;
							this.GetCustomerandVehicleInfo = false;
		
						}
						if (this.selectedOpp.Vehicle_Internal_Number__c) {
							this.PrivateVehicle = true;
						} else if (!this.selectedOpp.Vehicle_Internal_Number__c) {
							this.PrivateVehicle = false;
							this.GetCustomerandVehicleInfo = false;
		
		
						}
						if (this.selectedOpp.Account.AccountNumber && this.selectedOpp.Vehicle_Internal_Number__c) {
							this.GetCustomerandVehicleInfo = true;
						}
						this.showVehReceivingForm = true;
						this.oppPage = false;
						this.loaded = false;
                    })
                    .catch(error => {
                        console.log(error);
						this.dispatchEvent(
							new ShowToastEvent({
								title: 'error',
								message: error,
								variant: 'error',
							}),
						);
						this.loaded = false;
                    });
            }
        }

	}


	onOppClick(event) {
		this.loaded = true;
		let leadId = [];
		console.log('Lead Id>>>>>>>', event.currentTarget.dataset.recordid);
        leadId = event.currentTarget.dataset.recordid; //this.oppList[0].Id;
        console.log('leadId>>>>>>>>>',leadId);
        convertLead({ leadId })
            .then(result => {
                this.oppRec = result;
				console.log('Opp Id>>>>>>>>>>', this.oppRec);
		//let oppId = event.currentTarget.dataset.recordid;
		this.showSearchPage = false;

		if (this.selectedType == 'Vehicle Receiving') {
			//this.showVehReceivingForm = true;
			this.showPage3 = true;

		}
		//this.oppList.forEach((item) => {
			//if (item.Id == oppId) {
				this.selectedOpp = this.oppRec[0];
				console.log("onOppClick selected", this.selectedOpp)
				console.log("onOppClick selected acc no", this.selectedOpp.Account.AccountNumber)
				console.log("onOppClick selected Vehicle_Internal_Number__c no", this.selectedOpp.Vehicle_Internal_Number__c)

				///Integration
				/*if (this.selectedOpp.Account.AccountNumber) {
					this.AccountNumberInERP = true ;
				} else if (!this.selectedOpp.Account.AccountNumber) {
					this.AccountNumberInERP = false;
					this.GetCustomerandVehicleInfo = false;

				}
				if (this.selectedOpp.Vehicle_Internal_Number__c) {
					this.PrivateVehicle = true;
				} else if (!this.selectedOpp.Vehicle_Internal_Number__c) {
					this.PrivateVehicle = false;
					this.GetCustomerandVehicleInfo = false;


				}
				if (this.selectedOpp.Account.AccountNumber && this.selectedOpp.Vehicle_Internal_Number__c) {
					this.GetCustomerandVehicleInfo = true;
				}*/
				///
			//}

		//});

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
		
		console.log(oppList)
	}
	eventHanlderAppointment(event) {
        const oppRec = this.oppRec;
        const leadEvent = new CustomEvent("eventleadforms", {
            detail: { oppRec }
        });
        this.dispatchEvent(leadEvent);
    }
	handleListSerivce(event)
	{
		this.listOfRequiredServices = event.detail.value;
		console.log('List of Service>>>>>>>>>', this.listOfRequiredServices);
		this.theretoppRecord.List_of_Required_Services__c = this.listOfRequiredServices.join(';');
		console.log('List _selected>>>>>>>>>', this.theretoppRecord.List_of_Required_Services__c);
			
	}


	handleFormInputChange(event) {

		// Past Date Not Accept Validation
		/* let selectedDate = new Date(event.target.value);
		let currentDate = new Date();
		if (selectedDate!='' && selectedDate < currentDate) {
				event.target.value = ''; // Clear the input value
				const toastEvent = new ShowToastEvent({
				  title: 'Warning',
				  message: 'Past dates are not allowed.',
				  variant: 'warning'
				});
				this.dispatchEvent(toastEvent);
			console.log('after:'+event.target.value);
	   } */
		//

		const value = event.target.value;
		const checkboxvalue = event.target.checked;
		const fieldName = event.target.name;
		
		if (fieldName == 'Insurance__c') {
			this.theRecord[fieldName] = checkboxvalue;
			this.InsuranceCompanyTF = checkboxvalue;
		} else {

			this.theRecord[fieldName] = value;
		}
	}



	backButtonClickHandler(event) {
		console.log(this.selectedButton)
		if (this.selectedButton == "walk-in") {
			this.showVehReceivingForm = false;
			this.showPage4 = true;
		} else if (this.selectedButton == "Insurance") {
			this.showVehReceivingForm = false;
			this.showPage4 = true;
		} else if (this.selectedButton == "Internal") {
			this.showVehReceivingForm = false;
			this.showPage4 = false;
			this.showPage3 = false;
			this.InternalPage = true;
		} else if (this.selectedButton == "Appointment") {
			this.showVehReceivingForm = false;
			this.showPage4 = true;
		}


	}
	isFormUpdated = false;
	updateOpportunity(event) {
		console.log(this.selectedOpp.Id)
		this.theRecord.CampaignId = this.vehCampaignRecordId;
		console.log('this.theRecord',this.theRecord)
		updateOpportunityRecord({ opportunityId: this.selectedOpp.Id, opportunityData: this.theRecord })
			.then(result => {
				this.isFormUpdated = true;
				if (this.recallingMethod == 'AccountERPHandler') {
					this.AccountERPHandler();
				}
				if (this.recallingMethod == 'CreateVehicleHandler') {
					this.CreateVehicleHandler();
				}
				console.log(result)
				this.updatedOppRecList = result;
				this.updatedOppRecList.forEach((item) => {
					let oppId = item.Id;
					if (item.Id == oppId) {
						this.updatedOppRec = item;
					}
				});
				/* this.dispatchEvent(
					new ShowToastEvent({
						title: 'Success',
						message: 'Opportunity Record Updated Successfully ',
						variant: 'success',
					}),
				); */

				//this.goToHomeHandeler();
			})
			.catch(error => {
				// Handle the error response
				alert(error)
			});
	}
	eventHandlerLeadForms(event) {
		this.showVehLeadForm = false;
		this.oppList = event.detail.oppRec;
		this.oppList.forEach((item) => {
			let oppId = item.Id;
			if (item.Id == oppId) {
				this.selectedOpp = item;
			}
		});
		this.currentTarget = this.selectedOpp.Id;
		this.searchBtnHandeler(this.currentTarget);
		if (this.selectedButton == "Insurance") {
			this.showPage3 = false;
			this.showPage4 = true;
			this.InternalPage = false;

		}/* else if(this.selectedButton == "Internal") {
			this.showPage3 = false;
			this.showPage4 = false;
			this.InternalPage = true;
		} */else {
			this.showPage3 = true;
			this.showPage4 = false;
			this.InternalPage = false;

		}
	}
	backButtonClickHandlerwalkin(event) {
		this.showHomePage = true;
		this.showVehLeadForm = false;
		this.showSearchPage = false;

	}

	// integration 


	AccountERPHandler() {
		this.loaded = true;
		if (!this.isFormUpdated) {
			this.recallingMethod = 'AccountERPHandler';
			this.updateOpportunity(this.recallingMethod);

		}
		if (this.isFormUpdated) {
			console.log(this.selectedOpp.Account.Id)
			console.log(this.selectedOpp.Id)
			CreateAccountinERP({ accID: this.selectedOpp.Account.Id, OppId: this.selectedOpp.Id })
				.then(() => {
					this.currentTarget = this.selectedOpp.Id;
					this.searchBtnHandeler(this.currentTarget);
					this.dispatchEvent(
						new ShowToastEvent({
							title: 'Success',
							message: 'Account in ERP Created Successfully ',
							variant: 'success',
						}),
					);
					this.CreateAccountinERP = true;
					this.loaded = false;
				})
				.catch(error => {
					this.CreateAccountinERP = false;
					// Handle the error response
					this.loaded = false;

					alert(error)
				});




		}


	}

	GetVehicleDetailsHandler() {
		this.validationCheck = true;
		this.NextButtonHandeler(this.validationCheck);
		if (this.isFormValid) {
			this.loaded = true;
			if (this.theRecord.Chassis_Number__c && this.theRecord.Chassis_Number__c !== 'undefined' || this.theRecord.Chassis_Number__c == '') {
				this.ChassiNo = this.theRecord.Chassis_Number__c;
			} else {
				
				this.ChassiNo = this.selectedOpp.Chassis_Number__c;
			}
			console.log('ChassisNumber', this.ChassiNo)
			console.log('recordId', this.selectedOpp.Id)

			GetVehicleDetails({ ChassisNumber: this.ChassiNo, recordId: this.selectedOpp.Id })
				.then(result => {
					this.currentTarget = this.selectedOpp.Id;
					this.searchBtnHandeler(this.currentTarget);
					console.log('result', result)
					if (result == 'No Vehicle') {
						this.dispatchEvent(
							new ShowToastEvent({
								title: 'error',
								message: 'No vehicle is found with given chassis number',
								variant: 'error',
							}),
						);
						this.CreatePrivateVehicle = false;
						this.CreateAccountinERP = false;
					} else if (result == 'Private Vehicle is created successfully in ERP') {
						this.dispatchEvent(
							new ShowToastEvent({
								title: 'Success',
								message: 'Vehicle is found and updated back in CRM',
								variant: 'success',
							}),
						);
						this.CreatePrivateVehicle = true;
						this.CreateAccountinERP = true;
					} else if (result == 'Private Vehicle is created successfully in ERP--No Account') {
						this.dispatchEvent(
							new ShowToastEvent({
								title: '',
								message: 'Private Vehicle is created successfully in ERP--No Account Created',
								variant: 'warning',
							}),
						);
						this.CreatePrivateVehicle = true;
						this.CreateAccountinERP = false;
					}
					
				})
				.catch(error => {
					// Handle the error response
					this.loaded = false;

					alert(error)
					console.log(error)
				});
		}

	}
	@track workshopLocationRecId;
	getWorkshopRecordDetails(event) {
        this.workshopLocationRecId = event.detail.Id;
        console.log('this.workshopLocationRecId>>>>>' , this.workshopLocationRecId);

		this.theCheckIn.Workshop_Location__c = this.workshopLocationRecId;
		console.log('this.theCheckIn.Workshop_Location__c>>>>>' , this.theCheckIn.Workshop_Location__c);
    }

	CreateVehicleHandler() {
		this.loaded = true;
		if (!this.isFormUpdated) {
			this.recallingMethod = 'CreateVehicleHandler';
			this.updateOpportunity(this.recallingMethod);
		}
		if (this.isFormUpdated) {
			console.log('CreateVehicleHandlerid', this.selectedOpp.Id)
			console.log('CreateVehicleHandleraccnumber', this.selectedOpp.Account.AccountNumber)


			CreateVehicle({ AccNumber: this.selectedOpp.Account.AccountNumber, OppId: this.selectedOpp.Id })
				.then(() => {
					this.currentTarget = this.selectedOpp.Id;
					this.searchBtnHandeler(this.currentTarget);
					this.dispatchEvent(
						new ShowToastEvent({
							title: 'Success',
							message: 'Vehicle has been created successfully ',
							variant: 'success',
						}),
					);
					this.CreatePrivateVehicle = true;
					this.loaded = false;
				})
				.catch(error => {
					this.loaded = false;
					this.dispatchEvent(
						new ShowToastEvent({
							title: 'error',
							message: 'Check with system administrator',
							variant: 'error',
						}),
					);
					this.CreatePrivateVehicle = false;
					// Handle the error response
					//alert(error) 
				});

		}
	}




















}
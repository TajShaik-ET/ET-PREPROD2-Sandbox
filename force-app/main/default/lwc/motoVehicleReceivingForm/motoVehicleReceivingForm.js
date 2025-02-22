import { LightningElement, api, track, wire } from 'lwc';
import vehRecInfoSaveHandler from '@salesforce/apex/MOTO_VehInspectionCtrl.vehicleReceivingformSaveHandler';
import checkoutRecSaveHandler from '@salesforce/apex/MOTO_VehInspectionCtrl.checkoutRecFormSaveHandler';
import createServiceRequest from '@salesforce/apex/MOTO_VehInspectionCtrl.createServiceRequest';
import createCheckIn from '@salesforce/apex/MOTO_VehInspectionCtrl.createCheckIn';
import createCheckInERP from '@salesforce/apex/MOTO_VehInspectionCtrl.createCheckInERP';
import createCheckOutERP from '@salesforce/apex/MOTO_VehInspectionCtrl.createCheckOutERP';
//import getCheckInResp from '@salesforce/apex/MOTO_VehInspectionCtrl.getCheckInResp';
import imageResource from '@salesforce/resourceUrl/carIMG_LWC';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { getPicklistValues , getObjectInfo } from 'lightning/uiObjectInfoApi';
import getPicklistValues from '@salesforce/apex/MOTO_VehInspectionCtrl.getPicklistValues';
import VEHREC_OBJECT from '@salesforce/schema/Vehicle_Receiving_Info__c';
import VEHREC_FUEL_FIELD from '@salesforce/schema/Vehicle_Receiving_Info__c.Check_in_Fuel_Reading__c';
import LWCImages from "@salesforce/resourceUrl/LWCImages";
import CICOImages from "@salesforce/resourceUrl/CICO_Diagrams";
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';



let canvasElement, ctx,cts,SigcanvasElement,Sigimg, flag = false, dot_flag = false, prevX = 0,
	currX = 0, prevY = 0,
	currY = 0, x = "red", y = 2, w, h, img, signx="blue";
let storageArray = [];
let cStep = 0;
let SigcStep = 0;
let attachment; //holds attachment information after saving the sigture on canvas
let dataURL, convertedDataURI; //holds image data

export default class MotoVehicleReceivingForm extends LightningElement {
	ETimage_uploadImage = LWCImages + '/LWC-Images/ETimage_upload.png';
	//spinner
	loaded;
	Tloaded = true;
	Floaded = false;
	@track hasRendered = true;
	//cavas
	@api recordId;
	constructor() {
		super();

	}
	@track selectedJob = '';
	isLoadedFully = false;

	get assetOption()
	{
		return [
            { label: 'Ambulance', value: 'Ambulance' },
			{ label: 'Bus', value: 'Bus' },
			{ label: 'Car', value: 'Car' },
			{ label: 'Car-SUV', value: 'Car-SUV' },
			{ label: 'Electric-Car', value: 'Electric-Car' },
			{ label: 'Forklift', value: 'Forklift' },
			{ label: 'Freezer', value: 'Freezer' },
			{ label: 'Mini-Bus', value: 'Mini-Bus' },
			{ label: 'Motorcycle', value: 'Motorcycle' },
			{ label: 'Pickup', value: 'Pickup' },
			{ label: 'Tanker', value: 'Tanker' },
			{ label: 'Trailor', value: 'Trailor' },
		];
	}

	get picklistOptions() {
        return [
            { label: '0', value: '0' },
            { label: '5', value: '5' },
            { label: '10', value: '10' },
            { label: '15', value: '15' },
            { label: '20', value: '20' },
            { label: '25', value: '25' },
            { label: '30', value: '30' },
            { label: '35', value: '35' },
            { label: '40', value: '40' },
            { label: '45', value: '45' },
            { label: '50', value: '50' },
            { label: '55', value: '55' },
            { label: '60', value: '60' },
            { label: '65', value: '65' },
            { label: '70', value: '70' },
            { label: '75', value: '75' },
            { label: '80', value: '80' },
            { label: '85', value: '85' },
            { label: '90', value: '90' },
            { label: '95', value: '95' },
            { label: '100', value: '100' },
           

        ];
    }

	@track hasRendered = true;
	renderedCallback() {
		
		console.log('this.CICOImage Start>>>>>>>>', this.CICOImage);
		
		Promise.all([
			loadStyle(this, LWCImages + '/LWC-Images/css/ETExternalStyle.css')

		])
			.then(() => {
				console.log("All scripts and CSS are loaded. perform any initialization function.")
			})
			.catch(error => {
				console.log("failed to load the scripts");
			});

		if (this.hasRendered) {
			
			let canvasQuery = this.template.querySelector('[data-id="canvasDia"]');
			canvasQuery.addEventListener('mousemove', (e) => { this.searchCoordinatesForEvent('move', e) });
			canvasQuery.addEventListener('mousedown', (e) => { this.searchCoordinatesForEvent('down', e) });
			canvasQuery.addEventListener('mouseup', (e) => { this.searchCoordinatesForEvent('up', e) });
			canvasQuery.addEventListener('mouseout', (e) => { this.searchCoordinatesForEvent('out', e) });

			canvasQuery.addEventListener('touchstart', (e) => {

				var touch = e.touches[0];
				var mouseEvent = new MouseEvent("mousedown", {
					clientX: touch.clientX,
					clientY: touch.clientY
				});
				canvasQuery.dispatchEvent(mouseEvent);
				e.preventDefault();
			});
			canvasQuery.addEventListener('touchend', (e) => {

				this.searchCoordinatesForEvent('up', e)
			});
			canvasQuery.addEventListener('touchmove', (e) => {

				var touch = e.touches[0];
				var mouseEvent = new MouseEvent("mousemove", {
					clientX: touch.clientX,
					clientY: touch.clientY
				});
				canvasQuery.dispatchEvent(mouseEvent);
				e.preventDefault();
			});

			
			canvasElement = canvasQuery;
			ctx = canvasElement.getContext("2d");
			img = new Image();
			console.log('this.CICOImage IMG>>>>>>>>', this.CICOImage);
			img.src = this.CICOImage; //+'/images/Bus.jpg'; //imageResource;
			img.onload = () => {
				ctx.drawImage(img, 0, 0, canvasElement.width, canvasElement.height);
			}

			///signature-Capture
			let SigcanvasQuery = this.template.querySelector('[data-id="canvasSig"]');
			if(SigcanvasQuery){
			SigcanvasQuery.addEventListener('mousemove', (e) => { this.SigsearchCoordinatesForEvent('move', e) });
			SigcanvasQuery.addEventListener('mousedown', (e) => { this.SigsearchCoordinatesForEvent('down', e) });
			SigcanvasQuery.addEventListener('mouseup', (e) => { this.SigsearchCoordinatesForEvent('up', e) });
			SigcanvasQuery.addEventListener('mouseout', (e) => { this.SigsearchCoordinatesForEvent('out', e) });

			SigcanvasQuery.addEventListener('touchstart', (e) => {

				var touch = e.touches[0];
				var mouseEvent = new MouseEvent("mousedown", {
					clientX: touch.clientX,
					clientY: touch.clientY
				});
				SigcanvasQuery.dispatchEvent(mouseEvent);
				e.preventDefault();
			});
			SigcanvasQuery.addEventListener('touchend', (e) => {

				this.SigsearchCoordinatesForEvent('up', e)
			});
			SigcanvasQuery.addEventListener('touchmove', (e) => {

				var touch = e.touches[0];
				var mouseEvent = new MouseEvent("mousemove", {
					clientX: touch.clientX,
					clientY: touch.clientY
				});
				SigcanvasQuery.dispatchEvent(mouseEvent);
				e.preventDefault();
			});
		
			SigcanvasElement = SigcanvasQuery;
			cts = SigcanvasElement.getContext("2d");
			Sigimg = new Image();
			//Sigimg.src = imageResource;
			Sigimg.onload = () => {
				cts.drawImage(Sigimg, 0, 0, SigcanvasElement.width, SigcanvasElement.height);
			}

			
			

			

		// till Signature



			this.hasRendered = false;
		}
		}

		let undoButton = this.template.querySelector('[data-id="undoBtn"]');
		undoButton.addEventListener("click", (e) => {
			if (cStep > 0) {
				cStep--;
				var canvasPic = new Image();
				canvasPic.src = storageArray[cStep];
				canvasPic.onload = () => {
					ctx.drawImage(canvasPic, 0, 0);
				}
			}
		});
		let redoButton = this.template.querySelector('[data-id="redoBtn"]');
		redoButton.addEventListener("click", (e) => {

			if (cStep < storageArray.length - 1) {
				cStep++;
				var canvasPic = new Image();
				canvasPic.src = storageArray[cStep];
				canvasPic.onload = () => { ctx.drawImage(canvasPic, 0, 0); }
			}

		});


	}
	cPush() {
		try {
			cStep++;

			if (cStep < storageArray.length) {
				storageArray.length = cStep;
			}
			storageArray.push(canvasElement.toDataURL());

		} catch (e) {
			console.log(e.message)
		}


	}
	searchCoordinatesForEvent(requestedEvent, e) {
		e.preventDefault();
		const rect = canvasElement.getBoundingClientRect();

		if (requestedEvent == 'down') {
			prevX = currX;
			prevY = currY;
			currX = e.clientX - rect.left;
			currY = e.clientY - rect.top;

			flag = true;
			dot_flag = true;
			if (dot_flag) {
				ctx.beginPath();
				ctx.fillStyle = x;
				ctx.fillRect(currX, currY, 2, 2);
				ctx.closePath();
				dot_flag = false;
			}
		}
		if (requestedEvent == 'up' || requestedEvent == "out") {
			flag = false;
			if (requestedEvent == 'up')
				this.cPush();
		}

		if (requestedEvent == 'move') {
			if (flag) {
				prevX = currX;
				prevY = currY;
				currX = e.clientX - rect.left;
				currY = e.clientY - rect.top;
				this.draw();
			}
		}

	}

	draw() {
		ctx.beginPath();
		ctx.moveTo(prevX, prevY);
		ctx.lineTo(currX, currY);
		ctx.strokeStyle = x;
		ctx.lineWidth = y;
		ctx.stroke();
		ctx.closePath();
	}
	clearDrawing() {
		ctx.clearRect(0, 0, canvasElement.width, canvasElement.height);
		ctx.drawImage(img, 0, 0, canvasElement.width, canvasElement.height);
		cStep = 0;
	}

	//till cavas


 	//Signature Capture


	 SigsearchCoordinatesForEvent(requestedEvent, e) {
		e.preventDefault();
		const rect = SigcanvasElement.getBoundingClientRect();

		if (requestedEvent == 'down') {
			prevX = currX;
			prevY = currY;
			currX = e.clientX - rect.left;
			currY = e.clientY - rect.top;

			flag = true;
			dot_flag = true;
			if (dot_flag) {
				cts.beginPath();
				cts.fillStyle = signx;
				cts.fillRect(currX, currY, 2, 2);
				cts.closePath();
				dot_flag = false;
			}
		}
		if (requestedEvent == 'up' || requestedEvent == "out") {
			flag = false;
			if (requestedEvent == 'up')
				this.SigcPush();
		}

		if (requestedEvent == 'move') {
			if (flag) {
				prevX = currX;
				prevY = currY;
				currX = e.clientX - rect.left;
				currY = e.clientY - rect.top;
				this.Sigdraw();
			}
		}

	}

	Sigdraw() {
		cts.beginPath();
		cts.moveTo(prevX, prevY);
		cts.lineTo(currX, currY);
		cts.strokeStyle = signx;
		cts.lineWidth = y;
		cts.stroke();
		cts.closePath();
	}
	SigclearDrawing() {
		cts.clearRect(0, 0, SigcanvasElement.width, SigcanvasElement.height);
		cts.drawImage(Sigimg, 0, 0, SigcanvasElement.width, SigcanvasElement.height);
		SigcStep = 0;
	}

	SigcPush() {
		try {
			SigcStep++;

			if (SigcStep < storageArray.length) {
				storageArray.length = SigcStep;
			}
			storageArray.push(SigcanvasElement.toDataURL());

		} catch (e) {
			console.log(e.message)
		}


	}
	/* Customer Signature */
	handleAddToStorage(event) {
        const valueToAdd = event.detail.CustomerSigCapture;
        this.allFilesData.push(valueToAdd);
    }
	//





	
	// Till -Signature Capture


	
	uploadedFiles = [];
	@track noOfFiles = 0;
	@track windowsnoOfFiles = 0;
	@track SeatsnoOfFiles = 0;
	@track SeatbeltsnoOfFiles = 0;
	@track DashboardnoOfFiles = 0;
	@track InfotainmentSystemScreennoOfFiles = 0;
	@track ACFunctionalitynoOfFiles = 0;
	@track RadioKnobsPanelnoOfFiles = 0;
	@track CanvasFilesnoOfFiles = 0;

	validationPassed = false;


	@track showAllFiles = [];
	fileData;
	toast;
	@api oppRecord;
	@api checkOutId;
	@track fieldValue;
	@track fuelValue;
	@track vehReceivingRec;
	@track checkOutRec;
	@track allFilesData = [];
	@track Vehicle_registration__c;
	@track Service_Book__c;
	@track Fire_Extinguisher__c;
	@track Floor_Mats__c;
	@track Jack__c;
	@track Key__c;
	@track Mirrors__c;
	@track Remote__c;
	@track Spare_wheel__c;
	@track Tools__c;
	@track Warning_Triangle__c;
	@track Windows__c;
	@track Seats__c;
	@track Seat_belts__c;
	@track Radio_Knobs_Panel__c;
	@track Infotainment_System_Screen__c;
	@track Dashboard__c;
	@track A_C_Functionality__c;
	@track oppID;
	@api selectedForm;
	@api checkIn;
	@api checkOut;
	@track assetType = 'Car'; 
	@track advisor;
	@track customer;
	@track isAsset = false;
	@track mobNum;
	connectedCallback() {
		let vehObj = { sobjectType: 'Vehicle_Receiving_Info__c' };
		let checkObj = {sobjectType: 'CICO_Check_Out__c'}
		console.log('result After value picklistOptions>>>>>', this.picklistOptions);
		console.log('Check IN in Receiving Form>>>>>', this.checkIn);
		console.log('Check Out in Receiving Form>>>>>', this.checkOut);
		console.log('this.oppRecord>>>>>', this.oppRecord);
		console.log('this.oppRecord.Id>>>>>', this.oppRecord.Id);
		console.log('PersonMobilePhone>>>>>>', this.oppRecord.Account.PersonMobilePhone);
		console.log('Account FirstName>>>>>>', this.oppRecord.Account.FirstName);
		this.oppcheckoutID = this.oppRecord;
		this.oppID = this.oppRecord.Id;
		this.advisor = this.oppRecord.Owner.FirstName + ' Signature';
		if(this.oppRecord.Driver_s_Mobile__c)
		{
			this.mobNum = this.oppRecord.Driver_s_Mobile__c;
		}
		else{
			this.mobNum = this.oppRecord.Account.PersonMobilePhone;
			console.log('mobNum>>>>>>>>', this.mobNum);
		}
		if(this.oppRecord.Driver_s_Name__c)
		{
			this.customer = this.oppRecord.Driver_s_Name__c + ' Signature';
		}
		else{
			console.log('In Account Else>>>>>>>>');
			this.customer = this.oppRecord.Account.FirstName  + ' Signature';
			console.log('Customer>>>>>>>>', this.customer);
		}
		if(this.oppRecord.Asset_Type__c)
		{
			this.isAsset = true;
			this.assetType = this.oppRecord.Asset_Type__c;
			this.CICOImage = CICOImages +'/images/'+ this.assetType +'.jpg';
			console.log('this.CICOImage In Change>>>>>>>',  this.CICOImage);
			this.hasRendered = true;
		
		}
		console.log('this.oppID>>>>>>', this.oppID);
		vehObj.Opportunity__c = this.oppRecord.Id;
		vehObj.Vehicle_registration__c = true;
		vehObj.Service_Book__c = true;
		vehObj.Fire_Extinguisher__c = true;
		vehObj.Floor_Mats__c = true;
		vehObj.Jack__c = true;
		vehObj.Key__c = true;
		vehObj.Mirrors__c = true;
		vehObj.Remote__c = true;
		vehObj.Spare_wheel__c = true;
		vehObj.Tools__c = true;
		vehObj.Warning_Triangle__c = true;
		vehObj.Windows__c = true;
		vehObj.Seats__c = true;
		vehObj.Seat_belts__c = true;
		vehObj.Radio_Knobs_Panel__c = true;
		vehObj.Infotainment_System_Screen__c = true;
		vehObj.Dashboard__c = true;
		vehObj.A_C_Functionality__c = true;
		this.vehReceivingRec = vehObj;

		checkObj.Radio__c = true;
		checkObj.Emer_Tool_Kit__c = true;
		checkObj.Fire_Ext_In__c = true;
		checkObj.First_Aid_Box__c = true;
		checkObj.Reflec_Trian__c = true;
		checkObj.Spare_Wheel__c = true;
		this.checkOutRec = checkObj;
	}
	


	validRecformFile() {

		if (this.windowsnoOfFiles == 0) {
			const windowsv = this.template.querySelector('[data-id="windowsv"]');
			windowsv.setCustomValidity('You must upload at least 1 file');
			windowsv.reportValidity();
			windowsv.scrollIntoView({ behavior: 'smooth', block: 'center' });
		}
		if (this.SeatsnoOfFiles == 0) {
			const Seatsv = this.template.querySelector('[data-id="Seatsv"]');
			Seatsv.setCustomValidity('You must upload at least 1 file');
			Seatsv.reportValidity();
			Seatsv.scrollIntoView({ behavior: 'smooth', block: 'center' });

		}
		if (this.SeatbeltsnoOfFiles == 0) {
			const Seatbeltsv = this.template.querySelector('[data-id="Seatbeltsv"]');
			Seatbeltsv.setCustomValidity('You must upload at least 1 file');
			Seatbeltsv.reportValidity();
			Seatbeltsv.scrollIntoView({ behavior: 'smooth', block: 'center' });

		}
		if (this.DashboardnoOfFiles == 0) {
			const Dashboardv = this.template.querySelector('[data-id="Dashboardv"]');
			Dashboardv.setCustomValidity('You must upload at least 1 file');
			Dashboardv.reportValidity();
			Dashboardv.scrollIntoView({ behavior: 'smooth', block: 'center' });

		}
		if (this.InfotainmentSystemScreennoOfFiles == 0) {
			const InfotainmentSystemScreenv = this.template.querySelector('[data-id="InfotainmentSystemScreenv"]');
			InfotainmentSystemScreenv.setCustomValidity('You must upload at least 1 file');
			InfotainmentSystemScreenv.reportValidity();
			InfotainmentSystemScreenv.scrollIntoView({ behavior: 'smooth', block: 'center' });

		}
		if (this.ACFunctionalitynoOfFiles == 0) {
			const ACFunctionalityv = this.template.querySelector('[data-id="ACFunctionalityv"]');
			ACFunctionalityv.setCustomValidity('You must upload at least 1 file');
			ACFunctionalityv.reportValidity();
			ACFunctionalityv.scrollIntoView({ behavior: 'smooth', block: 'center' });

		}
		if (this.RadioKnobsPanelnoOfFiles == 0) {
			const RadioKnobsPanelv = this.template.querySelector('[data-id="RadioKnobsPanelv"]');
			RadioKnobsPanelv.setCustomValidity('You must upload at least 1 file');
			RadioKnobsPanelv.reportValidity();
			RadioKnobsPanelv.scrollIntoView({ behavior: 'smooth', block: 'center' });
		}
		return;

	}
	
	serviceRequestInERP() {
		var this1 = this; 
		console.log('IN serviceRequestInERP>>>>>>>');
		console.log('Opportunity Id>>>>>>>', this.oppID);
		
		createServiceRequest({ recId: this.oppID }).then(result => {
			console.log('Results Service Request>>>>>>>', result);
			if(result == 'Success'){
				console.log('IN Success Result>>>>>>>');
				this1.dispatchEvent(
					new ShowToastEvent({
						title: 'Success',
						message: ' Service Request Created In ERP Successfully ',
						variant: 'success'
					}),
				);
				//this.serviceRequestSuccessToast();
				console.log('IN Success Msg TRUE>>>>>>>', this.successMsgServiceReq);
		
				this.CheckInERP();
				
			}
			else
			{
				console.log('IN NOt Success of Service Request>>>>>>>');
				this1.dispatchEvent(
					new ShowToastEvent({
						title: 'Error',
						message: ' Service Request not created In ERP',
						variant: 'error'
					}),
				);
				this.loaded = this.Floaded;
				this.clearDrawing();
				this.inspectionHomePage7Hanlder();
			}
			
			
		}).catch(error => {
			console.error('Error>>>>>>>', error); // Log the error for debugging
			this1.dispatchEvent(
				new ShowToastEvent({
					title: 'Error',
					message: 'Error in Service Request to ERP',
					variant: 'error'
				}),
			);
			this.loaded = this.Floaded;
			this.clearDrawing();
			this.inspectionHomePage7Hanlder();
		});
		
		
		
	}
	@track showRecentCheckIn;
	parseResponse;
	CheckInERP() {
		console.log('IN serviceRequestInERP>>>>>>>');
		console.log('Opportunity Id>>>>>>>', this.oppID);
		var this1 = this;
		createCheckIn({ recId: this.oppID }).then(result => {
			console.log('Result Check IN Request>>>>>>>', result);
			if(result)
			{
				createCheckInERP({ 
					recId: this.oppID,
					checkId: result
				 }).then(result => {
					console.log('Result Check In Request>>>>>>>', result);
					this.parseResponse = JSON.parse(result);
					if(this.parseResponse.Status == 'S')
					{
						this1.dispatchEvent(
							new ShowToastEvent({
								title: 'Success',
								message: this.parseResponse.Message,
								variant: 'success'
							}),
						);
						this.loaded = this.Floaded;
						this.clearDrawing();
						this.inspectionHomePage7Hanlder();
						this.showRecentCheckIn = true;
						window.location.reload();
					}
					else{
						this1.dispatchEvent(
							new ShowToastEvent({
								title: 'Error',
								message: this.parseResponse.Message,
								variant: 'error'
							}),
						);
						this.loaded = this.Floaded;
						this.clearDrawing();
						this.inspectionHomePage7Hanlder();

					}


				}).catch(error => {
					console.error('Error>>>>>>> of Check In ERP', error); // Log the error for debugging
					this1.dispatchEvent(
						new ShowToastEvent({
							title: 'Error',
							message: error,
							variant: 'error'
						}),
					);
					this.loaded = this.Floaded;
					this.clearDrawing();
					this.inspectionHomePage7Hanlder();
				});
			
			}		
		}).catch(error => {
			console.error('Error>>>>>>> of Checkin Record Creation', error); // Log the error for debugging
			this1.dispatchEvent(
				new ShowToastEvent({
					title: 'Error',
					message: error,
					variant: 'error'
				}),
			);
			this.loaded = this.Floaded;
			this.clearDrawing();
			this.inspectionHomePage7Hanlder();
		});
			
	}

	// getCheckInStatus(){
	// 	var this1 = this; 
	// 	getCheckInResp({recId: this.oppID}).then(result => {
	// 		console.log('Result Check IN Status>>>>>>>', result);
	// 		if(result == 'Success'){
	// 			console.log('IN Success Result Check IN>>>>>>>');
	// 			this1.dispatchEvent(
	// 				new ShowToastEvent({
	// 					title: 'Success',
	// 					message: ' Check In Created In ERP Successfully ',
	// 					variant: 'success'
	// 				}),
	// 			);
	// 			this.loaded = this.Floaded;
	// 			this.clearDrawing();
	// 			this.inspectionHomePage7Hanlder();
	// 		}
	// 		else
	// 		{
	// 			console.log('IN NOt Success of Check In ERP>>>>>>>');
	// 			this1.dispatchEvent(
	// 				new ShowToastEvent({
	// 					title: 'Error',
	// 					message: 'Check In not created In ERP',
	// 					variant: 'error'
	// 				}),
	// 			);
	// 			this.loaded = this.Floaded;
	// 			this.clearDrawing();
	// 			this.inspectionHomePage7Hanlder();
	// 		}
			
			
	// 	}).catch(error => {
	// 		console.error('Error>>>>>>> of Check In ERP', error); // Log the error for debugging
	// 		this1.dispatchEvent(
	// 			new ShowToastEvent({
	// 				title: 'Error',
	// 				message: 'Error in Check In to ERP',
	// 				variant: 'error'
	// 			}),
	// 		);
	// 		this.loaded = this.Floaded;
	// 		this.clearDrawing();
	// 		this.inspectionHomePage7Hanlder();
	// 	});
	// }
	parseData;
	CheckOutERP() {
		console.log('IN CheckOutERP>>>>>>>');
		console.log('checkOut Id>>>>>>>', this.checkOutId);
		console.log('oppcheckoutID >>>>>>>', this.oppcheckoutID);
		var this1 = this;
		createCheckOutERP({ 
			checkoutId: this.checkOutId,
			oppId: this.oppcheckoutID,
		 }).then(result => {
			console.log('Result Check Out Request>>>>>>>', result);
			this.parseData = JSON.parse(result);
			if (this.parseData.Status == 'S'){
				this1.dispatchEvent(
					new ShowToastEvent({
						title: 'Success',
						message: 'Vehicle has been check out successfully - Doc No.' + this.parseData.DocNo,
						variant: 'Success'
					}),
				);
					this.loaded = this.Floaded;
					this.clearDrawing();
					this.inspectionHomePage7Hanlder();
			}
			else{
				console.log('IN NOt Success of Check Out ERP>>>>>>>');
				this1.dispatchEvent(
					new ShowToastEvent({
						title: 'Error',
						message: this.parseData.Message,
						variant: 'error'
					}),
				);
				this.loaded = this.Floaded;
				this.clearDrawing();
				this.inspectionHomePage7Hanlder();
			} 
			
		}).catch(error => {
			console.error('Error>>>>>>> of Check Out ERP', error); // Log the error for debugging
			this1.dispatchEvent(
				new ShowToastEvent({
					title: 'Error',
					message: error,
					variant: 'error'
				}),
			);
			this.loaded = this.Floaded;
			this.clearDrawing();
			this.inspectionHomePage7Hanlder();
		});
			
	}

	@track CICOImage = CICOImages +'/images/Car.jpg';
	handleAssetChange(event)
	{
		const value = event.target.value;
		this.assetType = value;
		console.log('Asset Value>>>>>', value);
		console.log('this.assetType>>>>>', this.assetType);
		
		 this.CICOImage = CICOImages +'/images/'+ this.assetType +'.jpg';
		 console.log('this.CICOImage In Change>>>>>>>',  this.CICOImage);
		 this.hasRendered = true;
		
	}

	
	handlePicklistChange(event) {

		const value = event.target.value;
		const checkboxvalue = event.target.checked;
		const fieldName = event.target.name;
        this.selectedJob = checkboxvalue;
		console.log('this.selectedJob in Handle Change>>>', this.selectedJob);
    }
	vehRecSaveHandler() {
		console.log('Selected Form>>>>>', this.selectedForm);
		const fieldElement = this.template.querySelector('[data-id="Comments"]');
		if (fieldElement) {
			this.fieldValue = fieldElement.value;
		}
		this.vehReceivingRec.Comments__c = this.fieldValue;

		const fieldElementfuel = this.template.querySelector('[data-id="fuel"]');
		//console.log('this.selectedJob in Save Handler>>>', this.selectedJob);
		//const fieldElementfuel = this.selectedJob;
		if (fieldElementfuel) {
			this.fuelValue = fieldElementfuel.value;
		}
		console.log('this.fuelValue>>>>>>>>', this.fuelValue);
		this.vehReceivingRec.Check_in_Fuel_Reading__c = this.fuelValue;
		console.log('this.vehReceivingRec.Check_in_Fuel_Reading__c1>>>>>>>>', this.vehReceivingRec.Check_in_Fuel_Reading__c);
		if (this.windowsnoOfFiles === 0 && this.Windows__c === true || this.SeatsnoOfFiles === 0 && this.Seats__c === true || this.SeatbeltsnoOfFiles === 0 && this.Seat_belts__c === true || this.DashboardnoOfFiles === 0 && this.Dashboard__c === true || this.InfotainmentSystemScreennoOfFiles === 0 && this.Infotainment_System_Screen__c === true || this.ACFunctionalitynoOfFiles === 0 && this.A_C_Functionality__c === true || this.RadioKnobsPanelnoOfFiles === 0 && this.Radio_Knobs_Panel__c === true) {
			this.validRecformFile();
			return;
		}

		if (cStep == 0) {
			const errorMsg = 'Please Mark The Diagram Before Saving';
			const evt = new ShowToastEvent({
				title: 'Error',
				message: errorMsg,
				variant: 'error'
			});
			this.dispatchEvent(evt);
			const canvasQuery = this.template.querySelector('[data-id="canvasDia"]');
			canvasQuery.scrollIntoView({ behavior: 'smooth' });
			return;
		}
		try {
			this.loaded = this.Tloaded;
			//canvas
			ctx.globalCompositeOperation = "destination-over";
			ctx.fillStyle = "#FFF"; //white
			ctx.fillRect(0, 0, canvasElement.width, canvasElement.height);
			dataURL = canvasElement.toDataURL("image/png");
			convertedDataURI = dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
			this.fileData = {
				'filename': 'MarkedDiagram.png',
				'filetype': 'image/png',
				'base64': convertedDataURI,
			}
			this.allFilesData.push(this.fileData)

			//Signature
			cts.globalCompositeOperation = "destination-over";
			cts.fillStyle = "#FFF"; //white
			cts.fillRect(0, 0, SigcanvasElement.width, SigcanvasElement.height);
			dataURL = SigcanvasElement.toDataURL("image/png");
			convertedDataURI = dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
			this.fileData = {
				'filename': 'AdvisorSignature.png',
				'filetype': 'image/png',
				'base64': convertedDataURI,
			}
			this.allFilesData.push(this.fileData)
			console.log('this.vehReceivingRec.Check_in_Fuel_Reading__c1>>>>>>>>', this.vehReceivingRec.Check_in_Fuel_Reading__c);
		
			if(this.vehReceivingRec.Check_in_Fuel_Reading__c)
			{
				vehRecInfoSaveHandler({
					vehicleInspectionList: [this.vehReceivingRec],
					fileData: JSON.stringify(this.allFilesData)
				}).then(result => {
					console.log('res--' + result)
					
					
						this.dispatchEvent(
							new ShowToastEvent({
								title: 'Success',
								message: 'Vehicle Receiving Form is created Successfully ',
								variant: 'success'
							}),
						);
						if(this.selectedForm != "Internal")
						{
							this.serviceRequestInERP();
						}
						else{
							this.CheckInERP();
						}
						
				}).catch(error => {
					console.log(error)
					this.dispatchEvent(
						new ShowToastEvent({
							title: 'Error creating Salesforce record',
							message: error.body.message,
							variant: 'error',
						}),
					);
				});
			}
		else{

			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Error',
					message: 'Please select the Check In Fuel Reading',
					variant: 'error'
				}),
			);
		this.loaded = this.Floaded;
		}

		} catch (e) {
			console.log(e.message)
		}
		console.log(this.allFilesData)
	}
	checkOutSaveHandler() {
		console.log('Selected Form>>>>>', this.selectedForm);
		const fieldElementfuel = this.template.querySelector('[data-id="fuel"]');
		//console.log('this.selectedJob in Save Handler>>>', this.selectedJob);
		//const fieldElementfuel = this.selectedJob;
		if (fieldElementfuel) {
			this.fuelValue = fieldElementfuel.value;
		}
		this.checkOutRec.Check_Out_fuel_reading__c = this.fuelValue;

		

		if (cStep == 0) {
			const errorMsg = 'Please Mark The Diagram Before Saving';
			const evt = new ShowToastEvent({
				title: 'Error',
				message: errorMsg,
				variant: 'error'
			});
			this.dispatchEvent(evt);
			const canvasQuery = this.template.querySelector('[data-id="canvasDia"]');
			canvasQuery.scrollIntoView({ behavior: 'smooth' });
			return;
		}
		try {
			this.loaded = this.Tloaded;
			//canvas
			ctx.globalCompositeOperation = "destination-over";
			ctx.fillStyle = "#FFF"; //white
			ctx.fillRect(0, 0, canvasElement.width, canvasElement.height);
			dataURL = canvasElement.toDataURL("image/png");
			convertedDataURI = dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
			this.fileData = {
				'filename': 'MarkedDiagram.png',
				'filetype': 'image/png',
				'base64': convertedDataURI,
			}
			this.allFilesData.push(this.fileData)

			//Signature
			cts.globalCompositeOperation = "destination-over";
			cts.fillStyle = "#FFF"; //white
			cts.fillRect(0, 0, SigcanvasElement.width, SigcanvasElement.height);
			dataURL = SigcanvasElement.toDataURL("image/png");
			convertedDataURI = dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
			this.fileData = {
				'filename': 'AdvisorSignature.png',
				'filetype': 'image/png',
				'base64': convertedDataURI,
			}
			this.allFilesData.push(this.fileData)
			console.log('this.checkOut in Save>>>>' , this.checkOutId);
			checkoutRecSaveHandler({
				checkOutList: [this.checkOutRec],
				fileData: JSON.stringify(this.allFilesData),
				checkOutId: this.checkOutId,
			}).then(result => {
				console.log('res--' + result)
				
				
					this.dispatchEvent(
						new ShowToastEvent({
							title: 'Success',
							message: 'Check Out is created Successfully ',
							variant: 'success'
						}),
					);
					console.log('this.checkOut>>>>' , this.checkOutId);
					this.CheckOutERP();
					
					
			}).catch(error => {
				console.log(error)
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'Error creating Salesforce record',
						message: error.body.message,
						variant: 'error',
					}),
				);
			});

		} catch (e) {
			console.log(e.message)
		}
		console.log(this.allFilesData)
	}
	backbButtonHanlder(event) {
		const backButtonEvent = new CustomEvent("backbuttonclick", {
			detail: null
		});
		this.dispatchEvent(backButtonEvent);
	}
	inspectionHomePage7Hanlder(event) {
		const backButtonEvent = new CustomEvent("inspectionpage7hanlder", {
			detail: null
		});
		this.dispatchEvent(backButtonEvent);
	}
	handleYesClick(event) {
		let fieldName = event.target.name;
		this.vehReceivingRec[fieldName] = true;
		this[fieldName] = false;
		console.log(this.vehReceivingRec);
	}
	handleNoClick(event) {
		let fieldName = event.target.name;
		this.vehReceivingRec[fieldName] = false;
		this[fieldName] = true;
		console.log(this.vehReceivingRec);
	}

	handleYesClickCO(event) {
		let fieldName = event.target.name;
		this.checkOutRec[fieldName] = true;
		this[fieldName] = false;
		console.log('this.checkOutRec NO>>>>>>>>',this.checkOutRec);
	}
	handleNoClickCO(event) {
		let fieldName = event.target.name;
		this.checkOutRec[fieldName] = false;
		this[fieldName] = true;
		console.log('this.checkOutRec No>>>>>>',this.checkOutRec);
	}

	handleFileUpload(event) {

		try {
			const uploadedFiles = event.target.files;
			const file = event.target.files[0];
			let fileName = event.target.name;
			console.log('fileSize', file.size)

			//Compress image

			let img = new Image();
			img.onload = () => {
				let canvas = document.createElement('canvas');


				// Set the desired width and height for the compressed image
				const maxWidth = 800;
				const maxHeight = 600;

				let width = img.width;
				let height = img.height;


				// Resize the image if needed
				if (width > maxWidth || height > maxHeight) {
				const ratio = Math.max(width / maxWidth, height / maxHeight);
				width /= ratio;
				height /= ratio;
			    }

				canvas.width = width;
				canvas.height = height;
				let ctx = canvas.getContext("2d");
				ctx.drawImage(img, 0, 0, width, height);// Draw the image on the canvas
				// Get the compressed image data from the canvas as a base64-encoded string
				let compressedImage = canvas.toDataURL('image/jpeg', 0.5);// Adjust the compression quality as per your needs
				var base64 = compressedImage.split(',')[1];
				var decodedData = window.atob(base64);
				console.log('compressedImage', decodedData.length)


				if (decodedData.length < 5000000) {

					var reader = new FileReader()
					reader.onload = () => {
						/* var base64 = reader.result.split(',')[1] */
						this.fileData = {
							'filename': fileName + '_' + file.name,
							'filetype': file.type,
							'base64': base64,
							
						}
						this.allFilesData.push(this.fileData)
						console.log('this.allFilesData', this.allFilesData);

						let temArray = {
							'imgUrl': reader.result
						}
						console.log('imgfilename:', fileName);
						if (fileName.startsWith('windows')) {
							temArray.Windows = true;
							this.windowsnoOfFiles += uploadedFiles.length;
							console.log(this.windowsnoOfFiles)
							if (this.windowsnoOfFiles == 1 || this.windowsnoOfFiles == 2 || this.windowsnoOfFiles == 3 || this.windowsnoOfFiles == 4) {
								if (this.Windows__c == true) {
									const windowsv = this.template.querySelector('[data-id="windowsv"]');
									windowsv.setCustomValidity('');
									windowsv.reportValidity();
									this.validationPassed = true;
								}
							} else if (this.windowsnoOfFiles > 4) {
								const errorMsg = 'You can upload a maximum of 4 files.';
								const evt = new ShowToastEvent({
									title: 'Error',
									message: errorMsg,
									variant: 'error'
								});
								this.dispatchEvent(evt);
								this.validationPassed = true;
								return;
							} else {
								this.validationPassed = true;
							}
						}
						if (fileName.startsWith('Seats')) {
							temArray.Seats = true;
							this.SeatsnoOfFiles += uploadedFiles.length;
							console.log(this.SeatsnoOfFiles)
							if (this.SeatsnoOfFiles == 1 || this.SeatsnoOfFiles == 2 || this.SeatsnoOfFiles == 3 || this.SeatsnoOfFiles == 4) {
								if (this.Seats__c == true) {
									const windowsv = this.template.querySelector('[data-id="Seatsv"]');
									windowsv.setCustomValidity('');
									windowsv.reportValidity();
									this.validationPassed = true;
								}
							} else if (this.SeatsnoOfFiles > 4) {
								const errorMsg = 'You can upload a maximum of 4 files.';
								const evt = new ShowToastEvent({
									title: 'Error',
									message: errorMsg,
									variant: 'error'
								});
								this.dispatchEvent(evt);
								this.validationPassed = true;
								return;
							} else {
								this.validationPassed = true;
							}
						}
						if (fileName.startsWith('Seat belts')) {
							temArray.Seatbelts = true;
							this.SeatbeltsnoOfFiles += uploadedFiles.length;
							console.log(this.SeatbeltsnoOfFiles)
							if (this.SeatbeltsnoOfFiles == 1 || this.SeatbeltsnoOfFiles == 2 || this.SeatbeltsnoOfFiles == 3 || this.SeatbeltsnoOfFiles == 4) {
								if (this.Seat_belts__c == true) {
									const windowsv = this.template.querySelector('[data-id="Seatbeltsv"]');
									windowsv.setCustomValidity('');
									windowsv.reportValidity();
									this.validationPassed = true;
								}
							} else if (this.SeatbeltsnoOfFiles > 4) {
								const errorMsg = 'You can upload a maximum of 4 files.';
								const evt = new ShowToastEvent({
									title: 'Error',
									message: errorMsg,
									variant: 'error'
								});
								this.dispatchEvent(evt);
								this.validationPassed = true;
								return;
							} else {
								this.validationPassed = true;
							}
						}
						if (fileName.startsWith('Dashboard')) {
							temArray.Dashboard = true;
							this.DashboardnoOfFiles += uploadedFiles.length;
							console.log(this.DashboardnoOfFiles)
							if (this.DashboardnoOfFiles == 1 || this.DashboardnoOfFiles == 2 || this.DashboardnoOfFiles == 3 || this.DashboardnoOfFiles == 4) {
								if (this.Dashboard__c == true) {
									const windowsv = this.template.querySelector('[data-id="Dashboardv"]');
									windowsv.setCustomValidity('');
									windowsv.reportValidity();
									this.validationPassed = true;
								}
							} else if (this.DashboardnoOfFiles > 4) {
								const errorMsg = 'You can upload a maximum of 4 files.';
								const evt = new ShowToastEvent({
									title: 'Error',
									message: errorMsg,
									variant: 'error'
								});
								this.dispatchEvent(evt);
								this.validationPassed = true;
								return;
							} else {
								this.validationPassed = true;
							}
						}
						if (fileName.startsWith('Infotainment System Screen')) {
							temArray.InfotainmentSystemScreen = true;
							this.InfotainmentSystemScreennoOfFiles += uploadedFiles.length;
							console.log(this.InfotainmentSystemScreennoOfFiles)
							if (this.InfotainmentSystemScreennoOfFiles == 1 || this.InfotainmentSystemScreennoOfFiles == 2 || this.InfotainmentSystemScreennoOfFiles == 3 || this.InfotainmentSystemScreennoOfFiles == 4) {
								if (this.Infotainment_System_Screen__c == true) {
									const windowsv = this.template.querySelector('[data-id="InfotainmentSystemScreenv"]');
									windowsv.setCustomValidity('');
									windowsv.reportValidity();
									this.validationPassed = true;
								}
							} else if (this.InfotainmentSystemScreennoOfFiles > 4) {
								const errorMsg = 'You can upload a maximum of 4 files.';
								const evt = new ShowToastEvent({
									title: 'Error',
									message: errorMsg,
									variant: 'error'
								});
								this.dispatchEvent(evt);
								this.validationPassed = true;
								return;
							} else {
								this.validationPassed = true;
							}
						}
						if (fileName.startsWith('AC Functionality')) {
							temArray.ACFunctionality = true;
							this.ACFunctionalitynoOfFiles += uploadedFiles.length;
							console.log(this.ACFunctionalitynoOfFiles)
							if (this.ACFunctionalitynoOfFiles == 1 || this.ACFunctionalitynoOfFiles == 2 || this.ACFunctionalitynoOfFiles == 3 || this.ACFunctionalitynoOfFiles == 4) {
								if (this.A_C_Functionality__c == true) {
									const windowsv = this.template.querySelector('[data-id="ACFunctionalityv"]');
									windowsv.setCustomValidity('');
									windowsv.reportValidity();
									this.validationPassed = true;
								}
							} else if (this.ACFunctionalitynoOfFiles > 4) {
								const errorMsg = 'You can upload a maximum of 4 files.';
								const evt = new ShowToastEvent({
									title: 'Error',
									message: errorMsg,
									variant: 'error'
								});
								this.dispatchEvent(evt);
								this.validationPassed = true;
								return;
							} else {
								this.validationPassed = true;
							}
						}
						if (fileName.startsWith('RadioKnobsPanel')) {
							temArray.RadioKnobsPanel = true;
							this.RadioKnobsPanelnoOfFiles += uploadedFiles.length;
							console.log(this.RadioKnobsPanelnoOfFiles)
							if (this.RadioKnobsPanelnoOfFiles == 1 || this.RadioKnobsPanelnoOfFiles == 2 || this.RadioKnobsPanelnoOfFiles == 3 || this.RadioKnobsPanelnoOfFiles == 4) {
								if (this.Radio_Knobs_Panel__c == true) {
									const windowsv = this.template.querySelector('[data-id="RadioKnobsPanelv"]');
									windowsv.setCustomValidity('');
									windowsv.reportValidity();
									this.validationPassed = true;
								}
							} else if (this.RadioKnobsPanelnoOfFiles > 4) {
								const errorMsg = 'You can upload a maximum of 4 files.';
								const evt = new ShowToastEvent({
									title: 'Error',
									message: errorMsg,
									variant: 'error'
								});
								this.dispatchEvent(evt);
								this.validationPassed = true;
								return;
							} else {
								this.validationPassed = true;
							}
						}
						if (fileName.startsWith('CanvasFiles')) {
							temArray.CanvasFiles = true;
							this.CanvasFilesnoOfFiles += uploadedFiles.length;
							console.log(this.CanvasFilesnoOfFiles)
							if (this.CanvasFilesnoOfFiles > 4) {
								const errorMsg = 'You can upload a maximum of 4 files.';
								const evt = new ShowToastEvent({
									title: 'Error',
									message: errorMsg,
									variant: 'error'
								});
								this.dispatchEvent(evt);
								this.validationPassed = true;
								return;
							} else {
								this.validationPassed = true;
							}
						}
						this.showAllFiles.push(temArray)
					}
					reader.readAsDataURL(file)
				} else {
					const errorMsg = decodedData.length;
					const evt = new ShowToastEvent({
						title: 'Error',
						message: errorMsg,
						variant: 'error'
					});
					this.dispatchEvent(evt);
				}


			}
			img.src = URL.createObjectURL(file);
			console.log('Compression started.',file.size)
		} catch (e) {
			console.log(e.message)
		}


	}
	handleRemoveAttachment(event) {
		const index = event.target.dataset.filename;
		console.log('index', index);
		this.allFilesData.splice(index, 1);
		this.showAllFiles.splice(index, 1);

	}

	@track openChilds = false;

	@track parentOptions = [
        { label: 'Preventative', value: 'Preventative' },
        { label: 'Corrective or Breakdown', value: 'Corrective or Breakdown' },
        { label: 'Accident Repair', value: 'Accident Repair' }
    ];
    @track selectedParentValues = [];
    @track selectedChildValues = [];
	


    get childOptions() {
        // Logic to determine childOptions based on the selectedParentValues
        // You need to implement the logic based on your Salesforce data or custom logic
        // For simplicity, let's assume a static mapping for this example

        const mapping = {
            'Preventative': ['Schedule A - Minor', 'Schedule B – Minor', 'Schedule C - Major'],
            'Corrective or Breakdown': ['Fluid Leaks', 'Warning Lights', 'Suspension and Steering Issues', 'Braking System Issues', 'Tire and Wheel Issues', 'Electrical System Issues', 'Exhaust Emissions', 'Engine-related Issues', 'Transmission-related Issues', 'Fuel System Issues', 'Remote Key/Keyless Entry Issues', 'Communication Systems', 'Entertainment and Infotainment Systems', 'Dashboard Display and Controls', 'Drivetrain Issues', 'Windshield and Wipers', 'Exterior and Visual Inspection', 'Interior Issues', 'Miscellaneous Issues'],
            'Accident Repair': ['None']
        };

        let options = [];
        this.selectedParentValues.forEach(value => {
            options = options.concat(mapping[value] || []);
        });
        return options.map(opt => ({ label: opt, value: opt }));
    }

	get causeOptions() {
        // Logic to determine childOptions based on the selectedParentValues
        // You need to implement the logic based on your Salesforce data or custom logic
        // For simplicity, let's assume a static mapping for this example

        const mapping = {
            'Fluid Leaks': ['Oil leaks', 'Coolant leaks', 'Transmission fluid leaks'],
            'Warning Lights': ['Other warning lights on the dashboard (besides the check engine light)'],
            'Suspension and Steering Issues': ['Vehicle pulling to one side', 'Strange noises when turning', 'Rough or bumpy ride', 'Steering vibration'],
			'Braking System Issues': ['Squeaking or grinding brakes','Soft or spongy brake pedal','ABS warning light on'],
			'Tire and Wheel Issues': ['Flat tire','Vibration at certain speeds','Uneven tire wear','Tire pressure problems','Wheel balancing issues'],
			'Electrical System Issues': ['Battery failure','Self starter failure','Electrical shorts','Power windows or locks not working'],
			'Exhaust Emissions': ['Unusual or excessive exhaust smoke','Problems with emissions control systems','Checking for leaks in the exhaust system'],
			'Engine-related Issues': ['Check engine light on','Engine overheating','Strange noises from the engine','Rough idling'],
			'Transmission-related Issues': ['Transmission slipping','Difficulty shifting gears','Unusual noises during gear changes','Low pickup/acceleration'],
			'Fuel System Issues': ['Difficulty starting the vehicle','Poor fuel efficiency','Unusual fuel odors'],
			'Remote Key/Keyless Entry Issues': ['Problems with key fob','Keyless entry not working'],
			'Communication Systems': ['Issues with Bluetooth connectivity','Malfunctions in the hands-free calling system','Problems with GPS navigation'],
			'Entertainment and Infotainment Systems': ['Problems with audio system functionality','Issues with touchscreen or control interface','Malfunctions in entertainment connectivity (USB, Bluetooth)'],
			'Dashboard Display and Controls': ['Malfunctioning gauges','Issues with infotainment system','Problems with instrument cluster'],
			'Drivetrain Issues': ['Unusual noises from the drivetrain','Vibration during acceleration','Issues with constant velocity (CV) joints'],
			'Windshield and Wipers': ['Cracked or chipped windshield','Wipers not working properly','Fluid level low for windshield washer'],
			'Exterior and Visual Inspection': ['Scratches or dents','Broken or missing exterior parts','Issues with lights (headlights, taillights, indicators)','Damaged or bent rims','Corrosion or rust on exterior surfaces'],
			'Interior Issues': ['Non-functioning or malfunctioning controls (AC, radio, etc.)','Interior stains or damage','Strange odors in the cabin'],
			'Miscellaneous Issues': ['Unusual odors from the vehicle','Unusual sounds during driving'],     
			'None': ['None']
        };

        let optionsCause = [];
        this.selectedChildValues.forEach(value => {
            optionsCause = optionsCause.concat(mapping[value] || []);
        });
        return optionsCause.map(opt => ({ label: opt, value: opt }));
    }

    handleParentChange(event) {
        this.selectedParentValues = event.detail.value;
		console.log('List of Service>>>>>>>>>', this.selectedParentValues);
		this.vehReceivingRec.Symptom_Type__c = this.selectedParentValues.join(';');
		console.log('List _selected>>>>>>>>>', this.vehReceivingRec.Symptom_Type__c);
		if(this.selectedParentValues)
			this.openChilds = true;
    }

    handleChildChange(event) {
        this.selectedChildValues = event.detail.value;
		this.vehReceivingRec.Symptoms__c = this.selectedChildValues.join(';');
		console.log('List _selected>>>>>>>>>', this.vehReceivingRec.Symptoms__c);
    }

	handleCauseChange(event) {
        this.selectedCauseValues = event.detail.value;
		this.vehReceivingRec.Cause__c = this.selectedCauseValues.join(';');
		console.log('List _selected>>>>>>>>>', this.vehReceivingRec.Cause__c);
    }
	

}
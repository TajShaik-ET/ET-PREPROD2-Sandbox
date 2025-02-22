import { LightningElement, wire, api, track } from 'lwc';
import getOpportunities from '@salesforce/apex/MOTO_VehInspectionCtrl.getOpportunitiesFormsHome'

export default class MOTO_VehicleFormsHome extends LightningElement {
    showHomePage = true;
	showSearchPage = true;
	selectedType = "36 Points Check";
	showVehReceivingForm = false;
	showVehLeadForm = false;
	@track show36InspectionForm = false;
	@track show111POintsCheck = false;
	@api mobileNumber = null;
	@api oppList;
	@track oppListRF;
	@track oppListRT;
	@api selectedOpp;
	@track selectedButton;
	

	get typeOptions() {
		return [
			{ label: '36 Points Check', value: '36 Points Check' },
			{ label: '111 Points Check', value: '111 Points Check' },
		];
	}
	handleTypeChange(event) {
		this.selectedType = event.target.value;
	}
	handleMobileChange(event) {
		this.mobileNumber = event.target.value;
	}
	/* goToHomeHandeler(event) {
		this.showHomePage = true;
		this.showSearchPage = false;
	} */

	searchBtnHandeler(event) {
		console.log(this.selectedType + '--' + this.mobileNumber)
		getOpportunities({
			MobNum: this.mobileNumber
		}).then(result => {
			console.log(result)
			if (result.length > 0) {
				this.oppList = result;
				this.oppListRT=true;
				this.oppListRF=false;
			}else{
				this.oppListRF=true;
				this.oppListRT=false;
			}
		}).catch(error => {
			console.log(error)
		});
	}

	onOppClick(event) {
		let oppId = event.currentTarget.dataset.recordid;
		this.showSearchPage = false;
		if (this.selectedType == '36 Points Check') {
			this.show36InspectionForm = true;
		}
		if (this.selectedType == '111 Points Check') {
			this.show111POintsCheck = true;
		}
		
		this.oppList.forEach((item) => {
			if (item.Id == oppId) {
				this.selectedOpp = item;
			}
		});
		console.log(oppList)

	}
	backButtonClickHandler(event) {
		this.show36InspectionForm = false;
		this.show111POintsCheck = false;
		this.showSearchPage = true;
	}

}
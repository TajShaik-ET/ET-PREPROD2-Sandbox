import { LightningElement,track,api,wire } from 'lwc';
import getLocationDetails from '@salesforce/apex/ET_SendSMSFromCase.getLocationDetails';
import sendNotification from '@salesforce/apex/ET_SendSMSFromCase.sendNotification';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class SendSMSToCustomer extends LightningElement {
    @api recordId;
    @track refreshData=[];
    @track addressArr;
    @track mapLocation = {};
    @track textval = '';
    @track isHide= false;
    @track error;
    isLoading = false;

    @wire(getLocationDetails)
    getAddDetails(result){   
        //console.log(result.data);
        
        this.addressArr = [];
        this.refreshData = result;//for refreh apex
        if (result.data) {
            debugger;
            //this.addressArr = result.data;
            for( let ind = 0 ; ind < result.data.length; ind++){
                this.mapLocation[result.data[ind].Id] =  result.data[ind];
                this.addressArr.push({label: result.data[ind].Label,value: result.data[ind].Id});
            }
        }
    }

    changeLocation(event){
        let locationID = event.detail.value;
        this.textval = this.mapLocation[locationID].Label + ',\n';
        this.textval += this.mapLocation[locationID].Address__c+'\n';
        if(this.mapLocation[locationID].Lat_Long__c != '' && this.mapLocation[locationID].Lat_Long__c != undefined)
            this.textval += 'https://www.google.com/maps/search/?api=1&query=' + this.mapLocation[locationID].Lat_Long__c;
        this.textval += '\n\n'+'Teams,'+'\n';
        this.textval += 'Emirates Transport';
    }

    sendSMS(event){
        this.isLoading = true;
        sendNotification({'subject':this.textval,'recId':this.recordId})
        .then(result => {   
            this.isLoading = false;
            if(result == 'S'){
                const evt = new ShowToastEvent({
                    title: "Success",
                    message: "SMS Sent Successfully!",
                    mode: 'dismissable',
                    variant: "success"
                });
                this.dispatchEvent(evt);
            }else{
                const evt = new ShowToastEvent({
                    title: "Error",
                    message: ""+result,
                    mode: 'dismissable',
                    variant: "error"
                });
                this.dispatchEvent(evt);
            }
        })
        .catch(error => {
            this.isLoading = false;
        });    
    }

    handleChange(event){
        if(event.detail.value != undefined){
            this.textval = event.detail.value;
        }
    }
}
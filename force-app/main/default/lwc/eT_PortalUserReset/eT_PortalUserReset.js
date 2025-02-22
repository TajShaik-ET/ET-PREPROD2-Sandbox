import { LightningElement, track, wire } from 'lwc';
import getrecordsfromapex from '@salesforce/apex/ET_PortalUserReset.fetchRecords';  
import resetUserPassword from '@salesforce/apex/ET_PortalUserReset.resetUserPassword';  
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ET_PortalUserReset extends LightningElement {
@track UserInput;
@track UserQuery;
arrayUSRrecs=[];
dynamicHide = true;

InputHandler(event){
    this.UserInput = event.target.value;
    const baseQuery = 'SELECT Id, Name, UserRole.Name, Email, userName, ProfileId, Profile.Name, IsActive, LastLoginDate, License_Name__c, Profile.UserLicense.Name, LastPasswordChangeDate FROM User WHERE isActive = true';
    const communityCondition = ' AND (Profile.UserLicense.Name = \'Partner Community Login\' OR Profile.UserLicense.Name = \'Customer Community Login\')';
    const userCondition = ` AND (Email = '${this.UserInput}' OR userName = '${this.UserInput}')`;
    this.UserQuery = `${baseQuery}${communityCondition}${userCondition}`;
}

OnclickHandler(event){
    getrecordsfromapex({ query: this.UserQuery})
    .then(result=>{
        this.arrayUSRrecs= result;
        if (this.arrayUSRrecs.length > 0) {
            this.dynamicHide = true;
           
        }else{
            this.dynamicHide = false;
        }
    })
    .catch(error=>{
        console.log(error);
    });
}

handleButtonClick(event) {
    const index = event.target.dataset.index;
    const clickedRecord = this.arrayUSRrecs[index];
    resetUserPassword({ userId: clickedRecord.Id})
    .then(result => {
        this.arrayUSRrecs = this.arrayUSRrecs.slice(0, index).concat(this.arrayUSRrecs.slice(index + 1));
        this.showToast('Success', 'Password reset successfully', 'success');
    })
    .catch(error => {
        console.error('Error resetting password:', error);
    });
}

showToast(title, message, variant) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
    });
    this.dispatchEvent(event);
}

}
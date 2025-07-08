import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import postAmanSurvey from '@salesforce/apex/ETI_AmanSurvey.postAmanSurvey';
import getAmanSurvey from '@salesforce/apex/ETI_AmanSurvey.getAmanSurvey';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import Survey from "@salesforce/resourceUrl/Survey";

export default class ETI_AmanSurvey extends LightningElement {
    @track showSurvey = false;
    @track showThankyou = false;
    @track ratingValue;
    @track reference = '';
    @track comments = '';
    @track ratingSelected = false;
    @track amanSurveyStatus = {};

    connectedCallback() {
        var url = new URL(window.location.href);
        console.log('reference 1: ' + this.reference);
        this.reference = url.searchParams.get('Reference');
        console.log('reference 2: ' + this.reference);
        if (this.reference != null && this.reference != '') {
           this.getAmanSurveyDetails();
        }
        Promise.all([
            loadStyle(this, Survey)
        ])
    }

    getAmanSurveyDetails() {
        console.log('getAmanSurveyDetails');
        getAmanSurvey({
            recpNo: this.reference
        }).then((response) => {
            console.log('response: ', JSON.stringify(response));
            if (response != null && response != '') {
                this.amanSurveyStatus = response;
                if (response.Status == 'S') {
                    if (response.IfReferenceExists == 'Yes') {
                        this.showSurvey = true;
                    } else if (response.IfReferenceExists == 'Duplicate' && response.TestResultsLink != '') {
                        this.openTestResult();
                    } else if (response.IfReferenceExists == 'No') {
                        this.showToastNotification('Error', 'Invalid Reference Number', 'error', 'sticky');
                    }
                }
            } else {
                this.showToastNotification('Error', 'Something went wrong! Please check with Admin', 'error', 'sticky');
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
            this.showToastNotification('Error', error, 'error', 'sticky');
        })
    }

    handleSubmit() {
        console.log('handleSubmit');
        /*const commentsField = this.template.querySelector('.comments');
        commentsField.setCustomValidity('');
        if ((this.ratingValue == 'Neutral Face' || this.ratingValue == 'Slightly Frowning Face') && !this.comments) {
            commentsField.setCustomValidity('Comments are required.');
            commentsField.reportValidity();
            return;
        }
        commentsField.setCustomValidity('');
        commentsField.reportValidity();*/
        if (this.ratingValue) {
            postAmanSurvey({
                Reference: this.reference,
                SatisfactionLevel: this.ratingValue,
                Comments: this.comments,
                SurveyCompleted: 'Y'
            }).then(response => {
                console.log('response: ', JSON.stringify(response));
                if (response != null && response != '') {
                    if (response.Status == 'S' && response.Message != '') {
                        this.showSurvey = false;
                        this.showThankyou = true;
                        this.showToastNotification('Success', response.Message, 'success', 'sticky');
                        this.openTestResult();
                    } else if (response.Status == 'E' && response.Message != '') {
                        this.showToastNotification('Error', response.Message, 'error', 'sticky');
                        //this.openTestResult();
                    }
                } else {
                    this.showToastNotification('Error', 'Something went wrong! Please check with Admin', 'error', 'sticky');
                }
            }).catch((error) => {
                console.log('error');
                console.error(error);
                this.showToastNotification('Error', error, 'error', 'sticky');
            })
        }
    }

    onRadioButtonChange(event) {
        this.ratingSelected = true;
        this.ratingValue = event.target.value;
    }

    handleComments(event) {
        this.comments = event.target.value;
    }

    openTestResult() {
        console.log('amanSurveyStatus: ', JSON.stringify(this.amanSurveyStatus));
        if (this.amanSurveyStatus) {
            if (this.amanSurveyStatus.TestResultsLink != null && this.amanSurveyStatus.TestResultsLink != '') {
                window.open(this.amanSurveyStatus.TestResultsLink, '_blank');
            }
        }
    }

    showToastNotification(title, message, variant, mode) {
        //console.log(message);
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant, //info (default), success, warning, and error
            mode: mode //dismissible (default), pester, sticky
        });
        this.dispatchEvent(evt);
    }

    disconnectedCallback() {
        console.log('---- disconncted callbcak -------');
    }
}
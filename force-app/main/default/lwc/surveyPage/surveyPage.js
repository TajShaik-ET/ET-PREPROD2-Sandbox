import { LightningElement, track } from 'lwc';
import createSurveyRec from '@salesforce/apex/surveyPageController.createSurveyRec';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSurveyRecord from '@salesforce/apex/surveyPageController.getSurveyRecord';

export default class SurveyPage extends LightningElement {
    @track showSurveyPage = false;
    @track showThankyouPage = false;
    @track ratingValue;
    @track caseid;
    @track caseAccid;
    @track surveyName;
    @track comments = '';
    @track ratingSelected = false;

    connectedCallback() {
        var url = new URL(window.location.href);
        this.caseid = url.searchParams.get('id');
        let type=url.searchParams.get('ty');
        if (type=='ese') {
        this.surveyName = 'ESE Survey';
        } else if (type=='case') {
        this.surveyName = 'Case Closing Satisfaction Survey';
            
        }  
       

  getSurveyRecord({
            CaseId:this.caseid
        }).then(result => {
           
            this.caseAccid=result.AccountId;
            if(result.Survey_Responded__c==true){
                this.showThankyouPage=true;
                this.showSurveyPage=false;
            }
            else{
                this.showThankyouPage=false;
                this.showSurveyPage=true;
            }
        });
    }

    handleSubmit() {
        const commentsField = this.template.querySelector('.comments');
        
        commentsField.setCustomValidity('');

        if ((this.ratingValue == '1' || this.ratingValue == '2') && !this.comments) {
            commentsField.setCustomValidity('Comments are required.');
            commentsField.reportValidity();
            return;
        }

        commentsField.setCustomValidity(''); 
        commentsField.reportValidity(); 

        /* if (this.ratingSelected == true) { */
            var surveyObject = new Object();
            surveyObject.sobjectType = 'Survey__c';
            surveyObject.Case__c = this.caseid;
            surveyObject.Survey_Name__c = this.surveyName;
            surveyObject.Ans1__c = this.ratingValue;
            surveyObject.Comments__c = this.comments;
            surveyObject.Ques1__c='Are you happy with Service';
            surveyObject.Account__c=this.caseAccid;

            var caseObject = new Object();
            caseObject.sobjectType= 'Case';
            caseObject.Id = this.caseid;
            caseObject.Survey_Responded__c=true;

            createSurveyRec({
                surveyRecord: surveyObject,
                caseRecord: caseObject
            })
                .then(result => {
                    //alert('Result' + result);
                    if (result == 'Success') {
                        this.showSurveyPage = false;
                        this.showThankyouPage = true;

                        const events = new ShowToastEvent({
                            title: 'Success',
                            variant: 'Success',
                            message: 'Feedback submitted successfully...',
                        });
                        this.dispatchEvent(events);
                    }
                });
       /*  }

        else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message:'Please provide a rating to submit the feedback..',
                    variant: 'error'
                })
            );
        } */
    }

    onRadioButtonChange(event) {
        this.ratingSelected = true;
        //alert(event.target.value);
        this.ratingValue = event.target.value;
    }

    handleComments(event) {
        this.comments = event.target.value;
    }
}
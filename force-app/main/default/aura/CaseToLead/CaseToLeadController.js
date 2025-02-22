({
    doInit: function(component, event, helper) {
        
        
    },
    handleLoad : function(component, event, helper) {
        console.log('### MAB');
        var action = component.get("c.fetchContactList");
        var recordId =  component.get("v.recordId");
        console.log('### MAB' + recordId);
        
        action.setParams({"qId":component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state=response.getState();
            console.log('### MAB2' + state);
            if (state === "SUCCESS") {               
                console.log('### MAB3' + response.getReturnValue()[0]);
                component.set("v.cases",response.getReturnValue()[0]);
                console.log('handle handleLoad');
                var caseRecord = component.get("v.cases");
                if(caseRecord.First_Name__c !=null && caseRecord.First_Name__c !=''){
                   component.find("FirstNameField").set("v.value", caseRecord.First_Name__c);
                }
                if(caseRecord.Last_Name__c !=null && caseRecord.Last_Name__c !=''){
                   component.find("LastNameField").set("v.value", caseRecord.Last_Name__c);
                }else if(caseRecord.Contact !=null){
                    component.find("LastNameField").set("v.value", caseRecord.Contact.Name);
                }
                if(caseRecord.Email__c !=null && caseRecord.Email__c !=''){
                   component.find("EmailField").set("v.value", caseRecord.Email__c);
                }else {
                    component.find("EmailField").set("v.value", caseRecord.ContactEmail);
                }
                component.find("PhoneField").set("v.value", caseRecord.Phone_Number__c);
                component.find("RequestCategoryField").set("v.value", caseRecord.Request_Category__c);
                component.find("PreferredLocationField").set("v.value", caseRecord.Preferred_Location__c);
                var value=[];
                value.push(caseRecord.Description);
                value.push(caseRecord.Detail_business_Enquiry__c);
                console.log('value***'+value);
                component.find("DescriptionField").set("v.value", value.join('\r\n'));
               // component.find("DescriptionField").set("v.value", caseRecord.Description+'\n'+caseRecord.Detail_business_Enquiry__c);
               // component.find("CompanyField").set("v.value", caseRecord.Account.Name);

            }             
        });
        $A.enqueueAction(action);
        
        
        // requires inputFields to have aura:id
    },
    handleSubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var fields = event.getParam("fields");
        fields["Related_Case__c"]=component.get("v.recordId");
        fields["LeadSource"]= "Call Center";
        component.find('createLeadForm').submit(fields); // Submit form
        console.log('handle handleSubmit');
        $A.get('e.force:refreshView').fire();
    },
    handleSuccess : function(component, event, helper) {
        console.log('record updated successfully');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"title": "Success!","message": "The property's info has been updated.","type": "success"});
	toastEvent.fire();
        helper.showHide(component);	
    },
})
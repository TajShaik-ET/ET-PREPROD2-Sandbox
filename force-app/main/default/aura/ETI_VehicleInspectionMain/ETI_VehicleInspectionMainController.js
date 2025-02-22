({
	doinit : function(component, event, helper) {
        console.log('-MainPage--- ');
        helper.setCommunityLanguage(component, event, helper);
        var action = component.get("c.getAccountDetails");
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state>>---- '+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result onload>> '+JSON.stringify(result));
                if(result!=undefined && result!=null){
                    component.set("v.selectedEmirate",result.ET_Changed_Location__c);
                    if(result.ET_Changed_Location__c == 'Abu Dhabi' || result.ET_Changed_Location__c == 'Fujairah' ||result.ET_Changed_Location__c == 'Sharjah' ){
                        component.set("v.showAlertPopup",false);
                    }else {
                        component.set("v.showAlertPopup",true);
                    }
                    console.log('PersonMobilePhone>>---- '+result.PersonMobilePhone);
                    if(result.Preferred_Language__c ==null || result.Preferred_Language__c =='' || result.PersonMobilePhone ==undefined || result.PersonMobilePhone ==''){
                        if(result.Preferred_Language__c ==null || result.Preferred_Language__c =='')
                            component.set("v.showPreferredLanguage",true);
                        if(result.PersonMobilePhone =='' || result.PersonMobilePhone ==undefined)
                            component.set("v.showPersonMobilePhone",true);
                        component.set("v.account",result);
                        component.set("v.showPopup",true);
                    }
                }
            }
        });
        $A.enqueueAction(action);
	},
    redirectToHOme : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/customer/s"
        });
        urlEvent.fire();
    },
    
    updateAccount: function(component, event, helper) {
        var isValueMissing=false;
        var letters = /^[0-9]+$/;
        if (component.get("v.showPreferredLanguage") && (component.find('Cust_Language').get('v.value') == '' || component.find('Cust_Language').get('v.value') == undefined)){
            component.set('v.errorLanguage',true);
            isValueMissing = true;
        }else {
            component.set('v.errorLanguage',false);
        }
       
        if(component.get("v.showPersonMobilePhone")){
            if(component.find('Cust_mobileNo').get('v.value') == '' || component.find('Cust_mobileNo').get('v.value') == undefined){
                component.find('Cust_mobileNo').setCustomValidity(component.get("v.Field_is_required"));
                component.find('Cust_mobileNo').reportValidity();
                isValueMissing = true;
        	}else if (component.find('Cust_mobileNo').get('v.value').length != 12) {
                component.find('Cust_mobileNo').setCustomValidity(component.get("v.Mobile_Number_12"));
                component.find('Cust_mobileNo').reportValidity();
                isValueMissing = true;
            }else if(component.find('Cust_mobileNo').get('v.value').substring(0, 3) !='971'){
                component.find('Cust_mobileNo').setCustomValidity(component.get("v.Mobile_Number_should_start_with_971"));
                component.find('Cust_mobileNo').reportValidity();
                isValueMissing = true;
            }else if(!component.find('Cust_mobileNo').get('v.value').toString().match(letters)){
            component.find('Cust_mobileNo').setCustomValidity(component.get("v.Enter_only_numbers"));
            component.find('Cust_mobileNo').reportValidity();
            isValueMissing = true;
        }else{
                 component.find('Cust_mobileNo').setCustomValidity("");
                 component.find('Cust_mobileNo').reportValidity();
            }
        }
        if(isValueMissing)
            return true;
        var upAcc = component.get("v.account");
        upAcc.PersonMobilePhone = '+'+upAcc.PersonMobilePhone;
        var action = component.get("c.updatePreferredLanguage");
        action.setParams({
            accountObj : component.get("v.account")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state>> '+state);
            if (state === "SUCCESS") {
                component.set("v.showPopup",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": component.get("v.Success"),
                    "message": component.get("v.Details_Updated_Successfully")
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action); 
        
    },
    handleSaveSuccess : function(component, event) {
        component.set("v.saveState", "SAVED");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": component.get("v.Success"),
            "message": component.get("v.Details_Updated_Successfully")
        });
        toastEvent.fire();
    }
})
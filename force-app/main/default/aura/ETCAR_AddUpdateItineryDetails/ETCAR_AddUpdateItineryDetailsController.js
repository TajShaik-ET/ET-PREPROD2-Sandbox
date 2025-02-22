({
    doInit: function (component, event, helper) {  
        
        var action = component.get('c.getRequestDetials');  
        action.setParams({ 
            recId : component.get("v.recordId")
        });  
        action.setCallback(this, function(response) {  
            var state = response.getState();  
            let result = response.getReturnValue();
            if ( state === 'SUCCESS') { 
                if(result.ETST_Service_Type__c === 'Hourly'){
                    component.set("v.durationInHours", true);
                    component.set("v.isLimo", true);
                }else if(result.ETST_Service_Type__c === 'One Way'){
                    component.set("v.durationInHours", false);
                    component.set("v.isLimo", true);
                }
                else if(result.ETST_Service_Type__c === 'Rental'){
                    component.set("v.isLimo", false);
                    component.set("v.durationInHours", false);
                }
            }   
            
        });  
        $A.enqueueAction(action);  
        
    },  
    handleFormLoad :function(component, event, helper) {
        var eventParams = event.getParams();
        var rec = component.get("v.serviceRequestRecord");
        var record= eventParams.recordUi.record;
        console.log(eventParams);
        rec.ETST_Pick_Up_From__c=record.fields.ETST_Pick_Up_From__c.value;
        rec.ETST_Drop_Off_To__c=record.fields.ETST_Drop_Off_To__c.value;
        component.set("v.serviceRequestRecord",rec);
        component.set("v.isloaded",true);
    },
    handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The Itinery details has been updated.",
            "type": "success"
        });
        toastEvent.fire();
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    handleCancel : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    handleError: function (cmp, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "There has been some error, please check with Admin.",
            "type": "error"
        });
        toastEvent.fire();
    },
    
    getPickupLocation: function(component, event, helper) {
        var searchText=component.get("v.serviceRequestRecord.ETST_Pick_Up_From__c");
        helper.getAddressRecommendations(component,event,searchText);
    },
    getDropoffLocation: function(component, event, helper) {
        console.log('---getDropoffLocation---');
        component.set('v.isDropoff',true);
        // component.set('v.serviceRecord.ETST_Dropoff_Location__Longitude__s','');
        //$A.util.removeClass(component.find("Drop-Address-listbox"), "slds-hide");
        var searchText=component.get("v.serviceRequestRecord.ETST_Drop_Off_To__c");
        console.log('searchTextdrop = '+searchText);
        helper.getAddressRecommendations(component,event,searchText);
    },
    selectDropOffOption:function(component, event, helper) {
        console.log('---selectOption---');
        component.set('v.isDropoff',true);
        helper.getAddressDetailsByPlaceId(component, event);
    },
    selectPickUpOption:function(component, event, helper) {
        console.log('---selectOption---');
        var str = event.currentTarget.dataset.address;;
        console.log('str  = ' + str);
        var result = str.includes("Airport");
        console.log('result = '+ result);
        if(result){
            component.set("v.flightdetails",true);
        }else{
            component.set("v.flightdetails",false);
        }
        helper.getAddressDetailsByPlaceId(component, event);
    },
    hoursChange: function(component, event, helper) {
        var hrs = component.find("additionalHoursId").get("v.value");
        console.log('hrs '+hrs);
        debugger;
        console.log('label '+$A.get("$Label.c.ETCRentalCarsDurationHours"));
        if(hrs == $A.get("$Label.c.ETCRentalCarsDurationHours")){
            component.set("v.additionalHours",true); 
        }else{
            component.set("v.additionalHours",false); 
            component.set("v.serviceRequestRecord.ETC_Additional_Hours__c",'');
            
        }
    }
})
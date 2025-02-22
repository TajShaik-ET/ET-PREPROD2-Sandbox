({
	doInit : function(component, event, helper) {
       
		helper.getCheckListDetails(component, event, helper);
	},
    getoption : function(component, event, helper) {
        
    },
    handleLoad : function(component, event, helper) {
        
    },
    
    onRecordSubmit : function(component, event, helper) {
/*
        //console.log('Lightning Record Form'+component.find('clinelist'));
        console.log('tender'+component.find("tender").get("v.value"));
        console.log('onRecordSubmit');
        
        event.preventDefault(); // stop form submission
        var evFields = event.getParam("fields");
        
        evFields["ETSALES_Tender__c"] = component.find("tender").get("v.value");
    	evFields["ETSALES_Checklist__c"] = component.find("checkList").get("v.value");
        evFields["ETSALES_Status__c"] = component.find("option").get("v.value");
        evFields["ETSALES_Assign_To__c"] = component.find("userId").get("v.value");
        evFields["ETSALES_Required__c"] = component.find("required").get("v.value");
    	event.setParam("fields", evFields);
        component.find('clinelist').submit(evFields);*/
    },
    onerror : function(component, event, helper) {
        console.log('error--------');
    },
    handleSuccess : function(component, event, helper) {
	    
	//Redirect to detail page on success
	var payload = event.getParams().response;
        var navService = component.find("navService");
    
        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                "recordId": payload.id,
                "objectApiName": ETSALES_Check_List_Lines__c,
                "actionName": "view"
            }
        }
        event.preventDefault();
        navService.navigate(pageReference);
    },
    getuserId : function(component, event, helper) {
        
    },
    setVisible : function(component, event, helper) {
        //alert('setVisible');
        //helper.handleStatusChange(component, event, helper);
    },
    handleSubmit : function(component, event, helper) {
		helper.handleSubmitHelper(component, event, helper);
	},
    
    handleCancel : function(component, event, helper) {
		 $A.get("e.force:closeQuickAction").fire();
	},
})
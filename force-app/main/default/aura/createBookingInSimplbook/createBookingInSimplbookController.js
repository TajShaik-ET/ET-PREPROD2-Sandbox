({
    doInit : function(component, event, helper) {
        component.set("v.showSpinner",true);
    },
    onForceLoad : function(component, event, helper) {
        
        let data = component.get("v.record");
        let hasError = false;
       
        if(data.Appointment_Date__c && data.Email && data.MobilePhone && data.Vehicle_Brand__c &&data.Vehicle_Brand__r.Name && data.Moto_Vehicle_Model__c && data.Moto_Vehicle_Model__r.Name && data.ETM_Vehicle_Model__c && data.List_of_Required_Services__c && data.Service_Cateogry__c){
            
            if(data.Type_of_Services__c=='Campaign' && !data.Campaign__c && !data.Campaign__r.Simplybook_Service_Id__c && !data.Campaign__r.Simplybook_Category_Id__c){
              
                hasError = true;
                
            }
            
            hasError = false;
            
        }else{
            hasError = true;
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Error",
                "title":"Error",
                "message":"Please fill required details",
                "mode":"dismissible"
            });
            toastReference.fire();

        }
        if(!hasError){
            helper.sendToSimplybook(component, event, helper);
        }else{
             component.set("v.showSpinner",false);
        }
    }
})
({
    doInit: function (component, event, helper) {        
      
        helper.getCustomerAmountInfo(component, event, helper);
    },
	 handleOnLoad : function(component, event, helper) {
      
    },
   
    handleOnSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id;
        var accId = component.get("v.recordId");
        var dispositionCode = component.get("v.dispositionCode");
        console.log('-disposition--'+dispositionCode);
        //need to change disposition code before deploying
        //production a7k3z000000PSy0AAG
        //sandbox (etdev) a7Z8E000000Hak6UAC
        if(dispositionCode == 'a7k3z000000PSy0AAG'){
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:disputeCreationContainer",
                componentAttributes: {
                    recId : accId,
                    collectorLogId : myRecordId,
                }
            });
            evt.fire();
        }else{
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId":myRecordId,
            });
            navEvt.fire();
        }
        
        component.set("v.showSpinner",true);
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Record has been saved!",
            "type": "success",
        }).fire();
    },
    
    handleOnSubmit : function(component, event, helper) {
        component.set("v.showSpinner",true);
        component.set("v.buttonDisable", true);
          
    },
    handleOnError: function (component, event, helper) {
        component.set("v.showSpinner",false);
        component.set("v.buttonDisable", false);
       
        var errorMessage = event.getParam("message");
        console.log(errorMessage)       
       
    },
    dispositionHandler :function (component, event, helper) {
   
    let dspCode=component.get("v.dispositionCode");
    let dspCodeList=component.get("v.dispositionList");
        dspCodeList.forEach(function(item){
            if(item.Id==dspCode){
                component.set("v.remarks",item.Remark__c);
                return false;
            }
        });
   },
   onAccountLoad: function (component, event, helper) {
        var customerOracleId=component.get("v.accountRecord").ETSALES_Customer_Account_Id__c;
        var OracleIdisempty= $A.util.isEmpty(customerOracleId);
       
        if(OracleIdisempty!=false){
            component.set("v.showSpinner",true);
            component.set("v.buttonDisable", true);
            console.log(component.get("v.accountRecord"));
            console.log(component.get("v.accountRecord").ETSALES_Customer_Account_Id__c);
            $A.get('e.force:showToast').setParams({
                "title": "Error",
                "message": "There is no Account number in the Account",
                "type": "Error",
            }).fire();
        }
    }
        
})
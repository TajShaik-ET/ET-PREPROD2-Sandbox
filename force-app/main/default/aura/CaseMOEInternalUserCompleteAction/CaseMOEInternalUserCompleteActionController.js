({
    doInit : function(component, event, helper) {
        component.set("v.spinner", true); 
        component.set("v.confirmFlag", true);
        helper.doInit(component, event, helper);
    },
    closeConfirmModal : function(component, event, helper){
       // $A.get("e.force:closeQuickAction").fire();
        component.set("v.confirmFlag",false);
    },
    saveRecord : function(component, event, helper){
        console.log('saveRecord function called');
        var req = component.get('v.currentrecType');
        debugger;
       
        /*var driverName = component.find("driverName").get("v.value");
        var driverNumber = component.find("driverNumber").get("v.value");
        var validityName = component.find("driverName").get("v.validity");
        var validityNumber = component.find("driverNumber").get("v.validity");
        console.log("validityName***"+validityName.valid);
        console.log("validityNumber***"+validityNumber.valid);
        if(driverName == null || driverName == '' || driverName == 'undefined' && driverNumber == null || driverNumber == '' || driverNumber == 'undefined'){
            component.find("driverName").showHelpMessageIfInvalid();
            component.find("driverNumber").showHelpMessageIfInvalid();
            component.set("v.isDisabled", false);
        }
        if(validityName.valid === true && validityNumber.valid === true){
            helper.updateCaseStatus(component, event, helper);  
        }
        added uncomment
        */
        
        
       /* if(isNaN(driverNumber)){
            driverNumber = "";
            validityName.valid = false;
        }
        if(!driverName.match(/[a-z]/i)){
            driverName="";
            validityNumber.valid = false;
        }*/
      	
       /* else{
            helper.updateCaseStatus(component, event, helper);
        } */
        
       /* var allValid = component.find('driverNumber').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
         }, true);
         if (allValid) {
             helper.updateCaseStatus(component, event, helper);  
         } */
      //  var caseCommentsList = component.find('caseComments');
       
       // var validityName = component.find("driverName").get("v.validity");       
      // var casecomments = component.find("caseComments").get("v.value");  
       // var validityNumber = component.find("driverNumber").get("v.validity");
      //  var validityCase = component.find("caseComments").get("v.validity");

        let showerror = false;
        if (req === 'Global_Event_Request') {
            helper.updateCaseStatus(component, event, helper);
        } else {
            //var driverName = component.find("driverName").get("v.value");
            //var driverNumber = component.find("driverNumber").get("v.value");
            var casecomments = component.find("caseComments").get("v.value");  
            if(casecomments == null || casecomments == '' || casecomments == 'undefined'){
                showerror = true;
                
            }
            /*else if(driverName == null || driverName == '' || driverName == 'undefined'){
                showerror = true;
            }
                else if(driverNumber == null || driverNumber == '' || driverNumber == 'undefined'){
                    showerror = true;
                }*/
                    else{
                        showerror = false;
                    }
            
            if(showerror){
                $A.get('e.force:showToast').setParams({
                    "title": "Error",
                    "message": "Comments are mondatory",
                    "type": "Error",
                }).fire();
                
            }
            else{
                
                helper.updateCaseStatus(component, event, helper);  
            }
        }
        
    
        
    },
    globalCaseHandler: function(component, event, helper) {
     
    },
    showSpinner: function(component, event, helper) {
      component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){   
        component.set("v.spinner", false);
    }
})
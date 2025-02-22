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
        var caseCommentsList = component.find('caseComments');
        var driverName = component.find("driverName").get("v.value");
        var driverNumber = component.find("driverNumber").get("v.value");
        var validityName = component.find("driverName").get("v.validity");       
        var casecomments = component.find("caseComments").get("v.value");  
        var validityNumber = component.find("driverNumber").get("v.validity");
        var validityCase = component.find("caseComments").get("v.validity");

        let showerror = false;
        if(casecomments == null || casecomments == '' || casecomments == 'undefined'){
            showerror = true;
            
        }else if(driverName == null || driverName == '' || driverName == 'undefined'){
            showerror = true;
        }
            else if(driverNumber == null || driverNumber == '' || driverNumber == 'undefined'){
                showerror = true;
            }
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
            //alert('This is Capital Complete ');
            helper.updateCaseStatus(component, event, helper);  
        }
      
    },
    showSpinner: function(component, event, helper) {
      //  component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){   
        component.set("v.spinner", false);
    }
})
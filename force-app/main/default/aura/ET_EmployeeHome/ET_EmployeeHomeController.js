({
    doInit : function(component, event, helper) {
        helper.getUserDetails(component, event, helper);
        component.set("v.showEmpHome", true);
     },
    
    handleSelectTab : function(component, event, helper) {   
      /***Commented by Janardhan on 25/04/23 **/
        
        /*let tab = component.get('v.selectedTab');
          let selTab = component.get('v.FormVisibility');
                console.log('selTab'+JSON.stringify(selTab));

        if((tab == 'DriverForm') && (selTab.includes('Driver Checklist Form'))) {
            component.set("v.showDriverForm",true);
            component.set("v.showSchoolForm",false);
            component.set("v.showMonitoringForm",false);
        }
        
        if((tab == 'SchoolForm') && (selTab.includes('School Visit Form'))){
            component.set("v.showSchoolForm",true);
            component.set("v.showDriverForm",false);
            component.set("v.showMonitoringForm",false);
        }
        
        if((tab == 'monitoringForm') && (selTab.includes('Field Monitoring Form'))){
            component.set("v.showMonitoringForm",true);
            component.set("v.showDriverForm",false);
            component.set("v.showSchoolForm",false);
        }
        //Changed by akash
         if((tab == 'ETdi') && (selTab.includes('ETDI Booking Request'))){
            component.set("v.showETDIRequestForm",true);
            
          // component.set("v.showDriverForm",false);
           // component.set("v.showSchoolForm",false);
        }
*/
        
    },
    handleEvent : function(component, event, helper) {
        var showHome = event.getParam("showHome");
        var showTask = event.getParam("showTask");
        var showLeave = event.getParam("showLeave");
        var showSalary = event.getParam("showSalary");
        var showInsurance = event.getParam("showInsurance");
        var showSupport = event.getParam("showSupport");
        component.set("v.showHome", showHome);
        component.set("v.showTask", showTask);
        component.set("v.showLeave", showLeave);
        component.set("v.showSalary", showSalary);
        component.set("v.showInsurance", showInsurance);
        component.set("v.showSupport", showSupport);
        
    },
    handleClick: function(component, event, helper) {
        
        var navService = component.find("navService");
        var pageReference = {
            type: "standard__recordPage",
            attributes: {
                recordId: $A.get("$SObjectType.CurrentUser.Id"),
                objectApiName: "Profile",
                actionName: "view"
            }
        };
        navService.navigate(pageReference);
    },
    
   
    
    
})
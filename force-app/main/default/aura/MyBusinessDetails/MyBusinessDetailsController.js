({
    doInit: function (component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
        
        var action = component.get('c.getUserAccountDetails');
        action.setParams({
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.businessWrapper', a.getReturnValue());
                var salesAgCounter = 0;
                var vehicleCounter = 0;
                var resorceCounter = 0;
                var invoiceCounter = 0;
                var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                
                for (var item in result.salesAgreementList) {
                    if (result.salesAgreementList[item].Contract_Status__c == 'Active'  ||
                       result.salesAgreementList[item].Contract_Status__c == 'ACTIVE') {
                        salesAgCounter++;
                    }
                }
                for (var item in result.assignedVehicleList) {
                    if (result.assignedVehicleList[item].Assign_End_Date__c >= today) {
                        vehicleCounter++;
                    }
                }
                for (var item in result.assignedResourcesList) {
                    if (result.assignedResourcesList[item].Assign_End_Date__c >= today) {
                        resorceCounter++;
                    }
                }
                for (var item in result.invoicesList) {
                    if (result.invoicesList[item].Contract_End_Date__c >= today) {
                        invoiceCounter++;
                    }
                }
                component.set('v.activeSalesAgreements', salesAgCounter);
                component.set('v.activeVehicles', vehicleCounter);
                component.set('v.activeResources', resorceCounter);
                component.set('v.activeInvoices', invoiceCounter);
                component.set('v.activeSchools', result.schoolsCount);
                component.set('v.activeStudents', result.studentsCount);
               component.set('v.studentsList', result.studentsList);
                
                
            }
        });
        $A.enqueueAction(action);
    },
    showCaseModal: function(component,event){
        var modalBody;
        var modalFooter;
        var idx = event.getSource().get("v.name");
         console.log(event.getSource().get("v.name")); 
         console.log('&&&&&&&&&&&INSIDECHILD'+idx);
        $A.createComponents([
            ["c:CaseB2BPopup",{
                "recordId": idx,
            }]
        ],
         function(components, status){
             console.log('&&&&&&&&&&&2'+status);
             if (status === "SUCCESS") {
                 modalBody = components[0];
                 console.log('&&&&&&&&&&&3');
                 component.find('overlayLib').showCustomModal({
                     header: "Create Complaint",
                     body: modalBody,
                     footer: modalFooter,
                     showCloseButton: true,
                     cssClass: "my-modal,my-custom-class,my-other-class",
                     closeCallback: function() {
                     }
                 });
             }
         });
        
        
    },
    handleApplicationEvent: function (component, event) {
        
        var myBusinessDashboard = event.getParam("salesAgreementDashboard");
        var sAg = event.getParam("salesAgreement");
        var assignRes = event.getParam("assignResources");
        var vehicle = event.getParam("assignVehicles");
        var inv = event.getParam("invoices");
        
        var agreementClick = event.getParam("salesAgreementClick");
        var resourceClick = event.getParam("assignResourcesClick");
        var vehicleClick = event.getParam("assignVehiclesClick");
        var invClick = event.getParam("invoicesClick");
        var govtSchool = event.getParam("govtSchool");
        
        component.set("v.salesAgreementDashboard", myBusinessDashboard);
        component.set("v.salesAgreement", sAg);
        component.set("v.assignResources", assignRes);
        component.set("v.assignVehicles", vehicle);
        component.set("v.invoices", inv);
        component.set("v.govtSchool", govtSchool);
        component.set("v.salesAgreementClick", agreementClick);
        component.set("v.assignResourcesClick", resourceClick);
        component.set("v.assignVehiclesClick", vehicleClick);
        component.set("v.invoiinvoicesClickces", invClick);
    },
    handleSalesAgreementClick: function (component, event, helper) {
        var recId = event.target.id;
        /*   var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":"et-sales-agreement/"
        });
        appEvent.fire(); */
        
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "et-sales-agreement/");
        
    },
    handleAssignedResourcesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        /* var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":'saline-assigned-resource/'
        });
        appEvent.fire();*/
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-resource/");
        
    },
    handleAssignedVehiclesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        /*   var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":'saline-assigned-vehicle/'
        });
        appEvent.fire();*/
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-vehicle/");
    },
    handleinvoicesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        /*  var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":'invoice/'
        });
        appEvent.fire(); */
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "invoice/");
        
    },
     handleStudentsDashboard: function (component, event, helper) {
        
        component.set('v.salesAgreementClick', false);
        component.set('v.salesAgreement', false);
        
        component.set('v.assignResources', false);
        component.set('v.assignResourcesClick', false);
        
        component.set('v.assignVehiclesClick', false);
        component.set('v.assignVehicles', false);
        
        component.set('v.invoicesClick', false);
        component.set('v.invoices', false);
        
        component.set('v.studentsClick', true);
        component.set('v.students', true);

        component.set('v.salesAgreementDashboard', false);
    },
     handleSalesAgreementClickDashboard: function (component, event, helper) {
        
        component.set('v.salesAgreementClick', true);
        component.set('v.salesAgreement', true);
        
        component.set('v.assignResources', false);
        component.set('v.assignResourcesClick', false);
        
        component.set('v.assignVehiclesClick', false);
        component.set('v.assignVehicles', false);
        
        component.set('v.invoicesClick', false);
        component.set('v.invoices', false);
         
         
        component.set('v.studentsClick', false);
        component.set('v.students', false);
        
        component.set('v.salesAgreementDashboard', false);
    },
    handleActiveResourceClickDashboard: function (component, event, helper) {
        
        component.set('v.assignResources', true);
        component.set('v.assignResourcesClick', true);
        
        component.set('v.salesAgreementClick', false);
        component.set('v.salesAgreement', false);
        
        component.set('v.assignVehiclesClick', false);
        component.set('v.assignVehicles', false);
        
        component.set('v.invoicesClick', false);
        component.set('v.invoices', false);
        
        
        component.set('v.studentsClick', false);
        component.set('v.students', false);
        component.set('v.salesAgreementDashboard', false);
    },
    handleActiveVehiclesClickDashboard: function (component, event, helper) {
        
        component.set('v.assignVehiclesClick', true);
        component.set('v.assignVehicles', true);
        
        component.set('v.salesAgreementClick', false);
        component.set('v.salesAgreement', false);
        
        component.set('v.assignResources', false);
        component.set('v.assignResourcesClick', false);
        
        component.set('v.invoicesClick', false);
        component.set('v.invoices', false);
        
        
        component.set('v.studentsClick', false);
        component.set('v.students', false);
        
        component.set('v.salesAgreementDashboard', false);
    },
    handleActiveInvoicesClickDashboard: function (component, event, helper) {
        
        component.set('v.invoicesClick', true);
        component.set('v.invoices', true);
        
        component.set('v.assignVehiclesClick', false);
        component.set('v.assignVehicles', false);
        
        component.set('v.salesAgreementClick', false);
        component.set('v.salesAgreement', false);
        
        component.set('v.assignResources', false);
        component.set('v.assignResourcesClick', false);
        
        
        component.set('v.studentsClick', false);
        component.set('v.students', false);
        
        component.set('v.salesAgreementDashboard', false);
    },
})
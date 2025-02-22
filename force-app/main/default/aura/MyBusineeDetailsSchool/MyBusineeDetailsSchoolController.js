({
    doInit1 : function(component, event, helper) {
		helper.doInit(component, event, helper);
	},
    saveOpp: function(component, event, helper) {
        var allValid = component.find('form1').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
 
        if (allValid) {
		helper.saveOppHelper(component, event, helper);
        }
	},
    openMoreActionWindow: function(component, event, helper) {
        var item=event.getSource().get('v.value');
        component.set('v.currentPO',item);
		component.set('v.more', true); 
	},
    closeModel: function(component, event, helper) {
		helper.resetFlags(component);
	},
    openAddMoreWindow: function(component, event, helper) {
        component.set('v.terminateRequest', false); 
       component.set('v.addMore', true); 
	}, 
    addMoreRequestController: function(component, event, helper) {
		component.set('v.addMoreRequest', true); 
	}, 
    openTerminateRequestController: function(component, event, helper) {
        component.set('v.caseRecord.Business_Request_Type__c',component.find('TerminateReq').get('v.value'));
         component.set('v.addMore', false); 
        component.set('v.terminateRequest', true); 
	}, 
    terminateRequestController : function(component, event, helper) {
        var allValid = component.find('form2').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
 
        if (allValid) {
        helper.terminateRequestHelper(component, event, helper);
        }
	},
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
                 var cntmap=0;
                for(var cnt in result.poList){
                    cntmap++;
                }
                var custs=[];
                for ( var key in result.poList ) {
                    custs.push({value:result.poList[key], key:key});
                }
                component.set("v.poList", custs);
                component.set('v.activeSalesAgreements', cntmap);
                component.set('v.activeInvoices', result.invCount); 
                component.set('v.activeSites', result.sitesCount);
                component.set('v.activeStudents', result.studentsCount);
                component.set('v.accountId', result.accRecord);
                           
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
    handleVehicleCount: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set("v.assignVehicles", true);
        var monthNo = event.target.id;
        helper.showVehiclesHelper(component, event, helper,monthNo);
        
    },
    handleResourceCount: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set("v.assignResources", true);
        var monthNo = event.target.id;
        helper.showResourcesHelper(component, event, helper,monthNo);
        
    },
    handleSalesAgreementClick: function (component, event, helper) {
        var recId = event.target.id;
        helper.resetDashBoard(component);
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "et-sales-agreement/");
        
    },
    handleAssignedResourcesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        //helper.resetDashBoard(component);
        //component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-resource/");
        
        $A.createComponent(
            "c:BusinessCommunityRecordDetailPopup",{
               showIFrame: true,
               recordDetailId:component.get("v.recordDetailId"),
               recordTypeName:component.get("v.recordTypeName")
            },
            function(newcomponent){
                if (component.isValid()) {
                    var body = component.get("v.body");
                    body.push(newcomponent);
                    component.set("v.body", body);             
                }
            }            
        );  
        
    },
    handleAssignedVehiclesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        helper.resetDashBoard(component);
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-vehicle/");
        
        $A.createComponent(
            "c:BusinessCommunityRecordDetailPopup",{
               showIFrame: true,
               recordDetailId:component.get("v.recordDetailId"),
               recordTypeName:component.get("v.recordTypeName")
            },
            function(newcomponent){
                if (component.isValid()) {
                    var body = component.get("v.body");
                    body.push(newcomponent);
                    component.set("v.body", body);             
                }
            }            
        );  
    },
    handleinvoicesClick: function (component, event, helper) {
        
        var recId = event.target.id;
       helper.resetDashBoard(component);
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "invoice/");
       
          $A.createComponent(
            "c:BusinessCommunityRecordDetailPopup",{
               showIFrame: true,
               recordDetailId:component.get("v.recordDetailId"),
               recordTypeName:component.get("v.recordTypeName")
            },
            function(newcomponent){
                if (component.isValid()) {
                    var body = component.get("v.body");
                    body.push(newcomponent);
                    component.set("v.body", body);             
                }
            }            
        );        
        
      
        
    },
    handleSitesClickDashboard: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set('v.sites',true);
        helper.getSiteDetailsHelper(component, event, helper);
    },
  
     handleSalesAgreementClickDashboard: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set('v.salesAgreement', true);
        
    },
    handleActiveResourceClickDashboard: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set('v.assignResources', true);
        
    },
    handleActiveVehiclesClickDashboard: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set('v.assignVehiclesClick', true);
        
    },
     handleStudentsDashboard: function(component, event, helper) {
          helper.resetDashBoard(component);
        component.set('v.isStudent',true);	   
        helper.getStudentListHelper(component, event, helper);
        
    },
    handleActiveInvoicesClickDashboard: function (component, event, helper) {
        helper.getInvHelper(component, event, helper);
        helper.resetDashBoard(component);
        component.set('v.invoices', true);
        
    },
    handleUploadFinished: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Time sheet uploaded successfully."
        });
        toastEvent.fire();
    },
    searchInvoices: function(component, event, helper) {
        var searchKey=component.get('v.searchText');
        console.log('searchKey-->'+searchKey);
        if(searchKey.length>2){
            var deliveryData = component.get('v.invoicesList');
            var fileredData =  deliveryData.filter(function(item) {
                return (item.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
               // ||(item.Status.toLowerCase().indexOf(searchKey) !== -1);
            });
            
            component.set('v.currentInvoicesList',fileredData); 
        }else{
             component.set('v.currentInvoicesList',component.get('v.invoicesList'));  
        }
    
    },
    searchStudents: function(component, event, helper) {
        var searchKey=component.get('v.searchText');
        console.log('searchKey-->'+searchKey);
        if(searchKey.length>2){
            var deliveryData = component.get('v.studentsList');
            var fileredData =  deliveryData.filter(function(item) {
                return (item.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
               // ||(item.Status.toLowerCase().indexOf(searchKey) !== -1);
            });
            
            component.set('v.currentStudentsList',fileredData); 
        }else{
             component.set('v.currentStudentsList',component.get('v.studentsList'));  
        }
    
    },
    handleStudentClick: function (component, event, helper) {
        var recId = event.target.id;
          
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "etst-student/"); 
        
        $A.createComponent(
            "c:BusinessCommunityRecordDetailPopup",{
               showIFrame: true,
               recordDetailId:component.get("v.recordDetailId"),
               recordTypeName:component.get("v.recordTypeName")
            },
            function(newcomponent){
                if (component.isValid()) {
                    var body = component.get("v.body");
                    body.push(newcomponent);
                    component.set("v.body", body);             
                }
            }            
        );  
        
    },
    searchSites : function(component, event, helper) {
        var searchKey=component.get('v.searchText');
        console.log('searchKey-->'+searchKey);
        if(searchKey.length>2){
            var deliveryData = component.get('v.siteList');
            var fileredData =  deliveryData.filter(function(item) {
                return (item.Account.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
               // ||(item.Status.toLowerCase().indexOf(searchKey) !== -1);
            });
            
            component.set('v.currentsiteData',fileredData); 
        }else{
             component.set('v.currentsiteData',component.get('v.siteList'));  
        }
    
    },
    downloadResources :function(component, event, helper){
         
       var allResources=component.get("v.resourceList");
        var type='resource';
        //component.set("v.finalListToAdd",allResources);
        //var finalListToDownload=component.get("v.finalListToAdd");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources,type); 
        if(csv==null)
        {
            
          return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='ResourceExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
    downloadSites:function(component, event, helper){
         var type='site'; 
       var allResources=component.get("v.siteList");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources,type); 
        if(csv==null)
        {
            
          return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='SitesExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
    downloadVehicles :function(component, event, helper){
       var type='vehicle';  
       var allResources=component.get("v.vehileList");
        //component.set("v.finalListToAdd",allResources);
        //var finalListToDownload=component.get("v.finalListToAdd");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources,type); 
        if(csv==null)
        {
            
          return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='VehiclesExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
   showSalesAggs: function (component, event, helper) {
    helper.showSalesAggsHelper(component, event, helper);
        /*component.set('v.isSalesAggs',true);
        var item=event.getSource().get('v.value');
        var action = component.get('c.getsalesAggsforPO');
        action.setParams({
            POName: item
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.salesAgreementList', result);
                
            }
        });
        $A.enqueueAction(action);*/
    },
})
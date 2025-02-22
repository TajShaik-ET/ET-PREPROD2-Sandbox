({
	doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
        helper.getSchoolDetails(component, event, helper);        
	},
    handleSelectedMenu: function(component, event, helper) {
        helper.resetValues(component);
        var selected = component.get('v.selectedItem');
        if (selected === 'students') {
         	component.set('v.isStudent',true);	   
            helper.getStudentListHelper(component, event, helper);
        }else if (selected === 'Assign_Vehicles') {
         	component.set('v.isVehicle',true);	   
            helper.getvehicleListHelper(component, event, helper);
        }
        else if (selected === 'Assign_Resources') {
         	component.set('v.isResource',true);	   
            helper.getResourceListHelper(component, event, helper);
        }
         else if (selected === 'Sales_Agreement') {
         	component.set('v.isSA',true);	   
            helper.getSAListHelper(component, event, helper);
        }
        else if (selected === 'Schools') {
         	component.set('v.isSchool',true);	   
            helper.getSchoolListHelper(component, event, helper);
        }
        else if (selected === 'Invoices') {
         	component.set('v.isInvoice',true);	   
            helper.getInvoiceListHelper(component, event, helper);
        }
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
    handleStudentsDashboard: function(component, event, helper) {
        helper.resetValues(component);
        component.set('v.isStudent',true);	   
        helper.getStudentListHelper(component, event, helper);
        
    },
    handleSchoolsDashboard: function(component, event, helper) {
        helper.resetValues(component);
        component.set('v.isSchool',true);	   
        helper.getSchoolListHelper(component, event, helper);
        
    },
    handleSADashboard: function(component, event, helper) {
        helper.resetValues(component);
        component.set('v.isSA',true);	   
        helper.getSAListHelper(component, event, helper);
        
    },
    handleResourceDashboard: function(component, event, helper) {
        helper.resetValues(component);
        component.set('v.isResource',true);	   
        helper.getResourceListHelper(component, event, helper);
        
    },
    handleVehiclesDashboard: function(component, event, helper) {
        helper.resetValues(component);
        component.set('v.isVehicle',true);	   
        helper.getvehicleListHelper(component, event, helper);
        
    },
    handleInvoicesDashboard: function(component, event, helper) {
        helper.resetValues(component);
        component.set('v.isInvoice',true);	   
        helper.getInvoiceListHelper(component, event, helper);
        
    },
  handleStudentClick: function (component, event, helper) {
        var recId = event.target.id;
          
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "etst-student/");
        
    },
    handleAssignedResourcesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-resource/");
        
    },
    handleAssignedVehiclesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-vehicle/");
    },
    handleSalesAgreementClick: function (component, event, helper) {
        var recId = event.target.id;
          
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "et-sales-agreement/");
        
    },
    handleSchoolClick: function (component, event, helper) {
        var recId = event.target.id;
          
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "etst-school/");
        
    },
    handleinvoicesClick: function (component, event, helper) {
            
            var recId = event.target.id;
            component.set("v.showRecordDetailModal", true);
            component.set("v.recordDetailId", recId);
            component.set("v.recordTypeName", "invoice/");
            
        },
     searchRequest: function(component, event, helper) {
       
        var searchKey=component.get('v.searchText'); 
        if(searchKey.length>2){
            var data = component.get('v.SAList'); 
            console.log('data'+JSON.stringify(data));
            var fileredData =  data.filter(function(item) {
                return (item.Name.indexOf(searchKey) !== -1)||
                    (item.Contract_Status__c.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1)||
                    (item.Salesforce_Customer__r!=undefined ?(item.Salesforce_Customer__r.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1) : null);
                 
            });
              component.set('v.currentSAList',fileredData);
             //console.log('currentSAList'+JSON.stringify(fileredData));
            //component.set('v.totalRecords',fileredData.size); 
        }else{
            component.set("v.currentSAList",component.get("v.SAList"));
        }
    
    },
    searchResources: function(component, event, helper) {
        
        var searchKey=component.get('v.searchText'); 
        if(searchKey.length>2){
            var data = component.get('v.resourceList'); 
            console.log('data'+JSON.stringify(data));
            var fileredData =  data.filter(function(item) {
                return (item.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1)||
                    (item.Sales_Agreement__r!=undefined ?(item.Sales_Agreement__r.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1) : null);
                    //(item.Salesforce_Customer__r.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
            });
              component.set('v.currentResourceList',fileredData);
             //console.log('currentSAList'+JSON.stringify(fileredData));
            //component.set('v.totalRecords',fileredData.size); 
        }else{
            component.set("v.currentResourceList",component.get("v.resourceList"));
        }
    
    },
    searchVehicles: function(component, event, helper) {
        
        var searchKey=component.get('v.searchText'); 
        if(searchKey.length>2){
            var data = component.get('v.vehicleList'); 
            console.log('data'+JSON.stringify(data));
            var fileredData =  data.filter(function(item) {
                return (item.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1)||
                    (item.Vehicle_Number__c.indexOf(searchKey) !== -1)||
                    (item.Vehicle_Description__c!=undefined ?(item.Vehicle_Description__c.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1) : null)||
                    (item.Sales_Agreement__r!=undefined ?(item.Sales_Agreement__r.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1) : null);
                    //(item.Salesforce_Customer__r.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
            });
              component.set('v.currentVehicleList',fileredData);
             //console.log('currentSAList'+JSON.stringify(fileredData));
            //component.set('v.totalRecords',fileredData.size); 
        }else{
            component.set("v.currentVehicleList",component.get("v.vehicleList"));
        }
    
    },
    searchInvoices: function(component, event, helper) {
        
        var searchKey=component.get('v.searchText'); 
        if(searchKey.length>2){
            var data = component.get('v.invoiceList'); 
            console.log('data'+JSON.stringify(data));
            var fileredData =  data.filter(function(item) {
                return (item.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1)||
                    (item.Total_Inv_Amount__c.indexOf(searchKey) !== -1)||
                    (item.Description__c!=undefined ?(item.Description__c.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1) : null)||
                    (item.Sales_Agreement__r!=undefined ?(item.Sales_Agreement__r.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1) : null);
                    //(item.Salesforce_Customer__r.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
            });
              component.set('v.currentInvoiceList',fileredData);
             //console.log('currentSAList'+JSON.stringify(fileredData));
            //component.set('v.totalRecords',fileredData.size); 
        }else{
            component.set("v.currentInvoiceList",component.get("v.invoiceList"));
        }
    
    },
    searchStudents: function(component, event, helper) {
        
        var searchKey=component.get('v.searchText'); 
        if(searchKey.length>2){
            var data = component.get('v.studentsList'); 
            console.log('data'+JSON.stringify(data));
            var fileredData =  data.filter(function(item) {
                return (item.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1)||
                    (item.ETST_Student_Id__c.indexOf(searchKey) !== -1)||
                    (item.ETST_Emirates_Id__c!=undefined ?(item.ETST_Emirates_Id__c.indexOf(searchKey) !== -1) : null)||
                    (item.ETST_Account_Name__r!=undefined ?(item.ETST_Account_Name__r.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1) : null);
                    //(item.Salesforce_Customer__r.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
            });
              component.set('v.currentStudentsList',fileredData);
             //console.log('currentSAList'+JSON.stringify(fileredData));
            //component.set('v.totalRecords',fileredData.size); 
        }else{
            component.set("v.currentStudentsList",component.get("v.studentsList"));
        }
    
    },
    searchSchools: function(component, event, helper) {
        
        var searchKey=component.get('v.searchText'); 
        if(searchKey.length>2){
            var data = component.get('v.schoolsList'); 
            console.log('data'+JSON.stringify(data));
            var fileredData =  data.filter(function(item) {
                return (item.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1)||
                    (item.AccountNumber!=undefined ?(item.AccountNumber.indexOf(searchKey) !== -1) : null)||
					(item.ETST_Account_Type__c!=undefined ?(item.ETST_Account_Type__c.indexOf(searchKey) !== -1) : null)||
                    (item.ETST_SchoolRefID__c!=undefined ?(item.ETST_SchoolRefID__c.indexOf(searchKey) !== -1) : null);
                    //(item.Salesforce_Customer__r.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
            });
              component.set('v.currentSchoolsList',fileredData);
             //console.log('currentSAList'+JSON.stringify(fileredData));
            //component.set('v.totalRecords',fileredData.size); 
        }else{
            component.set("v.currentSchoolsList",component.get("v.schoolsList"));
        }
    
    },
})
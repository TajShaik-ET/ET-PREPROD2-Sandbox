({
	doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
        helper.getSchoolDetails(component, event, helper);    
        helper.setCommunityLanguage(component, event, helper);
	},
     showCaseModal: function(component,event){
        var modalBody;
        var modalFooter;
        var idx = event.getSource().get("v.name");
         console.log('Inside main modal'); 
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
        
    },
    
    handleStudentsDashboard: function(component, event, helper) {
        helper.resetValues(component);
        component.set('v.isStudent',true);	   
        helper.getStudentListHelper(component, event, helper);
        
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
    handleStudentClick: function (component, event, helper) {
        var recId = event.target.id;
          
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "etst-student/");
        
    }
    ,
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
})
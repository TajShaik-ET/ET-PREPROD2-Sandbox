({
	doInit : function(component, event, helper) {
		 helper.getDetails(component, event, helper);        
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
    handleSADashboard: function(component, event, helper) {
        helper.resetValues(component);
        component.set('v.isSA',true);	   
        helper.getSAListHelper(component, event, helper);
        
    },
    handleEstimationsDashboard: function(component, event, helper) {
        helper.resetValues(component);
        component.set('v.isEstimation',true);	   
        helper.getEstimationsListHelper(component, event, helper);
        
    },
    handleInvoicesDashboard: function(component, event, helper) {
        helper.resetValues(component);
        component.set('v.isInvoice',true);	   
        helper.getInvoiceListHelper(component, event, helper);
        
    },
  handleAssignedEstimationClick: function (component, event, helper) {
        
        var recId = event.target.id;
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "estimation/");
    },
    handleSalesAgreementClick: function (component, event, helper) {
        var recId = event.target.id;
          
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "et-sales-agreement/");
        
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
    searchEstimations: function(component, event, helper) {
        
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
    
})
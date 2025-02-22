({
	doInit : function(component, event, helper) {
		
         helper.getInsurancedetails(component, event, helper);
         
	},
    
    openRecord : function(component, event, helper) {
        
         var selectedItem = event.currentTarget;
       	var vehicleInsList = component.get('v.vehicleInsList');
        var index  = selectedItem.dataset.value;
        var recId = selectedItem.dataset.record;
        component.set('v.recordId', recId);
        component.set('v.detailPage', true);
    },
     handleback: function(component,event,helper){
        
        component.set('v.recordId', '');
        component.set('v.detailPage', false);
       
    },
    handleApproved : function(component,event,helper){
        
        helper.updateStatusWithAcceptAndReject(component,event,helper, 'Approved');
             
    },
    handlereject: function(component,event,helper){
            component.set('v.isModalOpen', true);        
      
    },
    closeModel: function(component, event, helper) {
            component.set("v.isModalOpen", false);
   },
   onRecordSubmit :function(component, event, helper) {
        
        event.preventDefault();
        
        var rejectVal = component.find("rejectReason").get("v.value"); 
        var eventFields = event.getParam("fields");
        
        if(!rejectVal){
            
            component.find('rejectReason').setCustomValidity("This field is required");
            component.find('rejectReason').reportValidity();  
        }else {
            
            eventFields["ETVIN_Rejection_Reason__c"] = rejectVal;
            component.find('accForm').submit(eventFields);   
                        
             
        }
        
        
    },
    
    handleSuccessReq :function(component, event, helper) {
        
         component.set("v.isModalOpen", false);
        
        
        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "dismissible",
                    message: 'The record has been rejected.',
                    type: 'Success',
                    title: 'Success!'
                });
                toastEvent.fire();
        
        
        component.set('v.recordId', '');
        component.set('v.detailPage', false);
        helper.getInsurancedetails(component, event, helper);
        
        
        var address = new URL(window.location.origin);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": address+'partnerportal/s',
            "isredirect" :false
        });
        urlEvent.fire();
    },
    
    
     getData : function(component, event, helper) {
        var params = event.getParam('arguments');
         
        if (params) {
            var searchKey = params.searchKeyWord.toLowerCase();
            if(searchKey.length>2){
               
                 var reqData = component.get('v.vehicleInsList');
               
                var fileredData =  reqData.filter(function(item) {
              
                 return (item.Name.toLowerCase().indexOf(searchKey) !== -1);
                 //return (item.FirstName.toLowerCase().indexOf(searchKey) !== -1); || (item.FirstName.toLowerCase().indexOf(searchKey) !== -1) || (item.LastName.toLowerCase().indexOf(searchKey) !== -1)
                  
             });
                component.set('v.FilteredData',fileredData);
            }else{
                           
             var data = component.get('v.vehicleInsList');
             component.set('v.FilteredData',data);
                
            }
             //console.log('--filter data--'+fileredData);
        }
       
    }
})
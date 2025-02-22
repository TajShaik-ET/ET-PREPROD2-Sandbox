({
	doInit : function(component, event, helper) {
        helper.getInsurancedetails(component, event, helper);
       var  recordId = component.get('v.recordId');
        if(recordId){
            
           helper.fetchContentDocument(component,event,helper); 
        }
        
    },
    openRecord: function(component,event,helper){
        
        
        var selectedItem = event.currentTarget;
       	var vehicleInsList = component.get('v.vehicleInsList');
        var index  = selectedItem.dataset.value;
        var recId = selectedItem.dataset.record;
        component.set('v.recordId', recId);
        component.set('v.detailPage', true);
        helper.fetchContentDocument(component,event,helper);
        //alert(recId)
    },
    handleApproved : function(component,event,helper){
       
        helper.updateStatusWithAcceptAndReject(component,event,helper, 'Approved');
       
    },
    handlereject: function(component,event,helper){
        
     component.set('v.isModalOpen', true);        
        
      
        //alert(recId)
    },
    handleback: function(component,event,helper){
        
        component.set('v.recordId', '');
        component.set('v.detailPage', false);
        //alert(recId)
    },
     closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
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
         
         component.set('v.showLoadingSpinner', true);
         helper.updateStatusWithAcceptAndReject(component,event,helper, 'Reject');  
       }
        
       
        
    },
    
   submitDetails: function(component, event, helper) {
       
      
      
      
     
     
      },
    getSelected : function(component,event,helper){
        // display modle and set seletedDocumentId attribute with selected record Id   
        //component.set("v.hasModalOpen" , true);
        component.set("v.selectedDocumentId" , event.currentTarget.getAttribute("data-Id")); 
        
        var rec_id = event.currentTarget.getAttribute("data-Id");
        
        $A.get('e.lightning:openFiles').fire({
            //Lightning Openfiles event  
            recordIds: [rec_id] //file id  
        });  
        
    },
    closeFileModel: function(component, event, helper) {
        // for Close Model, set the "hasModalOpen" attribute to "FALSE"  
        component.set("v.hasModalOpen", false);
        component.set("v.selectedDocumentId" , null); 
    },
    openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
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
       
    },
    
    
})
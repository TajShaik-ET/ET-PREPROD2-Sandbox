({
    doInit : function(component, event, helper) {
       
        helper.getInsurancedetails(component, event, helper);
         helper.getPicklistValues(component, event, helper, 'ETIN_Insurance_Transactions__c', 'ETIN_AP_Type__c', 'v.aptype');
         helper.getPicklistValues(component, event, helper, 'ETIN_Insurance_Transactions__c', 'ETIN_Invoice_Type__c', 'v.invoicetype');
         helper.getPicklistValues(component, event, helper, 'ETIN_Insurance_Transactions__c', 'Insurance_Type__c', 'v.insurancetype');
        var  recordId = component.get('v.recordId');
        if(recordId){
           helper.fetchContentDocument(component,event,helper);
        }
        
             
        },
    openRecord: function(component,event,helper){
        
        
        var selectedItem = event.currentTarget;
       	var vehicleInsList = component.get('v.vehicleInsList');
        var index  = selectedItem.dataset.value;
        component.set('v.vehicleInsurancePol', vehicleInsList[index]);
        var recId = selectedItem.dataset.record;
        component.set('v.recordId', recId);
        component.set('v.detailPage', true);
        helper.fetchContentDocument(component,event,helper);
        //alert(recId)
    },
    handleApproved : function(component,event,helper){
        component.set("v.isModalOpen", true);
        var trancs = component.get('v.InsuranceTransactions');
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        trancs.ETIN_Invoice_Date__c = today;
        component.set('v.InsuranceTransactions', trancs);
         component.set("v.isApproved", true);
        
         let org = window.location.origin;
        history.pushState(null, null, "/partnerportal/s/");
   
    },
    handlereject: function(component,event,helper){
         component.set("v.isModalOpen", true);
         component.set("v.isApproved", false);
         let org = window.location.origin;
        history.pushState(null, null, "/partnerportal/s/");
     
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
    
     submitDetails: function(component, event, helper) {
       
      
        var isAprroved  = component.get("v.isApproved");
      
       if(isAprroved){
             try{
               if(helper.validateFile(component, event, helper)){
                   //alert('success')
                 component.find("accForm123").submit();
                   
                  // var InsuranceTransactions  = component.get('v.InsuranceTransactions');
                  // console.log(JSON.stringify(InsuranceTransactions))
                  
               }
               
           }catch(err){
               alert(err.message)
           }
           
           //component.set("v.isModalOpen",false);
           
       }else{
         
            //component.find("accForm").submit();
           // helper.updateStatusWithAcceptAndReject(component,event,helper, 'Reject');
       }
     
       
   },
  
   onRecordSubmit: function(component, event, helper) {
       
       event.preventDefault();
        var isAprroved  = component.get("v.isApproved");
        var rejectVal = component.find("rejectReason").get("v.value"); 
        var eventFields = event.getParam("fields");
       
       if(rejectVal){
          
           eventFields["ETVIN_Rejection_Reason__c"] = rejectVal;
           eventFields["ETVIN_Request_Status__c"] = 'Insurance Rejected';
           component.find('accForm').submit(eventFields);
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "dismissible",
                    message: 'The record is been rejected.',
                    type: 'Success',
                    title: 'Success!'
                });
                toastEvent.fire();
           
           helper.getInsurancedetails(component, event, helper);
           component.set('v.recordId', '');
           component.set('v.detailPage', false);
           
          location.reload();
           
           
           
          // component.set('v.showLoadingSpinner', true);
          // helper.updateStatusWithAcceptAndReject(component,event,helper, 'Reject');  
          
           
       }else{
           
           component.find('rejectReason').setCustomValidity("This field is required");
           component.find('rejectReason').reportValidity();  
       }
       
       //component.find("accForm").submit();
       
    /*   if(isAprroved){
           try{
               if(!helper.validateFile(component, event, helper)){

                return ;
               }
               component.find("accForm123").submit();
           }catch(err){
               alert(err.message)
           }
           var InsuranceTransactions  = component.get('v.InsuranceTransactions');
           console.log(JSON.stringify(InsuranceTransactions))
           helper.updateStatusWithAcceptAndReject(component,event,helper, 'Approved');
           helper.uploadHelper(component,event, 'policyfileId', component.get("v.recordId"));
           
       }else{
           
           if(!rejectVal){
               
               component.find('rejectReason').setCustomValidity("This field is required");
               component.find('rejectReason').reportValidity();  
           }else {
               
               eventFields["ETVIN_Rejection_Reason__c"] = rejectVal;
               component.find('accForm').submit(eventFields);   
               
               component.set('v.showLoadingSpinner', true);
               helper.updateStatusWithAcceptAndReject(component,event,helper, 'Reject');  
           }
           
           
           
            //component.find("accForm").submit();
           // helper.updateStatusWithAcceptAndReject(component,event,helper, 'Reject');
       }
       */
       
   },
    openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
   },
    handleFilesChange: function(component, event, helper) {
        var a = event.getSource();
        var id = a.getLocalId();
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        if(id == 'policyfileId'){
             component.set("v.polfileName", fileName);
        }else{
             component.set("v.fileName", fileName);
        }
       
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
    
    getData : function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            var searchKey = params.searchKeyWord.toLowerCase();
            if(searchKey.length>2){
               
                 var reqData = component.get('v.vehicleInsList');
               
                var fileredData =  reqData.filter(function(item) {
              
                 return (item.Name.toLowerCase().indexOf(searchKey) !== -1) || (item.ETVIN_Internal_Number__c.toLowerCase().indexOf(searchKey) !== -1)  ;
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
    
    handleError : function(component, event, helper) {
        
       // alert('error')
    },
     handleSuccessCorrReq : function(component, event, helper) {
        
       var params = event.getParams();
        
        helper.updateStatusWithAcceptAndReject(component,event,helper, 'Approved');
        helper.uploadHelper(component,event, 'policyfileId', component.get("v.recordId"));
      //alert(params.response.id); 
         
     }
    
})
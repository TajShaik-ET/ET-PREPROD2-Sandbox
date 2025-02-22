({
	doInit : function(component, event, helper) {
		
        helper.getRenewInsRecds(component, event, helper);
        helper.getInsAdminRecds(component, event, helper);
        helper.getLoggedUserDetails(component, event, helper);
        
	},
    
      
    getSelectedRec : function(component,event,helper){
        
        
        var selectedRows = event.getParam('selectedRows');
       
        
        let obj =[] ;
         var setRows = []; 
        
        for (var i = 0; i < selectedRows.length; i++){
            obj.push(selectedRows[i].Id);
            setRows.push( selectedRows[ i ] );  
        }
        
        component.set("v.selectedRowIdList",obj);
       
        component.set( "v.selectedRowList", setRows );
        
        
        //console.log('---'+component.get("v.selectedRowList"));
        
    },
    submitToZOneHr :function(component,event,helper){
        
      var selectedRecs =  component.get('v.selectedRowList');
       
        if(selectedRecs.length == 0){
            
            helper.ErrorMsg(component,event,helper);
            
        }else{
            helper.submitToZone(component,event,helper);
        }
         
        
    },
    
    ApproveRenewalRequest :function(component,event,helper){
        
        var selectedRecs =  component.get('v.selectedRowList');
       
        if(selectedRecs.length == 0){
            
            helper.ErrorMsg(component,event,helper);
            
        }else{
            helper.submitToInsAdmin(component,event,helper);
        }
        
       
        
    },
    RejectRenewalRequest : function(component,event,helper){
        
         var selectedRecs =  component.get('v.selectedRowList');
       
        if(selectedRecs.length == 0){
            
            helper.ErrorMsg(component,event,helper);
            
        }else{
           helper.submitToZoneCoordinator(component,event,helper);
        }
        
        
    },
    ApproveByAdmin : function(component,event,helper){
         var selectedRecs =  component.get('v.selectedRowList');
       
        if(selectedRecs.length == 0){
            
            helper.ErrorMsg(component,event,helper);
            
        }else{
           helper.ApprovedByInsAdmin(component,event,helper);
        }
        
        
    },
    RejectByAdmin: function(component,event,helper){
         var selectedRecs =  component.get('v.selectedRowList');
       
        if(selectedRecs.length == 0){
            
            helper.ErrorMsg(component,event,helper);
            
        }else{
           helper.RejectedByInsAdmin(component,event,helper);
        }
       
    }
})
({
    doInit : function(component, event, helper) {
        
        helper.callGetRenewalDetails(component, event, helper);
        helper.callGetMasterDocDetails(component, event, helper);
        helper.callGetMasterPlansDetails(component,event, helper);
        helper.callGetClaimDocDetails(component, event, helper);
        helper.callGetDefaultInsPart(component, event, helper);
        helper.getPartnerList(component, event, helper);
        
        
    },
    
    handleEdit : function(component, event, helper) {
        console.log(event.getSource().get("v.name"));
        var record = event.getSource().get("v.value");
        console.log(JSON.stringify(record));
        if(record.Name == 'Renewal_Button')
            component.set("v.RenewBtnVisiblilty", true);
        if(record.Name == 'Claim_Button')
            component.set("v.ClaimBtnVisiblilty", true);
        if(record.Name == 'New Addition Button')
            component.set("v.NewAdditionBtnVisiblilty", true);
        if(record.Name == 'PopUp_Button')
            component.set("v.ShowPopupBtnVisiblilty", true);
    },
    
    handleSave : function(component, event, helper) {
        console.log(event.getSource().get("v.name"));
        var record = event.getSource().get("v.value");
        console.log(JSON.stringify(record));
        if(record.Name == 'Renewal_Button')
            component.set("v.RenewBtnVisiblilty", false);
        if(record.Name == 'Claim_Button')
            component.set("v.ClaimBtnVisiblilty", false);
        if(record.Name == 'New Addition Button')
            component.set("v.NewAdditionBtnVisiblilty", false);
        if(record.Name == 'PopUp_Button')
            component.set("v.ShowPopupBtnVisiblilty", false);
        if(record.Name != 'PopUp_Button'){
            var exeAction = component.get("c.updateRenewalButton");
            exeAction.setParams({ 
                "RecId": record.Id,
                "BooleanVal": record.Visibility__c
            });
            helper.serverSideCall(component,exeAction).then(
                function(res) {
                    console.log('----res---'+res);
                    helper.callGetRenewalDetails(component, event, helper);
                }
            ).catch(
                function(error) {
                    console.log('Error---'+JSON.stringify(error));
                }
            );
        }
        if(record.Name == 'PopUp_Button'){
            var action = component.get('c.updatePopupMsg');
            if (record.Message__c.length<=255){
                action.setParams({
                    "RecId": record.Id,
                    "BooleanVal": record.Visibility__c,
                    "popmessage": record.Message__c
                });
                helper.serverSideCall(component,action).then(
                    function(res) {
                        console.log('----res---'+res);
                        helper.callGetRenewalDetails(component, event, helper);
                    }
                ).catch(
                    function(error) {
                        console.log('Error---'+JSON.stringify(error));
                    }
                );
            }
            else {
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Error",
                    "title":"Error",
                    "message":'Please enter less than 255 characters',
                    "mode":"dismissible"
                });
                toastReference.fire();
            }
        }
    },
    
    handleCancel : function(component, event, helper) {
        console.log(event.getSource().get("v.name"));
        var record = event.getSource().get("v.value");
        console.log(JSON.stringify(record));
        if(record.Name == 'Renewal_Button')
            component.set("v.RenewBtnVisiblilty", false);
        if(record.Name == 'Claim_Button')
            component.set("v.ClaimBtnVisiblilty", false);
        if(record.Name == 'New Addition Button')
            component.set("v.NewAdditionBtnVisiblilty", false);
        if(record.Name == 'PopUp_Button')
            component.set("v.ShowPopupBtnVisiblilty", false);
        helper.callGetRenewalDetails(component, event, helper);
    },
    
    handleRowAction : function(component, event, helper) {
        
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log('---'+action.name+'--'+row.Id);		
    },
    
    handleSaveEdition : function(component, event, helper) {
        
        
    },
    
    handleEditInsPartner : function(component, event, helper) {
        
        component.set("v.InsPartnerBtnVisiblilty", true);
        component.set("v.AbuDhabiVisible", false);
        
    },
    handleCancelInsPartner :function(component, event, helper) {
        
        component.set("v.InsPartnerBtnVisiblilty", false);
        component.set("v.AbuDhabiVisible", true);
        $A.get('e.force:refreshView').fire();
        
    },
    
    handleSaveInsPartner : function(component, event, helper) {
        
        component.set("v.InsPartnerBtnVisiblilty", false);
        component.set("v.AbuDhabiVisible", true);
        
        var updateList = component.get("v.InsPartnerList");
        
        updateList[0].Account_ID__c = component.get("v.selectedSerachFilterValue");
        updateList[1].Account_ID__c = component.get("v.selectedSerachFilterValue2");
        
        var exeAction = component.get("c.updateInsPartList");
        exeAction.setParams({ 
            "UpdateList":updateList
            
        });
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                console.log('----res---'+res);
                helper.callGetDefaultInsPart(component, event, helper);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    
    handleRowAction :function(component, event, helper) {
        
        //var selectedRows = event.getParam('selectedRows');
        
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'edit_record':
                
                component.set( "v.EditRecord", true );
                component.set( "v.record", row );
                let ele = component.find( "recordPopup" );
                $A.util.removeClass( ele, "slds-hide" );
                
                break;
            case 'Delete':
                
                helper.DeleteMasterDocRec(component, event, helper, row);
                break;
        }
        
        
        
    },
    newDocMaster : function(component, event, helper) {
        component.set( "v.EditRecord", false );
        component.set( "v.record", {} );
        let ele = component.find( "recordPopup" );
        $A.util.removeClass( ele, "slds-hide" );
    },
    
    
    handleCancelPopupClick : function(component, event, helper){
        
        let ele = component.find( "recordPopup" );
        $A.util.addClass( ele, "slds-hide" );
        
    },
    handleSaveDocMaster : function(component, event, helper){
        
        let record = component.get( "v.record" );
        
        
        if( record.Label_Name__c == undefined || record.Label_Name__c == '' ){
            
            helper.errorMsgHandler(component,event, helper,'Document Name');
            
        }
        else if( record.Mandatory__c == true && record.Visibility__c == false ){
            
            helper.errorMsgHandler(component,event, helper,'Visibilty value');
            
        }else if( record.Emirate__c == undefined || record.Emirate__c == ''){
            
            helper.errorMsgHandler(component,event, helper,'Emirate');
        }else {
            
            helper.saveMasterDoc(component);
            
        }
        
        
    },
    handleEditDocMaster :function(component, event, helper){
        
        let record = component.get( "v.record" );
        
        
        if( record.Label_Name__c == undefined || record.Label_Name__c == '' ){
            
            helper.errorMsgHandler(component,event, helper,'Document Name');
            
        }
        else if( record.Mandatory__c == true && record.Visibility__c == false ){
            
            helper.errorMsgHandler(component,event, helper,'Visibility value');
        }else if( record.Emirate__c == undefined || record.Emirate__c == ''){
            
            helper.errorMsgHandler(component,event, helper,'Emirate');
        }else {
            
            helper.updateMasterDoc(component);
            
        }        
    },
    
    newPlanMaster : function(component, event, helper){
        
        component.set( "v.PlanRecord", {} );
        let ele = component.find( "recordPlanPopup" );
        $A.util.removeClass( ele, "slds-hide" );
        
    },
    
    handleCancelNewPlan : function(component, event, helper){
        let ele = component.find( "recordPlanPopup" );
        $A.util.addClass( ele, "slds-hide" );
        
    },
    
    handleSavePlanMaster : function(component, event, helper){
        
        let record = component.get( "v.PlanRecord" );
        
        if( record.Emirates__c == undefined || record.Emirates__c=='-None-' ){
            
            helper.errorMsgHandler(component,event, helper,'Emirates');
            
        }else /*if( record.Name == undefined || record.Name == '' ){
            
           helper.errorMsgHandler(component,event, helper,'Developer Name');
           
          }else*/ if ( record.Insurance_Company__c == undefined || record.Insurance_Company__c == ''){
              
              helper.errorMsgHandler(component,event, helper,'Insurance Company');
          }else if( record.Condition__c == undefined || record.Condition__c=='-None-' ){
              
              helper.errorMsgHandler(component,event, helper,'Condition');
              
          }else if(record.Salary__c == undefined || record.Salary__c == ''){
              
              helper.errorMsgHandler(component,event, helper,'Salary');
          }else if( record.Plans__c == undefined || record.Plans__c=='-None-' ){
              
              helper.errorMsgHandler(component,event, helper,'Plan');
              
          }else {
              
              helper.saveMasterPlan(component);
              
          }
    },
    
    handlePlanRowAction : function(component, event, helper){
        
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        
        switch (action.name) {
            case 'edit_Plan':
                
                
                component.set( "v.EditPlanRecord", true );
                component.set( "v.PlanRecord", row );
                let ele = component.find( "recordPlanPopup" );
                $A.util.removeClass( ele, "slds-hide" ); 
                
                break;
                
            case 'Delete_plan':
                
                helper.DeleteMasterPlanRec(component, event, helper, row);
                break;
        }
        
    },
    
    handleEditPlan : function(component, event, helper){
        
        let record = component.get( "v.PlanRecord" );
        
        if( record.Emirates__c == undefined || record.Emirates__c=='-None-' ){
            
            helper.errorMsgHandler(component,event, helper,'Emirates');
            
        }else if( record.Name == undefined || record.Name == '' ){
            
            helper.errorMsgHandler(component,event, helper,'Developer Name');
            
        }else if ( record.Insurance_Company__c == undefined || record.Insurance_Company__c == ''){
            
            helper.errorMsgHandler(component,event, helper,'Insurance Company');
        }else if( record.Condition__c == undefined || record.Condition__c=='-None-' ){
            
            helper.errorMsgHandler(component,event, helper,'Condition');
            
        }else if(record.Salary__c == undefined || record.Salary__c == ''){
            
            helper.errorMsgHandler(component,event, helper,'Salary');
        }else if( record.Plans__c == undefined || record.Plans__c=='-None-' ){
            
            helper.errorMsgHandler(component,event, helper,'Plan');
            
        }else {
            
            helper.updateMasterPlan(component);
            
        }
        
    },
    
    handleCancelNewClaim : function(component, event, helper){
        
        let ele = component.find( "recordClaimPopup" );
        $A.util.addClass( ele, "slds-hide" );
        
    },
    
    newClaimDoc : function(component, event, helper){
        
        component.set( "v.ClaimRecord", {} );
        let ele = component.find( "recordClaimPopup" );
        $A.util.removeClass( ele, "slds-hide" );
        
    },
    
    handleSaveClaim :function(component, event, helper){
        
        let record = component.get( "v.ClaimRecord" );
        
        if( record.Label__c == undefined || record.Label__c=='' ){
            
            helper.errorMsgHandler(component,event, helper,'Document Label');
            
        }else if( record.Mandatory__c == true && record.Visibility__c == false ){
            
            helper.errorMsgHandler(component,event, helper,'visibility Value');
            
        }else{
            
            helper.saveClaimDoc(component,event, helper);
        }    
        /*if( record.Name == undefined || record.Name == '' ){
            
           helper.errorMsgHandler(component,event, helper,'Developer Name');
           
        }else   */ 
    },
    
    handleClaimRowAction :function(component, event, helper){
        
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        
        switch (action.name) {
            case 'edit_claimDoc':
                
                component.set( "v.EditClaimRecord", true );
                component.set( "v.ClaimRecord", row );
                let ele = component.find( "recordClaimPopup" );
                $A.util.removeClass( ele, "slds-hide" ); 
                
                break;
                
            case 'Delete_claimDoc':
                helper.DeleteClaimDoc(component, event, helper, row);
                break;
        }
    },
    
    handleEditClaim :function(component, event, helper){
        
        let record = component.get( "v.ClaimRecord" );
        
        if( record.Label__c == undefined || record.Label__c=='' ){
            
            helper.errorMsgHandler(component,event, helper,'Document Label');
            
        }else if( record.Name == undefined || record.Name == '' ){
            
            helper.errorMsgHandler(component,event, helper,'Developer Name');
            
        }else if( record.Mandatory__c == true && record.Visibility__c == false ){
            
            helper.errorMsgHandler(component,event, helper,'visibility Value');
            
        }else {
            
            helper.updateClaimDoc(component);
        }        
        
    },
    stopSpecialChar : function(component,event,helper){
        
        if (event.key.match(/[a-zA-Z0-9- ]/g) ||event.key =='Backspace'){
            
            
        } else {
            event.preventDefault();
            
        }
    }
})
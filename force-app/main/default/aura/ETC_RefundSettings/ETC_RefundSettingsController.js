({
    doInit : function(component, event, helper) {
        helper.getRefundPolicyDetails(component,event, helper);
    },
    
    newRefundSetting : function(component, event, helper){        
        component.set( "v.RefundSettingsRecord", {} );
        let ele = component.find( "RefundSettingsRecordPopUp" );
        $A.util.removeClass( ele, "slds-hide" );
        
    },
    
    handleCancelRefundSetting : function(component, event, helper){
        let ele = component.find( "RefundSettingsRecordPopUp" );
        $A.util.addClass( ele, "slds-hide" );
        
    },
    
    handleEditRefundSetting : function(component, event, helper){
        let record = component.get( "v.RefundSettingsRecord" );
        console.log('frm '+record.ETC_From__c);
        console.log('to '+record.ETC_To__c);
        console.log('per '+record.ETC_Percentage__c);
        if( record.ETC_From__c == undefined ||record.ETC_From__c ==''){
            helper.errorMsgHandler(component,event, helper,'from value');
        }else if(record.ETC_To__c == undefined ||record.ETC_To__c ==''){
            helper.errorMsgHandler(component,event, helper,'to value');
        }else if(record.ETC_Percentage__c == undefined ||record.ETC_Percentage__c ===''){
            helper.errorMsgHandler(component,event, helper,'percentage value');
        }else{
            helper.updateRefund(component, event, helper);
        }
    },
    
    handleRefundRowAction : function(component, event, helper){
        
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'edit_Refund':
                component.set( "v.EditRefundSettings", true );
                component.set( "v.RefundSettingsRecord", row );
                let ele = component.find( "RefundSettingsRecordPopUp" );
                $A.util.removeClass( ele, "slds-hide" ); 
                
                break;
                
            case 'delete_Refund':
                
                helper.deleteRefundSettingRecord(component, event, helper, row);
                break;
        }
        
    },
    
    handleSaveRefundSetting : function(component, event, helper){
        let record = component.get( "v.RefundSettingsRecord" );
        console.log('frm '+record.ETC_From__c);
        console.log('to '+record.ETC_To__c);
        console.log('per '+record.ETC_Percentage__c);
        if( record.ETC_From__c == undefined ||record.ETC_From__c ==''){
            helper.errorMsgHandler(component,event, helper,'from value');
        }else if(record.ETC_To__c == undefined ||record.ETC_To__c ==''){
            helper.errorMsgHandler(component,event, helper,'to value');
        }else if(record.ETC_Percentage__c == undefined ||record.ETC_Percentage__c ==''){
            helper.errorMsgHandler(component,event, helper,'percentage value');
        }else{
            helper.saveRefund(component, event, helper);
        }
    },
    
    stopSpecialChar : function(component,event,helper){
        
        if (event.key.match(/[a-zA-Z0-9- ]/g) ||event.key =='Backspace'){
        } else {
            event.preventDefault();
        }
    }
})
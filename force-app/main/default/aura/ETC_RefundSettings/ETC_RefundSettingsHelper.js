({ 
    serverSideCall : function(component,action) {
        
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('State>>>'+state);
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue());
                } else {
                    console.log('server Error--'+response.getError());
                    reject(new Error(response.getError()));
                }
            }); 
            $A.enqueueAction(action);
        });
    },
    
    getRefundPolicyDetails : function(component,event, helper) {    
        
        var actions = [
            {
                'label': 'Edit',
                'iconName': 'utility:edit',
                'name': 'edit_Refund',
                
            },
            {
                'label': 'Delete',
                'iconName': 'utility:delete',
                'name': 'delete_Refund'
            }
        ];
        
        component.set('v.RefundSettingsColumns', [
            {label: 'From', fieldName: 'ETC_From__c', type: 'text'},
            {label: 'To', fieldName: 'ETC_To__c', type: 'text'},
            {label: 'Percentage', fieldName: 'perCustom', type: 'percent'},
            {label: 'Actions', type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        var action = component.get("c.getRefundPolicies");
        this.serverSideCall(component,action).then(
            function(res) {
                var records =res;
                records.forEach(function(record){
                    console.log(record.ETC_Percentage__c);
                    record.perCustom = record.ETC_Percentage__c;
                });
                // console.log('----res--- '+res);
                component.set('v.RefundSettingsData', res);
            }
        ).catch(
            function(error) {
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    
    saveRefund: function(component, event, helper){
        
        var exeAction = component.get("c.saveRefundSetting");
        exeAction.setParam("data", component.get("v.RefundSettingsRecord"));
        component.set( "v.RefundSettingsRecord", {} );
        let ele = component.find( "RefundSettingsRecordPopUp" );
        $A.util.addClass( ele, "slds-hide" );
        
        exeAction.setCallback( this, function( response ) {
            var state = response.getState();
            if( state === "SUCCESS") {
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"success",
                    "title":"success",
                    "message":'Your action has been completed!',
                    "mode":"dismissible"
                });
                toastReference.fire();
                
            }
            else if (state === "INCOMPLETE") {
                alert('Error in the response');
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Error",
                    "title":"Error",
                    "message":'Please check with your system admin!',
                    "mode":"dismissible"
                });
                toastReference.fire();
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":errors[0].message,
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                        
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":'Please check with your system admin!',
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                    }
                }
        });
        
        $A.enqueueAction(exeAction); 
        this.getRefundPolicyDetails(component);
    },
    
    updateRefund : function(component, event, helper, Msg) {
        var exeAction = component.get("c.updateRefundSetting");
        exeAction.setParam("Row", component.get("v.RefundSettingsRecord"));
        component.set( "v.RefundSettingsRecord", {} );
        let ele = component.find( "RefundSettingsRecordPopUp" );
        $A.util.addClass( ele, "slds-hide" );
        
        this.serverSideCall(component,exeAction).then(
            function(res) {
                console.log('----res---'+res);
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"success",
                    "title":"success",
                    "message":'Record has been updated!',
                    "mode":"dismissible"
                });
                toastReference.fire();
                // $A.get('e.force:refreshView').fire();
            }
        ).catch(
            function(error) {
                console.log('Error---'+JSON.stringify(error));
            }
        );
        try{
            this.getRefundPolicyDetails(component);
        }catch(e){
            //alert(e.message);
        }
    },
    
    deleteRefundSettingRecord : function(component, event, helper,row) {
        
        var exeAction = component.get("c.deleteRefundSettingRecord");
        exeAction.setParam("Row", row);
        
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                //console.log('----res---'+res);
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"success",
                    "title":"success",
                    "message":'Record has been deleted!',
                    "mode":"dismissible"
                });
                toastReference.fire();
                //$A.get('e.force:refreshView').fire();
            }
        ).catch(
            function(error) {
                // console.log('Error---'+JSON.stringify(error));
            }
        );
        this.getRefundPolicyDetails(component);
        
    },
    
    errorMsgHandler : function(component, event, helper, Msg) {
        
        var toastReference = $A.get("e.force:showToast");
        toastReference.setParams({
            "type":"Error",
            "title":"Error",
            "message":'Please enter '+Msg,
            "mode":"dismissible"
        });
        toastReference.fire();
    },
    
    
})
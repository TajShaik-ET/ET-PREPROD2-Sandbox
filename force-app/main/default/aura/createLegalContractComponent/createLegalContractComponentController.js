({
    doInit : function(component,event,helper){
       var rId = component.get('v.recordId');
       helper.callToServer(
            component,
            "c.findRecordTypes",
            function(response) {
                var res = JSON.stringify(response);
                console.log('response-->'+res);
                if(response != 'false'){
                	var jsonObject=JSON.parse(response);
                	component.set('v.recordTypeList',jsonObject);  
                	component.set('v.selectedRecordType',jsonObject[0].recordTypeId); 
                }
                else{
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({ 
                        "title": "error",
                    	"type":	 "Error",
                        "message":'Opportunity should be Negotiation stage.'
                    });
                    toastEvent.fire();
                }
            }, 
            {recId: rId}
        ); 
    },
     
    onChange : function(component, event, helper) {
		var value = event.getSource().get("v.text");
        component.set('v.selectedRecordType', value);
	},
    defaultCloseAction : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    onconfirm : function(component, event, helper){
        var selectedRecType=component.get('v.selectedRecordType');
        var oppId = component.get('v.recordId');
         if(selectedRecType){
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": 'Legal_Contract__c',
                "recordTypeId": selectedRecType,
                'defaultFieldValues': {
                    'Opportunity__c' :oppId,
                  }
            });
            createRecordEvent.fire();
        }
     }
})
({
	doInit : function(component, event, helper) {
      var recId = component.get('v.recordId');
	  var createRecordEvent = $A.get("e.force:createRecord");
      createRecordEvent.setParams({
         "entityApiName": "Contract_Request_Form__c",
          'defaultFieldValues': {
                    'ETS_Contract_Opportunity__c' : recId
                }
      });
      createRecordEvent.fire();
      //$A.get('e.force:closeQuickAction').fire();
	}
})
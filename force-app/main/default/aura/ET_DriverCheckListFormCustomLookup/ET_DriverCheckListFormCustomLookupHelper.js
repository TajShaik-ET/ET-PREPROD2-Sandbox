({
    searchRecordsHelper: function(component, event, helper, value) {
        var stringQuery;
        var personRecType = 'Person_B2C'; 
        if (component.get('v.objectName') == 'Account' && component.get('v.lookupFieldType') == 'Driver')
            stringQuery = 'SELECT Id,Name,ETIN_Employee_Id__c FROM Account WHERE ETIN_Employee_Id__c LIKE ' + '\'' + component.get('v.searchString') + '%\'' + ' LIMIT 4999';
        if (component.get('v.objectName') == 'Account' && component.get('v.lookupFieldType') == 'School')
            stringQuery = 'SELECT Id,Name,ETST_SchoolRefID__c,School_Code__c FROM Account WHERE ETST_SchoolRefID__c != null AND RecordType.DeveloperName != \'' + personRecType + '\''+' AND (Name LIKE ' + '\'' + component.get('v.searchString') + '%\'' + ' OR ETST_SchoolRefID__c LIKE ' + '\'' + component.get('v.searchString') + '%\'' + ' OR School_Code__c LIKE ' + '\'' + component.get('v.searchString') + '%\'' + ')' +' LIMIT 4999';
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
        var searchString = component.get('v.searchString');
        component.set('v.message', '');
        component.set('v.recordsList', []);
        var action = component.get('c.fetchRecords');
        action.setParams({
            'query': stringQuery
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            console.log('result: ' + JSON.stringify(result));
            if (response.getState() === 'SUCCESS') {
                if (result.length > 0) {
                    if ($A.util.isEmpty(value)) {
                        component.set('v.recordsList', result);
                    } else {
                        component.set('v.selectedRecord', result[0]);
                    }
                } else {
                    component.set('v.message', "No Records Found for '" + searchString + "'");
                }
            } else {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set('v.message', errors[0].message);
                }
            }
            if ($A.util.isEmpty(value))
                $A.util.addClass(component.find('resultsDiv'), 'slds-is-open');
            $A.util.addClass(component.find("Spinner"), "slds-hide");
        });
        $A.enqueueAction(action);
    },
    sendData: function(component) {
        const onDataReadyEvent = component.getEvent("onDataReady");
        onDataReadyEvent.setParams({
            "data": {
                "objectName": component.get("v.objectName"),
                "lookupFieldType": component.get("v.lookupFieldType"),
                "value": component.get("v.selectedRecord")
            }
        });
        onDataReadyEvent.fire();
    },
})
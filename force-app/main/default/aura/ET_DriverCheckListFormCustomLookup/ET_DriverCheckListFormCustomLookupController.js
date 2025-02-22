({
    removeItem: function(component, event, helper) {
        component.set('v.selectedRecord', null);
        component.set('v.searchString', '');
        helper.sendData(component);
        setTimeout(function() {
            component.find('inputLookup').focus();
        }, 250);
    },
    selectItem: function(component, event, helper) {
        if (!$A.util.isEmpty(event.currentTarget.id)) {
            var recordsList = component.get('v.recordsList');
            var index = recordsList.findIndex(x => x.Id === event.currentTarget.id)
            if (index != -1) {
                var selectedRecord = recordsList[index];
            }
            component.set('v.selectedRecord', selectedRecord);
            helper.sendData(component);
            //component.set('v.value',selectedRecord.value);
            $A.util.removeClass(component.find('resultsDiv'), 'slds-is-open');
        }
    },
    showRecords: function(component, event, helper) {
        if (!$A.util.isEmpty(component.get('v.recordsList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
            $A.util.addClass(component.find('resultsDiv'), 'slds-is-open');
        }
    },
    searchRecords: function(component, event, helper) {
        if (!$A.util.isEmpty(component.get('v.searchString'))) {
            helper.searchRecordsHelper(component, event, helper, '');
        } else {
            $A.util.removeClass(component.find('resultsDiv'), 'slds-is-open');
        }
    },
})
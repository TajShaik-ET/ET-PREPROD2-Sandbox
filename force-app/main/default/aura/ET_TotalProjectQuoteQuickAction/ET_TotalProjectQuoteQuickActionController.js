({
    doInit: function (component, event, helper) {
        var action = component.get('c.getPreviewQuoteTotalProject');
        action.setParams({
            quoteId: component.get("v.recordId")
        });
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function (response) {
            component.set('v.loaded', !component.get('v.loaded'));
            console.log('getState: ', response.getState());
            if (response.getState() == 'SUCCESS') {
                var quoteRec = response.getReturnValue();
                console.log('result : ' + JSON.stringify(quoteRec));
                if (quoteRec != null) {
                    if (quoteRec.ET_Type__c == 'Quote for Approval' && quoteRec.Quote_Type__c == 'Manual' && quoteRec.ContentDocumentLinks.length > 0) {
                        window.open("/lightning/r/ContentDocument/" + quoteRec.ContentDocumentLinks[0].ContentDocumentId + "/view");
                    } else if (quoteRec.ET_Type__c == 'Total Project Summary' && quoteRec.Id) {
                        window.open("/apex/ET_Quotation_Pricing_PDF?quoteId=" + quoteRec.Id);
                    }
                }
            }
            else if(response.getState() == "ERROR"){
                var errors = response.getError();
                console.log('Error: ' + errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    closeAction: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },

})
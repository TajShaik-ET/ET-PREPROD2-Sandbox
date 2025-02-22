({
	preveiwQuote: function (component, event, helper, recordId) {
		var action = component.get("c.getActiveQuotes");
		action.setParams({
			"serviceRequestId": null,
			"quoteId": recordId
		});
		action.setCallback(this, function (response) {
			console.log('getState: ', response.getState());
			if (response.getState() == 'SUCCESS') {
				var quoteRecs = response.getReturnValue();
				console.log('result : ' + JSON.stringify(quoteRecs));
				if (quoteRecs.length > 0) {
					if (quoteRecs[0].Quote_Type__c == 'Manual' && quoteRecs[0].ContentDocumentLinks.length > 0) {
						window.open("/lightning/r/ContentDocument/" + quoteRecs[0].ContentDocumentLinks[0].ContentDocumentId + "/view"); 
					} else {
						window.open("/apex/ET_Quotation_Pricing_PDF?quoteId=" + recordId);
					}
				}
			}
			else {
				var errors = response.getError();
				console.log('Error: ' + errors[0].message);
			}
		});
		$A.enqueueAction(action);
	}
})
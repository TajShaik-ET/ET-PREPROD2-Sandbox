({
	preveiwQuote: function (component, event, helper, recordId) {
		var action = component.get("c.getPreviewQuote");
		action.setParams({
			"serviceRequestId": null,
			"quoteId": recordId
		});
		action.setCallback(this, function (response) {
			console.log('getState: ', response.getState());
			if (response.getState() == 'SUCCESS') {
				var quoteRec = response.getReturnValue();
				console.log('result : ' + JSON.stringify(quoteRec));
				if (quoteRec != null) {
					if (quoteRec.ET_Type__c == 'Quote for Approval' && quoteRec.Quote_Type__c == 'Manual' && quoteRec.ContentDocumentLinks.length > 0) {
						window.open("/lightning/r/ContentDocument/" + quoteRec.ContentDocumentLinks[0].ContentDocumentId + "/view");
					} else if (quoteRec.ET_Type__c == 'Quote for Approval' && quoteRec.Quote_Type__c != 'Manual') {
						window.open("/apex/ET_Quotation_Pricing_PDF?quoteId=" + quoteRec.Id);
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
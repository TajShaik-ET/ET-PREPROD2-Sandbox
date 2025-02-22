({
     getApprovalRequest : function(component,event,helper){
        var recId = component.get('v.recordId');
        var action = component.get("c.getApprovalRequest");
        action.setParams({
            'quoteId': recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var vflg = response.getReturnValue();
                console.log('vflg--->'+vflg);
                component.set("v.flag",vflg);
            }            
         });
        $A.enqueueAction(action);
    },
    getSubmitFlag : function(component,event,helper){
        var recId = component.get('v.recordId');
        var action = component.get("c.fetchSubmitFlag");
        action.setParams({
            'quoteId': recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var vflg = response.getReturnValue();
                console.log('vflg--->'+vflg);
                component.set("v.flag2",vflg);
            }            
         });
        $A.enqueueAction(action);
    },
	onSubmitAction : function(component,event,helper,appString) {
        var cmt = component.get("v.commentStr");
        var recId = component.get('v.recordId');
		var action = component.get("c.approvalRequestAction");
        console.log('appString-->'+appString);
        console.log('comments-->'+cmt)
        console.log('recordId-->'+recId);
        action.setParams({
            'quoteId': recId,
            'actionStr' : appString,
            'comments' : cmt            
        });
        action.setCallback(this, function(response) {
             component.set("v.isModalOpen", false);
             var state = response.getState();
             var urlString = window.location.href;
			 var baseURL = urlString.substring(0, urlString.indexOf('/c'));
             console.log(urlString);
			 console.log(baseURL);
             if(state === "SUCCESS"){
               alert('Approved Successfully');
               window.location.href =baseURL+'/'+recId;
                             
             }
            else{
             var errors = response.getError();
           	 console.log('Error ' + errors);
             alert(errors[0].message);            
            }
        });
        $A.enqueueAction(action);
	},
    onSubmitRequest : function(component,event,helper,appString) {
        var cmt = component.get("v.commentStr");
        var recId = component.get('v.recordId');
		var action = component.get("c.submitForApproval");
        console.log('appString-->'+appString);
        console.log('comments-->'+cmt)
        console.log('recordId-->'+recId);
        action.setParams({
            'quoteId': recId,
            'comments' : cmt            
        });
        action.setCallback(this, function(response) {
             component.set("v.isModalOpen", false);
             var state = response.getState();
             var urlString = window.location.href;
			 var baseURL = urlString.substring(0, urlString.indexOf('/c'));
             console.log(urlString);
			 console.log(baseURL);
             if(state === "SUCCESS"){
               alert('Submitted for approval successfully');
               window.location.href =baseURL+'/'+recId;
                             
             }
            else{
             var errors = response.getError();
           	 console.log('Error ' + errors);
             alert(errors[0].message);            
            }
        });
        $A.enqueueAction(action);
	}
   
})
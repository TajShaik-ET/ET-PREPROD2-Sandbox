({
	doInit : function(component, event, helper) {
        var url_string = window.location.href; 
        var url = new URL(url_string);
        var service = url.searchParams.get("ser");
        console.log('service==>'+service);
        if(service==null || service=='' || service==undefined){
            component.set('v.service',"All");
        } 
        else if(service=='etst'){
            component.set('v.service',"School Transport");
        }
		helper.doInit(component, event, helper)
        helper.setCommunityLanguage(component, event, helper);
	},
	setTabId: function(component, event, helper) {
		 /*var urlString = window.location.href;
         var baseURL = urlString.substring(0, urlString.indexOf("/s"));
		var urlEvent = $A.get("e.force:navigateToURL");
		urlEvent.setParams({
				"url": urlString+"/#deliveryService"                            
			});
	   urlEvent.fire();*/
	    var selectedItem = event.currentTarget;
		var Name = selectedItem.dataset.record;
		component.set('v.selectedTabId',Name);
	}
})
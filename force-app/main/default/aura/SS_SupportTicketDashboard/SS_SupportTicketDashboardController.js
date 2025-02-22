({
    doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
         helper.setCommunityLanguage(component, event, helper);
        
	},
	setTabId: function(component, event, helper) {
        console.log('----------->insidetab');
        
			/* var selectedItem = event.currentTarget;
        console.log('----------->insidetab'+selectedItem);
		var statusdash = selectedItem.dataset.record;
          console.log('----------->insidetab'+statusdash);
		
	 var evt = $A.get("e.force:navigateToComponent");      
   		 evt.setParams({
             componentDef:"c:SS_SupportTicketDetails",
             componentAttributes: {
                status: statusdash
             }
    		});
        
 console.log('----------->insidetab'+evt);
	   evt.fire();
	  */
        var urlEvent = $A.get("e.force:navigateToURL");
		urlEvent.setParams({
				"url": "/#deliveryService"                            
			});
	//   urlEvent.fire();
	   var selectedItem = event.currentTarget;
		var Name = selectedItem.dataset.record;
		component.set('v.selectedTabId',Name);
		
	},
     myBusinessSelected : function(component, event, helper) {
        //helper.hideActiveClaass(component, event, helper);
        $A.util.removeClass(component.find("home"), 'active1');
        $A.util.addClass(component.find("business"), 'active1');
        var lang = component.get("v.clLang");
        var urlEvent = $A.get("e.force:navigateToURL");
        console.log("urlEvent***"+JSON.stringify(urlEvent));
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"my-business"+"?lang="+lang});   // Pass your community URL
        urlEvent.fire(); 
        
    },
    customerCareSelected : function(component, event, helper) {
       // helper.hideActiveClaass(component, event, helper);
        $A.util.addClass(component.find("care"), 'active1');
        var lang = component.get("v.clLang");
        //alert(lang);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"customer-care"+"?lang="+lang});   // Pass your community URL
        urlEvent.fire(); 
        
    },
    exploreServicesSelected : function(component, event, helper) {
       // helper.hideActiveClaass(component, event, helper);
        $A.util.addClass(component.find("explore"), 'active1');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"explore-services" });   // Pass your community URL
        urlEvent.fire(); 
        
    },
    specialRequestSelected : function(component, event, helper) {
       // helper.hideActiveClaass(component, event, helper);
        $A.util.addClass(component.find("explore"), 'active1');
        var lang = component.get("v.clLang");
       // alert(lang);
        component.set("v.language", lang);
        console.log(lang);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"special-requests"+"?lang="+lang });   // Pass your community URL
        urlEvent.fire(); 
        
    },
})
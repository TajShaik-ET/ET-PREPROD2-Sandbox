({
    afterScriptsLoaded : function(component, event, helper) {
        console.log('script loaded.......');
        component.set("v.isSDKLoaded",true);
        component.set("v.processSDKRerendering",true);
	},
    handleCheckOut :  function(component, event, helper) {
     
    }
})
({
	doInit : function(component, event, helper) {
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        component.set('v.userId',userId);
        component.set('v.profileUrl','/s/profile/'+userId);
	    var url= window.location.pathname;  
        if(url.includes("etst-home-page")){
            component.set("v.isETSTHomePage",true);
        }else{
            component.set("v.isETSTHomePage",false);
        }
	}
})
({
	doInit : function(component, event, helper) {
        var url_string = window.location.href;
        var url = new URL(url_string);
        console.log('url***'+url);
        var lang = url.searchParams.get("lang");
        console.log('lang***'+lang);
        component.set("v.lang", lang);
        component.set("v.language", 'English');
        if(lang=='ar'){
           component.set('v.mainLogo', $A.get("$Resource.ETST_arabicLogo"));
           component.set('v.language', component.get('v.arabic')); 
        }else{
            component.set('v.mainLogo', $A.get("$Resource.ETST_EngLogo"));
            component.set('v.language', component.get('v.english'));
        }
    },
     selectenLanguage : function(component, event, helper) {
         var url_string1 = window.location.href;
         var str2='';
         if(url_string1.includes("lang"))
             str2=url_string1.slice(0,-2);
         else
             str2=url_string1+'?lang=';
             
        var url1 = new URL(str2);
         component.set('v.url',url1+'en');
         //component.set('v.url','/Business/s/special-requests?lang=en');
         component.set('v.mainLogo', $A.get("$Resource.ETST_EngLogo"));
         component.set("v.language", component.get('v.english'));
	},
    selectarLanguage : function(component, event, helper) {
        var url_string1 = window.location.href;
         var str2='';
         if(url_string1.includes("lang"))
             str2=url_string1.slice(0,-2);
         else
             str2=url_string1+'?lang=';
             
        var url1 = new URL(str2);
         component.set('v.url',url1+'ar');
        //component.set('v.url','/Business/s/special-requests?lang=ar');
        component.set('v.mainLogo', $A.get("$Resource.ETST_arabicLogo"));
        component.set('v.language', component.get('v.arabic'));
	} 
})({
	myAction : function(component, event, helper) {
		
	}
})
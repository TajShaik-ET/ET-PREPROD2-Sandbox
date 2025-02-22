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
        }
        if(lang=='en'){
            component.set('v.mainLogo', $A.get("$Resource.ETST_EngLogo"));
            component.set('v.language', component.get('v.english'));
        }
    },
    selectenLanguage : function(component, event, helper) {
        //var sURL = decodeURIComponent(window.location.href);
        //console.log('sURL***'+sURL);
        var url_string = window.location.href; 
        var url = new URL(url_string);
        console.log('url***'+url);
        var lang = url.searchParams.get("lang");
        console.log('lang***'+lang);
        if(lang!=null && lang=='ar')
            component.set('v.url',url.toString().replace("ar","en"));
        else 
            component.set('v.url',url+'?lang=en');
         component.set('v.mainLogo', $A.get("$Resource.ETST_EngLogo"));
         component.set("v.language", component.get('v.english'));
	},
    selectarLanguage : function(component, event, helper) {
        var url_string = window.location.href; 
        var url = new URL(url_string);
        console.log('url***'+url);
        var lang = url.searchParams.get("lang");
        console.log('lang***'+lang);
        if(lang!=null && lang=='en')
            component.set('v.url',url.toString().replace("en","ar"));
        else 
        	component.set('v.url',url+'?lang=ar');
        component.set('v.mainLogo', $A.get("$Resource.ETST_arabicLogo"));
        component.set('v.language', component.get('v.arabic'));
	} 
})
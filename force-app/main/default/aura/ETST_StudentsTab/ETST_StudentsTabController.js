({
   /* doInit : function(component, event, helper) {
       $A.createComponent(
            "c:ETST_StudentDetails",
            {
                "aura:id" : "studentDetailsCmp"                
            },
            function(newcomponent){
                if (component.isValid()) {
                    var newCmp = component.find("cmpBody");
                    var body = newCmp.get("v.body");
                    body.push(newcomponent);
                    newCmp.set("v.body", body); 
                            
                }
            }            
        ); 
        var url_string = window.location.href;
        var url = new URL(url_string);
        console.log('url***'+url);
        var lang = url.searchParams.get("lang");
        console.log('lang***'+lang);
        component.set("v.lang", lang);
        if(lang == 'ar'){
            component.set("v.yourChildren", $A.get("$Label.c.ETST_Your_Children_AR"));
        } else {
            component.set("v.yourChildren", $A.get("$Label.c.ETST_Your_Children"));
        } 
    }, */
    doInit : function(component, event, helper) {
  		helper.profileData(component, event,helper);
        //alert('ETST_StudentsTab');
        //var recordId = component.get('v.recordId');
        //console.log('recordId:'+recordId);
        helper.setCommunityLanguage(component, event, helper);
        console.log('clLang***123***'+component.get('v.clLang'));
	   var url_string = window.location.href;
        var url = new URL(url_string);
        console.log('url***'+url);
        var lang = url.searchParams.get("lang");
        console.log('lang***'+lang);
        component.set("v.lang", lang);
        if(lang == 'ar'){
            component.set("v.clAddYourChild", $A.get("$Label.c.ETST_Add_Your_Child_AR"));
            component.set("v.clSupport", $A.get("$Label.c.ETST_Support_AR"));
            component.set("v.clMyCases", $A.get("$Label.c.ETST_My_Cases_AR"));
            component.set("v.clMyServices", $A.get("$Label.c.ETST_My_Services_AR"));
            component.set("v.clHelp", $A.get("$Label.c.ETST_Help_AR"));
        } else {
            component.set("v.clAddYourChild", $A.get("$Label.c.ETST_Add_Your_Child"));
            component.set("v.clSupport", $A.get("$Label.c.ETST_Support"));
            component.set("v.clMyCases", $A.get("$Label.c.ETST_My_Cases"));
            component.set("v.clMyServices", $A.get("$Label.c.ETST_My_Services"));
            component.set("v.clHelp", $A.get("$Label.c.ETST_Help"));
        } 
    }, 
    
    onForceLoad : function(component, event, helper){
        let data = component.get("v.record");
        console.log('data:'+data);
    },
    
    openStudentModal : function(component, event, helper) {
        component.set('v.addStudentModal',true);
    },
    closeModel: function(component, event, helper) {
        component.set('v.addStudentModal',false);
        component.set('v.isfeebackModal',false);
        
    },
    closeModelwithRefresh: function(component, event, helper) {
        component.set('v.addStudentModal',false);
        $A.get('e.force:refreshView').fire();
    },
    openFeedbackModal: function(component, event, helper){
        component.set('v.isfeebackModal',true);
    },
    gotocaseHist: function(component, event, helper){
        var url_string = window.location.href;
        var url = new URL(url_string);
        var lang = url.searchParams.get("lang");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
                "url": '/school-transport-case-history?ser=etst&lang='+lang
                
            });
      urlEvent.fire();
    },
    openHelpPage: function(component, event, helper){
        /*var url_string = window.location.href;
        var url = new URL(url_string);
        var lang = url.searchParams.get("lang");*/
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
               // "url": '/help-page'//'/school-transport-case-history?ser=etst&lang='+lang
               "url": '/help-page?lang='+component.get("v.clLang")
                
            });
      urlEvent.fire();
    },
    
    navigateToMyServices: function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
                "url": '/etst-my-services?lang='+component.get("v.clLang")
                
            });
      urlEvent.fire();
    },

})
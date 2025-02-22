({
	doInit: function(component, event, helper) {
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getTermsandConditions";
        var clLang =  this.getlanguage(component, event, helper);
        if(clLang == '' || clLang == undefined){
            clLang = 'en'; 
        }
       
        //Santosh
        var params;
       var serviceRecord = component.get('v.studentRecord').ETST_SchoolName__c;
        console.log('serviceRecord : ', serviceRecord);
        if(serviceRecord == 'Australian International school Sharjah'){
            params = {
                visibility : $A.get("$Label.c.Add_Aus"),
                language :clLang
            };
        }else{
            params = {
                visibility : $A.get("$Label.c.ETST_Add_Child"),
                language :clLang
            };        
        }
        
       
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                console.log('getTermsandConditions-->'+JSON.stringify(response));
                component.set("v.termsandConditionsFollow", response);
                //component.set("v.termsandConditionsNotFollow", response.termsandConditionsNotFollow);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport Terms and Conditions", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )    
    },
    getlanguage : function(component, event, helper) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.

            if (sParameterName[0] === 'lang') { //lets say you are looking for param name - firstName
                sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
            }
        }
        console.log('Param name'+sParameterName[0]);
        console.log('Param value'+sParameterName[1]);
        return sParameterName[1];
    }
})
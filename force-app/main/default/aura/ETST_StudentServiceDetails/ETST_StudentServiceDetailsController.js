({
    openpickupMapController : function(component, event, helper) {
        component.set('v.openpickupMap',true);
    },
    closePickupModel: function(component, event, helper) {
        component.set('v.openpickupMap',false);        
    },
    closeDropoffModel: function(component, event, helper) {
        component.set('v.openDropoffMap',false);        
    },
     openDropoffMapController : function(component, event, helper) {
        component.set('v.openDropoffMap',true);
    },
    updateService: function(component, event, helper) {
          if( component.get('v.serviceRecord.ETST_Pick_Up_From__c')==null||
            component.get('v.serviceRecord.ETST_Pick_Up_From__c').trim()==''){
            $A.util.removeClass(component.find("invalidpickup"), "slds-hide");   
        }else if(component.get('v.serviceRecord.ETST_Drop_Off_To__c')==null||
                 component.get('v.serviceRecord.ETST_Drop_Off_To__c').trim()==''){
            $A.util.removeClass(component.find("invalidDrop"), "slds-hide");
        }else{
          var currentTransportType=component.get('v.currentTransportType');
            var newTransportType=component.get('v.newTransportType');
            if(currentTransportType!=newTransportType ||
               component.get('v.currentPickup') !=component.get('v.serviceRecord.ETST_Pick_Up_From__c') ||
               component.get('v.currentDropoff') !=component.get('v.serviceRecord.ETST_Drop_Off_To__c')){
                helper.updateServiceHelper(component, event, helper);                
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "No changes observed."
                });
                toastEvent.fire();
            }
        }
        
    },
    updateLocations: function(component, event, helper) {
        var newTransportType=component.get('v.newTransportType');
        component.set('v.serviceRecord.ETST_Transport_Type__c', newTransportType);
        component.set("v.serviceRecord.ETST_Fare_Charges__c",'');
        var currentTransportType=component.get('v.currentTransportType');
        //if(newTransportType=='Two Way' && currentTransportType!='Two Way'){
            helper.getFareDetails(component, event, helper); 
        //}
                
    },
     getFareDetails: function(component, event, helper) {
        component.set('v.serviceRecord.ETST_Location__Latitude__s',0);
        component.set('v.serviceRecord.ETST_Location__Longitude__s',0);
        component.set("v.serviceRecord.ETST_Fare_Charges__c",'');
        var transportType=component.get("v.serviceRecord.ETST_Transport_Type__c");
        if(transportType!=null && transportType!='' && transportType!=undefined 
          ){
            helper.getFareDetails(component, event, helper); 
        }
    },
    doInit: function(component, event, helper) { 
        if (navigator.geolocation) {
            console.log("able to retrieve your location");
            navigator.geolocation.getCurrentPosition(function(position) {
                var latit = position.coords.latitude;
                var longit = position.coords.longitude;
                component.set('v.serviceRecord.ETST_Location__Latitude__c',latit);
                component.set('v.serviceRecord.ETST_Location__Longitude__c',longit);
                component.set('v.lat',latit);
                component.set('v.lon',longit);
                component.set('v.vfUrl','/apex/ETST_GoogleMapFinder?lat='+latit+'&long='+longit);
       
            });
        }else{
            console.log("Unable to retrieve your location");
        } 
        component.set('v.showService',false);
        component.set('v.updateService',true);
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
        helper.doInit(component, event, helper);
        if (navigator.geolocation) {
            console.log("able to retrieve your location");
            navigator.geolocation.getCurrentPosition(function(position) {
                var latit = position.coords.latitude;
                var longit = position.coords.longitude;
                component.set('v.ETST_Location__Latitude__c',latit);
                component.set('v.ETST_Location__Longitude__c',longit);
            });
        }else{
            console.log("(Unable to retrieve your location");
        }
        var urlString=window.location.href;
        var vfOrigin = urlString.substring(0, urlString.indexOf("/s"));
         window.addEventListener("message", $A.getCallback(function(event) {
            
            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
                //console.log(event.data);
                return;
            }
            // Handle the message
            console.log(event);
            var message = event.data;
            console.log('message-->'+message);
            /*if(message=='PaymentCancelled'){
                //helper.redirectTo(component, '/etst-home-page');
            }*/
            var res = message.split("~");
            if(res.length > 0){ 
                component.set('v.serviceRecord.ETST_Location__Latitude__c',res[0]);
                component.set('v.serviceRecord.ETST_Location__Longitude__c',res[1]);
                
            }
            
            /*if(messageText == 'SUCCESS'){
                 // component.set("v.currentStep",'Payment success');
                  helper.updateTransportRequestStatus(component, event, helper);
                  return;
            }*/
            
            
        }), false);
	      // for Community language ETST_BilingualCommunity component
        helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
        if(lang=='en' || lang=='null' || lang==null|| lang==undefined){
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__body');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
        }else{
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__body');
        } 
    }, 
 /*   handleOnload: function(component, event, helper) {
        var url_string = window.location.href;
        var url = new URL(url_string);
        console.log('url***'+url);
        var lang = url.searchParams.get("lang");
        console.log('lang***'+lang);
        component.set("v.lang", lang);
        if(lang=='en' || lang=='null' || lang==null|| lang==undefined){
            $A.util.toggleClass(component.find('editDiv'), 'userservicedetrtl');
        }else{
            $A.util.toggleClass(component.find('editDiv'), 'userservicedet');
        }
        if(lang == 'ar'){
            var heading = $A.get("$Label.c.ETST_Service_Details_AR");
            component.set("v.servicedetailsLabel", heading);
            var serviceType = $A.get("$Label.c.ETST_Service_Type_AR");
            component.set("v.serviceTypeLabel", serviceType);
            var back = $A.get("$Label.c.ETST_Back_AR");
            component.set("v.backLabel", back);
            var updateService = $A.get("$Label.c.ETST_Update_Service_AR");
            component.set("v.updateServiceLabel", updateService);
        } else {
            var heading = $A.get("$Label.c.ETST_Service_Details");
            component.set("v.servicedetailsLabel", heading);
            var serviceType = $A.get("$Label.c.ETST_Service_Type");
            component.set("v.serviceTypeLabel", serviceType);
            var back = $A.get("$Label.c.ETST_Back");
            component.set("v.backLabel", back);
            var updateService = $A.get("$Label.c.ETST_Update_Service");
            component.set("v.updateServiceLabel", updateService);
        }
        
    }, */
    cancelSave: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/etst-home-page?lang='+component.get("v.clLang")
        });
        urlEvent.fire();
    },
    recordUpdate : function(component, event, helper) {
        component.set("v.status",component.get("v.serviceRecord").ETST_Status__c);
    },
    selectOption:function(component, event, helper) {
        console.log('---selectOption---');
        helper.getAddressDetailsByPlaceId(component, event);
    },
    getDropoffLocation: function(component, event, helper) {
        console.log('---getDropoffLocation---');
        component.set('v.isDropoff',true);
        component.set('v.serviceRecord.ETST_Dropoff_Location__Longitude__s','');
        $A.util.removeClass(component.find("Drop-Address-listbox"), "slds-hide");
        var searchText=component.get("v.serviceRecord.ETST_Drop_Off_To__c");
        helper.getAddressRecommendations(component,event,searchText);
    },
    getPickupLocation: function(component, event, helper) {
        console.log('---getPickupLocation---');
        component.set('v.serviceRecord.ETST_Location__Longitude__s','');
        component.set('v.isDropoff',false);
        component.set("v.disableCheckbox",true);
        $A.util.removeClass(component.find("Address-listbox"), "slds-hide");
        var searchText=component.get("v.serviceRecord.ETST_Pick_Up_From__c");
        helper.getAddressRecommendations(component,event,searchText);
    },
    getCurrentLocation: function(component, event, helper) {
        console.log(event.currentTarget.value);
        if (navigator.geolocation) {
            console.log("able to retrieve your location");
            navigator.geolocation.getCurrentPosition(function(position) {
                var latit = position.coords.latitude;
                var longit = position.coords.longitude;
                component.set('v.serviceRecord.ETST_Location__Latitude__c',latit);
                component.set('v.serviceRecord.ETST_Location__Longitude__c',longit);
            });
        }else{
            console.log("Unable to retrieve your location");
        }
        
        
    },
    getLocationDetails: function(component, event, helper){    
        component.set('v.openpickupMap',false);
        var lat=component.get('v.serviceRecord.ETST_Location__Latitude__c');
        var long=component.get('v.serviceRecord.ETST_Location__Longitude__c');
        if(lat!=null && lat!='' && lat!=undefined){
        helper.getLocationDetails(component, event, helper,lat,long,true);
        }
    },
    getDropLocationDetails: function(component, event, helper){
        component.set('v.openDropoffMap',false);
        var lat=component.get('v.serviceRecord.ETST_Location__Latitude__c');
        var long=component.get('v.serviceRecord.ETST_Location__Longitude__c');
        if(lat!=null && lat!='' && lat!=undefined){
        helper.getLocationDetails(component, event, helper,lat,long,false);
        }
    },
    
    copyPickupLocation: function(component, event, helper) {
        var ischecked = component.find("dropCheckBox").get("v.value");
        if(ischecked){
            component.set('v.serviceRecord.ETST_Drop_Off_To__c',component.get('v.serviceRecord.ETST_Pick_Up_From__c'));
            component.set('v.serviceRecord.ETST_Dropoff_Location__Latitude__s', component.get('v.serviceRecord.ETST_Location__Latitude__s'));
            component.set('v.serviceRecord.ETST_Dropoff_Location__Longitude__s', component.get('v.serviceRecord.ETST_Location__Longitude__s'));
        }else{
            component.set('v.serviceRecord.ETST_Drop_Off_To__c',null);
        }
        
        
    },
    getCurrentLocation: function(component, event, helper) {
        
        helper.getLocationDetails(component, event, helper,component.get('v.lat'),component.get('v.lon'),true);
        
    },
    getCurrentDropLocation: function(component, event, helper) {       
        helper.getLocationDetails(component, event, helper,component.get('v.lat'),component.get('v.lon'),false);
    },
    getSearchResultbyEnter: function(component, event, helper) {
         
         window.addEventListener("keyup", function(event) {
         if(event.code == "Enter"){
             component.set('v.mapLoaded',false);
             helper.getAddressRecommendations(component, event,helper, component.get('v.searchText'));
         } 
          }, true);
    },
    getSearchResult: function(component, event, helper) {
        component.set('v.mapLoaded',false);
         helper.getAddressRecommendations(component, event,helper, component.get('v.searchText'));
         
    }
})
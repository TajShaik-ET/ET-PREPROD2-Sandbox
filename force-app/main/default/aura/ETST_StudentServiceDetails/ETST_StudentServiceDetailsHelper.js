({
    doInit : function(component, event, helper) {
        
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getServiceDetails";
        var params = {
            "recordId" : component.get("v.recordId")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.transportTypes',response.transportTypes);
                component.set('v.acadamicStart',response.acadamicStart);
                component.set('v.serviceRecord',response.service); 
                component.set('v.serviceRecord.Id',null); 
                console.log('serviceRecord--'+JSON.stringify(component.get('v.serviceRecord')));
                component.set('v.currentTransportType',component.get("v.serviceRecord.ETST_Transport_Type__c"));
                component.set("v.currentFare",component.get("v.serviceRecord.ETST_Fare_Charges__c"));
                component.set("v.currentPickup",component.get("v.serviceRecord.ETST_Pick_Up_From__c"));
                component.set("v.currentDropoff",component.get("v.serviceRecord.ETST_Drop_Off_To__c"));
                component.set("v.currentYearlyAmt",response.currentYearlyAmt);
                component.set('v.loaded', !component.get('v.loaded'));
                
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    getLocationDetails: function(component, event, helper,latit,longit,isPick){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getLocationDetails";
        var params = {
            "latitude" : latit,
            "longitude" : longit
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                //if(component.get("v.pickuponly") == true || component.get("v.twoway") == true)
                if(isPick)
                component.set('v.serviceRecord.ETST_Pick_Up_From__c',response);
                //if(component.get("v.dropoffonly") == true)
                if(!isPick)
                component.set('v.serviceRecord.ETST_Drop_Off_To__c',response);
                component.set("v.disableCheckbox",false);
                component.set('v.serviceRecord.ETST_Location__Latitude__s', latit);
                component.set('v.serviceRecord.ETST_Location__Longitude__s', longit);
                
                $A.util.addClass(component.find("invalidpickup"), "slds-hide");
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    
    getAddressRecommendations: function(component, event,helper,searchText){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getAddressSet";
        var params = {
            "SearchText" : searchText//component.get("v.serviceRecord.ETST_Pick_Up_From__c")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                var addressResponse = JSON.parse(response);
                var predictions = addressResponse.predictions;
                var addresses = [];
                if (predictions.length > 0) {
                    var placeId=predictions[0].place_id;
                    helper.getAddressDetailsByPlaceId(component,event,helper,placeId);
                     $A.util.addClass(component.find("invalidLoc"), "slds-hide"); 
                    /*for (var i = 0; i < predictions.length; i++) {
                        var bc =[];
                        addresses.push(
                            {
                                main_text: predictions[i].structured_formatting.main_text, 
                                secondary_text: predictions[i].structured_formatting.secondary_text,
                                place_id: predictions[i].place_id
                            });
                        
                    }
                    if(component.get('v.isDropoff')){
                        $A.util.addClass(component.find("invalidDrop"), "slds-hide");  
                    }else {
                        $A.util.addClass(component.find("invalidpickup"), "slds-hide");   
                    }*/
                }else{
                  $A.util.removeClass(component.find("invalidLoc"), "slds-hide"); 
                  component.set('v.mapLoaded',true);
                }
               
                component.set("v.AddressList", addresses);
                console.log('AddressList'+component.get("v.AddressList"));
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
       
    },
    //get address details by place Id from google API 
      getAddressDetailsByPlaceId: function(component,event,helper,placeId){
        //var selectedValue = event.currentTarget.dataset.value;
       var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getAddressDetailsByPlaceId";
        var params = {
            PlaceID:placeId 
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('response'+response);
                var addressResponse = JSON.parse(response);
                component.set('v.serviceRecord.ETST_Location__Latitude__c',addressResponse.result.geometry.location.lat);
                component.set('v.serviceRecord.ETST_Location__Longitude__c',addressResponse.result.geometry.location.lng);
                component.set('v.mapLoaded',true);
                component.set('v.vfUrl','/apex/ETST_GoogleMapFinder?lat='+addressResponse.result.geometry.location.lat+'&long='+addressResponse.result.geometry.location.lng);
                
               /* var postalCode = '', state = '', country= '', city = '', street = '',neighborhood='', street_number = '', route = '', subLocal1 = '', subLocal2 = '';
                for(var i=0; i < addressResponse.result.address_components.length ; i++){
                    var FieldLabel = addressResponse.result.address_components[i].types[0];
                    if(FieldLabel == 'neighborhood' || FieldLabel == 'sublocality_level_2' || FieldLabel == 'sublocality_level_1' || FieldLabel == 'street_number' || FieldLabel == 'route' || FieldLabel == 'locality' || FieldLabel == 'country' || FieldLabel == 'postal_code' || FieldLabel == 'administrative_area_level_1'){
                        switch(FieldLabel){
                            case 'sublocality_level_2':
                                subLocal2 = addressResponse.result.address_components[i].long_name;
                                break;
                            case 'neighborhood':
                                neighborhood = addressResponse.result.address_components[i].long_name;
                                break;
                            case 'sublocality_level_1':
                                subLocal1 = addressResponse.result.address_components[i].long_name;
                                break;
                            case 'premise':
                                street_number = addressResponse.result.address_components[i].long_name;
                                break;
                            case 'route':
                                route = addressResponse.result.address_components[i].short_name;
                                break;
                            case 'postal_code':
                                postalCode = addressResponse.result.address_components[i].long_name;
                                break;
                            case 'administrative_area_level_1':
                                state = addressResponse.result.address_components[i].short_name;
                                break;
                            case 'country':
                                country = addressResponse.result.address_components[i].long_name;
                                break;
                            case 'locality':
                                city = addressResponse.result.address_components[i].long_name;
                                break;
                            default:
                                break;
                        }
                    }
                }
                street = addressResponse.result.name + ','+ street_number + ',' + route+ ',' + neighborhood;//+' ' +subLocal1;
                
                 
                if(component.get('v.isDropoff')){
                    
                        component.set('v.serviceRecord.ETST_Dropoff_Street__c', street);
                       // component.set('v.jobRecord.PostalCode', postalCode);
                        component.set('v.serviceRecord.ETST_Dropoff_State', state);
                        component.set('v.serviceRecord.ETST_Country__c', country);
                        component.set('v.serviceRecord.ETST_Dropoff_Emirate__c', city);
                         
                        component.set('v.serviceRecord.ETST_Dropoff_Location__Latitude__s', addressResponse.result.geometry.location.lat);
                        component.set('v.serviceRecord.ETST_Dropoff_Location__Longitude__s', addressResponse.result.geometry.location.lng);
                       var fullAddr=street+','+country;
                        fullAddr=fullAddr.replace(',,,',','); 
                        fullAddr=fullAddr.replace(',,',',');
                    component.set("v.serviceRecord.ETST_Drop_Off_To__c", fullAddr);
                    $A.util.addClass(component.find("Drop-Address-listbox"), "slds-hide");
                }else{
                    
                 
                    component.set('v.serviceRecord.ETST_Street_Number__c', street);
                   // component.set('v.jobRecord.PostalCode', postalCode);
                    component.set('v.serviceRecord.ETST_State_or_Province__c', state);
                    component.set('v.serviceRecord.ETST_Country__c', country);
                    component.set('v.serviceRecord.ETST_Emirates__c', city);
                    component.set('v.serviceRecord.ETST_Location__Latitude__s', addressResponse.result.geometry.location.lat);
                    component.set('v.serviceRecord.ETST_Location__Longitude__s', addressResponse.result.geometry.location.lng);
                    var fullAddr=street+','+country;
                        fullAddr=fullAddr.replace(',,,',','); 
                        fullAddr=fullAddr.replace(',,',',');
                    component.set("v.serviceRecord.ETST_Pick_Up_From__c", fullAddr);

                    component.set("v.disableCheckbox",false);
                    $A.util.addClass(component.find("Address-listbox"), "slds-hide");
                    
                    component.set("v.serviceRecord.ETST_Fare_Charges__c",'');
                    var servicetype=component.get("v.serviceRecord.ETST_Service_Type__c");
                    var currentTransportType=component.get('v.currentTransportType');
                    if(newTransportType=='Two Way' && currentTransportType!='Two Way' &&
                       addressResponse.result.geometry.location.lat!='' &&
                       addressResponse.result.geometry.location.lat!=null){
                        helper.getFareDetails(component, event, helper); 
                    }
                }
               component.set("v.searchKey", null);*/
               }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
       
    },
    updateServiceHelper: function(component, event, helper){
        component.set('v.loaded', false);
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "updateService";
        var params = {
            "recordId":component.get("v.recordId"),
            "serviceRecord" : component.get("v.serviceRecord"),
            "agreementId" : component.get("v.serviceRecord.ET_Sales_Agreement__c")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                 component.set('v.loaded', true);
                utility.showToast("School Tranport", "Service is updated. Please wait for coordinator Confirmation!!", "success", "dismissible");
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": $A.get("$Label.c.ETST_home_page")
                });
                urlEvent.fire();
            }),
            
            $A.getCallback(function(error) {
                component.set('v.loaded', true);
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    getFareDetails: function(component, event, helper){
        component.set('v.loaded', !component.get('v.loaded'));
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getFareDetails";
        var params = {
            "studentId": component.get("v.serviceRecord.ETST_Student__c"),
            "transportType": component.get("v.serviceRecord.ETST_Transport_Type__c"),
            "lat": component.get('v.serviceRecord.ETST_Location__Latitude__s'),
            "longt": component.get('v.serviceRecord.ETST_Location__Longitude__s')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('response'+JSON.stringify(response));
                if(response!=undefined && response!=null){
                    component.set('v.priceList',response); 
                    component.set('v.serviceRecord.ETST_Payee__c',response.ETST_Payee__c);
                    if( response.ETST_Payee__c=='Parent' && response.ETST_Payee__c!=null && response.ETST_Payee__c!=undefined
                      ){
                        helper.setUpdatedFare(component, event, helper); 
                    }else{
                        
                        component.set("v.serviceRecord.ETST_Fare_Charges__c",0);
                    }
                    component.set('v.loaded', !component.get('v.loaded'));
                }
                
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    setUpdatedFare: function(component, event, helper) {
        var pricelist=component.get('v.priceList');
        var finalAmount=0;
        var totalDays=0;
        var ONE_DAY=1000 * 60 * 60 * 24;
        var serviceType=component.get("v.serviceRecord.ETST_Service_Type__c");
        var proRateAllowed=pricelist.ETST_Pro_Rate__c;
        
        var endDt=component.get('v.serviceRecord.ETST_Pick_Up_End_Date__c');
        if ( Object.prototype.toString.call(endDt) === "[object String]") {
           endDt = new Date(endDt.substring(0, 4), 
                                endDt.substring(5, 7)-1, 
                                endDt.substring(8)); 
        }
        var startDt=component.get("v.acadamicStart");
         var firstDate = new Date(startDt.substring(0, 4), 
                                    startDt.substring(5, 7)-1, 
                                    startDt.substring(8));
        var today = new Date();
        
        if(today<firstDate){ 
            component.set('v.serviceRecord.ETST_Pick_Up_Start_Date__c',firstDate);
            totalDays=Math.floor((endDt - firstDate) /ONE_DAY);   
            
        }else{
            component.set('v.serviceRecord.ETST_Pick_Up_Start_Date__c',today); 
            totalDays=Math.floor((endDt - today) /ONE_DAY);            
        }
        totalDays+=2;
        
        
        var ratePerDay=pricelist.ETST_Fare_Amount__c/304;
        var currentFare=component.get("v.currentYearlyAmt");
        var currentratePerDay=currentFare/304;
        var curFinalAmount=0;
        finalAmount= ratePerDay*totalDays;
        curFinalAmount=currentratePerDay*totalDays;
         if(serviceType=='Yearly'){
              if(!proRateAllowed){
             	  finalAmount=(pricelist.ETST_Fare_Amount__c);
                  curFinalAmount=currentFare;
              }
            
            if(pricelist.ETST_Discount_Percentage__c!=0 && pricelist.ETST_Discount_Percentage__c!=null
               && pricelist.ETST_Discount_Percentage__c!=''){
                finalAmount-=finalAmount/pricelist.ETST_Discount_Percentage__c;
            }
            console.log('finalAmount1'+finalAmount);
            
        }else if(serviceType=='Half Yearly'){
            if(!proRateAllowed){
             	  finalAmount=(pricelist.ETST_Fare_Amount__c/2);
                  curFinalAmount=currentFare/2;
              }
            if(pricelist.ETST_Half_Yearly_Discount_Percentage__c!=0 && pricelist.ETST_Half_Yearly_Discount_Percentage__c!=null
               && pricelist.ETST_Half_Yearly_Discount_Percentage__c!=''){
                finalAmount-=finalAmount/pricelist.ETST_Half_Yearly_Discount_Percentage__c;
            }
            
        }else if(serviceType=='Quarterly'){
            if(!proRateAllowed){
             	  finalAmount=(pricelist.ETST_Fare_Amount__c/4);
                  curFinalAmount=currentFare/4;
              }
            if(pricelist.ETST_Quarterly_Discount_Percentage__c!=0  && pricelist.ETST_Quarterly_Discount_Percentage__c!=null
               && pricelist.ETST_Quarterly_Discount_Percentage__c!=''){
                finalAmount-=finalAmount/pricelist.ETST_Quarterly_Discount_Percentage__c;
            }
            
        }else if(serviceType=='Monthly'){
             if(!proRateAllowed){
             	  finalAmount=(pricelist.ETST_Amount__c);
                  //curFinalAmount=currentFare;
              }
            if(pricelist.ETST_Monthly_Discount_Percentage__c!=0 && pricelist.ETST_Monthly_Discount_Percentage__c!=null
               && pricelist.ETST_Monthly_Discount_Percentage__c!=''){
                finalAmount-=finalAmount/pricelist.ETST_Monthly_Discount_Percentage__c;
            }
            
        }
        
        if(pricelist.ETST_Tax_Percentage__c!=0 && pricelist.ETST_Tax_Percentage__c!=null
           && pricelist.ETST_Tax_Percentage__c!=''){
            finalAmount+=finalAmount/pricelist.ETST_Tax_Percentage__c;
        }
        if(pricelist.ETST_Maintenance_Percentage__c!=0 && pricelist.ETST_Maintenance_Percentage__c!=null
           && pricelist.ETST_Maintenance_Percentage__c!=''){
            finalAmount+=finalAmount/pricelist.ETST_Maintenance_Percentage__c;
        } 
        if(pricelist.ETST_Other_Services_Cost__c!=0 && pricelist.ETST_Other_Services_Cost__c!=null
           && pricelist.ETST_Other_Services_Cost__c!=''){
            finalAmount+=ETST_Other_Services_Cost__c;
        } 
        var amt=0;
        //var finalAmount=parseFloat(finalAmount).toFixed(2);
        //var curFinalAmount1=parseFloat(curFinalAmount).toFixed(2);
        //alert(finalAmount);
        if(finalAmount-curFinalAmount<0){
            amt=curFinalAmount-finalAmount;
            amt=parseFloat(amt).toFixed(2);
            component.set("v.serviceRecord.ETST_Fare_Charges__c",0);
            component.set("v.serviceRecord.ETST_Refund_Amount__c",amt);
            
        }else{
            amt=finalAmount-curFinalAmount;
            amt=parseFloat(amt).toFixed(2);
            component.set("v.serviceRecord.ETST_Fare_Charges__c",amt);
            
        }
        component.set('v.newFare',amt);
        
        
      
    },
    
})
({
    doInit : function(component, event, helper) {
        
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getStudentInfo";
        var params = {
            "studentId" : component.get('v.serviceRecord.ETST_Student__c'),
            "lang": component.get('v.clLang')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                if(response!=null && response!=undefined){
                 
                    console.log(JSON.stringify(response.transportTypesAR))
                    console.log(JSON.stringify(response.transportTypes))
                    component.set('v.hasPriceList',true);
                    component.set('v.transportTypes',response.transportTypes);
                    component.set('v.transportTypesAR',response.transportTypesAR);
                    component.set('v.paidByTypes',response.paidByTypes);
                    component.set('v.paidByTypesAR',response.paidByTypesAR);
                    console.log('acadamicStart-->'+response.acadamicStart);
                    console.log('acadamicEnd-->'+response.acadamicEnd);
                    component.set('v.acadamicStart',response.acadamicStart);
                    component.set('v.acadamicEnd',response.acadamicEnd);
                    component.set('v.schoolType',response.schoolType);
                    
                    if(component.get('v.schoolType')=="Government School"){
                       
                        component.set("v.serviceRecord.ETST_Transport_Type__c",'Two Way');
                        component.set("v.showPickup",true);
                        component.set("v.showDropoff",true);   
                        component.set("v.tempVar",true);
                        helper.getServiceTypesInfo(component, event, helper,'Two Way');        
                        
                    }
                    else{
                        component.set("v.serviceRecord.ETST_Transport_Type__c",'');
                    }
                    
                    
                }else{
                    component.set('v.hasPriceList',false);
                }
                component.set('v.loaded', true);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
        
        
    },
    getQuaerterlyPickupDates: function(component, event, helper,transportType) {
        //alert('dt'+component.get('v.serviceRecord.ETST_Pick_Up_Start_Date__c'));
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getQuaerterlyPickupDates";
        var resultPickupDate = this.getPickupDateStr(component, event, helper, component.get('v.serviceRecord.ETST_Pick_Up_Start_Date__c'));
        console.log('resultPickupDate: ' + resultPickupDate);
        var params = {
            "startDt" : resultPickupDate.pickStartDate //component.get('v.serviceRecord.ETST_Pick_Up_Start_Date__c')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                
                var endDt=response.endDate;
                
                if(response!=null && response!=undefined){
                    component.set('v.serviceRecord.ETST_Pick_Up_End_Date__c',
                                  new Date(endDt.substring(0, 4), 
                                           endDt.substring(5, 7)-1, 
                                           endDt.substring(8))); 
                    component.set('v.duration',response.Duration);
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
    getHalfYearlyPickupDates: function(component, event, helper,transportType) {
        //alert('dt'+component.get('v.serviceRecord.ETST_Pick_Up_Start_Date__c'));
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getHalfyrlyPickupDates";
        var resultPickupDate = this.getPickupDateStr(component, event, helper, component.get('v.serviceRecord.ETST_Pick_Up_Start_Date__c'));
        console.log('resultPickupDate: ' + resultPickupDate);
        var params = {
            "startDate" : resultPickupDate.pickStartDate //component.get('v.serviceRecord.ETST_Pick_Up_Start_Date__c')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                var endDt=response.endDate;
                // alert('endDt '+endDt); 
                if(response!=null && response!=undefined){
                    component.set('v.serviceRecord.ETST_Pick_Up_End_Date__c',new Date(endDt.substring(0, 4), 
                                                                                      endDt.substring(5, 7)-1, 
                                                                                      endDt.substring(8))); 
                    component.set('v.duration',response.Duration);
                    
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
    getServiceTypesInfo: function(component, event, helper,transportType) {
       
        component.set('v.loaded', !component.get('v.loaded'));
        
        var action = component.get('c.getServiceTypes');        
        action.setParams({
            studentId : component.get('v.serviceRecord.ETST_Student__c'),
            transportType:transportType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
               let data =  response.getReturnValue();
             
                if(data!=null && data!=undefined){
                    try{
                    component.set('v.hasPriceList',true);
                    component.set('v.serviceTypes',data.serviceTypes);
                    component.set('v.AreaBased',data.areabased);
                    component.set('v.transportAreas',data.transportareas);
                    component.set('v.transportAreasAR',data.transportareasAR);
                    
                    component.set('v.serviceTypesAR',data.serviceTypesAR);
                  
                   
                    
                    }catch(e){
                        console.log(e.message)
                    }
                    //component.set('v.proRateAllowed',response.proRateAllowed);
                }else{
                    alert('err')
                    component.set('v.hasPriceList',false);
                    
                }
                 if(!component.get("v.tempVar"))
                    component.set('v.loaded', !component.get('v.loaded'));
                
                component.set("v.tempVar",false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);  
    },
    deactivateStudent: function(component, event, helper){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "deactivateStudent";
        var params = {
            "studentId" : component.get('v.serviceRecord.ETST_Student__c'),
            "serviceRecord": component.get('v.serviceRecord')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                utility.showToast("Student", 'Student Service is cancelled', "success", "dismissible");
                $A.get('e.force:refreshView').fire();
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    getFareDetails: function(component, event, helper, isPick){
        
        component.set('v.loaded', !component.get('v.loaded'));
        
        var lat;
        var longt;
        var areabased=component.get('v.AreaBased');
        if(isPick){
            lat = component.get('v.serviceRecord.ETST_Location__Latitude__s');
            longt = component.get('v.serviceRecord.ETST_Location__Longitude__s')
        } else {
            lat = component.get('v.serviceRecord.ETST_Dropoff_Location__Latitude__s');
            longt = component.get('v.serviceRecord.ETST_Dropoff_Location__Longitude__s')
        }
        console.log('lat***'+lat);
        console.log('longt***'+longt);
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getFareDetails";
        var backendMethod2= "getFareDetailsbyarea";
        var params = {
            "studentId": component.get("v.serviceRecord.ETST_Student__c"),
            "transportType": component.get("v.serviceRecord.ETST_Transport_Type__c"),
            // "lat": component.get('v.serviceRecord.ETST_Location__Latitude__s'),
            // "longt": component.get('v.serviceRecord.ETST_Location__Longitude__s')
            "lat":null,
            "longt":null
        };
        var params2 = {
            "studentId": component.get("v.serviceRecord.ETST_Student__c"),
            "transportType": component.get("v.serviceRecord.ETST_Transport_Type__c"),
            "area": component.get("v.serviceRecord.ETST_Area__c"),
            // "lat": component.get('v.serviceRecord.ETST_Location__Latitude__s'),
            // "longt": component.get('v.serviceRecord.ETST_Location__Longitude__s')
            "lat":null,
            "longt":null
        };
        var promise;
        if(areabased)
            promise = utility.executeServerCall(component, backendMethod2, params2);	
        else
            promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('response'+JSON.stringify(response));
                if(response!=undefined && response!=null){
                    component.set('v.priceList',response); 
                    component.set('v.priceListId',response.Id); 
                    component.set('v.serviceRecord.ETST_Payee__c',response.ETST_Payee__c);
                    component.set('v.serviceRecord.ETST_Area_Zone__c',response.ETST_Zone__c);                       
                    component.set('v.serviceRecord.ET_Sales_Agreement__c',response.ETST_Sales_Agreement__c);
                    
                    if( response.ETST_Payee__c=='Parent' && response.ETST_Payee__c!=null && response.ETST_Payee__c!=undefined
                      ){
                        helper.setCalculatedFare(component, event, helper); 
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
    getStudentSchoolAreas : function(component, event, helper){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getStudentSchoolAreas";
        var params = {
            "schoolId" : component.get('v.studentRecord.ETST_School_Name__c')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.schoolAreas',response);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    createNewService: function(component, event, helper, editSection){
        
        component.set("v.disableAddSerice",true);
        component.set('v.loaded',false);
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "createNewService";
        component.set('v.addressRecord.ET_Service_Type__c','School Transport');
        var params = {
            "serviceRecord" : component.get("v.serviceRecord"),
            "isRenew" : component.get('v.renewServiceModal'),
            "acadamicStart":component.get("v.acadamicStart"),
            "acadamicEnd":component.get("v.acadamicEnd"),
            "addressRecord": component.get("v.addressRecord"),
            "employerName":component.get("v.employerName"),
            "paidBy": component.get("v.serviceRecord.ETST_Paid_By__c"),
            "salesAgg":component.get('v.serviceRecord.ET_Sales_Agreement__c'),
            "priceListId": component.get('v.priceListId') ,
            "editSection":editSection
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('response***'+JSON.stringify(response));
                
                helper.setDefaultValues(component, event, helper); 
                
                
                if(editSection){
                    try{
                        var serviceRecord =  component.get('v.studentRecord');//component.get("v.serviceRecord");
                        var reqId;
                        if(serviceRecord.ETST_Transport_Requests__r != undefined){
                            reqId = serviceRecord.ETST_Transport_Requests__r[0].Id
                        }
                        var url = '/customer/s/student-details?recordId='+serviceRecord.Id+'&amp;requestId='+reqId+'&amp;docId='+serviceRecord.ETST_Image_Document_Id__c+'&amp;lang='+ component.get('v.clLang');
                        window.open(url, "_self");
                    }catch(er){
                        alert(er.message)
                    }
                }else{
                    component.set('v.addServiceModal',false);
                    component.set('v.renewServiceModal',false);
                    component.set('v.loaded',true);
                    utility.showToast("Service Registration", 'Your Service is registered with us. Our Coordinator will reach you soon..!', "success", "dismissible");
                    var actionEvt = $A.get("e.c:ETST_sendDataEvent");
                    actionEvt.setParams({
                        "actionname": 'refresh'
                    });
                    actionEvt.fire();
                }
                
                
            }),
            
            $A.getCallback(function(error) {
                
                component.set('v.loaded',true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type": "error",
                    "message": JSON.stringify(error)
                });
                toastEvent.fire();
                component.set("v.disableAddSerice",false);
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
                component.set("v.disableAddSerice",false);
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
                if(isPick){ 
                    component.set('v.serviceRecord.ETST_Pick_Up_From__c',response);  
                    component.set('v.serviceRecord.ETST_Location__Latitude__s', latit);
                    component.set('v.serviceRecord.ETST_Location__Longitude__s', longit);
                } else{
                    component.set('v.serviceRecord.ETST_Drop_Off_To__c',response);
                    component.set('v.serviceRecord.ETST_Dropoff_Location__Latitude__s', latit);
                    component.set('v.serviceRecord.ETST_Dropoff_Location__Longitude__s', longit);
                }
                component.set("v.disableCheckbox",false);
                
                /*var servicetype=component.get("v.serviceRecord.ETST_Service_Type__c");
                    var transportType=component.get("v.serviceRecord.ETST_Transport_Type__c");
                   //  var payee=component.get("v.serviceRecord.ETST_Payee__c");
                    if(servicetype!=null && servicetype!='' && servicetype!=undefined
                       && transportType!=null && transportType!='' && transportType!=undefined 
                     //&& payee=='Parent' && payee!=null && payee!=undefined
                      ){
                        helper.getFareDetails(component, event, helper, isPick); 
                    }*/
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
            "SearchText" : searchText
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
                    /* if(component.get('v.isDropoff')){
                            $A.util.removeClass(component.find("invalidDrop"), "slds-hide"); 
                            
                        }else {
                            $A.util.removeClass(component.find("invalidpickup"), "slds-hide");
                            
                        }  */
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
                //component.set('v.lat', addressResponse.result.geometry.location.lat);
                //component.set('v.lon', addressResponse.result.geometry.location.lng);
                //alert(' '+component.get('v.lat'));     
                /*var postalCode = '', state = '', country= '', city = '', street = '',neighborhood='', street_number = '', route = '', subLocal1 = '', subLocal2 = '';
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
                        
                        
                    }
                    component.set("v.serviceRecord.ETST_Fare_Charges__c",'');
                        var servicetype=component.get("v.serviceRecord.ETST_Service_Type__c");
                        var transportType=component.get("v.serviceRecord.ETST_Transport_Type__c");
                       // var payee=component.get("v.serviceRecord.ETST_Payee__c");
                        if(servicetype!=null && servicetype!='' && servicetype!=undefined
                           && transportType!=null && transportType!='' && transportType!=undefined &&
                           addressResponse.result.geometry.location.lat!='' &&
                           addressResponse.result.geometry.location.lat!=null 
                           //&&payee=='Parent' && payee!=null && payee!=undefined
                          ){
                            helper.getFareDetails(component, event, helper);  
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
    setServiceDates: function(component, event, helper) {
        
        var date = new Date();
        //var firstDay = $A.localizationService.formatDate(new Date(date.getFullYear(), date.getMonth(), date.getDay()), "YYYY-MM-DD");
        var lastDay = $A.localizationService.formatDate(new Date(date.getFullYear(), date.getMonth(), 0), "YYYY-MM-DD");
        var serviceType=component.get("v.serviceRecord.ETST_Service_Type__c");
        var today = new Date();
        var startDt=component.get("v.acadamicStart");
        //var endDt=component.get("v.acadamicEnd");
        /*var lastDate = new Date(endDt.substring(0, 4), 
                                        endDt.substring(5, 7)-1, 
                                        endDt.substring(8));*/
        var resultPickupDate = this.getPickupDateStr(component, event, helper, component.get('v.serviceRecord.ETST_Pick_Up_Start_Date__c'));
        console.log('resultPickupDate: ' + resultPickupDate);
        var pSD = resultPickupDate.pickStartDate; //component.get('v.serviceRecord.ETST_Pick_Up_Start_Date__c');
        var lastDate = new Date(date.getFullYear()+1,5,30);
        var firstDate = new Date(startDt.substring(0, 4), 
                                 startDt.substring(5, 7)-1, 
                                 startDt.substring(8));
        var pickstDate = new Date(pSD.substring(0, 4), 
                                  pSD.substring(5, 7)-1, 
                                  pSD.substring(8));
        var curyearlastdate=new Date(lastDate.getFullYear()-1,lastDate.getMonth(),30);
        
        if(serviceType=='Yearly'){
            if(pickstDate >= firstDate)
                component.set('v.serviceRecord.ETST_Pick_Up_End_Date__c',lastDate);
            else if(pickstDate < firstDate)
                component.set('v.serviceRecord.ETST_Pick_Up_End_Date__c',curyearlastdate);
            
        }else if(serviceType=='Half Yearly'){
            helper.getHalfYearlyPickupDates(component, event, helper);
        }else if(serviceType=='Quarterly'){
            helper.getQuaerterlyPickupDates(component, event, helper);
        } 
            else if(serviceType=='Monthly'){
                component.set('v.serviceRecord.ETST_Pick_Up_End_Date__c',lastDay); 
            }  
    },
    setCalculatedFare: function(component, event, helper) {
        var pricelist=component.get('v.priceList');
        var finalAmount=0;
        var duration=component.get('v.duration');
        var ONE_DAY=1000 * 60 * 60 * 24;
        var totalDays=0;
        var acadamicYearDays=0;
        var today = new Date();
        //var firstDay = $A.localizationService.formatDate(new Date(today.getFullYear(), today.getMonth()-1,1), "YYYY-MM-DD");
        var currentYear=today.getFullYear();
        var serviceType=component.get("v.serviceRecord.ETST_Service_Type__c");
        //var proRateAllowed=component.get('v.proRateAllowed');
        var endDt=component.get('v.serviceRecord.ETST_Pick_Up_End_Date__c');
        var resultPickupDate = this.getPickupDateStr(component, event, helper, component.get('v.serviceRecord.ETST_Pick_Up_Start_Date__c'));
        console.log('resultPickupDate: ' + resultPickupDate);
        var pickStartDate = resultPickupDate.pickStartDate; //component.get('v.serviceRecord.ETST_Pick_Up_Start_Date__c');
        var startDt=component.get("v.acadamicStart");
        var firstDate = new Date(startDt.substring(0, 4), 
                                 startDt.substring(5, 7)-1, 
                                 startDt.substring(8));
        //alert('endDt '+endDt +' - firstDate'+firstDate);
        if(serviceType!='Select Dates' && serviceType!=''){
            /*if ( Object.prototype.toString.call(endDt) === "[object String]") {
               endDt = new Date(endDt.substring(0, 4), 
                                    endDt.substring(5, 7)+1, 
                                    endDt.substring(8)); 
               }*/
            if(serviceType=='Monthly'){
                finalAmount=(pricelist.ETST_Amount__c);
                var endDay=new Date(pickStartDate.substring(0, 4), 
                                    pickStartDate.substring(5, 7), 
                                    0); 
                component.set('v.serviceRecord.ETST_Pick_Up_End_Date__c',endDay);
                if (resultPickupDate.pickStartDateMM == 7 || resultPickupDate.pickStartDateMM == 8) {
                    component.set('v.startDt', new Date(pickStartDate.substring(0, 4),
                        pickStartDate.substring(5, 7) - 1,
                        1));
                } else {
                    component.set('v.startDt', new Date(pickStartDate.substring(0, 4),
                        pickStartDate.substring(5, 7) - 1,
                        pickStartDate.substring(8)));
                }    
                if(pricelist.ETST_Monthly_Discount_Percentage__c!=0 && pricelist.ETST_Monthly_Discount_Percentage__c!=null
                   && pricelist.ETST_Monthly_Discount_Percentage__c!=''){
                    finalAmount-=finalAmount/pricelist.ETST_Monthly_Discount_Percentage__c;
                }
                
            }else{
                /*if(today<firstDate){ 
                    component.set('v.serviceRecord.ETST_Pick_Up_Start_Date__c',firstDate);
                    totalDays=Math.floor((endDt - firstDate) /ONE_DAY);
                      
                  }else{*/
                if(pricelist.ETST_Pro_Rate__c=='Day'){
                    //component.set('v.serviceRecord.ETST_Pick_Up_Start_Date__c',today); 
                    totalDays=Math.floor((endDt - today) /ONE_DAY);
                    //For Leap Year, One day is added
                    if((currentYear % 4 == 0) && (currentYear % 100 != 0) || (currentYear % 400 == 0)){
                        acadamicYearDays=304;
                    }else{
                        acadamicYearDays=303;
                    }
                    var ratePerDay=pricelist.ETST_Fare_Amount__c/acadamicYearDays;
                }else if(pricelist.ETST_Pro_Rate__c=='Month'){
                    var pickDay;
                    if (resultPickupDate.pickStartDateMM == 7 || resultPickupDate.pickStartDateMM == 8) {
                        pickDay = new Date(pickStartDate.substring(0, 4),
                            pickStartDate.substring(5, 7) - 1,
                            1);
                    } else {
                        pickDay = new Date(pickStartDate.substring(0, 4),
                            pickStartDate.substring(5, 7) - 1,
                            pickStartDate.substring(8));
                    }
                    var months = (endDt.getFullYear() - pickDay.getFullYear()) * 12;
                    months -= pickDay.getMonth();
                    months += endDt.getMonth(); 
                    
                    /*if(serviceType=='Half Yearly' || serviceType=='Quarterly'){
                              finalAmount=(months+1)*pricelist.ETST_Amount__c;
                          }else{
                              finalAmount=(months)*pricelist.ETST_Amount__c;
                          } */ 
                        finalAmount=(months+1)*pricelist.ETST_Amount__c;
                        component.set('v.startDt',pickDay);                  
                        //alert(today.getMonth()+ '   '+months+' '+endDt.getMonth());
                        //component.set('v.serviceRecord.ETST_Pick_Up_Start_Date__c',today); 
                    }
                   
                   //}
                   
                   
                   if(serviceType=='Yearly'){              
                       if( pricelist.ETST_Pro_Rate__c=='Day'){
                           finalAmount= ratePerDay*(totalDays+2);
                       }else if( pricelist.ETST_Pro_Rate__c=='None' || pricelist.ETST_Pro_Rate__c==''
                                || pricelist.ETST_Pro_Rate__c==null){
                           finalAmount=(pricelist.ETST_Fare_Amount__c);
                       }
                       
                       if(pricelist.ETST_Discount_Percentage__c!=0 && pricelist.ETST_Discount_Percentage__c!=null
                          && pricelist.ETST_Discount_Percentage__c!=''){
                           finalAmount-=finalAmount/pricelist.ETST_Discount_Percentage__c;
                       }
                       console.log('finalAmount1'+finalAmount);
                       
                   }else if(serviceType=='Half Yearly'){
                       if( pricelist.ETST_Pro_Rate__c=='Day'){
                           finalAmount= ratePerDay*totalDays;
                       }else if( pricelist.ETST_Pro_Rate__c=='None' || pricelist.ETST_Pro_Rate__c==''
                                || pricelist.ETST_Pro_Rate__c==null){
                           finalAmount=(pricelist.ETST_Amount__c*duration);
                       }
                       if(pricelist.ETST_Half_Yearly_Discount_Percentage__c!=0 && pricelist.ETST_Half_Yearly_Discount_Percentage__c!=null
                          && pricelist.ETST_Half_Yearly_Discount_Percentage__c!=''){
                           finalAmount-=finalAmount/pricelist.ETST_Half_Yearly_Discount_Percentage__c;
                       }
                       
                   }else if(serviceType=='Quarterly'){
                       if(pricelist.ETST_Pro_Rate__c=='Day'){
                           finalAmount= ratePerDay*totalDays;
                       }else if( pricelist.ETST_Pro_Rate__c=='None' || pricelist.ETST_Pro_Rate__c==''
                                || pricelist.ETST_Pro_Rate__c==null){
                           finalAmount=(pricelist.ETST_Amount__c*duration);
                       }
                       if(pricelist.ETST_Quarterly_Discount_Percentage__c!=0  && pricelist.ETST_Quarterly_Discount_Percentage__c!=null
                          && pricelist.ETST_Quarterly_Discount_Percentage__c!=''){
                           finalAmount-=finalAmount/pricelist.ETST_Quarterly_Discount_Percentage__c;
                       }
                       
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
            
            component.set("v.serviceRecord.ETST_Fare_Charges__c",finalAmount.toFixed(2));
        }else if(serviceType=='Select Dates'){
            helper.calculateOndemandFare(component, event, helper);
        }
        
        console.log('serviceRecord-->'+JSON.stringify(component.get('v.serviceRecord')));
    },
    calculateOndemandFare: function(component, event, helper) {
        var utility = component.find("ETST_UtilityMethods");
        var pricelist=component.get('v.priceList');
        var finalAmount=0;
        var endDt=component.get('v.serviceRecord.ETST_Pick_Up_End_Date__c');
        var startDt=component.get('v.serviceRecord.ETST_Pick_Up_Start_Date__c');
        if ( Object.prototype.toString.call(startDt) === "[object String]") {
            startDt = new Date(startDt.substring(0, 4), 
                               startDt.substring(5, 7), 
                               startDt.substring(8)); 
        }
        if ( Object.prototype.toString.call(endDt) === "[object String]") {
            endDt = new Date(endDt.substring(0, 4), 
                             endDt.substring(5, 7), 
                             endDt.substring(8)); 
        }
        
        var totalDays=Math.floor((endDt - startDt) /(1000 * 60 * 60 * 24));
        if(totalDays>=pricelist.ETST_Min_Duration__c && totalDays<=pricelist.ETST_Max_Duration__c){
            finalAmount=totalDays*pricelist.ETST_Ondemand_Rate_per_Day__c;
            component.set("v.serviceRecord.ETST_Fare_Charges__c",finalAmount.toFixed(2));
        }else{
            var msg='On Demand services are provided for least '+pricelist.ETST_Min_Duration__c
            +' days'+' and max '+pricelist.ETST_Max_Duration__c+' days';
            utility.showToast("School Tranport", msg, "error", "dismissible");
            helper.setDefaultValues(component, event, helper);
        }
    },
    getEmployerAddress: function(component, event, helper) {
        
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getEmployerAddress";
        var params = {
            //"studentId" : component.get('v.serviceRecord.ETST_Student__c')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                if(response!=null && response!=undefined){
                    component.set('v.addressRecord',response.address);
                    console.log('addressRecord-->'+component.get('v.addressRecord'));
                    component.set('v.employerCountry',response.employerCountry);
                    // component.set('v.employerName',response.Account__r.ETST_Employer_Name__c);
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
    setDefaultValues: function(component, event, helper) {
        component.set('v.serviceRecord.ETST_Service_Type__c','');
        component.set('v.serviceRecord.ETST_Transport_Type__c','');
        component.set('v.serviceRecord.ETST_Area__c','');
        component.set('v.serviceRecord.ETST_Pick_Up_From__c','');
        component.set('v.serviceRecord.ETST_Drop_Off_To__c','');
        component.set('v.serviceRecord.ETST_Payee__c','');
        component.set('v.serviceRecord.ETST_Fare_Charges__c','');  
        component.set('v.serviceRecord.ETST_Paid_By__c','');
        component.set("v.serviceRecord.ETST_Pick_Up_Start_Date__c",'');
    },
    validateDateForGovtSchool : function(component, event, helper) {
        try{
            let hasError = false;
          	let lang = component.get('v.clLang');
            if(component.get('v.schoolType')=="Government School"){
                let rec =  component.get('v.serviceRecord');
               
                if(rec.Semester_1__c || rec.Semester_2__c || rec.Semester_3__c || rec.Full_Academic_Year__c || rec.Ramadan__c){
                    hasError = false;
                    
                }else{
                    
                    hasError = true;
                	helper.showToastMessage(lang=='ar'?'خطأ':'Error','Error',lang=='ar'?'نوع الخدمة':'Service Type is required.');
                    
                }
                console.log(JSON.stringify(rec))
               
                if(rec.ETST_Transport_Type__c=='Two Way' && rec.ETST_Area__c=='' && rec.Drop_Off_Area__c==''){
                    
                    hasError = true;
                	helper.showToastMessage(lang=='ar'?'خطأ':'Error','Error',lang=='ar'?'منطقة الصعود والنزول':'Pickup and Drop off areas are required');
                     
                }
               
                if(rec.ETST_Transport_Type__c=='Two Way' && !rec.ETST_Pick_Up_From__c && !rec.ETST_Drop_Off_To__c){
                    
                    hasError = true;
                	helper.showToastMessage(lang=='ar'?'خطأ':'Error','Error',lang=='ar'?'نقطة الصعود والنزول':'Pickup and Drop off locations are required');
                       
                }
               
                if(rec.ETST_Transport_Type__c=='Pick up only' && !rec.ETST_Area__c ){
                    hasError = true;
                	helper.showToastMessage(lang=='ar'?'خطأ':'Error','Error',lang=='ar'?'منطقة الصعود':'Pickup area is required');
                    
                }
               
                if(rec.ETST_Transport_Type__c=='Pick up only' && rec.ETST_Pick_Up_From__c==''){
                    
                    hasError = true;
                	helper.showToastMessage(lang=='ar'?'خطأ':'Error','Error',lang=='ar'?'موقع الصعود':'Pickup location is required');
                   
                }
               
                if(rec.ETST_Transport_Type__c=='Drop off only' && !rec.Drop_Off_Area__c ){
                    
                    hasError = true;
                	helper.showToastMessage(lang=='ar'?'خطأ':'Error','Error',lang=='ar'?'منطقة النزول':'Drop off area is required');
                    
                    
                }
           
                if(rec.ETST_Transport_Type__c=='Drop off only' && rec.ETST_Drop_Off_To__c=='' ){
                    
                    hasError = true;
                	helper.showToastMessage(lang=='ar'?'خطأ':'Error','Error',lang=='ar'?'موقع النزول':'Drop off location is required');
                    
                }
                if(rec.ETST_Area__c =='Others' && !rec.Other_Area__c){
                    
                    hasError = true;
                	helper.showToastMessage(lang=='ar'?'خطأ':'Error','Error',lang=='ar'?'موقع صعود آخر':'Other pick up area is required');
                    
                    
                }
                if(rec.Drop_Off_Area__c =='Others' && !rec.Other_Area_Drop_off__c){
                    
                    hasError = true;
                    helper.showToastMessage(lang=='ar'?'خطأ':'Error','Error',lang=='ar'?'موقع نزول آخر':'Other drop off area is required');
                    
                }
                
                if(rec.Academic_Year__c ==''){
                    
                    hasError = true;
                    helper.showToastMessage(lang=='ar'?'خطأ':'Error','Error',lang=='ar'?'العام الدراسي مطلوب':'Academic year is required');
                    
                }
              
                if(hasError){
                    return false; 
                }else{
                    return true; 
                }
                
                
            }else{
                return true;
            }
        }catch(e){
            console.log(e.message)
        }
        
    },

    getPickupDateStr: function (component, event, helper, strDate) {
        var dateMM = strDate.substring(5, 7);
        console.log('dateMM:' + dateMM);
        if (dateMM == 7 || dateMM == 8) {
            return {
                pickStartDate: strDate.substring(0, 5) + '09' + strDate.substring(7),
                pickStartDateMM: dateMM
            }
        } else {
            return {
                pickStartDate: strDate,
                pickStartDateMM: dateMM
            }
        }
    },
    
     showToastMessage : function(title,type,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":type,
            "title":title,
            "message":message,
            "mode":"dismissible"
        });
        toastEvent.fire();
    }
})
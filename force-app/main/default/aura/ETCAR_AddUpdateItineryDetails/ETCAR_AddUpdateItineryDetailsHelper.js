({
	getAddressRecommendations: function(component, event,searchText){
        var utility = component.find("ETCAR_UtillityMethods");
        var backendMethod = "getAddressSet";
        var params = {
            "SearchText" : searchText 
        };
        
        console.log('searchText2 = '+searchText);
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                //alert('addressResponse = '+response);
                var addressResponse = JSON.parse(response);
                var predictions = addressResponse.predictions;
                var addresses = [];
                if (predictions.length > 0) {
                    for (var i = 0; i < predictions.length; i++) {
                        var bc =[];
                        addresses.push(
                            {
                                main_text: predictions[i].structured_formatting.main_text, 
                                secondary_text: predictions[i].structured_formatting.secondary_text,
                                place_id: predictions[i].place_id
                            });
                        
                    }
                    if(component.get('v.isDropoff')){
                        console.log('in drop off');
                        $A.util.addClass(component.find("invalidDrop"), "slds-hide");  
                    }else {
                        console.log('in Pickup');
                        $A.util.addClass(component.find("invalidpickup"), "slds-hide");   
                    }
                }else{
                    if(component.get('v.isDropoff')){
                        $A.util.removeClass(component.find("invalidDrop"), "slds-hide"); 
                        //component.set("v.serviceRecord.ETST_Drop_Off_To__c",null);
                    }else {
                        $A.util.removeClass(component.find("invalidpickup"), "slds-hide");
                        // component.set("v.serviceRecord.ETST_Pick_Up_From__c",null);
                    }  
                }
                //set drop off address
                if(component.get('v.isDropoff')){
                    component.set("v.dropAddressList", addresses);
                    console.log('AddressList'+component.get("v.dropAddressList"));
                }
                //set Pickup address
                else{
                    console.log('in Pickup');
                    component.set("v.pickAddressList", addresses);
                    console.log('AddressList'+component.get("v.pickAddressList"));
                }
            }),
            
            $A.getCallback(function(error) {
                console.error('in error');
                var errorToShow = utility.convertToUserFriendlyErrMsg(error);
                utility.showToast("Limo Services",errorToShow , "error", "dismissible");
            })
        )	
        
    },
    //get address details by place Id from google API 
    getAddressDetailsByPlaceId: function(component,event){
        var selectedValue = event.currentTarget.dataset.value;
        var utility = component.find("ETCAR_UtillityMethods");
        var backendMethod = "getAddressDetailsByPlaceId";
        var params = {
            PlaceID:selectedValue 
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                // console.log('response'+response);
                var addressResponse = JSON.parse(response);
                // console.log('response'+addressResponse.result.geometry.location.lat);
                //console.log('response'+addressResponse.result.name);
                var postalCode = '', state = '', country= '', city = '', street = '',neighborhood='', street_number = '', route = '', subLocal1 = '', subLocal2 = '';
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
                street = addressResponse.result.name + ' '+ street_number + ' ' + route+ ' ' + neighborhood+' ' +subLocal1;
                console.log('street = '+ street);
                console.log('lat = '+ addressResponse.result.geometry.location.lat);
                console.log('long = '+ addressResponse.result.geometry.location.lng);
                component.set('v.serviceRequestRecord.ETST_Street_Number__c', street);
                // component.set('v.jobRecord.PostalCode', postalCode);
                component.set('v.serviceRequestRecord.ETST_State_or_Province__c', state);
                component.set('v.serviceRequestRecord.ETST_Country__c', country);
                component.set('v.serviceRequestRecord.ETST_Emirates__c	', city);
                //set drop off address
                if(component.get('v.isDropoff')){
                    component.set("v.serviceRequestRecord.ETST_Drop_Off_To__c", street+' '+country);
                    component.set("v.serviceRequestRecord.ETST_Dropoff_Location__Latitude__s", addressResponse.result.geometry.location.lat);
                    component.set("v.serviceRequestRecord.ETST_Dropoff_Location__Longitude__s", addressResponse.result.geometry.location.lng);
                    $A.util.addClass(component.find("Drop-Address-listbox2"), "slds-hide");
                }
                //set Pickup address
                else{
                    component.set("v.serviceRequestRecord.ETST_Pick_Up_From__c", street+' '+country);
                    component.set('v.serviceRequestRecord.ETST_Location__Latitude__s', addressResponse.result.geometry.location.lat);
                    component.set('v.serviceRequestRecord.ETST_Location__Longitude__s', addressResponse.result.geometry.location.lng);
                    $A.util.toggleClass(component.find("Drop-Address-listbox"), "slds-hide");
                }
                
                console.log('pickup address = '+ street+' '+country);
                
                
                
                component.set("v.searchKey", null);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Delivery Management", errorToShow, "error", "dismissible");
            })
        )	
        
        
    }
})
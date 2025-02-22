({
    doInit: function(component, event, helper){
        debugger;

        var action = component.get('c.getUserAccountDetails');
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Acc'+result.accRecordName);
                component.set('v.AccountId', result.accRecord);
                component.set('v.AccountName', result.accRecordName);
                component.set('v.AccountARName', result.accRecordARName);
                component.set('v.contactId', result.cntRecord);
                component.set('v.SchoolCity', result.accSchoolCity);
                component.set('v.SchoolCode', result.accSchoolCode);
                component.set('v.SchoolArea', result.accSchoolArea);
                component.set('v.SchoolAreaAR', result.accSchoolAreaAR);
                component.set('v.SchoolCityAR', result.accSchoolAreaAR);
                component.set('v.SchoolAreaArabic', result.accSchoolCityAR);
                
               // result.catchmentArea
                var dynamicList=result.catchmentArea;
                console.log('CATCHMENT AREA'+JSON.stringify(picklist));
               
                var picklist=[];
                var picklistAR=[];

                for(var itr in dynamicList){
                    picklist.push({label:dynamicList[itr].Name,value:dynamicList[itr].Name}); 
                    picklistAR.push({label:dynamicList[itr].Area_Arabic__c,value:dynamicList[itr].Area_Arabic__c}); 

                }
                component.set('v.options', picklist);
                component.set('v.optionsAR', picklistAR);
               
                console.log('AddressList'+component.get("v.SchoolCity"));
            }
        });
        $A.enqueueAction(action);
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
                component.set('v.tripLoc',response);  
                $A.util.addClass(component.find("invalidpickup"), "slds-hide");
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("ET MOE", "Please try again later or contact ET Support", "error", "dismissible");
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
                utility.showToast("ET MOE", "Please try again later or contact ET Support", "error", "dismissible");
            })
        )	
        
    },
    resetFlags: function(component,event,helper){
        component.set("v.HandicapService", false);
        component.set("v.NewTeacherTransport", false);
        component.set("v.AwarenessSession", false);
        component.set("v.NewTripsRequest", false);
        component.set("v.GrowthRequest", false);
        component.set("v.RequestaboardingpassforCompanionHandycamptransportation", false);
    },
    //get address details by place Id from google API 
    getAddressDetailsByPlaceId: function(component,event,helper,placeId){
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
                component.set('v.lat',addressResponse.result.geometry.location.lat);
                component.set('v.lon',addressResponse.result.geometry.location.lng);
                component.set('v.mapLoaded',true);
                component.set('v.vfUrl','/Business/apex/ETST_GoogleMapFinder?lat='+addressResponse.result.geometry.location.lat+'&long='+addressResponse.result.geometry.location.lng);
                
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("ET MOE", "Please try again later or contact ET Support", "error", "dismissible");
            })
        )	 
    },
    
     searchRecordsHelper : function(component, event, helper, value) {
        
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
        var searchString = component.get('v.searchString');
        component.set('v.message', '');
        component.set('v.recordsList', []);
        // Calling Apex Method
        var action = component.get('c.fetchRecords');
        action.setParams({
            'objectName' : component.get('v.objectName'),
            'filterField' : component.get('v.fieldName'),
            'searchString' : searchString,
            'value' : value
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS') {
                if(result.length > 0) {
                    // To check if value attribute is prepopulated or not
                    if( $A.util.isEmpty(value) ) {
                        component.set('v.recordsList',result);        
                    } else {
                        component.set('v.selectedRecord', result[0]);
                    }
                } else {
                    component.set('v.message', "No Records Found for '" + searchString + "'");
                }
            } else {
                // If server throws any error
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set('v.message', errors[0].message);
                }
            }
            // To open the drop down list of records
            if( $A.util.isEmpty(value) )
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
            $A.util.addClass(component.find("Spinner"), "slds-hide");
        });
        $A.enqueueAction(action);
    },
    
    handlefileAttached: function(component, event, helper,casid) {
        debugger;
        try{
            var type = component.find("mySelect").get("v.value");
            var fileActiVsAwerList = component.get('v.fileActvityVsAwerness');
            var fileEmiratesId = component.get('v.fileListOfEmiratesId');
            var fileMedical = component.get('v.fileListOfMedical');
            var filesDataPassport = component.get('v.fileListPassport'); 
            var filesDataAcademic = component.get('v.fileListAcademic');
            var filesDataAcquaintance = component.get('v.fileListAcquaintance');
            
            var fEIDvsMedical = component.get('v.mergedListofEIDvsMedical');
            var allFilesData  = component.get('v.mergedAllFilesCompanion');
            
            // var casid=component.get("v.newCaseId").toString();  
            var recordIdString = casid.toString();
            console.log(fileActiVsAwerList);
            console.log(recordIdString);
            var action = component.get("c.attachFileToCase");
            if (fileActiVsAwerList && fileActiVsAwerList.length > 0) {
                action.setParams({
                    recordId: recordIdString,
                    filesData: JSON.stringify(fileActiVsAwerList)
                });
                
                
            }else if(fEIDvsMedical && fEIDvsMedical.length > 0 && type==component.get("v.clSpecialNeedsTransportationRequest")){
                action.setParams({
                    recordId: recordIdString,
                    filesData: JSON.stringify(fEIDvsMedical)
                });
            }else if(allFilesData && allFilesData.length > 0 && type==component.get("v.clSpecialNeedsCompanionRequest")){
                action.setParams({
                    recordId: recordIdString,
                    filesData: JSON.stringify(allFilesData)
                });
            }
            
            
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    console.log("File attached to Case.");
                   // component.set('v.newCase',false);
                    
                    $A.get('e.force:showToast').setParams({
                        "title": "Success",
                        "message": "Case is created succesfully!",
                        "type": "success",
                    }).fire();
                     //component.set('v.showSpinner', false);
                    location.reload();
                } else {
                    
                }
            });
            $A.enqueueAction(action);
        }catch (e){
            console.log(e.message);
            actionEvt.fire();
            $A.get('e.force:showToast').setParams({
                "title": "error",
                "message": "Error attaching file to Case!",
                "type": "success",
            }).fire();
            console.log("Error attaching file to Case: " + response.getError());
        }
    },
    
    showToast: function(component, variant, title, message,type,key,mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "variant": variant,
            "title": title,
            "message": message,
            "type":type,
            "key":key,
            "mode":mode
            
        });
        toastEvent.fire();
    },
    
    
    
})
({
    MAX_FILE_SIZE: 3000000,
    CHUNK_SIZE: 750000,
    getLocations : function(component,event,helper){
      
        console.log('emirate locations>> '+component.get("v.emirate")+'--lang--'+component.get("v.clLang"));
        var reTest=component.get("v.isRetest");
        var action = component.get("c.getAvailableCenters");
        action.setParams({
            SelectedEmirate : component.get("v.emirate"),
            SelectedLang : component.get("v.clLang")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result locations>> '+JSON.stringify(result));
                component.set("v.locationsMap",result);
            }else{
                var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request, Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Error",msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },
    fetchRequiredDetails : function(component,event,allBookingData,selectedPlace,idxVar){
        console.log('allBookingData'+JSON.stringify(allBookingData));
        var reTest=component.get("v.isRetest");
        var action = component.get("c.getRequiredDetails");
        action.setParams({
            obj : JSON.stringify(allBookingData),
            placeStr : selectedPlace,
            SelectedEmirate : component.get("v.emirate")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result11>> '+JSON.stringify(result));
                allBookingData[idxVar]=result[idxVar];
                //allBookingData[idxVar].booking.ET_Location__c='';
                allBookingData[idxVar].certificates=[];
                allBookingData[idxVar].booking.Booking_Date__c=null;
                allBookingData[idxVar].booking.ETI_Booking_slots__c='';
                //allBookingData[idxVar].booking.ETI_Pick_Up_Location__c='';
                allBookingData[idxVar].booking.Preferred_Time__c='';
                //if(allBookingData[idxVar].booking.Selected_Services_Code__c!=null && allBookingData[idxVar].booking.Selected_Services_Code__c!=''
                if(allBookingData[idxVar].isTrailer){
                	allBookingData[idxVar].booking.Selected_Services_Code__c='10';
                    allBookingData[idxVar].serviceCode='10';
                    allBookingData[idxVar].isTrailer =false;
                }else if(allBookingData[idxVar].isEquipment){
                	allBookingData[idxVar].booking.Selected_Services_Code__c='5';
                    allBookingData[idxVar].serviceCode='5';
                    allBookingData[idxVar].isEquipment =false;
                }
                console.log('allBookingData11>> '+JSON.stringify(allBookingData));
                component.set("v.allBookingData",allBookingData);
                this.buildWrpData(component,allBookingData,false);
            }else{
                var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request, Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },
    getServiceType : function(component,event,helper){
        var action = component.get("c.getPickListValues");
        action.setParams({
            selectedObject : "ETI_Booking__c",
            selectedField : "Service_Type__c"
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var returning = [];
                var result = response.getReturnValue();
                component.set("v.serviceType",result);
            }
            else{
                var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request, Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },
    getPurposeType : function(component,event,helper){
        var action = component.get("c.getTestPurposeTypes"); 
        action.setParams({
            SelectedLang : component.get("v.clLang")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var returning = [];
                var result = response.getReturnValue();
                component.set("v.testPurposeType",result);
            }
            else{
                var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request, Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },
    getVehicleType: function(component,event,helper){
        var action = component.get("c.getVehicleTypes");
        action.setParams({
            SelectedLang : component.get("v.clLang")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var returning = [];
                var result = response.getReturnValue();
                component.set("v.newVehicleTypeList",result);
            }
            else{
                var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request, Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },
    getVehicleColor: function(component,event,helper){
        var action = component.get("c.getVehicleColors");
        action.setParams({
            SelectedLang : component.get("v.clLang")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var returning = [];
                var result = response.getReturnValue();
                component.set("v.newColorList",result);
            }else{
                var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request, Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },
    getAvailableServices : function(component,event,allBookingData,idxVar){
        //var allBookingData = component.get("v.bookingWrp");
        console.log('allBookingData>> '+JSON.stringify(allBookingData[idxVar]));
        console.log('idxVar>> '+idxVar);
        var selectedPlace;
        var selectedLocation;
        if(component.get("v.selectedPremises")=='Customer Premises-B2B')
            selectedPlace=component.get("v.selectedPlace");
        else
            selectedPlace=component.get("v.selectedPremises");
        if(allBookingData[idxVar].booking.Service_Type__c!='Certificate'){
            //Added 20/08/2020
            if(allBookingData[idxVar].booking.Service_Type__c == 'ADFCA'){
                allBookingData[idxVar].isAdfcaVehicle=true;
            	selectedLocation=component.get("v.emirate");
            }else if(component.get("v.selectedPremises")=='Visit ET Premises')
                selectedLocation=component.get("v.selectedLocation");
            else if(component.get("v.selectedPremises")!='Visit ET Premises')
                selectedLocation= allBookingData[idxVar].booking.ET_Location__c;
            console.log('selectedPlace>> '+selectedPlace);
            console.log('selectedLocation>> '+selectedLocation);
            //upto here
            //allBookingData[idxVar].servicesMap=[];
            var action = component.get("c.getServices");
            action.setParams({
                serviceType: allBookingData[idxVar].booking.Service_Type__c,
                placeStr: selectedPlace,
                isAdafca: allBookingData[idxVar].isAdfcaVehicle,
                location: selectedLocation
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    console.log('service>> '+JSON.stringify(result));
                    allBookingData[idxVar].servicesMap=result;
                    if(!allBookingData[idxVar].isAdfcaVehicle){
                        if(component.get("v.selectedPremises")=='Visit ET Premises' || (component.get("v.selectedPremises")=='Customer Premises-B2B' && component.get("v.selectedPlace")=='Home/Office Premise-B2B'))
                        {
                            if(allBookingData[idxVar].isTrailer){
                                if(component.get("v.selectedPremises")=='Visit ET Premises'){
                                    allBookingData[idxVar].booking.Selected_Services_Code__c='10';
                                    allBookingData[idxVar].serviceCode='10';
                                    this.fetchRequiredDetails(component, event,allBookingData, selectedPlace,idxVar);
                                }else {
                                    allBookingData[idxVar].booking.Selected_Services_Code__c='17';
                                    allBookingData[idxVar].serviceCode='17';
                                }
                                allBookingData[idxVar].isTrailer =false;
                            }else if(allBookingData[idxVar].isEquipment){
                                if(component.get("v.selectedPremises")=='Visit ET Premises'){
                                    allBookingData[idxVar].booking.Selected_Services_Code__c='5';
                                    allBookingData[idxVar].serviceCode='5';
                                    this.fetchRequiredDetails(component, event,allBookingData, selectedPlace,idxVar);
                                }else {
                                    allBookingData[idxVar].booking.Selected_Services_Code__c='8';
                                    allBookingData[idxVar].serviceCode='8';
                                }
                                allBookingData[idxVar].isEquipment =false;
                            }else {
                                if(component.get("v.selectedPremises")!='Visit ET Premises'){
                                    allBookingData[idxVar].booking.Selected_Services_Code__c='12';
                                }
                            }
                        }
                    }
                    component.set("v.allBookingData",allBookingData);
                    console.log('allBookingData>> '+JSON.stringify(allBookingData));
                    component.set("v.selectedServiceType",allBookingData[idxVar].booking.Service_Type__c);
                    this.buildWrpData(component,allBookingData,false);
                }
                else{
                    var msg=component.get("v.Unexpected_Error_Message");//'There is a problem in getting Services, Please try again or contact our customer service team.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                }
            });
            $A.enqueueAction(action);
        }else if(allBookingData[idxVar].booking.Service_Type__c=='Certificate'){
            this.getCetificateServices(component, event, allBookingData,idxVar);
        }
    },
    getCetificateServices : function(component,event,allBookingData,idxVar){
        console.log('allBookingData after >> '+JSON.stringify(allBookingData));
        var action = component.get("c.getCertificates");
        action.setParams({
            servicePremise: component.get("v.selectedPremises"),
            bookedServicesMap: allBookingData[idxVar].openServicesMap,                
            location: allBookingData[idxVar].booking.ET_Location__c // 4/11/20
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('service>> '+JSON.stringify(result));
                allBookingData[idxVar].certificates=result;
                allBookingData[idxVar].booking.Selected_Services_Code__c='';
                if(component.get("v.certificateServices")=='')
                    component.set("v.certificateServices",result);
                component.set("v.allBookingData",allBookingData);
                component.set("v.selectedServiceType",'Certificate');
                console.log('allBookingData>> '+JSON.stringify(allBookingData));
                this.buildWrpData(component,allBookingData,false);
            }
            else{
                var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request, Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },
    getBookingSlotOptions : function(component,event,helper){
        var action = component.get("c.getPickListValues");
        action.setParams({
            selectedObject : "ETI_Booking__c",
            selectedField : "ETI_Booking_slots__c"
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var returning = [];
                var result = response.getReturnValue();
                component.set("v.bookingSlotOptions",result);
            }
            else{
                var msg=component.get("v.Unexpected_Error_Message");//'There is a problem in getting Booking slots, Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },
    filesChangeHelper: function (component, event, bookingRecords,uploadedDocName,idx) {
        console.log('uploadedDocName22--'+uploadedDocName);
        var Filelist = [];
        var files =[];
        Filelist = bookingRecords[idx].fileName;
        if (event.getSource().get("v.files").length > 0) {
            var aa = event.getSource().get("v.name");
            var fileName1 = event.getSource().get("v.files");
            console.log('fileName1..'+fileName1);
            for (var i = 0; i < fileName1.length; i++) {
                console.log('fileName1 INN '+fileName1[i].name);
                Filelist.push({'docName': uploadedDocName,'Name' :fileName1[i].name,'Id' : aa});
            }
            console.log('Filelist..'+Filelist);
        }
        console.log('Filelist after--'+JSON.stringify(Filelist));
        bookingRecords[idx].fileName=Filelist;
        console.log('docbooking after--'+JSON.stringify(bookingRecords));
        component.set("v.bookingWrp", bookingRecords);
        this.uploadHelper(component, event, bookingRecords,uploadedDocName);
    },
    //File Upload Helper Methods STart
    uploadHelper: function(component, event,bookingRecords,uploadedDocName) {
        // start/show the loading spinner   
        //component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = event.getSource().get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            //component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents,bookingRecords,uploadedDocName);
        });
        objFileReader.readAsDataURL(file);
    },
    
    uploadProcess: function(component, file, fileContents,bookingRecords,uploadedDocName) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, bookingRecords,uploadedDocName);
    },    
    uploadInChunk: function (component, file, fileContents, startPosition, endPosition, bookingRecords, uploadedDocName) {
        var getchunk = fileContents.substring(startPosition, endPosition);
        var idx=component.get("v.selectedRowIndex");
        console.log('uploadInChunk idx--'+idx);
        console.log('uploadedDocName-- '+uploadedDocName);
        var files =[];
        files = bookingRecords[idx].uploadedFile;
        files.push({'docName': uploadedDocName,'fileName': file.name,'base64Data': encodeURIComponent(getchunk),'contentType': file.type, 'vehicleId': bookingRecords[idx].booking.Customer_Vehicle__c});
        bookingRecords[idx].uploadedFile = files;
        console.log('docbooking after--'+JSON.stringify(bookingRecords));
        component.set("v.bookingWrp", bookingRecords);
        component.set("v.fileIndex",1);
    },
    showSpinner: function(component){
        component.set("v.IsSpinner",true);  
    },
    
    hideSpinner: function(component){
        component.set("v.IsSpinner",false);  
    }, 
    
    showSlots: function(component){
        component.set("v.showAvailableSlots",true);  
    },
    
    hideSlots: function(component){
        component.set("v.showAvailableSlots",false);  
    },
    
    getAddressRecommendations: function(component, event,searchText,idx){
        console.log('---getPickupLocationHelper---');
        var action = component.get("c.getAddressSet");
        action.setParams({
            "SearchText" :searchText
        });
        action.setCallback(this,function(response){
            console.log('---inside Call BAck---');
            var state = response.getState();
            console.log(state,'state');
            if(state === "SUCCESS"){
                console.log('In side SUccess',response.getReturnValue());
                var addressResponse = JSON.parse(response.getReturnValue());
                console.log('addressResponse..',addressResponse);
                var predictions = addressResponse.predictions;
                var addresses = [];
                if (predictions.length > 0) {
                    for (var i = 0; i < predictions.length; i++) {
                        console.log('test...'+predictions[i].structured_formatting.main_text);
                        console.log('test1...'+predictions[i].structured_formatting.secondary_text);
                        console.log('test2...'+predictions[i].place_id);
                        addresses.push({
                            main_text: predictions[i].structured_formatting.main_text, 
                            secondary_text: predictions[i].structured_formatting.secondary_text,
                            place_id: predictions[i].place_id
                        });
                    }
                    
                }
                //var allBookingData = component.get("v.allBookingData");
                console.log('addresses result '+JSON.stringify(addresses));
                component.set("v.AddressList", addresses);
                //allBookingData[idx].AddressList=addresses;
                //console.log('bookingRecords '+JSON.stringify(allBookingData));
                //component.set("v.allBookingData", allBookingData);
                //component.set("v.AddressList", addresses);
                //console.log('main print'+bookingRecords[idx].slotList);
            }
            else{
                var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request. Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");           
            }
        });
        $A.enqueueAction(action);
    },
    getAddressDetailsByPlaceId: function(component,event,idx){
        var selectedValue = event.currentTarget.dataset.value;
        console.log('selectedValue '+selectedValue);
        var allBookingData = component.get("v.allBookingData");
        console.log('allBookingData '+JSON.stringify(allBookingData));
        var AddressList = component.get("v.AddressList");
        console.log('AddressList '+JSON.stringify(AddressList));
        var idx = component.get("v.indexVar");
        console.log('idx>> '+idx);
        var action = component.get("c.getAddressDetailsByPlaceId");
        action.setParams ({
            PlaceID:selectedValue 
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state'+state);
            if(state === "SUCCESS"){
                var addressResponse = JSON.parse(response.getReturnValue());
                console.log('addressResponse'+JSON.stringify(addressResponse));
                var fullAddress;
                for (var i = 0; i < AddressList.length; i++) {
                    if(selectedValue==AddressList[i].place_id)
                    	fullAddress=AddressList[i].main_text+','+addressResponse.result.formatted_address;
                }
                for (var idx = 0; idx < allBookingData.length; idx++) {
                    allBookingData[idx].booking.ETI_Pick_Up_Location__c=fullAddress;
                    allBookingData[idx].booking.Latitude__c=addressResponse.result.geometry.location.lat;
                    allBookingData[idx].booking.Longitude__c=addressResponse.result.geometry.location.lng;
                }
                component.set("v.pickUpLocation",fullAddress);
                var addressComponents = addressResponse.result.address_components;
                for (var i = 0; i < addressComponents.length; i++) {
                    if(addressComponents[i].long_name=='Sharjah' || addressComponents[i].long_name=='Abu Dhabi'
                       || addressComponents[i].long_name=='Dubai' || addressComponents[i].long_name=='Fujairah'){
                        console.log('long_name INN>> '+addressComponents[i].long_name);
                        component.set("v.pickUpEmirate",addressComponents[i].long_name);
                    	break;
                    }
                }
                console.log('long_name11>> '+component.get("v.pickUpEmirate"));
                component.set("v.AddressList",[]);
                if(component.get("v.emirate")==='Sharjah'){
                    component.set("v.isAddressChanged",true);
                    this.getLocationBylatAndlng(component, event,allBookingData, addressResponse.result.geometry.location.lat,addressResponse.result.geometry.location.lng);
                }
            };
        });
        $A.enqueueAction(action); 
    },
    getLocationBylatAndlng : function(component,event,allBookingData,lat,lng){
        console.log('lat>> '+lat+' lng>> '+lng);
        var action = component.get("c.getLocationByLatitudeAndLongitude");
        action.setParams({
            selectedEmirate : component.get("v.emirate"),
            latitude : lat,
            longitude : lng
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result '+JSON.stringify(result));
                for (var idx = 0; idx < allBookingData.length; idx++) {
                    allBookingData[idx].booking.ET_Location__c =result;
                }
                component.set("v.allBookingData",allBookingData);
                console.log('allBookingData2--'+JSON.stringify(allBookingData));
                helper.buildWrpData(component, allBookingData,false);
            }else{
                var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request. Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },
    getPreferredTime : function(component,event,helper){
        var action = component.get("c.getPickListValues1");
        action.setParams({
            selectedObject : "ETI_Booking__c",
            selectedField : "Preferred_Time__c"
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var returning = [];
                var result = response.getReturnValue();
                console.log('result '+JSON.stringify(result));
                component.set("v.preferredTimeList",result);
            }
            else{
                var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request. Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },
    ValidateRequiredDetails : function(component,event,allBookingData,idx){
        console.log('ValidateRequiredDetails>> ');
        var selectedPremises = component.get('v.selectedPremises');
        var bookingRecords = component.get("v.bookingWrp");
        console.log('allBookingData>> '+allBookingData.length);
        console.log('bookingRecords>> '+bookingRecords.length);
        console.log('selectedPremises>> '+component.get("v.selectedPremises"));
        console.log('selectedPremises>> '+component.get("v.selectedPremises"));
        if(component.get("v.emirate")!='Sharjah'){
            if ((selectedPremises !='Customer Premises-B2B' && allBookingData[idx].booking.ET_Location__c == '' || allBookingData[idx].booking.ET_Location__c == undefined) ||((component.get("v.isRetest")==true && component.get("v.selectedServiceType") == '') || (component.get("v.isRetest")==false && allBookingData[idx].booking.Service_Type__c ==''))
                || (component.get("v.selectedPremises") == 'Customer Premises-B2B' && (allBookingData[idx].booking.ETI_Pick_Up_Location__c == undefined || allBookingData[idx].booking.ETI_Pick_Up_Location__c == '' || allBookingData[idx].booking.Preferred_Time__c == ''))
                || ((allBookingData[idx].booking.Service_Type__c =='Police Inspection' || allBookingData[idx].booking.Service_Type__c =='Certificate') && (allBookingData[idx].booking.Purpose_Type__c == undefined || allBookingData[idx].booking.Purpose_Type__c == ''))
                || (component.get("v.selectedPremises") == 'Visit ET Premises' && allBookingData[idx].booking.ETI_Booking_slots__c == '')
                || (allBookingData[idx].isAdfcaVehicle==true && (allBookingData[idx].customerVehicle.Trade_License_Number__c =='' || allBookingData[idx].customerVehicle.Trade_License_Number__c ==undefined || allBookingData[idx].customerVehicle.Trade_License_Expiry_Date__c == undefined || allBookingData[idx].customerVehicle.Trade_License_Expiry_Date__c==''))
                || (allBookingData[idx].isColorChange == true && allBookingData[idx].newColor == '')
                || (allBookingData[idx].isVehicleTypeChange == true && allBookingData[idx].newVehicleType == '')){
                if(!component.get("v.isChildModel") && !component.get("v.isRetest")){
                    allBookingData[idx].isValidated=true;
                    allBookingData[idx].errorMessage = component.get("v.Fields_Mandatory_Message");//'All fields are Mandatory to confirm booking, Click on Book.';
                    window.scrollTo(0, 0);
                }else if(component.get("v.isChildModel") || component.get("v.isRetest")){
                    allBookingData[idx].isChildValidated=true;
                    allBookingData[idx].childErrorMessage = component.get("v.All_fields_are_Mandatory");//'All fields are Mandatory.';
                    window.scrollTo(0, 0);
                }
                console.log('ValidateRequiredDetails>>11 ');
                component.set("v.isDataValidated",true);
                component.set('v.allBookingData',allBookingData);
				/*for(var idx1=0;idx<allBookingData.length;idx1++){  
					if(allBookingData[idx1].rowIndex==bookingRecords[idx].rowIndex)
						bookingRecords[idx]=allBookingData[idx];
				}*/
                /*var isError=false;
                var errorPage=1;
                for(var x=0;x<allBookingData.length;x++){  
                    console.log('x >> '+x);
                    for(var y=0;y<bookingRecords.length;y++){  
                        console.log('y >> '+y);
                        if(allBookingData[x].rowIndex==bookingRecords[y].rowIndex)
                            bookingRecords[y]=allBookingData[x];
                    }
                    if(allBookingData[x].isValidated && !isError){
                        console.log('allBookingData.length 11>> '+allBookingData.length);
                        console.log('rowIndex 11>> '+allBookingData[x].rowIndex);
                        errorPage=allBookingData[x].pageNumber;
                        isError=true;
                    }
                    console.log('isError>> '+isError);
                    if(isError){
                        console.log('errorPage 22>> '+errorPage);
                        component.set("v.currentPageNumber",errorPage);
                        helper.buildData(component, helper);
                        var msg='Please fix all the errors to proceed.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast("Error",msg,"","dismissible","error");
                    }
                }
				component.set("v.bookingWrp", bookingRecords);
                console.log('bookingRecords11>> '+bookingRecords.length);
                console.log('allBookingData11>> '+allBookingData.length);*/
                console.log('ValidateRequiredDetails>>22 ');
                return true;
            }
            console.log('ValidateRequiredDetails>>33 ');
            if(component.get("v.isRetest"))
                return false;
            
            var fileInput;
            if(allBookingData[idx].fileName !='' && allBookingData[idx].fileName !=undefined)
                fileInput = allBookingData[idx].fileName.length;
            else
                fileInput = 0;
            var totalDocList = allBookingData[idx].requiredDocuments.length;
            var reqDocList =[];
            for(var i=0;i<totalDocList;i++){
                if(allBookingData[idx].requiredDocuments[i].Is_Required__c == true){
                    reqDocList.push(allBookingData[idx].requiredDocuments[i].Name);
                }
            }
            var fileNotUploadedNames =[];
            if(reqDocList.length != 0){
                var requiredFilesUploaded =true;
                console.log('reqDocList>> '+reqDocList);
                console.log('fileName>> '+allBookingData[idx].fileName);
                 if(reqDocList.length != fileInput)
                    requiredFilesUploaded =false;
                if(!requiredFilesUploaded){
                	if(!component.get("v.isChildModel")){
                        allBookingData[idx].isValidated=true;
                        allBookingData[idx].errorMessage = component.get("v.Upload_all_Required_Documents");//'Please upload All Required Documents.';
                    }else {
                        allBookingData[idx].isChildValidated=true;
                        allBookingData[idx].childErrorMessage = component.get("v.Upload_all_Required_Documents");
                    }
                    component.set('v.allBookingData',allBookingData);
					/*for(var idx=0;idx<allBookingData.length;idx++){  
						if(allBookingData[idx].rowIndex==bookingRecords[idx].rowIndex)
							bookingRecords[idx]=allBookingData[idx];
					}
					component.set("v.bookingWrp", bookingRecords);*/
                    return true;
                }
                /*if(fileInput!=0){
                    for(var i=0;i<fileInput;i++){
                        console.log('docName>> '+reqDocList.includes(allBookingData[idx].fileName[i].docName));
                        if(reqDocList.includes(allBookingData[idx].fileName[i].docName))
                            requiredFilesUploaded =true;
                    }
                }
                if(!requiredFilesUploaded){
                    for(var i=0;i<reqDocList.length;i++){
                        if(fileInput!=0 && !reqDocList.includes(allBookingData[idx].fileName[i].docName)){
                            component.set("v.IsSpinner", false);
                            component.set("v.isFilesNotUploaded", true);
                            if(fileInput !=0)
                                fileNotUploadedNames.push(reqDocList[i]);
                        }
                    }
                    console.log('fileNotUploadedNames>> '+fileNotUploadedNames);
                    console.log('fileInput>> '+fileInput);
                    console.log('reqDocList>> '+reqDocList.length);
                    if(fileInput ==0 && reqDocList.length !=0){
                        if(!component.get("v.isChildModel")){
                            allBookingData[idx].isValidated=true;
                            allBookingData[idx].errorMessage = 'Please upload All Required Documents.';
                        }else {
                            allBookingData[idx].isChildValidated=true;
                            allBookingData[idx].childErrorMessage = 'Please upload All Required Documents.';
                        }
                        component.set("v.bookingWrp", allBookingData);
                        //component.set("v.isFilesNotUploaded", true);
                        //component.set("v.fileNotUploadedErrorMsg",errorMsg );
                        var scrollOptions = {
                            left: 0,
                            top: 0,
                            behavior: 'smooth'
                        }
                        window.scrollTo(scrollOptions);
                        return true;  
                    }
                    if(fileNotUploadedNames.length !=0){
                        var errorMsg='Please upload All Required Documents.';
                        errorMsg=errorMsg+'<html>';
                        for(var i=0;i<fileNotUploadedNames.length;i++){
                            errorMsg = errorMsg+'<li>'+fileNotUploadedNames[i]+'</li>';
                        }
                        errorMsg = errorMsg+'</html>';
                        if(!component.get("v.isChildModel")){
                            allBookingData[idx].isValidated=true;
                            allBookingData[idx].errorMessage = errorMsg;
                        }else {
                            allBookingData[idx].isChildValidated=true;
                            allBookingData[idx].childErrorMessage = errorMsg;
                        }
                        component.set("v.bookingWrp", allBookingData);
                        //component.set("v.fileNotUploadedErrorMsg",errorMsg );
                        return true;  
                    }
                }*/
            }
        }else if(component.get("v.emirate")=='Sharjah'){
			if(component.get("v.selectedPremises") == 'Customer Premises-B2B' && (allBookingData[idx].booking.ET_Location__c == undefined
                || allBookingData[idx].booking.ET_Location__c == '' || allBookingData[idx].booking.Booking_Date__c == undefined 
                || allBookingData[idx].booking.Booking_Date__c == '' || allBookingData[idx].booking.Preferred_Time__c == '' || allBookingData[idx].booking.Preferred_Time__c ==undefined )){
                if(!component.get("v.isChildModel") && !component.get("v.isRetest")){
                    allBookingData[idx].isValidated=true;
                    allBookingData[idx].errorMessage = component.get("v.Fields_Mandatory_Message");//'All fields are Mandatory to confirm booking, Click on Book to fill.';
                    window.scrollTo(0, 0);
                }else if(component.get("v.isChildModel") || component.get("v.isRetest")){
                    allBookingData[idx].isChildValidated=true;
                    allBookingData[idx].childErrorMessage = component.get("v.All_fields_are_Mandatory");//'All fields are Mandatory.';
                    window.scrollTo(0, 0);
                }
                component.set('v.allBookingData',allBookingData);
				/*for(var idx=0;idx<allBookingData.length;idx++){  
					if(allBookingData[idx].rowIndex==bookingRecords[idx].rowIndex)
						bookingRecords[idx]=allBookingData[idx];
				}
				component.set("v.bookingWrp", bookingRecords);*/
                return true;
            }
		}
        return false;
    }, 
    certificateLocations : function(component,event,allBookingData,idxVar){
        console.log('ValidateRequiredDetails>> ');
        var selectedPlace;
        if(allBookingData[idxVar].booking.Service_Type__c=='Certificate'){
            if(component.get("v.selectedPremises")=='Customer Premises-B2B')
                selectedPlace=component.get("v.selectedPlace");
            else 
                selectedPlace=component.get("v.selectedPremises");
        }
        console.log("selectedPlace>> "+selectedPlace);
        var selectedServices=allBookingData[idxVar].booking.Selected_Services_Code__c;
        console.log("selectedServices>> "+selectedServices);
        /* selectedOptions.forEach((option,index) => {
            console.log('option: '+option);
            if(selectedServices!='' && selectedServices!=undefined)
            selectedServices=selectedServices+';'+option;
            else
            selectedServices=option;
            console.log('selectedServices: '+selectedServices);
        });*/
        console.log("################");    
        var action = component.get("c.getSelectedCertificateCenters");
        action.setParams({
            selectedServices : selectedServices,
            placeStr : selectedPlace,
            SelectedEmirate : component.get("v.emirate")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result>> '+JSON.stringify(result));
                allBookingData[idxVar].locationMap=result;
                component.set("v.allBookingData",allBookingData);
                // component.get("v.bookingWrp")[idxVar].locationMap=result;
                // allBookingData[idxVar].booking.Selected_Services_Code__c=selectedServices;
                allBookingData[idxVar].booking.ET_Location__c='';
                allBookingData[idxVar].booking.Booking_Date__c=null;
                allBookingData[idxVar].booking.ETI_Booking_slots__c='';
                allBookingData[idxVar].booking.ETI_Pick_Up_Location__c='';
                allBookingData[idxVar].booking.Preferred_Time__c='';
                component.set("v.IsSpinner", false);
                console.log('length>> '+result.length);
                if(result==undefined || result.length ==0){
                    allBookingData[idxVar].isChildValidated=true;
                    allBookingData[idxVar].childErrorMessage=component.get("v.Locations_Not_Available");//'Locations are not available for selected Certificates';
                }else {
                    allBookingData[idxVar].isChildValidated=false;
                    allBookingData[idxVar].childErrorMessage='';
                }
                // component.set("v.bookingWrp",bookingRecords);
                //bookingRecords[idxVar]=result[idxVar];
                /*bookingRecords[idxVar].locationMap=result[idxVar].locationMap;
                    bookingRecords[idxVar].booking.ET_Location__c='';
                    bookingRecords[idxVar].booking.Booking_Date__c=null;
                    bookingRecords[idxVar].booking.ETI_Booking_slots__c='';
                    bookingRecords[idxVar].booking.ETI_Pick_Up_Location__c='';
                    bookingRecords[idxVar].booking.Preferred_Time__c='';*/
        //console.log('bookingRecords>> '+JSON.stringify(bookingRecords));
        //component.set("v.bookingWrp",JSON.parse(JSON.stringify(bookingRecords)));
    }else{
        component.set("v.IsSpinner", false);
    }
        
    });
        $A.enqueueAction(action);
    },
    handleOnChangeOfPurposeHelper: function (component, event, helper) {
        var allBookingData = component.get("v.allBookingData");
        var idx = event.getSource().get("v.name");
        //allBookingData[idx].customerVehicle.Trade_License_Number__c = '';
        //allBookingData[idx].booking.Trade_License_Expiry_Date__c = null;
        //allBookingData[idx].booking.Selected_Services_Code__c = '';
        //allBookingData[idx].booking.ET_Location__c = '';
        //allBookingData[idx].booking.ETI_Pick_Up_Location__c = '';
        allBookingData[idx].slotList = [];
        allBookingData[idx].booking.Booking_Date__c = null;
        allBookingData[idx].booking.ETI_Booking_slots__c = '';
        allBookingData[idx].booking.Preferred_Time__c = '';
        allBookingData[idx].uploadedFile = [];
        allBookingData[idx].fileName = [];
        component.set('v.allBookingData', allBookingData);
        helper.buildWrpData(component, allBookingData,false);
    },
    validateEmail :function(email) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
		if(!$A.util.isEmpty(email)){   
            return email.match(regExpEmailformat)
        }
    },
    /*
     * this function will build table data
     * based on current page selection
     * */
    buildWrpData : function(component, allBookingData,isValidFlag) {
        var isError=false;
        var errorPage=1;
        console.log('allBookingData: '+JSON.stringify(allBookingData));
        var bookingRecords = component.get("v.bookingWrp");
        var bookings =[];
        for(var x=0;x<allBookingData.length;x++){  
            for(var y=0;y<bookingRecords.length;y++){  
                if(allBookingData[x].rowIndex==bookingRecords[y].rowIndex && allBookingData[x].booking.Customer_Vehicle__c==bookingRecords[y].booking.Customer_Vehicle__c){
                    bookings.push(allBookingData[x]);
                }
            }
            if(isValidFlag){
                if(allBookingData[x].isValidated && !isError){
                    errorPage=allBookingData[x].pageNumber;
                    isError=true;
                }
        	}
            console.log('isError>> '+isError);
        }
        console.log('bookingRecords: '+JSON.stringify(bookings));
        if(!isError)
            component.set("v.bookingWrp",bookings);
        else {
            console.log('errorPage 22>> '+errorPage);
            this.buildData(component);
        }
    },
    buildData : function(component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allBookingData = component.get("v.allBookingData");
        var bookingRecords = component.get("v.bookingWrp");
        var totalRecords = component.get("v.totalRecords");
        console.log('pageNumber>> '+pageNumber);
        console.log('pageSize>> '+pageSize);
        var x = (pageNumber-1)*pageSize;
        var end=(pageNumber)*pageSize;
		console.log('x>> '+x);
        console.log('end>> '+end);
        component.set("v.recordStart", x+1);
        var s=0;
        var e=pageSize;
        for(var i=1;i<=pageSize+1;i++){
            for(;s<e;s++){  
                allBookingData[s].pageNumber=i;
                if(s==e-1){
                    s=e;
                    e=e+pageSize;
                    if(e>allBookingData.length)
                        e=allBookingData.length;
                    break;
                }
            }
        }
        //creating data-table data
        console.log('end>> ',end);
        for(; x<end; x++){
            if(allBookingData[x]){
                allBookingData[x].isSelectedRecord=false;
            	data.push(allBookingData[x]);
            }
        }
        console.log('allBookingData>> '+JSON.stringify(allBookingData));
        console.log('data>> '+JSON.stringify(data));
        component.set("v.allBookingData", allBookingData);
        component.set("v.bookingWrp", data);
        if(end>totalRecords)
        	component.set("v.recordEnd", totalRecords);
        else 
            component.set("v.recordEnd", end);
        this.generatePageList(component, pageNumber);
    },
    
    /*
     * this function generate page list
     * */
    generatePageList : function(component, pageNumber){
        console.log('pageNumber22>> ',pageNumber);
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        console.log('totalPages>> '+totalPages);
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        console.log('pageList>> '+pageList);
        component.set("v.pageList", pageList);
    },
    readFile: function(component, file, name) {
        var idx = component.get("v.selectedRowIndex");
        var allBookingData = component.get("v.allBookingData");
        // alert(allBookingData[idx].fileListWrap)
        var Filelist = allBookingData[idx].fileListWrap;// component.get('v.fileListFornewVersion');
        if(Filelist == undefined || Filelist == null){
            Filelist = [];
        }else{
            var Filelist = allBookingData[idx].fileListWrap;
        }
        var objFileReader = new FileReader();
        var self = this;
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            // console.log('### ', encodeURIComponent(fileContents));
            Filelist.push({'base64Data': encodeURIComponent(fileContents),'fileName' :name, 'contentType' : file.type});
            console.log('@@@  ' + JSON.stringify(Filelist))
            allBookingData[idx].fileListWrap = Filelist;
            component.set('v.allBookingData', allBookingData);
        });
        objFileReader.readAsDataURL(file);
        component.set('v.allBookingData', allBookingData);
      },
    /*getColorIndex: function (component, color, newColorList) {
        
        //var newColorList = component.get("v.newColorList");
        let currentindex = -1;
        //alert('Hello  ' + color)
        for(let index = 0; index < newColorList.length; index++){
            //alert(newColorList[index].id)
            if(color == newColorList[index].id){
                //alert(newColorList[index]);
                currentindex = index;
                break;
            }
        }
        return currentindex;
    }*/
    /*  getChangelocation: function (component, event, helper) {
        var action = component.get("c.getChangelocationFromContact");
        action.setParams({
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                 console.log('selectedEmirate1 = ' + result );
                component.set("v.selectedEmirate", result);
               
            }
        });
        $A.enqueueAction(action);
    },*/
    
    getPickListValueMNVRBrand: function (component, event, helper) {
        var pickvar = component.get("c.getPickListValuesIntoListMNVRBrand");
        pickvar.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var list = response.getReturnValue();
                component.set("v.picvalue", list);
            }
            else if(state === 'ERROR'){
                //var list = response.getReturnValue();
                //component.set("v.picvalue", list);
                alert('ERROR OCCURED.');
            }
        })
        $A.enqueueAction(pickvar);  
    },
    
        UpdateDocument : function(component,event,Id) {  
        var action = component.get("c.UpdateFiles");  
      
        action.setParams({"documentId":Id,  
                          "recordId": component.get("v.recordId")  
                         });  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue();  
                console.log('Result Returned: ' +result);  
               
            }  
        });  
        $A.enqueueAction(action);  
    },
    
    
    upload: function(component, file, base64Data, callback) {
        var action = component.get("c.uploadFile");
        console.log('type: ' + file.type);
        action.setParams({
            fileName: file.name,
            base64Data: base64Data,
            contentType: file.type
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                callback(a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    show: function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hide:function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
     createDraftBooking: function (component, event, helper) {
        //debugger;
        var sectionidblock = component.find("sectionidblock").getElement();
        component.set("v.IsSpinner", true);
        var idx = component.get("v.selectedRowIndex");
        var allBookingData = component.get("v.allBookingData");
         console.log('allBookingData>> '+JSON.stringify(allBookingData));
        var bookingRecords = component.get("v.bookingWrp");
        console.log('bnkg1--'+JSON.stringify(allBookingData[idx]));
        console.log('idx>> '+idx);
        var selectedPremises = component.get('v.selectedPremises');
        if((!allBookingData[idx].isAdfcaVehicle && (allBookingData[idx].booking.Selected_Services_Code__c == undefined || allBookingData[idx].booking.Selected_Services_Code__c == '')) || (selectedPremises !='Customer Premises-B2B' && (allBookingData[idx].booking.Purpose_Type__c == undefined || allBookingData[idx].booking.Purpose_Type__c == ''))){
            allBookingData[idx].isChildValidated=true;
            allBookingData[idx].childErrorMessage = component.get("v.All_fields_are_Mandatory");//'All fields are Mandatory.';
            component.set("v.bookingWrp", allBookingData);
            component.set("v.IsSpinner", false);
            sectionidblock.scrollTop = 0;
            return false;
        }
        var isDataMissing =false;
        component.set("v.isFilesNotUploaded", false);

        // Multiple document upload functionality start
        var serType=component.get("v.selectedServiceType");
        var fileListFornewVersion=component.get("v.fileListFornewVersion");
        if((allBookingData[idx].booking.Service_Type__c =='Certificate' ||allBookingData[idx].booking.Service_Type__c =='ADFCA') && (allBookingData[idx].fileListWrap == undefined || allBookingData[idx].fileListWrap.length ==0)){
            component.set("v.requiredDocError", true);
            component.set("v.IsSpinner", false);
            return false;
        }else{
            component.set("v.requiredDocError", false);
        }
        //allBookingData[idx].booking.Is_Terms_and_Conditions_Checked__c = termsAndCond;
        if((allBookingData[idx].booking.Service_Type__c == 'Police Inspection' || allBookingData[idx].booking.Service_Type__c == 'SPEA Inspection') && component.get("v.selectedPremises") == 'Customer Premises-B2B')
            allBookingData[idx].booking.Service_Premises__c=component.get("v.selectedPlace");
        else
            allBookingData[idx].booking.Service_Premises__c=component.get("v.selectedPremises");
        var bookingDate = allBookingData[idx].booking.Booking_Date__c;
        var location = allBookingData[idx].booking.ET_Location__c;
        isDataMissing = helper.ValidateRequiredDetails(component, event, allBookingData,idx);
        console.log('isDataMissing>> '+isDataMissing+' bookingDate>> '+bookingDate+' location>> '+location);
        if (isDataMissing){ 
            console.log('isDataMissing if<< '+isDataMissing);
            component.set("v.bookingWrp", allBookingData);
            component.set("v.IsSpinner", false);
            sectionidblock.scrollTop = 0;
            return false;
        }
        if (allBookingData[idx].isAdfcaVehicle && allBookingData[idx].customerVehicle.Trade_License_Expiry_Date__c < component.get("v.minDate")){
     		allBookingData[idx].isChildValidated=true;
            allBookingData[idx].childErrorMessage =component.get("v.Trade_License_Date_should_be_future");// 'Trade License Date should be future.';
            component.set("v.bookingWrp", allBookingData);
            component.set("v.IsSpinner", false);
            sectionidblock.scrollTop = 0;
            return false;
        }
        console.log('isDataMissing111>> '+isDataMissing);
        let isRestest= component.get('v.isRetest');
        if(isRestest){
            console.log('isDataMissing222>> '+isDataMissing);
            if(!allBookingData[0].isTermsAndConditionsAgreed){
                console.log('isDataMissing33>> '+isDataMissing);
                var parentElement =  component.find('termsandconditioncheckboxParent').getElement();
                var errorElement =  component.find('termsandconditioncheckboxError').getElement();
                $A.util.addClass(parentElement, 'slds-has-error');
                $A.util.removeClass(errorElement, 'slds-hide');
                component.set("v.IsSpinner", false);
                sectionidblock.scrollTop = 0;
                return false;
            }
        }
        console.log('isDataMissing44>> '+isDataMissing);
        var locationcheck = true;
        if(selectedPremises =='Visit ET Premises')
            locationcheck =  location !== undefined;
        console.log('isDataMissing555>> '+isDataMissing);
         //added below lines by Janardhan 03-04-23
         if(component.get("v.emirate")=='Sharjah'){
              var filesData = component.get('v.speaFileList')
              
              try{
             if(!allBookingData[idx].booking.MNVR_Brand__c){
                  helper.showErrorToast({
                    "title": "Warning",
                    "type": "Warning",
                    "message":"MNVR brand is required"
                });
                isDataMissing = true;
              }else if(allBookingData[idx].booking.MNVR_Brand__c =='Other' && !allBookingData[idx].booking.MNVR_Brand_Other__c){
                  helper.showErrorToast({
                    "title": "Warning",
                    "type": "Warning",
                    "message":"MNVR brand other is required"
                });
                isDataMissing = true;
              }else if(!allBookingData[idx].booking.MNVR_Model_Number__c){
                  helper.showErrorToast({
                    "title": "Warning",
                    "type": "Warning",
                    "message":"MNVR Model No. is required"
                });
                isDataMissing = true;
              }else if(!allBookingData[idx].booking.MNVR_Serial_Number__c){
                  helper.showErrorToast({
                    "title": "Warning",
                    "type": "Warning",
                    "message":"MNVR Serial No. is required"
                });
                isDataMissing = true;
              }else if(filesData == ''){                
                  helper.showErrorToast({
                    "title": "Warning",
                    "type": "Warning",
                    "message":"Attachment is required."
                });
                isDataMissing = true;
              }             
             
              }catch(e){
                  console.log(e.message)
              }
         }
         
         
       if (!isDataMissing && bookingDate !== undefined && locationcheck) {
           console.log('isDataMissing66>> '+isDataMissing);
            component.set("v.isDataValidated",false);
            allBookingData[idx].errorMessage='';
            allBookingData[idx].isChildValidated =false;
            allBookingData[idx].childErrorMessage = '';
            for (var indexVar = 0; indexVar < allBookingData.length; indexVar++) {
                if(idx==indexVar)
                    allBookingData[indexVar].isSelectedRecord=true;
                else 
                    allBookingData[indexVar].isSelectedRecord=false;
            }
            console.log('allBookingData before>> '+JSON.stringify(allBookingData));
           
            var action = component.get("c.createDraftBookings");
            action.setParams({
                obj:JSON.stringify(allBookingData),
                filesData : JSON.stringify(component.get('v.speaFileList'))
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state-->'+state);
                
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log('result draft>> '+JSON.stringify(result));
                    for(var indexVar=0;indexVar<allBookingData.length;indexVar++){
                        allBookingData[indexVar].requestId=result[indexVar].requestId;
                    }
                    result[idx].booking.Booking_Date__c=allBookingData[idx].booking.Booking_Date__c.substring(0, 10);
                    allBookingData[idx].booking=result[idx].booking;
                    allBookingData[idx].isChildValidated=result[idx].isChildValidated;
                    allBookingData[idx].childErrorMessage=result[idx].childErrorMessage;
                    allBookingData[idx].slotList=result[idx].slotList;
                    console.log('allBookingData Draft--'+JSON.stringify(allBookingData));
                    //component.set("v.bookingWrp",allBookingData);
                    component.set("v.allBookingData",allBookingData);
                    helper.buildWrpData(component, allBookingData,false);
                    if(!allBookingData[idx].isChildValidated){
                        console.log('isChildValidated INN--'+JSON.stringify(allBookingData[idx].isChildValidated));
                         if(component.get('v.speaFileList')){
                            component.set('v.speaFileList',[]);
                        }
                        var msg=component.set("v.Record_Saved_Successfully");//'The record has been Saved Sucessfully.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Success"),msg,"","dismissible","success");
                        component.set("v.isChildModel",false);
                    }else {
                        var msg=allBookingData[idx].childErrorMessage;
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                        component.set("v.IsSpinner", false);
            			return false;
                    }
                }else {
                    var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request. Please try again or contact our customer service team.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                }
               if (state === "ERROR") {
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                }
               }
                
                component.set("v.IsSpinner", false);
            });
            $A.enqueueAction(action);
        }else {
			component.set("v.allBookingData",allBookingData);
			for(var x=0;x<allBookingData.length;x++){  
				console.log('x >> '+x);
				for(var y=0;y<bookingRecords.length;y++){  
					 console.log('y >> '+y);
					if(allBookingData[x].rowIndex==bookingRecords[y].rowIndex)
						bookingRecords[y]=allBookingData[x];
				}
			}
            component.set("v.bookingWrp",bookingRecords);
            component.set("v.IsSpinner", false);
            sectionidblock.scrollTop = 0;
        }
    },
    showErrorToast : function(params) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    }
})
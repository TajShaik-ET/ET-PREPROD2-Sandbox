({
    MAX_FILE_SIZE: 3000000,
    CHUNK_SIZE: 750000,
    getLocations : function(component,event,helper){
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
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },
    fetchRequiredDetails : function(component,event,allBookingRows,selectedPlace,idxVar){
        console.log('allBookingRows'+JSON.stringify(allBookingRows));
        var reTest=component.get("v.isRetest");
        var action = component.get("c.getRequiredDetails");
        action.setParams({
            obj : JSON.stringify(allBookingRows),
            placeStr : selectedPlace,
            SelectedEmirate : component.get("v.emirate")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result>> '+JSON.stringify(result));
                allBookingRows[idxVar]=result[idxVar];
                //allBookingRows[idxVar].booking.ET_Location__c='';
                allBookingRows[idxVar].certificates=[];
                allBookingRows[idxVar].booking.Booking_Date__c=null;
                allBookingRows[idxVar].booking.ETI_Booking_slots__c='';
                //allBookingRows[idxVar].booking.ETI_Pick_Up_Location__c='';
                allBookingRows[idxVar].booking.Preferred_Time__c='';
                //if(allBookingRows[idxVar].booking.Selected_Services_Code__c!=null && allBookingRows[idxVar].booking.Selected_Services_Code__c!=''
                if(allBookingRows[idxVar].isTrailer){
                	allBookingRows[idxVar].booking.Selected_Services_Code__c='10';
                    allBookingRows[idxVar].serviceCode='10';
                    allBookingRows[idxVar].isTrailer =false;
                }else if(allBookingRows[idxVar].isEquipment){
                	allBookingRows[idxVar].booking.Selected_Services_Code__c='5';
                    allBookingRows[idxVar].serviceCode='5';
                    allBookingRows[idxVar].isEquipment =false;
                }
                console.log('allBookingRows>> '+JSON.stringify(allBookingRows));
                component.set("v.bookingWrp",allBookingRows);
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
    
    getAvailableServices : function(component,event,bookingRecords,idxVar){
        console.log('bookingRecords>> '+JSON.stringify(bookingRecords));
        console.log('idxVar>> '+idxVar);
        var selectedPlace;
        var selectedLocation;
        if(component.get("v.selectedPremises")=='Customer Premises')
            selectedPlace=component.get("v.selectedPlace");
        else
            selectedPlace=component.get("v.selectedPremises");
        if(bookingRecords[idxVar].booking.Service_Type__c!='Certificate'){
            if(bookingRecords[idxVar].booking.Service_Type__c == 'ADFCA'){//18/10/20
                bookingRecords[idxVar].isAdfcaVehicle=true;
                selectedLocation=component.get("v.emirate");
            }else if(component.get("v.selectedPremises")=='Visit ET Premises')
                selectedLocation=component.get("v.selectedLocation");
            else if(component.get("v.selectedPremises")!='Visit ET Premises')
                selectedLocation= bookingRecords[idxVar].booking.ET_Location__c;
            console.log('selectedPlace>> '+selectedPlace);
            console.log('selectedLocation>> '+selectedLocation);
            //upto here
            //bookingRecords[idxVar].servicesMap=[];
            var action = component.get("c.getServices");
            action.setParams({ //18/10/20
                serviceType: bookingRecords[idxVar].booking.Service_Type__c,
                placeStr: selectedPlace,
                isAdafca: bookingRecords[idxVar].isAdfcaVehicle,
                location: selectedLocation
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    console.log('service>> '+JSON.stringify(result));
                    bookingRecords[idxVar].servicesMap=result;
                    if(!bookingRecords[idxVar].isAdfcaVehicle){
                        if(bookingRecords[idxVar].isTrailer){
                            bookingRecords[idxVar].booking.Selected_Services_Code__c='10';
                            bookingRecords[idxVar].serviceCode='10';
                            bookingRecords[idxVar].isTrailer =false;
                            this.fetchRequiredDetails(component, event,bookingRecords, selectedPlace,idxVar);
                        }else if(bookingRecords[idxVar].isEquipment){
                            bookingRecords[idxVar].booking.Selected_Services_Code__c='5';
                            bookingRecords[idxVar].serviceCode='5';
                            bookingRecords[idxVar].isEquipment =false;
                            this.fetchRequiredDetails(component, event,bookingRecords, selectedPlace,idxVar);
                        }
                    }
                    component.set("v.bookingWrp",bookingRecords);
                    console.log('bookingRecords>> '+JSON.stringify(bookingRecords));
                    //component.set("v.selectedServiceType",'Police Inspection');
                    component.set("v.selectedServiceType",bookingRecords[idxVar].booking.Service_Type__c);
                }
                else{
                    var msg=component.get("v.Unexpected_Error_Message");//'There is a problem in getting Services, Please try again or contact our customer service team.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                }
            });
            $A.enqueueAction(action);
        }else if(bookingRecords[idxVar].booking.Service_Type__c=='Certificate'){
            this.getCetificateServices(component, event, bookingRecords,idxVar);
        }
    },
    getCetificateServices : function(component,event,bookingRecords,idxVar){
        console.log('bookingRecords after >> '+JSON.stringify(bookingRecords));
        var action = component.get("c.getCertificates");
        action.setParams({
            servicePremise: component.get("v.selectedPremises"),
            bookedServicesMap: bookingRecords[idxVar].openServicesMap,                
            location: bookingRecords[idxVar].booking.ET_Location__c // 4/11/20
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('service>> '+JSON.stringify(result));
                if(result==null){
                    var msg='This Vehicle has pending bookings.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Error",msg,"","dismissible","error");
                    bookingRecords[idxVar].showBook=false;
                    component.set("v.showBook",false);
                    component.set("v.bookingWrp",bookingRecords);
                }else {
                    bookingRecords[idxVar].certificates=result;
                    bookingRecords[idxVar].booking.Selected_Services_Code__c='';
                    if(component.get("v.certificateServices")=='')
                        component.set("v.certificateServices",result);
                    component.set("v.bookingWrp",bookingRecords);
                    component.set("v.selectedServiceType",'Certificate');
                    console.log('bookingRecords>> '+JSON.stringify(bookingRecords));
                }
            }
            else{
                var msg=component.get("v.Unexpected_Error_Message");//'There is a problem in getting Services, Please try again or contact our customer service team.';
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
                var msg=component.get("v.Unexpected_Error_Message");//'There is a problem in getting Services, Please try again or contact our customer service team.';
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
                console.log('addresses result '+JSON.stringify(addresses));
                component.set("v.AddressList", addresses);
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
        var allBookingRows = component.get("v.bookingWrp");
        console.log('allBookingRows'+JSON.stringify(allBookingRows));
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
                for (var idx = 0; idx < allBookingRows.length; idx++) {
                    allBookingRows[idx].booking.ETI_Pick_Up_Location__c=fullAddress;
                    allBookingRows[idx].booking.Latitude__c=addressResponse.result.geometry.location.lat;
                    allBookingRows[idx].booking.Longitude__c=addressResponse.result.geometry.location.lng;
                }
                component.set("v.pickUpLocation",fullAddress);
                component.set("v.AddressList",[]);
                //this.getLocationBylatAndlng(component, event,allBookingRows, addressResponse.result.geometry.location.lat,addressResponse.result.geometry.location.lng);
            };
        });
        $A.enqueueAction(action); 
    },
    getLocationBylatAndlng : function(component,event,allBookingRows,lat,lng){
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
                for (var idx = 0; idx < allBookingRows.length; idx++) {
                    allBookingRows[idx].booking.ET_Location__c =result;
                }
                component.set("v.bookingWrp",allBookingRows);
                console.log('bnkg2--'+JSON.stringify(allBookingRows));
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
    ValidateRequiredDetails : function(component,event,bookingRecords,idx){
        console.log('ValidateRequiredDetails>> ');
        var selectedPremises = component.get('v.selectedPremises');
        console.log('selectedPremises>> '+selectedPremises);
        console.log('Pick_Up_Location>> '+bookingRecords[idx].booking.ETI_Pick_Up_Location__c);
        if(component.get("v.emirate")!='Sharjah'){
            if ((selectedPremises !='Customer Premises' && bookingRecords[idx].booking.ET_Location__c == '' || bookingRecords[idx].booking.ET_Location__c == undefined) ||((component.get("v.isRetest")==true && component.get("v.selectedServiceType") == '') || (component.get("v.isRetest")==false && bookingRecords[idx].booking.Service_Type__c ==''))
                || (component.get("v.selectedPremises") == 'Customer Premises' && (bookingRecords[idx].booking.ETI_Pick_Up_Location__c == undefined || bookingRecords[idx].booking.ETI_Pick_Up_Location__c == '' || bookingRecords[idx].booking.Preferred_Time__c == ''))
                || ((bookingRecords[idx].booking.Service_Type__c =='Police Inspection' || bookingRecords[idx].booking.Service_Type__c =='Certificate') && (bookingRecords[idx].booking.Purpose_Type__c == undefined || bookingRecords[idx].booking.Purpose_Type__c == ''))
                || (component.get("v.selectedPremises") == 'Visit ET Premises' && bookingRecords[idx].booking.ETI_Booking_slots__c == '')
                || (bookingRecords[idx].isAdfcaVehicle==true && (bookingRecords[idx].customerVehicle.Trade_License_Number__c =='' || bookingRecords[idx].customerVehicle.Trade_License_Number__c ==undefined || bookingRecords[idx].customerVehicle.Trade_License_Expiry_Date__c == undefined || bookingRecords[idx].customerVehicle.Trade_License_Expiry_Date__c==''))
                || (bookingRecords[idx].isColorChange == true && bookingRecords[idx].newColor == '')
                || (bookingRecords[idx].isVehicleTypeChange == true && bookingRecords[idx].newVehicleType == '')){
                if(!component.get("v.isChildModel") && !component.get("v.isRetest")){
                    bookingRecords[idx].isValidated=true;
                    bookingRecords[idx].errorMessage = component.get("v.Fields_Mandatory_Message");;
                    window.scrollTo(0, 0);
                }else if(component.get("v.isChildModel") || component.get("v.isRetest")){
                    bookingRecords[idx].isChildValidated=true;
                    bookingRecords[idx].childErrorMessage = component.get("v.All_fields_are_Mandatory");;
                    window.scrollTo(0, 0);
                }
                console.log('ValidateRequiredDetails>>11 ');// || bookingRecords[idx].newColor2 == '' || bookingRecords[idx].newColor3 == '' || bookingRecords[idx].newColor4 == ''
                component.set("v.isDataValidated",true);
                component.set("v.bookingWrp",bookingRecords);
                console.log('ValidateRequiredDetails>>22 ');
                return true;
            }
            console.log('ValidateRequiredDetails>>33 ');
            if(component.get("v.isRetest"))
                return false;
            
            var fileInput;
            if(bookingRecords[idx].fileName !='' && bookingRecords[idx].fileName !=undefined)
                fileInput = bookingRecords[idx].fileName.length;
            else
                fileInput = 0;
            var totalDocList = bookingRecords[idx].requiredDocuments.length;
            var reqDocList =[];
            for(var i=0;i<totalDocList;i++){
                if(bookingRecords[idx].requiredDocuments[i].Is_Required__c == true){
                    reqDocList.push(bookingRecords[idx].requiredDocuments[i].Name);
                }
            }
            var fileNotUploadedNames =[];
            if(reqDocList.length != 0){
                var requiredFilesUploaded =true;
                console.log('reqDocList>> '+reqDocList);
                console.log('fileName>> '+bookingRecords[idx].fileName);
                 if(reqDocList.length != fileInput)
                    requiredFilesUploaded =false;
                if(!requiredFilesUploaded){
                	if(!component.get("v.isChildModel")){
                        bookingRecords[idx].isValidated=true;
                        bookingRecords[idx].errorMessage = component.get("v.Upload_all_Required_Documents");
                        window.scrollTo(0, 0);
                    }else {
                        bookingRecords[idx].isChildValidated=true;
                        bookingRecords[idx].childErrorMessage = component.get("v.Upload_all_Required_Documents");;
                        window.scrollTo(0, 0);
                    }
                    component.set("v.bookingWrp", bookingRecords);
                    return true;
                }
                /*if(fileInput!=0){
                    for(var i=0;i<fileInput;i++){
                        console.log('docName>> '+reqDocList.includes(bookingRecords[idx].fileName[i].docName));
                        if(reqDocList.includes(bookingRecords[idx].fileName[i].docName))
                            requiredFilesUploaded =true;
                    }
                }
                if(!requiredFilesUploaded){
                    for(var i=0;i<reqDocList.length;i++){
                        if(fileInput!=0 && !reqDocList.includes(bookingRecords[idx].fileName[i].docName)){
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
                            bookingRecords[idx].isValidated=true;
                            bookingRecords[idx].errorMessage = 'Please upload All Required Documents.';
                        }else {
                            bookingRecords[idx].isChildValidated=true;
                            bookingRecords[idx].childErrorMessage = 'Please upload All Required Documents.';
                        }
                        component.set("v.bookingWrp", bookingRecords);
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
                            bookingRecords[idx].isValidated=true;
                            bookingRecords[idx].errorMessage = errorMsg;
                        }else {
                            bookingRecords[idx].isChildValidated=true;
                            bookingRecords[idx].childErrorMessage = errorMsg;
                        }
                        component.set("v.bookingWrp", bookingRecords);
                        //component.set("v.fileNotUploadedErrorMsg",errorMsg );
                        return true;  
                    }
                }*/
            }
        }
        return false;
    }, 
    certificateLocations : function(component,event,allBookingRows,idxVar){
        console.log('ValidateRequiredDetails>> ');
        var selectedPlace;
        if(allBookingRows[idxVar].booking.Service_Type__c=='Certificate'){
            if(component.get("v.selectedPremises")=='Customer Premises')
                selectedPlace=component.get("v.selectedPlace");
            else 
                selectedPlace=component.get("v.selectedPremises");
        }
        console.log("selectedPlace>> "+selectedPlace);
        var selectedServices=allBookingRows[idxVar].booking.Selected_Services_Code__c;
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
                allBookingRows[idxVar].locationMap=result;
                component.set("v.bookingWrp",allBookingRows);
                // component.get("v.bookingWrp")[idxVar].locationMap=result;
                // allBookingRows[idxVar].booking.Selected_Services_Code__c=selectedServices;
                allBookingRows[idxVar].booking.ET_Location__c='';
                allBookingRows[idxVar].booking.Booking_Date__c=null;
                allBookingRows[idxVar].booking.ETI_Booking_slots__c='';
                allBookingRows[idxVar].booking.ETI_Pick_Up_Location__c='';
                allBookingRows[idxVar].booking.Preferred_Time__c='';
                component.set("v.IsSpinner", false);
                console.log('length>> '+result.length);
                if(result==undefined || result.length ==0){
                    allBookingRows[idxVar].isChildValidated=true;
                    allBookingRows[idxVar].childErrorMessage=component.get("v.Locations_Not_Available");
                }else {
                    allBookingRows[idxVar].isChildValidated=false;
                    allBookingRows[idxVar].childErrorMessage='';
                }
                // component.set("v.bookingWrp",allBookingRows);
                //allBookingRows[idxVar]=result[idxVar];
                /*allBookingRows[idxVar].locationMap=result[idxVar].locationMap;
                    allBookingRows[idxVar].booking.ET_Location__c='';
                    allBookingRows[idxVar].booking.Booking_Date__c=null;
                    allBookingRows[idxVar].booking.ETI_Booking_slots__c='';
                    allBookingRows[idxVar].booking.ETI_Pick_Up_Location__c='';
                    allBookingRows[idxVar].booking.Preferred_Time__c='';*/
        //console.log('allBookingRows>> '+JSON.stringify(allBookingRows));
        //component.set("v.bookingWrp",JSON.parse(JSON.stringify(allBookingRows)));
    }else{
        component.set("v.IsSpinner", false);
    }
        
    });
        $A.enqueueAction(action);
    },
    handleOnChangeOfPurposeHelper: function (component, event, helper) {
        //18/10/20
        var allBookingRows = component.get("v.bookingWrp");
        var idx = event.getSource().get("v.name");
        //allBookingRows[idx].customerVehicle.Trade_License_Number__c = '';
        //allBookingRows[idx].customerVehicle.Trade_License_Expiry_Date__c = null;
        //allBookingRows[idx].booking.Selected_Services_Code__c = '';
        //allBookingRows[idx].booking.ET_Location__c = '';
        //allBookingRows[idx].booking.ETI_Pick_Up_Location__c = '';
        allBookingRows[idx].slotList = [];
        allBookingRows[idx].booking.Booking_Date__c = null;
        allBookingRows[idx].booking.ETI_Booking_slots__c = '';
        allBookingRows[idx].booking.Preferred_Time__c = '';
        allBookingRows[idx].uploadedFile = [];
        allBookingRows[idx].fileName = [];
        component.set('v.bookingWrp', allBookingRows);
    },
    readFile: function(component, file, name) {
        var idx = component.get("v.selectedRowIndex");
        var allBookingData = component.get("v.bookingWrp");
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
            component.set('v.bookingWrp', allBookingData);
        });
        objFileReader.readAsDataURL(file);
        component.set('v.bookingWrp', allBookingData);
      },
})
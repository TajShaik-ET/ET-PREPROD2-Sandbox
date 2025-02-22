({
    doinit : function(component, event, helper) {
        component.set("v.IsSpinner", true);
        console.log('-------TRequest--'+component.get("v.tableDisplay"));
        helper.setCommunityLanguage(component, event, helper);
        helper.getServiceType(component, event, helper);
        helper.getPurposeType(component, event, helper);
        helper.getVehicleType(component, event, helper);
        helper.getVehicleColor(component, event, helper);
        helper.getLocations(component, event, helper);//18/10/20
        var result = new Date();
        var result1 = new Date();
        result.setDate(result.getDate());
        var todayErrMsgFormat = $A.localizationService.formatDate(result, "dd MMM yyyy");
        component.set('v.minDateErrmsg',todayErrMsgFormat);
        var today = $A.localizationService.formatDate(result, "YYYY-MM-DD");
        result1.setDate(result1.getDate() + parseInt($A.get("$Label.c.ETI_BookingMaxDateLimitInDays")));
        var maxDate = $A.localizationService.formatDate(result1, "YYYY-MM-DD");
        var maxErrMsgFormat = $A.localizationService.formatDate(result1, "dd MMM yyyy");
        component.set('v.maxDateErrmsg',maxErrMsgFormat);
        component.set('v.minDate',today);
        component.set('v.maxDate',maxDate);
        component.set('v.tradeMinDate',today);
        var result2 = new Date();
        console.log('bookingWrp>> '+JSON.stringify(component.get("v.bookingWrp")));
        console.log('emirate>> '+component.get("v.emirate"));
        if(!component.get("v.isRetest")){
            var bookingList = component.get("v.booking");
            console.log('bookingList>> '+JSON.stringify(bookingList));
            var action = component.get("c.getBookingWrapper");
            action.setParams({
                lstBooking: bookingList,
                SelectedEmirate : component.get("v.emirate"),
                SelectedLang : component.get("v.clLang")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state>> '+state);
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log('result onload>> '+JSON.stringify(result));
                    console.log('serviceTypes onload>> '+JSON.stringify(result[0].serviceTypes));
                    if(result[0].serviceTypes == undefined || result[0].serviceTypes.length ==0){
                        var msg=component.get("v.Pending_Bookings");//'This Vehicle has pending bookings.';//All Services are booked for this vehicle.
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast("Info",msg,"","sticky","info");
                        component.set("v.IsSpinner", false);
                        component.set("v.tableDisplay", false);
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": decodeURIComponent(window.location)
                        });
                        urlEvent.fire();
                        return true;
                    }
                    var locationMap = [];
                    component.set("v.bookingWrp",result);
                    component.set("v.bookingWrp1",result);
                    console.log('resultWrp>> '+JSON.stringify(result));
                    if(component.get("v.emirate")==='Sharjah')
                        helper.getPreferredTime(component, event, helper);
                    else
                        component.set("v.selectedPremises",'Visit ET Premises');  
                    component.set("v.IsSpinner", false);
                }else {
                    var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request. Please try again or contact our customer service team.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast(component.get("v.Info"),msg,"","sticky","info");
                    component.set("v.IsSpinner", false);
                }
            });
            $A.enqueueAction(action);
        }else if(component.get("v.isRetest")){
            var bookingRecords = component.get("v.bookingWrp");
            var idx =0;
            var selectedPlace;
            var serviceType = bookingRecords[0].booking.Service_Type__c;
            console.log('bnkg retest-- '+JSON.stringify(bookingRecords));
            component.set("v.bookingWrp1",bookingRecords);
            bookingRecords[0].isSelectedRecord=true;
            //bookingRecords[0].rowIndex=0;
            component.set("v.selectedRowIndex",0);
            if(bookingRecords[0].booking.Service_Premises__c==='Visit ET Premises'){
                component.set("v.selectedPremises",bookingRecords[0].booking.Service_Premises__c);
            }else {
                component.set("v.selectedPremises",'Customer Premises');
                component.set("v.selectedPlace",bookingRecords[0].booking.Service_Premises__c);
                helper.getPreferredTime(component, event, helper);
            }
            console.log('Service_Type--'+bookingRecords[0].booking.Service_Type__c);
            component.set("v.selectedServiceType",bookingRecords[0].booking.Service_Type__c);
            console.log('selectedServiceType--'+component.get("v.selectedServiceType"));
            if(bookingRecords[0].booking.Service_Type__c=='Police Inspection'){
                if(component.get("v.selectedPremises")=='Customer Premises')
                    selectedPlace=component.get("v.selectedPlace");
                else 
                    selectedPlace=component.get("v.selectedPremises");
            }
            component.set("v.IsSpinner", false);
        } 
    },
    serviceTypeChange: function (component, event, helper) {
        var idx = event.getSource().get("v.name");
        var bookingRecords = component.get("v.bookingWrp");
        component.set("v.bookingWrp1", bookingRecords);
        var reTest=component.get("v.isRetest");
        if(!reTest){
            if(component.get("v.selectedPremises")=='Customer Premises' && (component.get("v.pickUpLocation") == undefined || component.get("v.pickUpLocation") == '')){
                console.log('selectedPremises if: '+component.get("v.selectedPremises"));
                var msg=component.get("v.Provide_the_Equipment_Location");//'Please Provide the Equipment Location.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                bookingRecords[idx].booking.Service_Type__c='';
                component.set("v.bookingWrp", bookingRecords);
            }else if(component.get("v.selectedPremises") !='Customer Premises' && (component.get("v.selectedLocation") =='' || component.get("v.selectedLocation") == undefined)){
                console.log('selectedPremises else: '+component.get("v.selectedPremises"));
                var msg=component.get("v.Select_a_Location");//'Please Select a Location to proceed.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                bookingRecords[idx].booking.Service_Type__c='';
                component.set("v.bookingWrp", bookingRecords);
            }else {
                console.log('Service_Type** '+bookingRecords[idx].booking.Service_Type__c);
                var serviceType;
                var selectedPlace;
                serviceType=bookingRecords[idx].booking.Service_Type__c;
                for(var idxVar=0;idxVar<bookingRecords.length;idxVar++){
                    if(idx==idxVar){
                        if(serviceType == 'Certificate' || serviceType == 'Police Inspection'){
                            bookingRecords[idxVar].servicesMap=[];
                        }else
                            bookingRecords[idxVar].certificates=[];
                        bookingRecords[idxVar].isAdfcaVehicle=false;
                        bookingRecords[idxVar].isSelectedRecord=true;
                        bookingRecords[idxVar].requiredDocuments=[];
                        bookingRecords[idxVar].booking.Booking_Date__c=null;
                        bookingRecords[idxVar].uploadedFile=[];
                        bookingRecords[idxVar].fileName=[];
                        bookingRecords[idxVar].customerVehicle.Trade_License_Number__c='';
                        bookingRecords[idxVar].customerVehicle.Trade_License_Expiry_Date__c=null;
                        bookingRecords[idxVar].isVehicleTypeChange=false;
                        bookingRecords[idxVar].isColorChange=false;
                        bookingRecords[idxVar].newVehicleType='';
                        bookingRecords[idxVar].newColor='';
                        bookingRecords[idxVar].newColor2='';
                        bookingRecords[idxVar].newColor3='';
                        bookingRecords[idxVar].newColor4='';
                        bookingRecords[idxVar].locationMap = [];
                        bookingRecords[idxVar].isChildValidated =false;
                        bookingRecords[idxVar].childErrorMessage = '';
                        bookingRecords[idxVar].showBook=true;
                        //bookingRecords[idxVar].booking.Selected_Services_Code__c='';
                        //bookingRecords[idxVar].booking.ET_Location__c=''; //18/10/20
                    }else 
                        bookingRecords[idxVar].isSelectedRecord=false;
                    if(bookingRecords[idxVar].booking.Service_Type__c !=''){
                        bookingRecords[idxVar].isValidated = false;
                        bookingRecords[idxVar].errorMessage = '';
                    }
                }
                if(serviceType=='Certificate')
                    selectedPlace='Visit ET Premises';
                console.log('serviceType@@>> '+serviceType);
                console.log('selectedPremises@@>> '+component.get("v.selectedPremises"));
                if(serviceType=='Police Inspection' || serviceType=='SPEA Inspection'){
                    if(component.get("v.selectedPremises")=='Customer Premises')
                        selectedPlace=component.get("v.selectedPlace");
                    else 
                        selectedPlace=component.get("v.selectedPremises");
                }
                if(component.get("v.selectedPremises")!='Customer Premises'){
                    if(bookingRecords[idx].booking.Vehicle_Type__c!=null && bookingRecords[idx].booking.Vehicle_Type__c!=''){
                        if(bookingRecords[idx].booking.Vehicle_Type__c=='Trailer')
                            bookingRecords[idx].isTrailer=true;
                        else 
                            if(bookingRecords[idx].booking.Vehicle_Type__c=='Equipment')
                                bookingRecords[idx].isEquipment=true;
                    }
                }else {
                    bookingRecords[idx].booking.Selected_Services_Code__c='';
                    bookingRecords[idx].serviceCode='';
                }
                console.log('vehicleTypeCode@@>> '+bookingRecords[idx].vehicleTypeCode);
                if(serviceType=='Police Inspection' && bookingRecords[idx].vehicleTypeCode!=undefined && component.get("v.selectedPremises")!='Customer Premises'){
                    helper.fetchRequiredDetails(component, event,bookingRecords, selectedPlace,idx);
                }else if(serviceType=='Certificate' || serviceType=='ADFCA' || (serviceType=='Police Inspection' && (bookingRecords[idx].vehicleTypeCode==undefined || component.get("v.selectedPremises")=='Customer Premises'))){
                    helper.getAvailableServices(component, event,bookingRecords, idx);
                }
            }
        }
    },
    handleTermAndCond: function(component, event){
        try{
            var val =  component.find('termsandconditioncheckbox').getElement().checked;
            if(val){
                var parentElement =  component.find('termsandconditioncheckboxParent').getElement();
                var errorElement =  component.find('termsandconditioncheckboxError').getElement();
                $A.util.removeClass(parentElement, 'slds-has-error');
                $A.util.addClass(errorElement, 'slds-hide');
            }else{
                var parentElement =  component.find('termsandconditioncheckboxParent').getElement();
                var errorElement =  component.find('termsandconditioncheckboxError').getElement();
                $A.util.addClass(parentElement, 'slds-has-error');
                $A.util.removeClass(errorElement, 'slds-hide');
            }
            component.set('v.bookingWrp[0].isTermsAndConditionsAgreed', val);
        }catch(err){
            console.log(err.message)
        }
    },
    bookService: function (component, event, helper) {
        var idx = parseInt(event.currentTarget.getAttribute("data-value"));
        var bookingRecords = component.get("v.bookingWrp");
        var selectedPremises = component.get('v.selectedPremises');
        component.set("v.IsSpinner", true);
        if(component.get("v.selectedPremises")=='Customer Premises' && (component.get("v.pickUpLocation") == undefined || component.get("v.pickUpLocation") == '')
           && (component.get("v.emirate")!='Sharjah' && (component.get("v.selectedLocation") == undefined || component.get("v.selectedLocation") == ''))){
            var msg=component.get("v.Provide_Equipment_and_Inspection_Center");//'Please Provide the Equipment Location and Inspection Center.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if(component.get("v.selectedPremises")=='Customer Premises' && (component.get("v.pickUpLocation") == undefined || component.get("v.pickUpLocation") == '')){
            var msg=component.get("v.Provide_the_Equipment_Location");//'Please Provide the Equipment Location.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if(component.get("v.selectedPremises")=='Customer Premises' && component.get("v.emirate")!='Sharjah' && (component.get("v.selectedLocation") == undefined || component.get("v.selectedLocation") == '')){
            var msg=component.get("v.Provide_Inspection_Center");//'Please Provide the Inspection Center.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if((selectedPremises !='Customer Premises' && (component.get("v.selectedLocation") !='' && component.get("v.selectedLocation") != undefined
                                                             && bookingRecords[idx].booking.Service_Type__c !='' && bookingRecords[idx].booking.Service_Type__c != undefined 
                                                             && bookingRecords[idx].booking.Mobile_No__c !='' && bookingRecords[idx].booking.Mobile_No__c != undefined)) 
                 || (selectedPremises =='Customer Premises' && bookingRecords[idx].booking.Service_Type__c !='' && bookingRecords[idx].booking.Service_Type__c != undefined 
                     && bookingRecords[idx].booking.Mobile_No__c !='' && bookingRecords[idx].booking.Mobile_No__c != undefined 
                     && component.get("v.pickUpLocation") != null && component.get("v.pickUpLocation") != '')){
            var mobile = bookingRecords[idx].booking.Mobile_No__c;
            var numbers = /^[0-9]+$/;
            if (!mobile.match(numbers)) {
                var msg=component.get("v.Mobile_Number_should_numeric");//'Mobile Number should numeric characters only.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                component.set("v.IsSpinner", false);
                return true;
            }else if (mobile.length != 12) {
                var msg=component.get("v.Mobile_Number_should_be_12_digits");//'Mobile Number should be 12 digits.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                component.set("v.IsSpinner", false);
                return true;
            }else if(mobile.substring(0, 3) !='971'){
                var msg=component.get("v.Mobile_Number_should_start_with_971");//'Mobile Number should start with 971.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");                           component.set("v.IsSpinner", false);
                component.set("v.IsSpinner", false);
                return true;
            } 
            component.set("v.selectedRowIndex",idx);
            bookingRecords[idx].isValidated =false;
            bookingRecords[idx].errorMessage = '';
            if(!bookingRecords[idx].isAdfcaVehicle){
                bookingRecords[idx].isChildValidated =false;
                bookingRecords[idx].childErrorMessage = '';
            }
            component.set("v.isDataValidated",false);
            component.set("v.isChildModel",true);
            component.set("v.bookingWrp", bookingRecords);
            component.set("v.IsSpinner", false);
        }else if((bookingRecords[idx].booking.Service_Type__c =='' || bookingRecords[idx].booking.Service_Type__c == undefined)
                 && (selectedPremises !='Customer Premises' && (component.get("v.selectedLocation") =='' || component.get("v.selectedLocation") == undefined))
                 && (bookingRecords[idx].booking.Mobile_No__c =='' || bookingRecords[idx].booking.Mobile_No__c == undefined)){
            var msg=component.get("v.Provide_Location_MobileNo_Service_Type");//'Please Provide Location, Mobile No and Service Type to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if((bookingRecords[idx].booking.Service_Type__c =='' || bookingRecords[idx].booking.Service_Type__c == undefined)
                 && (selectedPremises !='Customer Premises' && (component.get("v.selectedLocation") =='' || component.get("v.selectedLocation") == undefined))){
            var msg=component.set("v.Select_Location_and_Service_Type");//'Please Select Location and Service Type to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if((selectedPremises !='Customer Premises' && (component.get("v.selectedLocation") =='' || component.get("v.selectedLocation") == undefined))
                 && (bookingRecords[idx].booking.Mobile_No__c =='' || bookingRecords[idx].booking.Mobile_No__c == undefined)){
            var msg=component.set("v.Select_Location_and_Mobile_No");//'Please Select Location and Mobile No to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if((selectedPremises !='Customer Premises' && (component.get("v.selectedLocation") =='' || component.get("v.selectedLocation") == undefined))){
            var msg=component.set("v.Select_a_Location");//'Please Select a Location to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if(bookingRecords[idx].booking.Service_Type__c =='' || bookingRecords[idx].booking.Service_Type__c == undefined){
            var msg=component.set("v.Select_a_Service_Type");//'Please Select a Service Type to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if(bookingRecords[idx].booking.Mobile_No__c =='' || bookingRecords[idx].booking.Mobile_No__c == undefined){
            var msg=component.set("v.Provide_Mobile_No");//'Please Provide Mobile No to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }
    },
    closeChildModel: function(component, event, helper) {
        var msg =component.get("v.Close_Popup_Message");//'Are you sure you want to close this popup without saving?';
        if (!confirm(msg)) {
            console.log('No');
            return false;
        } else {
            if(component.get("v.isReschedule") && component.get("v.isRetest")){
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": decodeURIComponent(window.location)
                });
                urlEvent.fire();
            }
            component.set("v.isChildModel", false);
            component.set("v.isReschedule", false);
            component.set("v.isDataValidated",false);
            component.set("v.isFilesNotUploaded",false);
        }
    },
    addService: function(component, event, helper) {
        var rowIdx = parseInt(event.currentTarget.getAttribute("data-value"));
        console.log('rowIdx>> '+rowIdx);
        var bookingList = component.get("v.bookingWrp");
        console.log('bookingList>> '+JSON.stringify(bookingList));
        var allServiceTypes= bookingList[rowIdx].serviceTypes;
        var resultArray =JSON.parse(JSON.stringify(allServiceTypes));
        var selectedType = bookingList[rowIdx].booking.Service_Type__c;
        const index = resultArray.map(r => r.value).indexOf(selectedType)
        var addRec = {"booking":{"Purpose_Type__c":bookingList[rowIdx].booking.Purpose_Type__c,"Registration_Type__c":bookingList[rowIdx].booking.Registration_Type__c,"ET_Location__c":bookingList[rowIdx].booking.ET_Location__c,"Chassis_No__c":bookingList[rowIdx].booking.Chassis_No__c,"Plate_Color__c":bookingList[rowIdx].booking.Plate_Color__c,"Plate_No__c":bookingList[rowIdx].booking.Plate_No__c,"Customer_Vehicle__c":bookingList[rowIdx].booking.Customer_Vehicle__c,"Mobile_No__c":bookingList[rowIdx].booking.Mobile_No__c,"Service_Type__c":""},"requestId":bookingList[rowIdx].requestId,"enableAvailableSlots":false,"fileName":[],"uploadedFile":[],"isAdfcaVehicle":false,"customerVehicle":{"Trade_License_Number__c":"","Trade_License_Expiry_Date__c":null,"Id":bookingList[rowIdx].customerVehicle.Id},"isColorChange":false,"isEnabled":true,"isDuplicate":false,"isFeeDetailsExist":false,"isSelectedRecord":false,"vehicleTypeCode":bookingList[rowIdx].vehicleTypeCode,"isValidated":false,"isVehicleTypeChange":false,"locationMap":[],"openServicesMap":bookingList[rowIdx].openServicesMap,"showBook":true,"certificates":[],"rowIndex":rowIdx+1};
        if(component.get("v.selectedPremises")=='Customer Premises'){
            addRec.booking.ETI_Pick_Up_Location__c=bookingList[rowIdx].booking.ETI_Pick_Up_Location__c;
            addRec.booking.Latitude__c=bookingList[rowIdx].booking.Latitude__c;
            addRec.booking.Longitude__c=bookingList[rowIdx].booking.Longitude__c;
            addRec.booking.ET_Location__c=bookingList[rowIdx].booking.ET_Location__c;
        }
        bookingList.splice(rowIdx+1, 0, addRec);
        var allBookings =[];
        for(var idx = 0; idx < bookingList.length; idx++){
            bookingList[idx].rowIndex=idx;
        }
        if (index > -1) {
            resultArray.splice(index, 1);
        }
        allServiceTypes = allServiceTypes.filter(item => item.value === selectedType)
        
        /* for(var idx = 0; idx < allServiceTypes.length; idx++){
            console.log('idx>> '+JSON.stringify(allServiceTypes[idx]));
            console.log('val1>> '+allServiceTypes[idx].value);
            console.log('val2>> '+resultArray[0].value);
            if (resultArray.some(r => r.value == allServiceTypes[idx].value))
                allServiceTypes.splice(idx, 1);
            for(var i = 0; i < resultArray.length; i++){
                //if(resultArray.length >0 && allServiceTypes[idx].value==resultArray[0].value){ 
                if(allServiceTypes[idx].value==resultArray[i].value){   
                	console.log('resultArray[i]>> '+resultArray[i].value);
                    allServiceTypes.splice(idx, 1);
                }
            }
        }*/
        bookingList[rowIdx].serviceTypes = JSON.parse(JSON.stringify(allServiceTypes));
        bookingList[rowIdx+1].serviceTypes = resultArray;
        /*if(resultArray.slice(-1).length ==1){
            bookingList[rowIdx+1].isAddDisabled=true;
        }*/
        bookingList[rowIdx].isAddDisabled=true;
        component.set("v.bookingWrp", bookingList);
    },
    removeService: function(component, event, helper) {
        var rowIdx = parseInt(event.currentTarget.getAttribute("data-value"));
        var bookingList = component.get("v.bookingWrp");
        for(var idx = 0; idx < bookingList.length; idx++){
            if(idx!=rowIdx){
                if(bookingList[rowIdx].booking.Customer_Vehicle__c == bookingList[idx].booking.Customer_Vehicle__c){
                    bookingList[idx].isAddDisabled=false;
                    for(var i = 0; i < bookingList[rowIdx].serviceTypes.length; i++){
                        console.log('value innn>> '+bookingList[rowIdx].serviceTypes[i].value);
                        //if(!bookingList[idx].serviceTypes.includes(bookingList[rowIdx].serviceTypes[i].value))
                        if (!bookingList[idx].serviceTypes.some(r => r.value === bookingList[rowIdx].serviceTypes[i].value))
                            bookingList[idx].serviceTypes.push(bookingList[rowIdx].serviceTypes[i]);
                    }
                    break;
                }
            }
        }
        /*if(bookingList[rowIdx].booking.Customer_Vehicle__c == bookingList[rowIdx-1].booking.Customer_Vehicle__c){
            bookingList[rowIdx-1].isAddDisabled=false;
        	console.log('length>> '+bookingList[rowIdx].serviceTypes.length);
        	for(var idx = 0; idx < bookingList[rowIdx].serviceTypes.length; idx++){
                console.log('innn>> '+bookingList[rowIdx].serviceTypes[idx]);
            	bookingList[rowIdx-1].serviceTypes.push(bookingList[rowIdx].serviceTypes[idx]);
            }
        }
        if(bookingList[rowIdx].booking.Customer_Vehicle__c == bookingList[rowIdx+1].booking.Customer_Vehicle__c){
            bookingList[rowIdx+1].isAddDisabled=false;
        	console.log('length>> '+bookingList[rowIdx].serviceTypes.length);
        	for(var idx = 0; idx < bookingList[rowIdx].serviceTypes.length; idx++){
                console.log('innn>> '+bookingList[rowIdx].serviceTypes[idx]);
            	bookingList[rowIdx+1].serviceTypes.push(bookingList[rowIdx].serviceTypes[idx]);
            }
        }*/
        //console.log('out>> '+bookingList[rowIdx-1].serviceTypes);
        bookingList.splice(rowIdx, 1);
        var allBookings =[];
        for(var idx = 0; idx < bookingList.length; idx++){
            allBookings[idx]=bookingList[idx];
            allBookings[idx].rowIndex=idx;
        }
        component.set("v.bookingWrp", allBookings);
    },
    fetchCenters: function (component, event, helper) {
        if(!component.get("v.isRetest")){
            var bookingRecords = component.get("v.bookingWrp");
            console.log('selectedPlace '+component.get("v.selectedPlace"));
            var idx = event.getSource().get("v.name");
            console.log('idx>> '+idx);
            for(var idxVar=0;idxVar<bookingRecords.length;idxVar++){
                if(idx==idxVar)
                    bookingRecords[idxVar].isSelectedRecord=true;
                else 
                    bookingRecords[idxVar].isSelectedRecord=false;
            }
            console.log('bookingRecords'+JSON.stringify(bookingRecords));
            var reTest=component.get("v.isRetest");
            if(reTest) idx=0;
            var selectedPlace;
            if(component.get("v.selectedPremises")=='Visit ET Premises'){
                selectedPlace=component.get("v.selectedPremises");
            }else 
                selectedPlace=component.get("v.selectedPlace");
            helper.getLocations(component, event, bookingRecords,selectedPlace,idx);
        }
        helper.handleOnChangeOfPurposeHelper(component, event, helper);
    },
    onPremisesChange: function (component, event, helper) {
        component.set("v.IsSpinner", true);
        component.set("v.errorSelectedPremises", false);
        component.set("v.servicesList", []);
        component.set("v.selectedServices", '');
        component.set("v.selectedPlace", '');
        component.set("v.selectedServiceType", '');
        if(component.get("v.emirate")!='Sharjah')
            component.set("v.pickUpLocation", '');
        var reTest=component.get("v.isRetest");
        var bookingRecords = component.get("v.bookingWrp");
        bookingRecords[0].servicesMap=[];
        bookingRecords[0].slotList = [];
        bookingRecords[0].booking.Place_of_Service__c='';
        bookingRecords[0].booking.Service_Type__c='';
        //if(component.get("v.emirate")!='Sharjah' && bookingRecords[0].vehicleTypeCode!=undefined )
        //	bookingRecords[0].booking.Purpose_Type__c='';
        bookingRecords[0].booking.Selected_Services_Code__c='';
        bookingRecords[0].booking.ET_Location__c='';
        bookingRecords[0].booking.Preferred_Time__c='';
        bookingRecords[0].booking.Booking_Date__c=null;
        bookingRecords[0].isVehicleTypeChange=false;
        bookingRecords[0].isColorChange=false;
        bookingRecords[0].newVehicleType='';
        bookingRecords[0].newColor='';
        bookingRecords[0].newColor2='';
        bookingRecords[0].newColor3='';
        bookingRecords[0].newColor4='';
        bookingRecords[0].isValidated =false;
        bookingRecords[0].errorMessage = '';
        bookingRecords[0].isChildValidated =false;
        bookingRecords[0].childErrorMessage = '';
        bookingRecords[0].certificates = [];
        bookingRecords[0].locationMap = [];
        bookingRecords[0].customerVehicle.Trade_License_Number__c='';
        bookingRecords[0].customerVehicle.Trade_License_Expiry_Date__c=null;
        component.set("v.selectedLocation",'');
        if(0<bookingRecords.length-1 && bookingRecords[0].booking.Customer_Vehicle__c == bookingRecords[1].booking.Customer_Vehicle__c){
            console.log('length>> '+bookingRecords[1].serviceTypes.length);
            for(var idx = 0; idx < bookingRecords[1].serviceTypes.length; idx++){
                console.log('innn>> '+bookingRecords[1].serviceTypes[idx]);
                bookingRecords[0].serviceTypes.push(bookingRecords[1].serviceTypes[idx]);
            }
        }
        if(component.get("v.emirate")!='Sharjah')
            bookingRecords[0].isAddDisabled=false;
        component.set("v.bookingWrp", bookingRecords[0]);
        component.set("v.IsSpinner", false);
        if(component.get("v.selectedPremises")=='Customer Premises')
            helper.getPreferredTime(component, event, helper);
    },
    clearWrapper: function (component, event, helper) {
        component.set("v.errorSelectedPlace", false);
        var bookingRecords = component.get("v.bookingWrp");
        component.set("v.selectedServiceType", '');
        bookingRecords[0].booking.Service_Type__c='';
        //if(component.get("v.emirate")!='Sharjah' && (bookingRecords[0].vehicleTypeCode!=undefined && bookingRecords[0].vehicleTypeCode!='')) 
        //    bookingRecords[0].booking.Purpose_Type__c=''; 
        bookingRecords[0].slotList = [];
        bookingRecords[0].booking.Selected_Services_Code__c='';
        //bookingRecords[0].booking.ETI_Pick_Up_Location__c=''; //18/10/22
        //bookingRecords[0].booking.Latitude__c='';
        //bookingRecords[0].booking.Longitude__c='';
        //bookingRecords[0].booking.ET_Location__c=''; 
        bookingRecords[0].booking.Booking_Date__c=null;
        bookingRecords[0].booking.Preferred_Time__c='';
        bookingRecords[0].isValidated =false;
        bookingRecords[0].errorMessage = '';
        bookingRecords[0].isChildValidated =false;
        bookingRecords[0].childErrorMessage = '';
        bookingRecords[0].certificates = [];
        bookingRecords[0].locationMap = [];
        bookingRecords[0].servicesMap=[];
        bookingRecords[0].isVehicleTypeChange=false;
        bookingRecords[0].isColorChange=false;
        bookingRecords[0].newVehicleType='';
        bookingRecords[0].newColor='';
        bookingRecords[0].newColor2='';
        bookingRecords[0].newColor3='';
        bookingRecords[0].newColor4='';
        bookingRecords[0].customerVehicle.Trade_License_Number__c='';
        bookingRecords[0].customerVehicle.Trade_License_Expiry_Date__c=null;
        if(0<bookingRecords.length-1 && bookingRecords[0].booking.Customer_Vehicle__c == bookingRecords[1].booking.Customer_Vehicle__c){
            console.log('length>> '+bookingRecords[1].serviceTypes.length);
            for(var idx = 0; idx < bookingRecords[1].serviceTypes.length; idx++){
                console.log('innn>> '+bookingRecords[1].serviceTypes[idx]);
                bookingRecords[0].serviceTypes.push(bookingRecords[1].serviceTypes[idx]);
            }
        }
        if(component.get("v.emirate")!='Sharjah')
            bookingRecords[0].isAddDisabled=false;
        component.set("v.selectedServices", '');
        component.set("v.bookingWrp", bookingRecords[0]);
        //component.set("v.bookingWrp", bookingRecords);
    },
    clearvalues3: function (component, event, helper) {
        component.set("v.selectedPremises", '');
        component.set("v.selectedServiceType", '');
    },
    fillTradeLicense: function (component, event, helper) {
        alert(hiii);
        var allBookingRows = component.get("v.bookingWrp");
        var idx = event.getSource().get("v.name");
        console.log('idx>> '+idx);
        var tradeLicenseNumber = allBookingRows[idx].customerVehicle.Trade_License_Number__c;
        console.log('tradeLicenseNumber>> '+tradeLicenseNumber);
        for (var indexVar = 0; indexVar < allBookingRows.length; indexVar++) {
            if(idx!=indexVar)
                allBookingRows[indexVar].customerVehicle.Trade_License_Number__c=tradeLicenseNumber;
        }
        component.set("v.bookingWrp", allBookingRows);
    },
    getPickupLocation: function(component, event, helper) {//18/10/20
        console.log('---getPickupLocation---');
        var allBookingRows = component.get("v.bookingWrp");
        var idx = event.getSource().get("v.id");
        console.log('idx>> '+idx);
        var searchText= component.get("v.pickUpLocation");
        /*for (var indexVar = 0; indexVar < allBookingRows.length; indexVar++) {
            console.log('idx slot>> '+idx+' indexVar>> '+indexVar);
            if(idx==indexVar)
                searchText = allBookingRows[indexVar].booking.ETI_Pick_Up_Location__c;
        }*/
        console.log('searchText>> '+searchText);
        component.set("v.indexVar", idx);
        console.log('searchText...',searchText);
        helper.getAddressRecommendations(component,event,searchText,idx);
    },
    selectOption:function(component, event, helper) {
        console.log('---selectOption---');
        helper.getAddressDetailsByPlaceId(component, event);
    },   
    fetchAvailableSlots: function (component, event, helper) {
        var allBookingRows = component.get("v.bookingWrp");
        console.log('bnkg1--'+JSON.stringify(allBookingRows));
        var idx = event.getSource().get("v.name");
        var bookingDate = $A.localizationService.formatDate(allBookingRows[idx].booking.Booking_Date__c, "YYYY-MM-DD");
        console.log('Booking_Date--'+JSON.stringify(allBookingRows[idx].booking.Booking_Date__c));
        console.log('minDate--'+component.get("v.maxDate"));
        console.log('selectedPremises--'+component.get("v.selectedPremises"));
        console.log('preferredTimeList--'+component.get("v.preferredTimeList"));
          if (bookingDate < component.get("v.minDate") || bookingDate > component.get("v.maxDate")){
            allBookingRows[idx].slotList = [];
            allBookingRows[idx].booking.ETI_Booking_slots__c = '';
            allBookingRows[idx].enableAvailableSlots = false;
            component.set("v.bookingWrp", allBookingRows);
            return false;
        }
        console.log('preferredTimeList2--'+component.get("v.preferredTimeList"));
        allBookingRows[idx].slotList = [];
        allBookingRows[idx].booking.ETI_Booking_slots__c = '';
        allBookingRows[idx].booking.Preferred_Time__c = '';
        if(component.get("v.selectedPremises")=='Visit ET Premises'){
            component.set("v.bookingSlotOptions", []);
            if (allBookingRows[idx].booking.ET_Location__c == '' || allBookingRows[idx].booking.ET_Location__c == undefined ){
                var msg=component.get("v.Select_a_Location");//'Please Select a Location to Proceed.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","Sticky","error");
                allBookingRows[idx].booking.Booking_Date__c == null;
                component.set("v.bookingWrp",allBookingRows);
                return false;
            }
            var bookingDate;
            var location ;
            for (var indexVar = 0; indexVar < allBookingRows.length; indexVar++) {
                console.log('idx>> '+idx+' indexVar>> '+indexVar);
                if(idx==indexVar){
                    bookingDate = allBookingRows[indexVar].booking.Booking_Date__c;
                    location = allBookingRows[indexVar].booking.ET_Location__c;
                    allBookingRows[indexVar].booking.ETI_Booking_slots__c='';
                    allBookingRows[indexVar].booking.Service_Premises__c=component.get("v.selectedPremises");
                    allBookingRows[indexVar].isSelectedRecord=true;
                    allBookingRows[indexVar].enableAvailableSlots=true;
                    allBookingRows[indexVar].errorMessage='';
                }else {
                    allBookingRows[indexVar].isSelectedRecord=false;
                    allBookingRows[indexVar].errorMessage='';
                }
            }
            console.log('bnkg2--'+JSON.stringify(allBookingRows));
            var isReTest=false;
            if(component.get("v.isRetest") && !component.get("v.isReschedule"))
                isReTest=true;
            if (bookingDate !== undefined && location !== undefined) {
                component.set("v.IsSpinner", true);
                var action = component.get("c.getAvailableSlots");
                action.setParams({
                    obj: JSON.stringify(allBookingRows),
                    isReTest: isReTest
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var result = response.getReturnValue();
                        console.log('result>> '+JSON.stringify(result));
                        console.log('slotList>> '+JSON.stringify(result[idx].slotList));
                        if(result[idx].slotList==null || result[idx].slotList== '' || result[idx].slotList==undefined){
                            var msg=component.get("v.Slots_Availability");//'Slots are not available on selected Date, Please select another date.';
                            var utility = component.find("ETI_UtilityMethods");
                            var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
                            allBookingRows[idx].enableAvailableSlots=false;
                        }else {
                            console.log('requiredDocuments>> '+result[idx].requiredDocuments);
                            allBookingRows[idx].slotList=result[idx].slotList;
                            allBookingRows[idx].laneNslotsMap=result[idx].laneNslotsMap;
                            allBookingRows[idx].serviceCode=result[idx].serviceCode;
                            allBookingRows[idx].booking.Purpose_Type__c=result[idx].booking.Purpose_Type__c;
                            if(result[idx].requiredDocuments!=undefined && result[idx].requiredDocuments.length>0 
                               && !component.get("v.isReschedule") && !component.get("v.isRetest"))
                                allBookingRows[idx].requiredDocuments=result[idx].requiredDocuments;
                        }
                        component.set("v.bookingWrp",allBookingRows);
                        console.log('allBookingRows--'+JSON.stringify(allBookingRows));
                    }else {
                        var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request. Please try again or contact our customer service team.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                    }
                    component.set("v.IsSpinner", false);
                });
                $A.enqueueAction(action);
            }
        }else if(component.get("v.selectedPremises")=='Customer Premises' && component.get("v.emirate")!='Sharjah'
                 && !component.get("v.isReschedule") && !component.get("v.isRetest")){
            console.log('bnkg1--'+JSON.stringify(allBookingRows));
            component.set("v.IsSpinner", true);
            for (var indexVar = 0; indexVar < allBookingRows.length; indexVar++) {
                if(idx==indexVar)
                    allBookingRows[indexVar].isSelectedRecord=true;
                else 
                    allBookingRows[indexVar].isSelectedRecord=false;
            }
            var action = component.get("c.getRequiredDocuments");
            action.setParams({
                obj:JSON.stringify(allBookingRows),
                selectedPremise :component.get("v.selectedPremises"),
                preferTimes:component.get("v.preferredTimeList")
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('state--'+state);
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    console.log('docWrp--'+JSON.stringify(result));
                    component.set("v.bookingWrp",result);
                    if(result[idx].slotList.length==0){
                        var msg=component.get("v.Slots_Availability");//'Slots are not available for selected Date, please Select another date.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
                    }
                }
                component.set("v.IsSpinner", false);
            });
            $A.enqueueAction(action);
        }else if(component.get("v.selectedPremises")=='Customer Premises' && (component.get("v.emirate")=='Sharjah'
                                                                              || (component.get("v.emirate")!='Sharjah' && (component.get("v.isReschedule") || component.get("v.isRetest"))))){
            component.set("v.IsSpinner", true);
            for (var indexVar = 0; indexVar < allBookingRows.length; indexVar++) {
                if(idx==indexVar)
                    allBookingRows[indexVar].isSelectedRecord=true;
                else 
                    allBookingRows[indexVar].isSelectedRecord=false;
            }
            var action = component.get("c.getFinalPreferredTime");
            action.setParams({
                obj:JSON.stringify(allBookingRows),
                preferTimes :component.get("v.preferredTimeList")
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('state--'+state);
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    console.log('docWrp--'+JSON.stringify(result));
                    component.set("v.bookingWrp",result);
                    if(result[idx].slotList.length==0){
                        var msg=component.get("v.Slots_Availability");//'Slots are not available for selected Date, please Select another date.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
                    }
                }
                component.set("v.IsSpinner", false);
            });
            $A.enqueueAction(action);
        }
    },
    fetchRquiredDocuments: function (component, event, helper) {
        if(component.get("v.emirate")!='Sharjah' && !component.get("v.isReschedule") && !component.get("v.isRetest")){
            var bookingRecords = component.get("v.bookingWrp");
            console.log('bnkg1--'+JSON.stringify(bookingRecords));
            var action = component.get("c.getRequiredDocuments");
            action.setParams({
                obj:JSON.stringify(bookingRecords),
                selectedPremise :component.get("v.selectedPremises"),
                preferTimes:component.get("v.preferredTimeList")
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('state--'+state);
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    console.log('docWrp--'+JSON.stringify(result));
                    component.set("v.bookingWrp",result);
                }
            });
            $A.enqueueAction(action);
        }
    },
    // FIle Upload Methods
    handleFilesChange: function (component, event, helper) {
        var bookingRecords = component.get("v.bookingWrp");
        console.log('docbooking--'+JSON.stringify(bookingRecords));
        var idx=component.get("v.selectedRowIndex");
        var uploadedDocName = event.getSource().get("v.label");
        console.log('uploadedDocName11--'+uploadedDocName);
        helper.filesChangeHelper(component, event, bookingRecords,uploadedDocName,idx);
    },
    removeFile: function (component, event, helper) {
        var index = event.target.dataset.index;
        var idx=component.get("v.selectedRowIndex");
        var bookingRecords = component.get("v.bookingWrp");
        var fileslist = bookingRecords[idx].fileName;
        //var removefileDeleted = component.get("v.fileToBeUploaded");
        var toRemovefile = event.currentTarget.dataset.filename;
        fileslist.splice(index, 1);
        //removefileDeleted.splice(index, 1);
        bookingRecords[idx].fileName = fileslist;
        //component.set("v.fileToBeUploaded"+ removefileDeleted);
        var action = component.get("c.removeUploadedFiles");
        action.setParams({
            obj:JSON.stringify(bookingRecords[idx].uploadedFile),
            removefileName:toRemovefile
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result draft>> '+JSON.stringify(result));
                bookingRecords[idx].uploadedFile = result;
                component.set("v.bookingWrp", bookingRecords);
            }
        });
        $A.enqueueAction(action);
    },
    // FIle Upload Methods End
    closeRequestForService: function (component, event, helper) {
        component.set("v.tableDisplay", false);
        // component.set("v.isOpenRequestForService",false);
        try{
            if(component.get('v.isNavigateToHome')){
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/eti-homepage?lang='+component.get("v.clLang")                           
                });
                urlEvent.fire();
            }else{
                var url = new URL(window.location.href);
                var search_params = url.searchParams; 
                var recId = search_params.get('recordId');
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/customer/s/vehicle-page?showH=true&recordId='+recId+'&Loc='+component.get("v.emirate")+'&lang='+component.get("v.clLang")                           
                });
                urlEvent.fire();
            }
        }
        catch(error){
            console.log(error.message);
        } 
    }, 
    createDraftBooking: function (component, event, helper) {
        var sectionidblock = component.find("sectionidblock").getElement();
        component.set("v.IsSpinner", true);
        var idx = component.get("v.selectedRowIndex");
        var allBookingRows = component.get("v.bookingWrp");
        console.log('bnkg1--'+JSON.stringify(allBookingRows[idx]));
        console.log('idx>> '+idx);
        var selectedPremises = component.get('v.selectedPremises');
        if((!allBookingRows[idx].isAdfcaVehicle && (allBookingRows[idx].booking.Selected_Services_Code__c == undefined || allBookingRows[idx].booking.Selected_Services_Code__c == '')) || (selectedPremises !='Customer Premises' && (allBookingRows[idx].booking.Purpose_Type__c == undefined || allBookingRows[idx].booking.Purpose_Type__c == ''))){
            allBookingRows[idx].isChildValidated=true;
            allBookingRows[idx].childErrorMessage = component.get("v.All_fields_are_Mandatory");
            component.set("v.bookingWrp", allBookingRows);
            component.set("v.IsSpinner", false);
            sectionidblock.scrollTop = 0;
            return false;
        }
        var isDataMissing =false;
        component.set("v.isFilesNotUploaded", false);
        //allBookingRows[idx].booking.Is_Terms_and_Conditions_Checked__c = termsAndCond;
        if((allBookingRows[idx].booking.Service_Type__c == 'Police Inspection' || allBookingRows[idx].booking.Service_Type__c == 'SPEA Inspection') && component.get("v.selectedPremises") == 'Customer Premises')
            allBookingRows[idx].booking.Service_Premises__c=component.get("v.selectedPlace");
        else
            allBookingRows[idx].booking.Service_Premises__c=component.get("v.selectedPremises");
        var bookingDate = allBookingRows[idx].booking.Booking_Date__c;
        var location = allBookingRows[idx].booking.ET_Location__c;
        isDataMissing = helper.ValidateRequiredDetails(component, event, allBookingRows,idx);
        console.log('isDataMissing>> '+isDataMissing+' bookingDate>> '+bookingDate+' location>> '+location);
        if (isDataMissing){ 
            console.log('isDataMissing if<< '+isDataMissing);
            component.set("v.IsSpinner", false);
            sectionidblock.scrollTop = 0;
            return false;
        }
        if (allBookingRows[idx].isAdfcaVehicle && allBookingRows[idx].customerVehicle.Trade_License_Expiry_Date__c < component.get("v.minDate")){
            allBookingRows[idx].isChildValidated=true;
            allBookingRows[idx].childErrorMessage = component.get("v.Trade_License_Date_should_be_future");
            component.set("v.bookingWrp", allBookingRows);
            component.set("v.IsSpinner", false);
            sectionidblock.scrollTop = 0;
            return false;
        }
        console.log('isDataMissing111>> '+isDataMissing);
        let isRestest= component.get('v.isRetest');
        if(isRestest){
            console.log('isDataMissing222>> '+isDataMissing);
            if(!allBookingRows[0].isTermsAndConditionsAgreed){
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
        if (!isDataMissing && bookingDate !== undefined && locationcheck) {
            console.log('isDataMissing66>> '+isDataMissing);
            component.set("v.isDataValidated",false);
            allBookingRows[idx].errorMessage='';
            allBookingRows[idx].isChildValidated =false;
            allBookingRows[idx].childErrorMessage = '';
            for (var indexVar = 0; indexVar < allBookingRows.length; indexVar++) {
                if(idx==indexVar)
                    allBookingRows[indexVar].isSelectedRecord=true;
                else 
                    allBookingRows[indexVar].isSelectedRecord=false;
            }
            console.log('bookingRecords before>> '+JSON.stringify(allBookingRows));
            var action = component.get("c.createDraftBookings");
            action.setParams({
                obj:JSON.stringify(allBookingRows)
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log('result draft>> '+JSON.stringify(result));
                    for(var indexVar=0;indexVar<allBookingRows.length;indexVar++){
                        allBookingRows[indexVar].requestId=result[indexVar].requestId;
                    }
                    result[idx].booking.Booking_Date__c=allBookingRows[idx].booking.Booking_Date__c.substring(0, 10);
                    allBookingRows[idx].booking=result[idx].booking;
                    allBookingRows[idx].childErrorMessage=result[idx].childErrorMessage;                    
                    allBookingRows[idx].isChildValidated=result[idx].isChildValidated;
                    allBookingRows[idx].slotList=result[idx].slotList;
                    console.log('bookingRecords Draft--'+JSON.stringify(allBookingRows));
                    component.set("v.bookingWrp",allBookingRows);
                    if(!allBookingRows[idx].isChildValidated){
                        console.log('isChildValidated INN--'+JSON.stringify(allBookingRows[idx].isChildValidated));
                        var msg=component.set("v.Record_Saved_Successfully");//'The record has been Saved Sucessfully.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Success"),msg,"","dismissible","success");
                        component.set("v.isChildModel",false);
                    }else {
                        var msg=allBookingRows[idx].childErrorMessage;
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
                component.set("v.IsSpinner", false);
            });
            $A.enqueueAction(action);
        }else {
            component.set("v.bookingWrp",allBookingRows);
            component.set("v.IsSpinner", false);
            sectionidblock.scrollTop = 0;
        }
    },
    createBooking: function (component, event, helper) {//18/10/20
        var reTest=component.get("v.isRetest");
        var selectedPremises = component.get('v.selectedPremises');
        if(selectedPremises =='' && !reTest){
            component.set('v.errorSelectedPremises',true);
        }else if(selectedPremises !='Customer Premises' && (component.get("v.selectedLocation") =='' || component.get("v.selectedLocation") == undefined) && !reTest){
            var msg=component.get("v.Select_a_Location");//'Please Select a Location to proceed.';	
            var utility = component.find("ETI_UtilityMethods");	
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");	
        }else if(component.get("v.selectedPremises")=='Customer Premises' && (component.get("v.pickUpLocation") == undefined || component.get("v.pickUpLocation") == '')
                 && (component.get("v.emirate")!='Sharjah' && (component.get("v.selectedLocation") == undefined || component.get("v.selectedLocation") == '')) && !reTest){
            var msg=component.get("v.Provide_Equipment_and_Inspection_Center");//'Please Provide the Equipment Location and Inspection Center.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if(selectedPremises =='Customer Premises' && component.get("v.selectedPlace")=='' && !reTest){
            component.set('v.errorSelectedPlace',true);
        }else if(component.get("v.selectedPremises")=='Customer Premises' && (component.get("v.pickUpLocation") == null || component.get("v.pickUpLocation") == '') && !reTest){
            var msg=component.get("v.Provide_the_Equipment_Location");//'Please Provide the Equipment Location.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
        }else if(component.get("v.selectedPremises")=='Customer Premises' && component.get("v.emirate")!='Sharjah' && (component.get("v.selectedLocation") == undefined || component.get("v.selectedLocation") == '') && !reTest){
            var msg=component.get("v.Provide_Inspection_Center");//'Please Provide the Inspection Center.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else {
            component.set("v.IsSpinner", true);
            var allBookingRows = component.get("v.bookingWrp");
            console.log('bookingSlots11>> '+JSON.stringify(allBookingRows));
            var serType=component.get("v.selectedServiceType");
            console.log('serType >> '+JSON.stringify(serType));
            component.set("v.errorMsg", component.get("v.selectedServiceType"));
            console.log('serType >> '+JSON.stringify(serType));
            var isDataMissing =false;
            for(var idx=0;idx<allBookingRows.length;idx++){   
                if(allBookingRows[idx].booking.Service_Type__c==''){
                    allBookingRows[idx].isValidated =true;
                    allBookingRows[idx].errorMessage = component.get("v.Select_Service_Type");
                    isDataMissing=true;
                }
                var mobile = allBookingRows[idx].booking.Mobile_No__c;
                var numbers = /^[0-9]+$/;
                if (!mobile.match(numbers)) {
                    var msg=component.get("v.Mobile_Number_should_numeric");
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Info",msg,"","dismissible","info");
                    isDataMissing=true;
                    //return true;
                }else if (mobile.length != 12) {
                    var msg=component.get("v.Mobile_Number_should_be_12_digits");
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Info",msg,"","dismissible","info");
                    isDataMissing=true;
                    //return true;
                }else if(mobile.substring(0, 3) !='971'){
                    var msg=component.get("v.Mobile_Number_should_start_with_971");
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Info",msg,"","dismissible","info");  
                    isDataMissing=true;
                    //return true;
                } 
            }
            console.log('isDataMissing >> '+isDataMissing);
            if(isDataMissing){
                component.set("v.bookingWrp",allBookingRows);
                component.set("v.IsSpinner", false);
                return false;
            }
            console.log('isDataMissing >> '+isDataMissing);
            for(var indexVar=0;indexVar<allBookingRows.length;indexVar++){
                if(selectedPremises == 'Customer Premises' && !reTest) {           
                    allBookingRows[indexVar].booking.Service_Premises__c=component.get("v.selectedPlace");
                }
                console.log('Location>> '+allBookingRows[indexVar].booking.ET_Location__c); 
                console.log('Date_And_Time>> '+allBookingRows[indexVar].booking.Booking_Date__c); 
                let dataMissing=helper.ValidateRequiredDetails(component, event, allBookingRows,indexVar);
                console.log('dataMissing<< '+dataMissing);
                if (dataMissing){ 
                    console.log('isDataMissing if<< '+isDataMissing);
                    isDataMissing=true;
                    component.set("v.IsSpinner", false);
                    return false;
                }else { 
                    console.log('isDataMissing else<< '+isDataMissing);
                    if(allBookingRows[indexVar].isAdfcaVehicle && (allBookingRows[indexVar].booking.Selected_Services_Code__c == undefined || allBookingRows[indexVar].booking.Selected_Services_Code__c == '')){
                        allBookingRows[indexVar].isValidated=true;
                        allBookingRows[indexVar].errorMessage = component.get("v.Validate_Trade_License_Number");
                        isDataMissing=true;
                    }else if(allBookingRows[indexVar].booking.Selected_Services_Code__c == undefined || allBookingRows[indexVar].booking.Selected_Services_Code__c == '' || (selectedPremises !='Customer Premises' && (allBookingRows[indexVar].booking.Purpose_Type__c == undefined || allBookingRows[indexVar].booking.Purpose_Type__c == ''))){
                        allBookingRows[indexVar].isValidated=true;
                        allBookingRows[indexVar].errorMessage = component.get("v.Fields_Mandatory_Message");
                        isDataMissing=true;
                    }
                    console.log('isChildValidated else<< '+allBookingRows[indexVar].isChildValidated);
                    if(allBookingRows[indexVar].isChildValidated){
                        console.log('hiiiii');
                        allBookingRows[indexVar].isValidated = true;
                        allBookingRows[indexVar].errorMessage = allBookingRows[indexVar].childErrorMessage;
                        isDataMissing=true;
                    }
                    console.log('isValidated else<< '+allBookingRows[indexVar].isValidated);
                    if (allBookingRows[indexVar].isAdfcaVehicle && allBookingRows[indexVar].booking.Trade_License_Expiry_Date__c < component.get("v.minDate")){
                        allBookingRows[indexVar].isValidated=true;
                        allBookingRows[indexVar].errorMessage = component.get("v.Trade_License_Date_should_be_future");
                        isDataMissing=true;
                    }
                    if(!isDataMissing){
                        allBookingRows[indexVar].isValidated = false;
                        allBookingRows[indexVar].errorMessage = '';
                    }
                }
                console.log('isDataMissing if<< '+isDataMissing);
            } 
            if(isDataMissing){
                component.set("v.bookingWrp",allBookingRows);
                component.set("v.IsSpinner", false);
                return false;
            }
            console.log('allBookingRows: '+JSON.stringify(allBookingRows));
            component.set("v.bookingWrp",allBookingRows);
            console.log('isDataMissing<< '+isDataMissing);
            console.log('isTermsAndConditionsAgreed<< '+allBookingRows[0].isTermsAndConditionsAgreed);
            if(!allBookingRows[0].isTermsAndConditionsAgreed){
                console.log('reTest<< '+reTest);
                var parentElement= component.find('termsandconditioncheckboxParent1').getElement();
                var	errorElement= component.find('termsandconditioncheckboxError1').getElement();
                console.log('parentElement<< '+parentElement);
                console.log('errorElement<< '+errorElement);
                $A.util.addClass(parentElement, 'slds-has-error');
                $A.util.removeClass(errorElement, 'slds-hide');
                component.set("v.IsSpinner", false);
                return false;
            }
            if(!isDataMissing){
                var action = component.get("c.saveBooking");
                action.setParams({
                    obj:JSON.stringify(allBookingRows),
                    selectedPremise:component.get("v.selectedPremises")
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    console.log('state--' + state);
                    if (state === "SUCCESS") {
                        try{
                            var result =response.getReturnValue(); 
                            console.log('result>> '+JSON.stringify(result));
                            console.log('result lst>> '+JSON.stringify(result[0].bookingList));
                            if(!result[0].isDuplicateBookingsExit){
                                if(result[0].bookingList!=null){
                                    if(!result[0].isFeeDetailsExist){ 
                                        var msg=component.get("v.Unexpected_Error_Message");
                                        var utility = component.find("ETI_UtilityMethods");
                                        var promise = utility.showToast("Error",msg,"","dismissible","error");
                                        component.set("v.IsSpinner", false);
                                        return false;
                                    }
                                    component.set("v.tableDisplay", false);
                                    component.set("v.isRetest", false);
                                    component.set("v.isReschedule", false);
                                    //component.set("v.bookingFeeDetails", result[0].serviceItemMap);
                                    component.set("v.bookingFeeDetails", result[0].serviceItemWrp);
                                    component.set("v.isFeeDetailsVar", result[0].isFeeDetailsExist);
                                    component.set("v.showPaymentDetail1",true);
                                }else {
                                    //var msg='Your session has timed out, Please refill the deatils again.';
                                    var msg=component.get("v.Unexpected_Error_Message");
                                    var utility = component.find("ETI_UtilityMethods");
                                    var promise = utility.showToast("Error",msg,"","dismissible","error");
                                    component.set("v.bookingWrp",result);
                                }
                            }else {
                                var msg=component.get("v.Selected_Slot_Booked");
                                var utility = component.find("ETI_UtilityMethods");
                                var promise = utility.showToast("Error",msg,"","dismissible","error");
                                component.set("v.bookingWrp",result);
                            }
                        }
                        catch(error){
                            console.log(error.message);
                        }
                        component.set("v.IsSpinner", false);
                    }else {
                        var msg=component.get("v.Unexpected_Error_Message");
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast("Error",msg,"","dismissible","error");
                        component.set("v.IsSpinner", false);
                    }
                });
                $A.enqueueAction(action);
            }else {
                component.set("v.bookingWrp",allBookingRows);
                component.set("v.IsSpinner", false);
            }
        }
    },
    getCertificateLocations: function (component, event, helper) {
        component.set("v.IsSpinner", true);
        var allBookingRows = component.get("v.bookingWrp");
        var idxVar = component.get("v.selectedRowIndex");
        helper.certificateLocations(component, event, allBookingRows,idxVar);
    },
    handleOnChangeOfPurpose: function (component, event, helper) {
        helper.handleOnChangeOfPurposeHelper(component, event, helper);
    },
    locationChanged: function (component, event, helper) {  //18/10/20
        var allBookingRows = component.get("v.bookingWrp");
        if(allBookingRows[0].booking.Service_Type__c== undefined || allBookingRows[0].booking.Service_Type__c== '' || allBookingRows[0].booking.Service_Type__c==null){
            for(var idx=0;idx<allBookingRows.length;idx++){  
                allBookingRows[idx].booking.ET_Location__c= component.get("v.selectedLocation");
            }
        }else{
            var msg =component.get("v.Need_to_refill_details");
            if (!confirm(msg)) {
                component.set('v.selectedLocation',allBookingRows[0].booking.ET_Location__c);
                return false;
            } else {
                for(var idx=0;idx<allBookingRows.length;idx++){  
                    allBookingRows[idx].booking.ET_Location__c= component.get("v.selectedLocation");
                    //29/10/20 
                    //&& allBookingRows[idx].booking.Service_Type__c!='Certificate'
                    if(component.get("v.emirate")!='Sharjah' && (allBookingRows[idx].vehicleTypeCode!=undefined && allBookingRows[idx].vehicleTypeCode!='')) 
                        allBookingRows[idx].booking.Purpose_Type__c='';
                    allBookingRows[idx].servicesMap=[];
                    allBookingRows[idx].booking.Service_Type__c='';
                    allBookingRows[idx].booking.Booking_Date__c= null;
                    allBookingRows[idx].slotList= [];
                    allBookingRows[idx].booking.ETI_Booking_slots__c= '';
                    allBookingRows[idx].enableAvailableSlots= false;
                    allBookingRows[idx].isVehicleTypeChange=false;
                    allBookingRows[idx].isColorChange=false;
                    allBookingRows[idx].newVehicleType='';
                    allBookingRows[idx].newColor='';
                    allBookingRows[idx].newColor2='';
                    allBookingRows[idx].newColor3='';
                    allBookingRows[idx].newColor4='';
                    allBookingRows[idx].isValidated =false;
                    allBookingRows[idx].errorMessage = '';
                    allBookingRows[idx].isChildValidated =false;
                    allBookingRows[idx].childErrorMessage = '';
                    allBookingRows[idx].certificates = [];
                    allBookingRows[idx].customerVehicle.Trade_License_Number__c='';
                    allBookingRows[idx].customerVehicle.Trade_License_Expiry_Date__c=null;
                }
            } 
        }
        component.set('v.bookingWrp',allBookingRows);
        console.log('bookingWrp locationChanged>> '+JSON.stringify(component.get("v.bookingWrp")));
    },
    handleOnFileUploadFornewVersion :function(component, event, helper){
        try {
            component.set("v.IsSpinner", true);
            component.set("v.requiredDocError", false);
            // console.log('uploadedDocName22--'+uploadedDocName);
            var Filelist = [];
            var files =[];
            // Filelist = bookingRecords[idx].fileName;
            if (event.getSource().get("v.files").length > 0) {
                var aa = event.getSource().get("v.name");
                var fileName1 = event.getSource().get("v.files");
                console.log('fileName1..'+fileName1);
                // var fileInput = component.find("fileId").get("v.files");
                [].forEach.call(fileName1, function(file) { helper.readFile(component,file, file.name); });
                console.log('Filelist..' + JSON.stringify(Filelist));
               
                component.set("v.IsSpinner", false);
            }
            console.log('Filelist after--'+JSON.stringify(Filelist));
            
        } catch (er) {
            alert(er.message)  
        }
    },
    openDocumentSection :function(component, event, helper){
        component.set('v.isOpenDocumentSec', true);
    },
    closeDocumentSection :function(component, event, helper){
        component.set('v.isOpenDocumentSec', false);
    },
})
({
    doinit : function(component, event, helper) {
        //alert(component.get("v.recordId"));
        component.set("v.IsSpinner", true);
        console.log('-------TRequest--'+component.get("v.tableDisplay"));
        console.log('--isNavigateToHome--'+component.get("v.isNavigateToHome"));
        helper.setCommunityLanguage(component, event, helper);
        helper.getServiceType(component, event, helper);
        helper.getPurposeType(component, event, helper);
        helper.getVehicleType(component, event, helper);
        helper.getVehicleColor(component, event, helper);
        helper.getLocations(component, event, helper);
        helper.getPickListValueMNVRBrand(component, event, helper);
        //  helper.getChangelocation(component, event, helper);
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
        if(component.get("v.emirate")=='Sharjah')
            component.set('v.isSpea',true);
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
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log('result onload>> '+JSON.stringify(result));
                    console.log('arunId>> '+JSON.stringify(result[0].Id));
                    console.log('serviceTypes onload>> '+JSON.stringify(result[0].serviceTypes));
                    if(bookingList.length==1 && result[0].serviceTypes == undefined || result[0].serviceTypes.length ==0){
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
                    component.set("v.allBookingData",result);
                    component.set("v.bookingWrp1",result); 
                    console.log('allBookingData length>> '+result.length);
                    component.set("v.totalRecords",result.length);
                    if(result.length<component.get("v.pageSize"))
                        component.set("v.pageSize",result.length);
                    else if(result.length>100 && result.length<=200)
                        component.set("v.pageSize",15);
                    else if(result.length>200)
                        component.set("v.pageSize",20);
                    component.set("v.totalPages", Math.ceil(result.length/component.get("v.pageSize")));
                    component.set("v.currentPageNumber",1);
                    console.log('totalPages length>> '+component.get("v.totalPages"));
                    console.log('resultWrp>> '+JSON.stringify(result));
                    console.log('fullAddress>> '+JSON.stringify(result[0].fullAddress));
                    component.set("v.pickUpLocation",result[0].fullAddress);
                    if(component.get("v.emirate")==='Sharjah'){
                        helper.getPreferredTime(component, event, helper);
                    }else
                        component.set("v.selectedPremises",'Visit ET Premises'); 
                    helper.buildData(component, helper);
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
            component.set("v.allBookingData",component.get("v.bookingWrp"));
            component.set("v.bookingWrp1",component.get("v.bookingWrp")); 
            var allBookingData = component.get("v.bookingWrp");
            console.log('allBookingData length>> '+allBookingData.length);
            /*component.set("v.totalRecords",allBookingData.length);
            if(allBookingData.length>100 && allBookingData.length<=200)
                component.set("v.pageSize",15);
            else if(allBookingData.length>200)
                component.set("v.pageSize",20);
            component.set("v.totalPages", Math.ceil(allBookingData.length/component.get("v.pageSize")));
            component.set("v.currentPageNumber",1);*/
            
            var idx =0;
            var selectedPlace;
            var serviceType = allBookingData[0].booking.Service_Type__c;
            console.log('bnkg retest-- '+JSON.stringify(allBookingData));
            allBookingData[0].isSelectedRecord=true;
            //allBookingData[0].rowIndex=0;
            component.set("v.selectedRowIndex",0);
            if(allBookingData[0].booking.Service_Premises__c==='Visit ET Premises'){
                component.set("v.selectedPremises",allBookingData[0].booking.Service_Premises__c);
            }else {
                component.set("v.selectedPremises",'Customer Premises-B2B');
                component.set("v.selectedPlace",allBookingData[0].booking.Service_Premises__c);
                helper.getPreferredTime(component, event, helper);
            }
            console.log('Service_Type--'+allBookingData[0].booking.Service_Type__c);
            component.set("v.selectedServiceType",allBookingData[0].booking.Service_Type__c);
            console.log('selectedServiceType--'+component.get("v.selectedServiceType"));
            if(allBookingData[0].booking.Service_Type__c=='Police Inspection'){
                if(component.get("v.selectedPremises")=='Customer Premises-B2B')
                    selectedPlace=component.get("v.selectedPlace");
                else 
                    selectedPlace=component.get("v.selectedPremises");
            }
            component.set("v.allBookingData",allBookingData);
            component.set("v.bookingWrp",allBookingData);
            //helper.buildData(component, helper);
            component.set("v.IsSpinner", false);
        } 
    },
    serviceTypeChange: function (component, event, helper) {
        var idx = event.getSource().get("v.name");
        console.log('idx>> '+idx);
        var allBookingData = component.get("v.allBookingData");
        var bookingRecords = component.get("v.bookingWrp");
        //component.set("v.bookingWrp1", allBookingData);
        var reTest=component.get("v.isRetest");
        if(!reTest){
            if(component.get("v.selectedPremises")=='Customer Premises-B2B' && (component.get("v.pickUpLocation") == undefined || component.get("v.pickUpLocation") == '')){
                console.log('selectedPremises if: '+component.get("v.selectedPremises"));
                var msg=component.get("v.Provide_the_Equipment_Location");//'Please Provide the Equipment Location.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                allBookingData[idx].booking.Service_Type__c='';
                component.set("v.bookingWrp", allBookingData);
            }else if(component.get("v.selectedPremises") !='Customer Premises-B2B' && (component.get("v.selectedLocation") =='' || component.get("v.selectedLocation") == undefined)){
                console.log('selectedPremises else: '+component.get("v.selectedPremises"));
                var msg=component.get("v.Select_a_Location");//'Please Select a Location to proceed.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                allBookingData[idx].booking.Service_Type__c='';
                component.set("v.bookingWrp", allBookingData);
            }else {
                var serviceType;
                var selectedPlace;
                serviceType=allBookingData[idx].booking.Service_Type__c;
                for(var idxVar=0;idxVar<allBookingData.length;idxVar++){
                    if(idx==idxVar){
                        if(serviceType == 'Certificate'){
                            allBookingData[idxVar].servicesMap=[];
                            allBookingData[idxVar].isAdfcaVehicle=false;
                        }else
                            allBookingData[idxVar].certificates=[];
                        allBookingData[idxVar].isSelectedRecord=true;
                        allBookingData[idxVar].requiredDocuments=[];
                        allBookingData[idxVar].uploadedFile=[];
                        allBookingData[idxVar].fileName=[];
                        allBookingData[idxVar].customerVehicle.Trade_License_Number__c='';
                        allBookingData[idxVar].customerVehicle.Trade_License_Expiry_Date__c=null;
                        allBookingData[idxVar].isVehicleTypeChange=false;
                        allBookingData[idxVar].isColorChange=false;
                        allBookingData[idxVar].newVehicleType='';
                        allBookingData[idxVar].newColor='';
                        allBookingData[idxVar].newColor2='';
                        allBookingData[idxVar].newColor3='';
                        allBookingData[idxVar].newColor4='';
                        allBookingData[idxVar].locationMap = [];
                        allBookingData[idxVar].isChildValidated =false;
                        allBookingData[idxVar].childErrorMessage = '';
                        //allBookingData[idxVar].booking.Selected_Services_Code__c='';
                        if(component.get("v.selectedPremises")!='Customer Premises-B2B'){
                            allBookingData[idxVar].booking.Booking_Date__c=null;
                            //allBookingData[idxVar].booking.ET_Location__c='';
                        }
                    }else 
                        allBookingData[idxVar].isSelectedRecord=false;
                    if(allBookingData[idxVar].booking.Service_Type__c !=''){
                        allBookingData[idxVar].isValidated = false;
                        allBookingData[idxVar].errorMessage = '';
                    }
                }
                if(serviceType=='Certificate')
                    selectedPlace='Visit ET Premises';
                console.log('serviceType@@>> '+serviceType);
                console.log('selectedPremises@@>> '+component.get("v.selectedPremises"));
                if(serviceType=='Police Inspection' || serviceType=='SPEA Inspection'){
                    if(component.get("v.selectedPremises")=='Customer Premises-B2B')
                        selectedPlace=component.get("v.selectedPlace");
                    else 
                        selectedPlace=component.get("v.selectedPremises");
                }
                if(component.get("v.selectedPremises")=='Visit ET Premises' || (component.get("v.selectedPremises")=='Customer Premises-B2B' && component.get("v.selectedPlace")=='Home/Office Premise-B2B'))
                {
                    if(allBookingData[idx].booking.Vehicle_Type__c!=null && allBookingData[idx].booking.Vehicle_Type__c!=''){
                        if(allBookingData[idx].booking.Vehicle_Type__c=='Trailer')
                            allBookingData[idx].isTrailer=true;
                        else 
                            if(allBookingData[idx].booking.Vehicle_Type__c=='Equipment' || allBookingData[idx].booking.Vehicle_Type__c=='Vehicle'){
                                allBookingData[idx].isEquipment=true;
                                allBookingData[idx].isTrailer=false;
                            }
                               
                    }
                }else {
                    allBookingData[idx].booking.Selected_Services_Code__c='';
                    allBookingData[idx].serviceCode='';
                }
                    
                console.log('vehicleTypeCode@@>> '+allBookingData[idx].vehicleTypeCode);
                if(serviceType=='Police Inspection' && allBookingData[idx].vehicleTypeCode!=undefined && component.get("v.selectedPremises")!='Customer Premises-B2B'){
                    helper.fetchRequiredDetails(component, event,allBookingData, selectedPlace,idx);
                }else if(serviceType=='Certificate' || serviceType=='ADFCA' || (serviceType=='Police Inspection' && (allBookingData[idx].vehicleTypeCode==undefined || component.get("v.selectedPremises")=='Customer Premises-B2B'))){
                    helper.getAvailableServices(component, event,allBookingData, idx);
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
        debugger;
        var idx = parseInt(event.currentTarget.getAttribute("data-value"));
        //event.getSource().get("v.name");
		var allBookingData = component.get("v.allBookingData");
        var bookingRecords = component.get("v.bookingWrp");
        var selectedPremises = component.get('v.selectedPremises');
        console.log('allBookingData>> '+JSON.stringify(allBookingData));
        console.log('emirate>> '+component.get("v.emirate"));
        component.set("v.IsSpinner", true);
        console.log('idx>> '+idx);
        console.log('selectedRowIndex>> '+component.get("v.selectedRowIndex"));
        console.log('allBookingData>> '+allBookingData[idx]);
        console.log('booking>> '+allBookingData[idx].booking);
        console.log('Service_Type>> '+allBookingData[idx].booking.Service_Type__c);
         console.log('Service_Type>> '+allBookingData[idx].booking.Mobile_No__c);
        if(component.get("v.selectedPremises")=='Customer Premises-B2B' && (component.get("v.pickUpLocation") == undefined || component.get("v.pickUpLocation") == '')
           && (component.get("v.emirate")!='Sharjah' && (component.get("v.selectedLocation") == undefined || component.get("v.selectedLocation") == ''))){
            var msg=component.get("v.Provide_Equipment_and_Inspection_Center");//'Please Provide the Equipment Location and Inspection Center.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if(component.get("v.selectedPremises")=='Customer Premises-B2B' && (component.get("v.pickUpLocation") == undefined || component.get("v.pickUpLocation") == '')){
            var msg=component.get("v.Provide_the_Equipment_Location");//'Please Provide the Equipment Location.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if(component.get("v.selectedPremises")=='Customer Premises-B2B' && component.get("v.emirate")!='Sharjah' && (component.get("v.selectedLocation") == undefined || component.get("v.selectedLocation") == '')){
            var msg=component.get("v.Provide_Inspection_Center");//'Please Provide the Inspection Center.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if((selectedPremises !='Customer Premises-B2B' && (component.get("v.selectedLocation") !='' && component.get("v.selectedLocation") != undefined
           && allBookingData[idx].booking.Service_Type__c !='' && allBookingData[idx].booking.Service_Type__c != undefined 
           && allBookingData[idx].booking.Mobile_No__c !='' && allBookingData[idx].booking.Mobile_No__c != undefined)) 
           || (component.get("v.emirate") !='Sharjah' && selectedPremises =='Customer Premises-B2B' && allBookingData[idx].booking.Service_Type__c !='' && allBookingData[idx].booking.Service_Type__c != undefined 
               && allBookingData[idx].booking.Mobile_No__c !='' && allBookingData[idx].booking.Mobile_No__c != undefined 
               && component.get("v.pickUpLocation") != null && component.get("v.pickUpLocation") != '')
           || (component.get("v.emirate") =='Sharjah' && selectedPremises =='Customer Premises-B2B' && allBookingData[idx].booking.Service_Type__c !='' && allBookingData[idx].booking.Service_Type__c != undefined 
               && allBookingData[idx].booking.Email__c !='' && allBookingData[idx].booking.Email__c != undefined
               && allBookingData[idx].booking.Mobile_No__c !='' && allBookingData[idx].booking.Mobile_No__c != undefined 
               && component.get("v.pickUpLocation") != null && component.get("v.pickUpLocation") != '')){
           console.log('hii11>> ');
            if(component.get("v.emirate") =='Sharjah'){
                if(!helper.validateEmail(allBookingData[idx].booking.Email__c)){
                    var msg=component.get("v.Valid_Email_Address");//'Please Enter a Valid Email Address.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                    component.set("v.IsSpinner", false);
                    return true;
                }else {
                    for(var indexVar=0;indexVar<allBookingData.length;indexVar++){
                        allBookingData[indexVar].booking.Email__c=allBookingData[idx].booking.Email__c;
                    }
                }
            }
            console.log('hii22>> ');
            var mobile = allBookingData[idx].booking.Mobile_No__c;
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
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");                
                component.set("v.IsSpinner", false);
                return true;
            }else if(component.get("v.emirate") =='Sharjah'){
                for(var indexVar=0;indexVar<allBookingData.length;indexVar++){
                    allBookingData[indexVar].booking.Mobile_No__c=allBookingData[idx].booking.Mobile_No__c;
                }
            }
            console.log('hii33>> ');
            component.set("v.selectedRowIndex",idx);
            console.log('selectedRowIndex>> '+component.get("v.selectedRowIndex"));
            allBookingData[idx].isValidated =false;
            allBookingData[idx].errorMessage = '';
            console.log('hii44>> ');
            if(!allBookingData[idx].isAdfcaVehicle){
                allBookingData[idx].isChildValidated =false;
	            allBookingData[idx].childErrorMessage = '';
            }
            console.log('hii55>> ');
            component.set("v.isDataValidated",false);
            component.set("v.isChildModel",true);
            component.set("v.allBookingData", allBookingData);
            component.set("v.IsSpinner", false);
            helper.buildWrpData(component, allBookingData,false);
        }else if((allBookingData[idx].booking.Service_Type__c =='' || allBookingData[idx].booking.Service_Type__c == undefined)
                && (selectedPremises !='Customer Premises-B2B' && (component.get("v.selectedLocation") =='' || component.get("v.selectedLocation") == undefined))
                && (allBookingData[idx].booking.Mobile_No__c =='' || allBookingData[idx].booking.Mobile_No__c == undefined)){
            var msg=component.get("v.Provide_Location_MobileNo_Service_Type");//'Please Provide Location, Mobile No and Service Type to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if((allBookingData[idx].booking.Service_Type__c =='' || allBookingData[idx].booking.Service_Type__c == undefined)
                && (selectedPremises !='Customer Premises-B2B' && (component.get("v.selectedLocation") =='' || component.get("v.selectedLocation") == undefined))){
            var msg=component.get("v.Select_Location_and_Service_Type");//'Please Select Location and Service Type to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if((selectedPremises !='Customer Premises' && (component.get("v.selectedLocation") =='' || component.get("v.selectedLocation") == undefined))
                && (allBookingData[idx].booking.Mobile_No__c =='' || allBookingData[idx].booking.Mobile_No__c == undefined)){
            var msg=component.get("v.Select_Location_and_Mobile_No");//'Please Select Location and Mobile No to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if((selectedPremises !='Customer Premises-B2B' && (component.get("v.selectedLocation") =='' || component.get("v.selectedLocation") == undefined))){
            var msg=component.get("v.Select_a_Location");//'Please Select a Location to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if(allBookingData[idx].booking.Service_Type__c =='' || allBookingData[idx].booking.Service_Type__c ==null || allBookingData[idx].booking.Service_Type__c == undefined){
            var msg=component.get("v.Select_a_Service_Type");//'Please Select a Service Type to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if(component.get("v.emirate") =='Sharjah' && allBookingData[idx].booking.Email__c =='' || allBookingData[idx].booking.Email__c == undefined){
            var msg=component.get("v.Provide_Email_Id");//'Please Provide Email Id to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if(allBookingData[idx].booking.Mobile_No__c =='' || allBookingData[idx].booking.Mobile_No__c == undefined){
            var msg=component.get("v.Provide_Mobile_No");//'Please Provide Mobile No to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }
    },
    closeChildModel: function(component, event, helper) {
        //var msg ='If you close this popup without saving, You will lost the data.';
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
    cloneService: function(component, event, helper) {
        var allBookingData=component.get("v.allBookingData");
        var rowIdx = parseInt(event.currentTarget.getAttribute("data-value"));
        console.log('rowIdx>> '+rowIdx);
        var draftBooking=allBookingData[0].booking;
        console.log('draftBooking '+JSON.stringify(draftBooking));
        for(var idx = 0; idx < allBookingData.length; idx++){
            if(idx!=0){
                allBookingData[idx].booking.Service_Type__c = draftBooking.Service_Type__c;
                allBookingData[idx].servicesMap=allBookingData[0].servicesMap;
                allBookingData[idx].certificates=allBookingData[0].certificates;
                allBookingData[idx].slotList= allBookingData[0].slotList;
                allBookingData[idx].booking.Mobile_No__c = draftBooking.Mobile_No__c;
                allBookingData[idx].booking.Purpose_Type__c = draftBooking.Purpose_Type__c;
            	allBookingData[idx].booking.ET_Location__c = draftBooking.ET_Location__c;
                allBookingData[idx].booking.Booking_Date__c = draftBooking.Booking_Date__c;
                allBookingData[idx].booking.Preferred_Time__c = draftBooking.Preferred_Time__c;
                allBookingData[idx].requiredDocuments=[];
                allBookingData[idx].fileName=[];
                if(component.get("v.selectedPremises")=='Customer Premises-B2B' && component.get("v.selectedPlace")=='Home/Office Premise-B2B')
            	{
                    if(allBookingData[idx].booking.Vehicle_Type__c=='Trailer'){
                        allBookingData[idx].booking.Selected_Services_Code__c='17';
                        allBookingData[idx].isTrailer =false;
                    }else if(allBookingData[idx].booking.Vehicle_Type__c=='Equipment'){
                        allBookingData[idx].booking.Selected_Services_Code__c='8';
                        allBookingData[idx].isEquipment =false;
                    }else {
                        allBookingData[idx].booking.Selected_Services_Code__c='12';
                    }
                }
            }
        }
        console.log('allBookingData '+JSON.stringify(allBookingData));
        component.set("v.allBookingData",allBookingData);
        helper.buildData(component, helper);
        var msg=component.set("v.Request_completed_Message");//'Your request has been completed Sucessfully.';
        var utility = component.find("ETI_UtilityMethods");
        var promise = utility.showToast(component.get("v.Success"),msg,"","dismissible","success");
    },
    /*cloneService: function(component, event, helper) {
        var bookingRecords=component.get("v.bookingWrp");
        var rowIdx = event.getSource().get("v.name");
        console.log('rowIdx>> '+rowIdx);
        var draftBooking=bookingRecords[0].booking;
        console.log('draftBooking '+JSON.stringify(draftBooking));
        var isPendingBookingsExist=false;
        for(var idx = 0; idx < bookingRecords.length; idx++){
            if(idx!=0){
                bookingRecords[idx].isValidated =false;
        		bookingRecords[idx].errorMessage = '';
                if(bookingRecords[idx].serviceTypes == undefined || bookingRecords[idx].serviceTypes.length ==0){
                    var msg='This Vehicle has pending bookings remove from list.';
                }else {
                    console.log('serviceTypes '+bookingRecords[idx].serviceTypes);
                    console.log('selected type '+draftBooking.Service_Type__c);
                    console.log('selected type flag '+bookingRecords[idx].serviceTypes.includes(draftBooking.Service_Type__c));
                    if(bookingRecords[idx].serviceTypes.includes(draftBooking.Service_Type__c)){
                        bookingRecords[idx].booking.Service_Type__c = draftBooking.Service_Type__c;
                        bookingRecords[idx].servicesMap=bookingRecords[0].servicesMap;
                        bookingRecords[idx].certificates=bookingRecords[0].certificates;
                        bookingRecords[idx].slotList == bookingRecords[0].slotList;
                        bookingRecords[idx].booking.Mobile_No__c = draftBooking.Mobile_No__c;
                        bookingRecords[idx].booking.Purpose_Type__c = draftBooking.Purpose_Type__c;
                        bookingRecords[idx].booking.ET_Location__c = draftBooking.ET_Location__c;
                        bookingRecords[idx].booking.Booking_Date__c = draftBooking.Booking_Date__c;
                        bookingRecords[idx].booking.Preferred_Time__c = draftBooking.Preferred_Time__c;
                        bookingRecords[idx].requiredDocuments=[];
                        bookingRecords[idx].fileName=[];
                        if(component.get("v.selectedPremises")=='Customer Premises-B2B' && component.get("v.selectedPlace")=='Home/Office Premise-B2B')
                        {
                            if(bookingRecords[idx].booking.Vehicle_Type__c=='Trailer'){
                                bookingRecords[idx].booking.Selected_Services_Code__c='17';
                                bookingRecords[idx].isTrailer =false;
                            }else if(bookingRecords[idx].booking.Vehicle_Type__c=='Equipment'){
                                bookingRecords[idx].booking.Selected_Services_Code__c='8';
                                bookingRecords[idx].isEquipment =false;
                            }else {
                                bookingRecords[idx].booking.Selected_Services_Code__c='12';
                            }
                        }
                    }else {
                         isPendingBookingsExist=true;
                         bookingRecords[idx].isValidated =true;
                    	 bookingRecords[idx].errorMessage = 'This Vehicle already has a '+draftBooking.Service_Type__c+' pending booking.';
                    }
                }
            }
        }
        console.log('bookingRecords '+JSON.stringify(bookingRecords));
        component.set("v.bookingWrp",bookingRecords);
        if(isPendingBookingsExist){
            var msg='Pending bookings exist for few vehicles, please review error message and remove from list to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("Error!",msg,"","sticky","error");
        }else{
            var msg='Your request has been completed Sucessfully.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("Success!",msg,"","dismissible","success");
        }
    },*/
    addService: function(component, event, helper) {
        var rowIdx = event.getSource().get("v.name");
        console.log('rowIdx>> '+rowIdx);
        var bookingList = component.get("v.bookingWrp");
        var allServiceTypes= bookingList[rowIdx].serviceTypes;
        var resultArray =JSON.parse(JSON.stringify(allServiceTypes));
        var selectedType = bookingList[rowIdx].booking.Service_Type__c;
        console.log('selectedType>> '+selectedType);
        const index = resultArray.indexOf(selectedType);
        var addRec = {"booking":{"Purpose_Type__c":bookingList[rowIdx].booking.Purpose_Type__c,"Registration_Type__c":bookingList[rowIdx].booking.Registration_Type__c,"ET_Location__c":bookingList[rowIdx].booking.ET_Location__c,"Chassis_No__c":bookingList[rowIdx].booking.Chassis_No__c,"Plate_Color__c":bookingList[rowIdx].booking.Plate_Color__c,"Plate_No__c":bookingList[rowIdx].booking.Plate_No__c,"Customer_Vehicle__c":bookingList[rowIdx].booking.Customer_Vehicle__c,"Mobile_No__c":bookingList[rowIdx].booking.Mobile_No__c,"Service_Type__c":""},"requestId":bookingList[rowIdx].requestId,"enableAvailableSlots":false,"fileName":[],"uploadedFile":[],"isAdfcaVehicle":false,"customerVehicle":{"Trade_License_Number__c":"","Trade_License_Expiry_Date__c":null,"Id":bookingList[rowIdx].customerVehicle.Id},"isColorChange":false,"isEnabled":true,"isDuplicate":false,"isFeeDetailsExist":false,"isSelectedRecord":false,"vehicleTypeCode":bookingList[rowIdx].vehicleTypeCode,"isValidated":false,"isVehicleTypeChange":false,"locationMap":[],"openServicesMap":bookingList[rowIdx].openServicesMap,"certificates":[],"rowIndex":rowIdx+1};
        if(component.get("v.selectedPremises")=='Customer Premises-B2B'){
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
        console.log('resultArray>> '+resultArray);
        console.log('length>> '+resultArray.length);
        for(var idx = 0; idx < allServiceTypes.length; idx++){
            console.log('idx>> '+allServiceTypes[idx]);
            if(resultArray.length >0 && allServiceTypes[idx]==resultArray[0]){ 
                console.log('resultArray[0]>> '+resultArray[0]);
                allServiceTypes.splice(idx, 1);
            }
        }
        console.log('allServiceTypes>> '+allServiceTypes);
        bookingList[rowIdx].serviceTypes = allServiceTypes;
        
        bookingList[rowIdx+1].serviceTypes = resultArray;
        if(resultArray.slice(-1).length ==1){
            bookingList[rowIdx+1].isAddDisabled=true;
        }
        bookingList[rowIdx].isAddDisabled=true;
        component.set("v.bookingWrp", bookingList);
    },
    removeService: function(component, event, helper) {
        var rowIdx = parseInt(event.currentTarget.getAttribute("data-value"));
        var allBookingData = component.get("v.allBookingData");
        var bookingRecords = component.get("v.bookingWrp");
        console.log('rowIdx>> ',rowIdx);
        var removedRowIndex;
        /*for(var idx = 0; idx < bookingRecords.length; idx++){
            if(allBookingData[rowIdx].booking.Customer_Vehicle__c == bookingRecords[idx].booking.Customer_Vehicle__c){
            	removedRowIndex=allBookingData[idx].rowIndex;
                break;
            }
        }
        for(var idx = 0; idx < allBookingData.length; idx++){
            if(idx!=rowIdx){
                if(allBookingData[rowIdx].booking.Customer_Vehicle__c == allBookingData[idx].booking.Customer_Vehicle__c){
                    allBookingData[idx].isAddDisabled=false;
                    removedRowIndex=allBookingData[idx].rowIndex;
                    console.log('length>> '+allBookingData[rowIdx].serviceTypes.length);
                    for(var i = 0; i < allBookingData[rowIdx].serviceTypes.length; i++){
                        console.log('innn>> '+allBookingData[rowIdx].serviceTypes[i]);
                        allBookingData[idx].serviceTypes.push(allBookingData[rowIdx].serviceTypes[i]);
                    }
                    break;
                }
            }
        }*/
        /*if(allBookingData[rowIdx].booking.Customer_Vehicle__c == allBookingData[rowIdx-1].booking.Customer_Vehicle__c){
            allBookingData[rowIdx-1].isAddDisabled=false;
        	console.log('length>> '+allBookingData[rowIdx].serviceTypes.length);
        	for(var idx = 0; idx < allBookingData[rowIdx].serviceTypes.length; idx++){
                console.log('innn>> '+allBookingData[rowIdx].serviceTypes[idx]);
            	allBookingData[rowIdx-1].serviceTypes.push(allBookingData[rowIdx].serviceTypes[idx]);
            }
        }
            else if(allBookingData[rowIdx].booking.Customer_Vehicle__c == allBookingData[rowIdx+1].booking.Customer_Vehicle__c){
            allBookingData[rowIdx+1].isAddDisabled=false;
        	console.log('length>> '+allBookingData[rowIdx].serviceTypes.length);
        	for(var idx = 0; idx < allBookingData[rowIdx].serviceTypes.length; idx++){
                console.log('innn>> '+allBookingData[rowIdx].serviceTypes[idx]);
            	allBookingData[rowIdx+1].serviceTypes.push(allBookingData[rowIdx].serviceTypes[idx]);
            }
        }*/
        //console.log('out>> '+allBookingData[rowIdx-1].serviceTypes);
        console.log('removedRowIndex>> ',removedRowIndex);
        allBookingData.splice(rowIdx, 1);
        //bookingRecords.splice(removedRowIndex, 1);
        console.log('allBookingData>> '+JSON.stringify(allBookingData));
        //console.log('bookingRecords>> '+JSON.stringify(bookingRecords));
        var allBookings =[];
        for(var idx = 0; idx < allBookingData.length; idx++){
            allBookings[idx]=allBookingData[idx];
            allBookings[idx].rowIndex=idx;
        }
        component.set("v.totalRecords",allBookings.length);
        component.set("v.totalPages", Math.ceil(allBookings.length/component.get("v.pageSize")));
        console.log('allBookings>> '+JSON.stringify(allBookings));
        component.set("v.allBookingData", allBookings);
        console.log('totalPages>> '+component.get("v.totalPages"));
        if(component.get("v.totalPages")>1)
        	helper.buildWrpData(component, allBookings,true);
        else
            component.set("v.bookingWrp", allBookings);
        //helper.buildData(component, helper);
    },
    fetchCenters: function (component, event, helper) {
        if(!component.get("v.isRetest")){
            var allBookingData = component.get("v.allBookingData");
            console.log('selectedPlace '+component.get("v.selectedPlace"));
            var idx = event.getSource().get("v.name");
            console.log('idx>> '+idx);
            for(var idxVar=0;idxVar<allBookingData.length;idxVar++){
                if(idx==idxVar)
                    allBookingData[idxVar].isSelectedRecord=true;
                else 
                    allBookingData[idxVar].isSelectedRecord=false;
            }
            console.log('allBookingData'+JSON.stringify(allBookingData));
            var reTest=component.get("v.isRetest");
            if(reTest) idx=0;
            var selectedPlace;
            if(component.get("v.selectedPremises")=='Visit ET Premises'){
                selectedPlace=component.get("v.selectedPremises");
            }else 
                selectedPlace=component.get("v.selectedPlace");
            //helper.getLocations(component, event, allBookingData,selectedPlace,idx);
        }
        helper.handleOnChangeOfPurposeHelper(component, event, helper);
    },
    onPremisesChange: function (component, event, helper) {
        component.set("v.IsSpinner", true);
        component.set("v.errorSelectedPremises", false);
        var allBookingData = component.get("v.allBookingData");
        /*if(component.get("v.emirate")!='Sharjah' && component.get("v.selectedPremises")=='Customer Premises-B2B'){
            var vehicleCount=0;
            let vehicleFlag=false;
            for(let index = 0 ; index < allBookingData.length; index++){
                if(allBookingData[index].booking.Vehicle_Type__c=='Vehicle' || allBookingData[index].booking.Vehicle_Type__c=='Trailer'){
                   vehicleCount++;
                   vehicleFlag=true;
                }
            }
        	if(vehicleCount<10 && vehicleFlag){
                var msg=component.get("v.Not_allowed_to_book_less_than_10");//'You are not allowed to book customer premises bookings for less than 10 vehicles.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Error",msg,"","dismissible","error");
                component.set("v.IsSpinner", false);
                component.set("v.selectedPremises", 'Visit ET Premises');
            	return false;
            }
        }*/
        component.set("v.servicesList", []);
        component.set("v.selectedServices", '');
        component.set("v.selectedPlace", '');
        component.set("v.selectedServiceType", '');
        if(component.get("v.emirate")!='Sharjah')
        	component.set("v.pickUpLocation", '');
        var reTest=component.get("v.isRetest");
        for(let index = 0 ; index < allBookingData.length; index++){
            allBookingData[index].servicesMap=[];
            allBookingData[index].booking.Place_of_Service__c='';
            allBookingData[index].booking.Service_Type__c='';
            //if(component.get("v.emirate")!='Sharjah' && allBookingData[index].vehicleTypeCode!=undefined )
            //    allBookingData[index].booking.Purpose_Type__c='';
            allBookingData[index].booking.Selected_Services_Code__c='';
            allBookingData[index].booking.Latitude__c='';
            allBookingData[index].booking.Longitude__c='';
            allBookingData[index].booking.Preferred_Time__c='';
            allBookingData[index].booking.Booking_Date__c=null;
            allBookingData[index].isVehicleTypeChange=false;
            allBookingData[index].isColorChange=false;
            allBookingData[index].newVehicleType='';
            allBookingData[index].newColor='';
            allBookingData[index].newColor2='';
            allBookingData[index].newColor3='';
            allBookingData[index].newColor4='';
            allBookingData[index].isValidated =false;
            allBookingData[index].errorMessage = '';
            allBookingData[index].isChildValidated =false;
            allBookingData[index].childErrorMessage = '';
            allBookingData[index].certificates = [];
            allBookingData[index].locationMap = [];
            allBookingData[index].customerVehicle.Trade_License_Number__c='';
            allBookingData[index].customerVehicle.Trade_License_Expiry_Date__c=null;
           
            if(component.get("v.emirate")!='Sharjah'){
                component.set("v.selectedLocation",'');
                allBookingData[index].isAddDisabled=false;
                allBookingData[index].booking.ET_Location__c='';
            	allBookingData[index].booking.ETI_Pick_Up_Location__c='';
            }
            
        }
        console.log('allBookingData after>> '+JSON.stringify(allBookingData));
        component.set("v.IsSpinner", false);
        component.set("v.allBookingData", allBookingData);
		helper.buildWrpData(component, allBookingData,false);
        if(component.get("v.selectedPremises")=='Customer Premises-B2B')
            helper.getPreferredTime(component, event, helper);
    },
    clearWrapper: function (component, event, helper) {
        component.set("v.errorSelectedPlace", false);
        var allBookingData = component.get("v.allBookingData");
        component.set("v.selectedServiceType", '');
        //component.set("v.pickUpLocation", '');
        for(let index = 0; index < allBookingData.length; index++){
            allBookingData[index].booking.Service_Type__c='';
            //if(component.get("v.emirate")!='Sharjah' && (allBookingData[index].vehicleTypeCode!=undefined && allBookingData[index].vehicleTypeCode!=''))
            //    allBookingData[index].booking.Purpose_Type__c='';//19/01/21 commented
            allBookingData[index].booking.Selected_Services_Code__c='';
            /*allBookingData[index].booking.ET_Location__c='';
            allBookingData[index].booking.ETI_Pick_Up_Location__c='';
            allBookingData[index].booking.Latitude__c='';
            allBookingData[index].booking.Longitude__c='';*/
            allBookingData[index].booking.Booking_Date__c=null;
            allBookingData[index].booking.Preferred_Time__c='';
            allBookingData[index].isValidated =false;
            allBookingData[index].errorMessage = '';
            allBookingData[index].isChildValidated =false;
            allBookingData[index].childErrorMessage = '';
            allBookingData[index].certificates = [];
            allBookingData[index].locationMap = [];
            allBookingData[index].servicesMap=[];
            allBookingData[index].isVehicleTypeChange=false;
            allBookingData[index].isColorChange=false;
            allBookingData[index].newVehicleType='';
            allBookingData[index].newColor='';
            allBookingData[index].newColor2='';
            allBookingData[index].newColor3='';
            allBookingData[index].newColor4='';
            allBookingData[index].customerVehicle.Trade_License_Number__c='';
            allBookingData[index].customerVehicle.Trade_License_Expiry_Date__c=null;
            if(component.get("v.emirate")!='Sharjah')
                allBookingData[index].isAddDisabled=false;
        }
        component.set("v.selectedServices", '');
        component.set("v.allBookingData", allBookingData);
		helper.buildWrpData(component, allBookingData,false);
    },
    clearvalues3: function (component, event, helper) {
        component.set("v.selectedPremises", '');
        component.set("v.selectedServiceType", '');
    },
    fillTradeLicense: function (component, event, helper) {
        var allBookingData = component.get("v.allBookingData");
        var idx = event.getSource().get("v.name");
        console.log('idx>> '+idx);
        var tradeLicenseNumber = allBookingData[idx].customerVehicle.Trade_License_Number__c;
        console.log('tradeLicenseNumber>> '+tradeLicenseNumber);
        for (var indexVar = 0; indexVar < allBookingData.length; indexVar++) {
            if(idx!=indexVar)
                allBookingData[indexVar].customerVehicle.Trade_License_Number__c=tradeLicenseNumber;
        }
        component.set("v.allBookingData", allBookingData);
    },
    getPickupLocation: function(component, event, helper) {
        console.log('---getPickupLocation---');
        var allBookingData = component.get("v.allBookingData");
        var idx = event.getSource().get("v.id");
        console.log('idx>> '+idx);
        var searchText= component.get("v.pickUpLocation");
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
       
        var allBookingData = component.get("v.allBookingData");
        var bookingRecords = component.get("v.bookingWrp");
        var idx = event.getSource().get("v.name");
        console.log('allBookingData--'+JSON.stringify(allBookingData));
        for(var x=0;x<bookingRecords.length;x++){  
            console.log('x >> '+x);
            if(allBookingData[idx].rowIndex==bookingRecords[x].rowIndex)
                allBookingData[idx]=bookingRecords[x];
        }
        component.set("v.allBookingData",allBookingData);
        console.log('allBookingData1--'+JSON.stringify(allBookingData));
        console.log('Booking_Date--'+JSON.stringify(allBookingData[idx].booking.Booking_Date__c));
        console.log('minDate--'+component.get("v.maxDate"));
        console.log('emirate--'+component.get("v.emirate"));
        console.log('idx--'+idx);
        console.log('selectedPremises--'+component.get("v.selectedPremises"));
        console.log('preferredTimeList--'+component.get("v.preferredTimeList"));
        if (allBookingData[idx].booking.Booking_Date__c < component.get("v.minDate") || allBookingData[idx].booking.Booking_Date__c > component.get("v.maxDate") 
            || allBookingData[idx].booking.Booking_Date__c == null || allBookingData[idx].booking.Booking_Date__c == undefined){
            allBookingData[idx].slotList = [];
            allBookingData[idx].booking.ETI_Booking_slots__c = '';
            allBookingData[idx].enableAvailableSlots = false;
            component.set("v.allBookingData", allBookingData);
			helper.buildWrpData(component, allBookingData,false);
            return false;
        }
       
        allBookingData[idx].slotList = [];
        allBookingData[idx].booking.ETI_Booking_slots__c = '';
        allBookingData[idx].booking.Preferred_Time__c = '';
        if(component.get("v.selectedPremises")=='Visit ET Premises'){
             component.set("v.bookingSlotOptions", []);
            if (allBookingData[idx].booking.ET_Location__c == '' || allBookingData[idx].booking.ET_Location__c == undefined ){
                var msg=component.get("v.Select_a_Location");//'Please Select a Location to Proceed.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","Sticky","error");
                allBookingData[idx].booking.Booking_Date__c == null;
                component.set("v.allBookingData",allBookingData);
				helper.buildWrpData(component, allBookingData,false);
                return false;
            }
            var bookingDate;
            var location ;
            for (var indexVar = 0; indexVar < allBookingData.length; indexVar++) {
                console.log('idx>> '+idx+' indexVar>> '+indexVar);
                if(idx==indexVar){
                    bookingDate = allBookingData[indexVar].booking.Booking_Date__c;
                    location = allBookingData[indexVar].booking.ET_Location__c;
                    allBookingData[indexVar].booking.ETI_Booking_slots__c='';
                    allBookingData[indexVar].booking.Service_Premises__c=component.get("v.selectedPremises");
                    allBookingData[indexVar].isSelectedRecord=true;
                    allBookingData[indexVar].enableAvailableSlots=true;
                    allBookingData[indexVar].errorMessage='';
                }else {
                    allBookingData[indexVar].isSelectedRecord=false;
                    //allBookingData[indexVar].errorMessage='';
                }
                //allBookingData[indexVar].certificates=[];
            }
            console.log('bnkg2--'+JSON.stringify(allBookingData));
            var isReTest=false;
            if(component.get("v.isRetest") && !component.get("v.isReschedule"))
                isReTest=true;
            if (bookingDate !== undefined && location !== undefined) {
                component.set("v.IsSpinner", true);
                var action = component.get("c.getAvailableSlots");
                debugger;
                action.setParams({
                    obj: JSON.stringify(allBookingData),
                    isReTest: isReTest
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        debugger;
                        var result = response.getReturnValue();
                        console.log('result>> '+JSON.stringify(result));
                        console.log('slotList>> '+JSON.stringify(result[idx].slotList));
                        if(result[idx].slotList==null || result[idx].slotList== '' || result[idx].slotList==undefined){
                            var msg=component.get("v.Slots_Availability");//'Slots are not available on selected Date, Please select another date.';
                            var utility = component.find("ETI_UtilityMethods");
                            var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
                            allBookingData[idx].enableAvailableSlots=false;
                            
                        }else {
                            
                            console.log('requiredDocuments>> '+result[idx].requiredDocuments);
                            allBookingData[idx].slotList=result[idx].slotList;
                            allBookingData[idx].laneNslotsMap=result[idx].laneNslotsMap;
                            allBookingData[idx].serviceCode=result[idx].serviceCode;
                            allBookingData[idx].booking.Purpose_Type__c=result[idx].booking.Purpose_Type__c;
                            if(result[idx].requiredDocuments!=undefined && result[idx].requiredDocuments.length>0 
                               && !component.get("v.isReschedule") && !component.get("v.isRetest"))
                            	allBookingData[idx].requiredDocuments=result[idx].requiredDocuments;
                        }
                        component.set("v.allBookingData",allBookingData);
                        console.log('allBookingData--'+JSON.stringify(allBookingData));
						helper.buildWrpData(component, allBookingData,false);
                    }else {
                        var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request. Please try again or contact our customer service team.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                    }
                    component.set("v.IsSpinner", false);
                });
                $A.enqueueAction(action);
            }
        }else if(component.get("v.selectedPremises")=='Customer Premises-B2B' && component.get("v.emirate")!='Sharjah'
                && !component.get("v.isReschedule") && !component.get("v.isRetest")){
            
            component.set("v.IsSpinner", true);
            for (var indexVar = 0; indexVar < allBookingData.length; indexVar++) {
                if(idx==indexVar)
                    allBookingData[indexVar].isSelectedRecord=true;
                else 
                    allBookingData[indexVar].isSelectedRecord=false;
            }
            var action = component.get("c.getRequiredDocuments");
            action.setParams({
                obj:JSON.stringify(allBookingData),
                selectedPremise :component.get("v.selectedPremises"),
                preferTimes:component.get("v.preferredTimeList")
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('state--'+state);
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    console.log('docWrp--'+JSON.stringify(result));
                    component.set("v.allBookingData",result);
                    if(result[idx].slotList.length==0){
                        var msg=component.get("v.Slots_Availability");//'Slots are not available for selected Date, please Select another date.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
                    }else {
						helper.buildWrpData(component, result,false);
                    }
                }
                component.set("v.IsSpinner", false);
            });
            $A.enqueueAction(action);
        }else if(component.get("v.selectedPremises")=='Customer Premises-B2B' && (component.get("v.emirate")=='Sharjah'
                || (component.get("v.emirate")!='Sharjah' && (component.get("v.isReschedule") || component.get("v.isRetest"))))){
          
            component.set("v.IsSpinner", true);
            for (var indexVar = 0; indexVar < allBookingData.length; indexVar++) {
                if(idx==indexVar)
                    allBookingData[indexVar].isSelectedRecord=true;
                else 
                    allBookingData[indexVar].isSelectedRecord=false;
            }
         
            var action = component.get("c.getFinalPreferredTime");
            action.setParams({
                obj:JSON.stringify(allBookingData),
                preferTimes :component.get("v.preferredTimeList")
            });
            debugger;
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('state--'+state);
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    console.log('docWrp--'+JSON.stringify(result));
                    component.set("v.allBookingData",result);
                    console.log('result[idx] = '+ JSON.stringify(result[idx]));
                    console.log('result[idx].slotList = '+ result[idx].slotList);
                   
                    if(  result[idx].slotList == undefined || ( result[idx].slotList != undefined  && result[idx].slotList.length==0 )){
                        var msg=component.get("v.Slots_Availability");//'Slots are not available for selected Date, please Select another date.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
                    }
                    if(!component.get("v.isRetest") || !component.get("v.isReschedule"))
						helper.buildWrpData(component, result,false);
                    else 
                        component.set("v.bookingWrp",result);
                }
                component.set("v.IsSpinner", false);
            });
            $A.enqueueAction(action);
        }
    },
    fetchRquiredDocuments: function (component, event, helper) {
        if(component.get("v.emirate")!='Sharjah' && !component.get("v.isReschedule") && !component.get("v.isRetest")){
            var allBookingData = component.get("v.allBookingData");
            console.log('bnkg1--'+JSON.stringify(allBookingData));
            var action = component.get("c.getRequiredDocuments");
            action.setParams({
                obj:JSON.stringify(allBookingData),
                selectedPremise :component.get("v.selectedPremises"),
                preferTimes:component.get("v.preferredTimeList")
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('state--'+state);
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    console.log('docWrp--'+JSON.stringify(result));
                    component.set("v.allBookingData",result);
					helper.buildWrpData(component, allBookingData,false);
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
        var Lang='en';
        if(component.get("v.clLang")=='ar')
            Lang='ar';
        try{
            if(component.get('v.isNavigateToHome')){
                var urlEvent = $A.get("e.force:navigateToURL");
                // "url": '/eti-homepage?Loc='+component.get("v.selectedEmirate")  
                urlEvent.setParams({
                    "url": '/Business/s/home-inspection?lang='+Lang                        
                });
                urlEvent.fire();
            }else{
                var url = new URL(window.location.href);
                var search_params = url.searchParams; 
                var recId = search_params.get('recordId');
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                  //  "url": '/s/vehicle-page?showH=true&recordId='+recId+'&Loc='+component.get("v.emirate")   
                    "url": '/Business/s/b2bvehicle-pageinspection?showH=true&recordId='+recId+'&Loc='+component.get("v.emirate")                       
                });
                urlEvent.fire();
            }
        }
        catch(error){
            console.log(error.message);
        } 
    }, 
   
    createBooking: function (component, event, helper) {
        var reTest=component.get("v.isRetest");
        var selectedPremises = component.get('v.selectedPremises');
        if(selectedPremises =='' && !reTest){
            component.set('v.errorSelectedPremises',true);
        }else if(selectedPremises =='Customer Premises-B2B' && component.get("v.selectedPlace")=='' && !reTest){
            component.set('v.errorSelectedPlace',true);
        }else if(selectedPremises !='Customer Premises-B2B' && (component.get("v.selectedLocation") =='' || component.get("v.selectedLocation") == undefined) && !reTest){	
            var msg=component.get("v.Select_a_Location");//'Please Select a Location to proceed.';	
            var utility = component.find("ETI_UtilityMethods");	
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");	
        }else if(component.get("v.selectedPremises")=='Customer Premises-B2B' && (component.get("v.pickUpLocation") == undefined || component.get("v.pickUpLocation") == '')
            && (component.get("v.emirate")!='Sharjah' && (component.get("v.selectedLocation") == undefined || component.get("v.selectedLocation") == '')) && !reTest){
            var msg=component.get("v.Provide_Equipment_and_Inspection_Center");//'Please Provide the Equipment Location and Inspection Center.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }
                else if(component.get("v.selectedPremises")=='Customer Premises-B2B' && (component.get("v.pickUpLocation") == undefined || component.get("v.pickUpLocation") == '') && !reTest){
            var msg=component.get("v.Provide_the_Equipment_Location");//'Please Provide the Equipment Location.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else if(component.get("v.selectedPremises")=='Customer Premises-B2B' && component.get("v.emirate")!='Sharjah' && (component.get("v.selectedLocation") == undefined || component.get("v.selectedLocation") == '') && !reTest){
            var msg=component.get("v.Provide_Inspection_Center");//'Please Provide the Inspection Center.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            component.set("v.IsSpinner", false);
        }else {
            component.set("v.IsSpinner", true);
            var allBookingData = component.get("v.allBookingData");
            var bookingRecords = component.get("v.bookingWrp");
            console.log('bookingSlots11>> '+JSON.stringify(allBookingData));
            var serType=component.get("v.selectedServiceType");
            console.log('serType >> '+JSON.stringify(serType));
            component.set("v.errorMsg", component.get("v.selectedServiceType"));
            console.log('serType >> '+JSON.stringify(serType));
            var isDataMissing =false;
            console.log('allBookingData length: '+allBookingData.length);
            for(var idx=0;idx<allBookingData.length;idx++){ 
                allBookingData[idx].isChildValidated =false;
                allBookingData[idx].childErrorMessage = '';
                allBookingData[idx].isValidated =false;
                allBookingData[idx].errorMessage = '';
                if(component.get("v.emirate") =='Sharjah' && !helper.validateEmail(allBookingData[idx].booking.Email__c)){
                    allBookingData[idx].isValidated =true;
                    allBookingData[idx].errorMessage = component.get("v.Valid_Email_Address");//'Please Enter a Valid Email Address.';
                    var msg=component.get("v.Valid_Email_Address");//'Please Enter a Valid Email Address.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
                    isDataMissing=true;
                }else {
                    var mobile = allBookingData[idx].booking.Mobile_No__c;
                    var numbers = /^[0-9]+$/;
                    if (!mobile.match(numbers)) {
                        allBookingData[idx].isValidated =true;
                    	allBookingData[idx].errorMessage = component.get("v.Mobile_Number_should_numeric"); //'Mobile Number should numeric characters only.';
                        var msg=component.get("v.Mobile_Number_should_numeric"); //'Mobile Number should numeric characters only.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
                        isDataMissing=true;
                        //return true;
                    }else if (mobile.length != 12) {
                        allBookingData[idx].isValidated =true;
                    	allBookingData[idx].errorMessage = component.get("v.Mobile_Number_should_be_12_digits");// 'Mobile Number should be 12 digits.';
                        var msg= component.get("v.Mobile_Number_should_be_12_digits"); //'Mobile Number should be 12 digits.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
                        isDataMissing=true;
                        //return true;
                    }else if(mobile.substring(0, 3) !='971'){
                        allBookingData[idx].isValidated =true;
                    	allBookingData[idx].errorMessage = component.get("v.Mobile_Number_should_start_with_971"); //'Mobile Number should start with 971.';
                        var msg=component.get("v.Mobile_Number_should_start_with_971"); //'Mobile Number should start with 971.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");  
                        isDataMissing=true;
                        //return true;
                    } 
                }
                if(allBookingData[idx].booking.Service_Type__c==''){
                    console.log('idx >> '+idx);
                    allBookingData[idx].isValidated =true;
                    allBookingData[idx].errorMessage = component.get("v.Select_Service_Type");//'Please select Service Type and click on Book to proceed.';
                    isDataMissing=true;
                }
                //Added by Taj - Due for Retest Booking screen - Documents upload as mandatory.
                console.log('button label: '+event.getSource().get("v.label"));
                if(component.get("v.emirate") == 'Sharjah' && (event.getSource().get("v.label") == 'Save & Next' || event.getSource().get("v.label") == 'حفظ & التالي')){
                    var filesData = component.get('v.speaFileList');
                    //console.log('filesData '+JSON.stringify(filesData));
                    if(filesData == ''){   
                        helper.showErrorToast({
                            "title": "Warning",
                            "type": "Warning",
                            "message":"Attachment is required."
                        });
                        isDataMissing = true;
                    }  
                }
            }
            console.log('isDataMissing iiii>> '+isDataMissing);
            console.log('allBookingData: '+JSON.stringify(allBookingData));
            console.log('isDataMissing >> '+isDataMissing);
            if(!isDataMissing){
                for(var indexVar=0;indexVar<allBookingData.length;indexVar++){
                    if(selectedPremises == 'Customer Premises-B2B' && !reTest) {           
                        allBookingData[indexVar].booking.Service_Premises__c=component.get("v.selectedPlace");
                    }
                    if(reTest){
                        allBookingData[indexVar].isChildValidated=false;
                    	allBookingData[indexVar].childErrorMessage = '';
                    }
                    console.log('Location>> '+allBookingData[indexVar].booking.ET_Location__c); 
                    console.log('Date_And_Time>> '+allBookingData[indexVar].booking.Booking_Date__c); 
                    let dataMissing=helper.ValidateRequiredDetails(component, event, allBookingData,indexVar);
                    console.log('dataMissing<< '+dataMissing);
                    if (dataMissing){ 18/11/20
                        console.log('isDataMissing if<< '+isDataMissing);
                        if(!isDataMissing)             
                            isDataMissing=true;
                        component.set("v.IsSpinner", false);
                        //return false;
                    }else { 
                        console.log('isDataMissing else<< '+isDataMissing);
                        if(allBookingData[indexVar].isAdfcaVehicle && (allBookingData[indexVar].booking.Selected_Services_Code__c == undefined || allBookingData[indexVar].booking.Selected_Services_Code__c == '')){
                            allBookingData[indexVar].isValidated=true;
                            allBookingData[indexVar].errorMessage = component.get("v.Validate_Trade_License_Number");//'Validate Trade License number to confirm booking, Click on Book and then Save to validate.';
                            isDataMissing=true;
                    	}else if(allBookingData[indexVar].booking.Selected_Services_Code__c == undefined || allBookingData[indexVar].booking.Selected_Services_Code__c == '' || (selectedPremises !='Customer Premises-B2B' && (allBookingData[indexVar].booking.Purpose_Type__c == undefined || allBookingData[indexVar].booking.Purpose_Type__c == ''))){
                            allBookingData[indexVar].isValidated=true;
                            allBookingData[indexVar].errorMessage = component.get("v.Fields_Mandatory_Message"); //'All fields are Mandatory to confirm booking, Click on Book to fill.';
                                //'Purpose type field is Mandatory.';
                            isDataMissing=true;
                        }
                        console.log('isChildValidated else<< '+allBookingData[indexVar].isChildValidated);
                        if(allBookingData[indexVar].isChildValidated){
                            allBookingData[indexVar].isValidated = true;
                            allBookingData[indexVar].errorMessage = allBookingData[indexVar].childErrorMessage;
                            isDataMissing=true;
                        }
                        console.log('isValidated else<< '+allBookingData[indexVar].isValidated);
                        if (allBookingData[indexVar].isAdfcaVehicle && allBookingData[indexVar].booking.Trade_License_Expiry_Date__c < component.get("v.minDate")){
                            allBookingData[indexVar].isValidated=true;
                            allBookingData[indexVar].errorMessage = component.get("v.Trade_License_Date_should_be_future"); //'Trade Liciense Date should be future.';
                            isDataMissing=true;
                        }
                        if(!isDataMissing){
                            allBookingData[indexVar].isValidated = false;
                            allBookingData[indexVar].errorMessage = '';
                        }
                    }
                    console.log('isDataMissing if<< '+isDataMissing);
                } 
        	}
            if(isDataMissing){
                var isError=false;
                var errorPage=1;
                component.set("v.allBookingData",allBookingData);
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
                        var msg=component.get("v.Fix_All_Errors");//'Please fix all the errors to proceed.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                    }
				}
                console.log('bookingRecords: '+JSON.stringify(bookingRecords));
                if(!isError)
                	component.set("v.bookingWrp",bookingRecords);
                component.set("v.IsSpinner", false);
                return false;
            }
            console.log('allBookingData: '+JSON.stringify(allBookingData));
            component.set("v.allBookingData",allBookingData);
            console.log('isDataMissing<< '+isDataMissing);
            console.log('isTermsAndConditionsAgreed<< '+allBookingData[0].isTermsAndConditionsAgreed);
            if(!allBookingData[0].isTermsAndConditionsAgreed){
                var parentElement =  component.find('termsandconditioncheckboxParent').getElement();
                var errorElement =  component.find('termsandconditioncheckboxError').getElement();
                $A.util.addClass(parentElement, 'slds-has-error');
                $A.util.removeClass(errorElement, 'slds-hide');
                component.set("v.IsSpinner", false);
                return false;
            }
            if(!isDataMissing){
                var changedAddress;
                console.log('pickUpEmirate>> '+component.get("v.pickUpEmirate"));
                console.log('emirate>> '+component.get("v.emirate"));
                console.log('pickUpLocation>> '+component.get("v.pickUpLocation"));
                var pickUpLocation;
                if(component.get("v.pickUpEmirate")!=null && component.get("v.pickUpEmirate")!=undefined)
                    pickUpLocation=component.get("v.pickUpEmirate");
                else 
                    pickUpLocation=component.get("v.emirate");
                if(component.get("v.isAddressChanged"))
                    changedAddress = component.get("v.pickUpLocation");
                console.log('pickUpLocation: '+pickUpLocation+' emirate: '+component.get("v.emirate")+' selectedLocation: '+component.get("v.selectedLocation"));
                if(component.get("v.emirate") == 'Abu Dhabi' || component.get("v.emirate") == 'AbuDhabi')
                    var action = component.get("c.saveBooking");
                if(component.get("v.emirate") == 'Sharjah')
                    var action = component.get("c.saveBooking_SPEA");
                console.log('allBookingData Newly Added: '+JSON.stringify(allBookingData));
                action.setParams({
                    obj:JSON.stringify(allBookingData),
                    selectedPremise:component.get("v.selectedPremises"),
                    fullAddress : changedAddress,
                    emirate : pickUpLocation
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
                                        //alert("Online Payment service is down now, Please pay at our Premises.");
                                        var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while fetching the fee Details. Please try again or contact our customer service team.';
                                        var utility = component.find("ETI_UtilityMethods");
                                        var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
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
                                    var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request. Please try again or contact our customer service team.';
                                    var utility = component.find("ETI_UtilityMethods");
                                    var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                                    component.set("v.allBookingData",result);
                                    helper.buildData(component, helper);
                                }
                            }else {
                                var msg=component.get("v.Selected_Slot_Booked");//'Selected slot already Booked for these bookings, Please select another slots.';
                                var utility = component.find("ETI_UtilityMethods");
                                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                                component.set("v.allBookingData",result);
                                helper.buildData(component, helper);
                            }
                        }
                        catch(error){
                            console.log(error.message);
                        }
                        component.set("v.IsSpinner", false);
                    }else {
                        var msg=component.get("v.Unexpected_Error_Message");//'Unexpected error occurred while processing your request. Please try again or contact our customer service team.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                        component.set("v.IsSpinner", false);
                    }
                });
                $A.enqueueAction(action);
            }else {
                component.set("v.allBookingData",allBookingData);
                helper.buildWrpData(component, allBookingData,false);
                //helper.buildData(component, helper);
                component.set("v.IsSpinner", false);
            }
        }
    },
    getCertificateLocations: function (component, event, helper) {
    	component.set("v.IsSpinner", true);
        var allBookingData = component.get("v.allBookingData");
        var idxVar = component.get("v.selectedRowIndex");
        helper.certificateLocations(component, event, allBookingData,idxVar);
	},
    handleOnChangeOfPurpose: function (component, event, helper) {
       helper.handleOnChangeOfPurposeHelper(component, event, helper);
    },
    locationChanged: function (component, event, helper) {  
        var allBookingData = component.get("v.allBookingData");
        var bookingRecords = component.get("v.bookingWrp");
        if(allBookingData[0].booking.Service_Type__c== undefined || allBookingData[0].booking.Service_Type__c== '' || allBookingData[0].booking.Service_Type__c==null){
        	for(var idx=0;idx<allBookingData.length;idx++){  
                allBookingData[idx].booking.ET_Location__c= component.get("v.selectedLocation");
            	/*if(allBookingData[idx].booking.Customer_Vehicle__c==bookingRecords[idx].booking.Customer_Vehicle__c)
                    bookingRecords[idx]=allBookingData[idx];*/
            }
        }else{
            var msg = component.get("v.Need_to_refill_details");//'You need to refill the details agian if you change the location, Still you want to change the location?';
            if (!confirm(msg)) {
                return false;
            } else {
                for(var idx=0;idx<allBookingData.length;idx++){  
                    allBookingData[idx].booking.ET_Location__c= component.get("v.selectedLocation");
                	//29/10/20
                	if(component.get("v.emirate")!='Sharjah' && (allBookingData[idx].vehicleTypeCode!=undefined && allBookingData[idx].vehicleTypeCode!='')) 
        				allBookingData[idx].booking.Purpose_Type__c='';
                    allBookingData[idx].servicesMap=[];
                    allBookingData[idx].booking.Service_Type__c='';
                    allBookingData[idx].booking.Booking_Date__c= null;
                    allBookingData[idx].slotList= [];
                    allBookingData[idx].booking.ETI_Booking_slots__c= '';
                    allBookingData[idx].enableAvailableSlots= false;
                    allBookingData[idx].isVehicleTypeChange=false;
                    allBookingData[idx].isColorChange=false;
                    allBookingData[idx].newVehicleType='';
                    allBookingData[idx].newColor='';
                    allBookingData[idx].newColor2='';
                    allBookingData[idx].newColor3='';
                    allBookingData[idx].newColor4='';
                    allBookingData[idx].isValidated =false;
                    allBookingData[idx].errorMessage = '';
                    allBookingData[idx].isChildValidated =false;
                    allBookingData[idx].childErrorMessage = '';
                    allBookingData[idx].certificates = [];
                    allBookingData[idx].customerVehicle.Trade_License_Number__c='';
                    allBookingData[idx].customerVehicle.Trade_License_Expiry_Date__c=null;
                    /*if(allBookingData[0].booking.Customer_Vehicle__c==bookingRecords[0].booking.Customer_Vehicle__c)
                    	bookingRecords[0]=allBookingData[0];*/
                }
            } 
        }
        component.set('v.allBookingData',allBookingData);
        helper.buildWrpData(component, allBookingData,false);
        //helper.buildData(component, helper);
        //component.set('v.bookingWrp',bookingRecords);
        console.log('allBookingData locationChanged>> '+JSON.stringify(component.get("v.allBookingData")));
	},
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
    handleUploadFinished: function (cmp, event) {
        //Get the list of uploaded files
        var booking = cmp.get('v.booking');
        alert(JSON.stringify(booking))
        var uploadedFiles = event.getParam("files");
        //Show success message – with no of files uploaded
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type" : "success",
            "message": uploadedFiles.length+" files has been uploaded successfully!"
        });
        toastEvent.fire();
         
        $A.get('e.force:refreshView').fire();
         
        //Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
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
            var Filelist1 = component.get('v.fileListFornewVersion');
            console.log(Filelist1);
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
    
    
    handleUploadFinishedSharjah: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
        var documentId = uploadedFiles[0].documentId;  
        helper.UpdateDocument(component,event,documentId);  
        // Get the file name
        //uploadedFiles.forEach(file => console.log(file.name));
    },
    
    
     onFileUploaded:function(component,event,helper){
        helper.show(component,event);
        var files = component.get("v.fileToBeUploaded");
        if (files && files.length > 0) {
            var file = files[0][0];
            var reader = new FileReader();
            reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                helper.upload(component, file, content, function(answer) {
                    if (answer) {
                        helper.hide(component,event);
                        // Success
                    }
                    else{
                        // Failure
                    }
                });
            }
            reader.readAsDataURL(file);
        }
        else{
            helper.hide(component,event);
        }
    },
   
    OnUploadSpea: function(component, event, helper) {
        try{
             var files = component.get("v.uploadedDocs");
             var fileUploadWrapper = component.get("v.speaFileList");
             var contentWrapperArr = [];
            
            if(files && files.length > 0 && fileUploadWrapper.length < 1 ) {
                for(var i=0; i < files[0].length; i++){
                    var file = files[0][i];
                   
                    if(file.size <= 2500000) {                        
                        var reader = new FileReader();
                        reader.name = file.name;
                        reader.type = file.type;                      
                        reader.onloadend = function(e) {
                            var base64 = reader.result.split(',')[1]
                            fileUploadWrapper.push({
                                'filename':file.name,
                                'filetype':file.type,
                                'base64':base64
                                
                            });
                            contentWrapperArr.push({
                                'filename':file.name,
                                'filetype':file.type,
                                'base64':base64                      
                            });
                            console.log(fileUploadWrapper);
                            component.set("v.speaFileList",fileUploadWrapper);
                        }
                        function handleEvent(event) {
                            if(contentWrapperArr.length == i){
                                
                                component.set("v.speaFileList",fileUploadWrapper);
                            }
                        }
                        reader.readAsDataURL(file);
                        reader.addEventListener('loadend', handleEvent);
                    }else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please upload file less than 2.5 MB.",
                            "mode": "sticky"
                        });
                        toastEvent.fire();
                    }
                }
            }else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "You cannot upload more than one file.",
                            "mode": "sticky"
                        });
                        toastEvent.fire();
                    }
           
        }catch (e){
            console.log(e.message);
        }
    },
    
     removeRecord: function(component, event, helper) {
        var speaFileList = component.get("v.speaFileList");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        speaFileList.splice(index, 1);
        component.set("v.speaFileList", speaFileList);
    },
     createDraftBookingNew: function(component, event, helper) {
       
            helper.createDraftBooking(component, event, helper); 
       
    },
     
    /* handleOnColorChange: function (component, event, helper) {
        try{
             var idxVar = component.get("v.selectedRowIndex");
        var bookingRecords = component.get("v.bookingWrp");
        var color1 = bookingRecords[idxVar].newColor;
        var color2 = bookingRecords[idxVar].newColor2;
        var color3 = bookingRecords[idxVar].newColor3;
        var color4 = bookingRecords[idxVar].newColor4;
        var newColorList = JSON.parse(JSON.stringify(component.get("v.newColorList"))); 
           
           
            var currentId = event.getSource().getLocalId();
            if(color1 != null && color1 != undefined && color1 != '' && currentId != 'newColor1'){
                newColorList.splice(helper.getColorIndex(component, color1, newColorList), 1);
            }
            if(color2 != null && color2 != undefined && color2 != '' && currentId != 'newColor1'){
                newColorList.splice(helper.getColorIndex(component, color2, newColorList), 1);
            }
            if(color3 != null && color3 != undefined && color3 != '' && currentId != 'newColor1'){
                newColorList.splice(helper.getColorIndex(component, color3, newColorList), 1);
            }
             var index = helper.getColorIndex(component, event.getSource().get("v.value"), newColorList);
        if(currentId == 'newColor1' ){
            
            if (index > -1) {
                newColorList.splice(index, 1);
            }
            //console.log('@@@@@@   ', newColorList);
            component.set("v.newColorList2",newColorList);
             component.set("v.newColorList3",newColorList);
             component.set("v.newColorList4",newColorList);
        }
       // index = newColorList.indexOf(color2);
        if(currentId == 'newColor2'){
            //alert(index)
             //console.log('@@@@@@   ', JSON.parse(JSON.stringify(newColorList)));
             if (index > -1) {
                newColorList.splice(index, 1);
            }
             component.set("v.newColorList3",newColorList);
             //component.set("v.newColorList1",newColorList);
             component.set("v.newColorList4",newColorList);
        }
       // index = newColorList.indexOf(color3);
        if(currentId == 'newColor3'){
             if (index > -1) {
                newColorList.splice(index, 1);
            }
             //component.set("v.newColorList2",newColorList);
             //component.set("v.newColorList1",newColorList);
             component.set("v.newColorList4",newColorList);
        }
       ///index = newColorList.indexOf(color4);
        if(currentId == 'newColor4'){
             if (index > -1) {
                newColorList.splice(index, 1);
            }
           // component.set("v.newColorList2",newColorList);
           // component.set("v.newColorList1",newColorList);
            //component.set("v.newColorList3",newColorList);
        }       
        }catch(err){
            alert(err.message)
        }
       // component.set("v.newColorList4",result);
       // alert(idxVar)
	}*/
})
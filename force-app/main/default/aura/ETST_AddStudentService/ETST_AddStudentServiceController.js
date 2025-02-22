({
    openpickupMapController : function(component, event, helper) {        
        component.set('v.openpickupMap',true);
    },
    closePickupModel: function(component, event, helper) {
        component.set('v.openpickupMap',false); 
        component.set("v.searchText", '');
    },
    closeDropoffModel: function(component, event, helper) {
        component.set('v.openDropoffMap',false);  
        component.set("v.searchText", '');
    },
     openDropoffMapController : function(component, event, helper) {
        component.set('v.openDropoffMap',true);
    },
    doInit : function(component, event, helper) {
        const d = new Date();
		let year = d.getFullYear();
        let nextYr=year+1;
		let yrList=[];
		yrList.push(year); 
        yrList.push(nextYr);
        component.set('v.academicYr',yrList);
        
        
        component.set('v.loaded',false);
        component.set('v.serviceRecord.ETST_Dropoff_Location__Latitude__s',0.0);
        component.set('v.serviceRecord.ETST_Dropoff_Location__Longitude__s',0.0);
        component.set('v.serviceRecord.ETST_Location__Latitude__s',0.0);
        component.set('v.serviceRecord.ETST_Location__Longitude__s',0.0);
        component.set('v.serviceRecord.Remarks__c',''); // Added by Sreelakshmi SK-- 29/3/2023
        component.set('v.serviceRecord.Other_Area__c',''); // Added by Sreelakshmi SK-- 1/6/2023
        
        
        if(component.get('v.renewServiceModal')){
            var now = new Date();
            if (now.getMonth() == 11) {
                var current = new Date(now.getFullYear() + 1, 0, 1);
            } else {
                var current = new Date(now.getFullYear(), now.getMonth() + 1, 1);
            }
            component.set('v.today', $A.localizationService.formatDate(current, "YYYY-MM-DD"));
            
        }else{
             var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
             component.set('v.today', today);        
        }
        
        var options = { enableHighAccuracy: false,  timeout: 60000 };
        
		if (navigator.geolocation) {
            //alert("able to retrieve your location1");
            navigator.geolocation.getCurrentPosition(function(position) {
                //alert("able to retrieve your location"+position);
                var latit = position.coords.latitude;
                var longit = position.coords.longitude;
                //alert(latit+'lat');
                component.set('v.serviceRecord.ETST_Location__Latitude__c',latit);
                component.set('v.serviceRecord.ETST_Location__Longitude__c',longit);
                component.set('v.lat',latit);
                component.set('v.lon',longit);
                component.set('v.vfUrl','/apex/ETST_GoogleMapFinder?lat='+latit+'&long='+longit);
       
            });
         
        }else{
            console.log("Unable to retrieve your location");
        }       
        helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
        helper.doInit(component, event, helper);
        if(lang=='ar'){
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__body');
        }else{
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__body');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
        } 
        var urlString=window.location.href;
        var vfOrigin = urlString.substring(0, urlString.indexOf("/customer/s"));
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
     
        
    },
    
    /*afterRender: function(component, helper) {
    this.superAfterRender();
    // Apply highlight to the checkbox initially
    var checkbox = component.find("Semester_1__c");
    $A.util.addClass(checkbox, "slds-has-focus");
  },*/
    
    setServiceDates: function(component, event, helper) { 
        component.set("v.serviceRecord.ETST_Fare_Charges__c",'');
        component.set("v.serviceRecord.ETST_Area__c",'');
        component.set('v.serviceRecord.ETST_Pick_Up_From__c','');
        component.set('v.serviceRecord.ETST_Location__Longitude__s','');
        component.set('v.serviceRecord.ETST_Drop_Off_To__c','');
        component.set('v.serviceRecord.ETST_Dropoff_Location__Latitude__s','');
        component.set("v.serviceRecord.ETST_Pick_Up_Start_Date__c",'');
        //helper.setServiceDates(component, event, helper);
    },
    setfares: function(component, event, helper) { 
        component.set("v.serviceRecord.ETST_Fare_Charges__c",'');
        component.set("v.serviceRecord.ETST_Pick_Up_Start_Date__c",'');
        var areaslctd=component.get('v.serviceRecord.ETST_Area__c');
        let TrasType = component.get("v.serviceRecord.ETST_Transport_Type__c");
        if(TrasType =='Two Way'){
            component.set("v.serviceRecord.Drop_Off_Area__c",areaslctd);}
       
        if(areaslctd=='Others'){
            component.set('v.showOthersfield',true);
           
        }else{
            component.set('v.showOthersfield',false);
        }
        let serRec =  component.get("v.serviceRecord");
        if(serRec.Drop_Off_Area__c =='Others'){
            component.set('v.showOthersDropfield',true);
        }else{
           component.set('v.showOthersDropfield',false); 
        }
      
    },
    dropOffAreaHandler: function(component, event, helper) { 
        component.set("v.serviceRecord.ETST_Fare_Charges__c",'');
        component.set("v.serviceRecord.ETST_Pick_Up_Start_Date__c",'');
        var areaslctd=component.get('v.serviceRecord.Drop_Off_Area__c');
      
        if(areaslctd=='Others'){
            component.set('v.showOthersDropfield',true);
        }else{
            component.set('v.showOthersDropfield',false);
        }
    },
    getServiceTypesData: function(component, event, helper) {
        //debugger;
        component.set("v.serviceRecord.ETST_Fare_Charges__c",'');
        component.set('v.serviceRecord.ETST_Pick_Up_From__c','');
        component.set('v.serviceRecord.ETST_Drop_Off_To__c','');
        component.set('v.serviceRecord.ETST_Location__Longitude__s','');
        component.set("v.serviceRecord.ETST_Service_Type__c",'');
        component.set("v.serviceRecord.ETST_Area__c",'');
        component.set("v.serviceRecord.ETST_Pick_Up_Start_Date__c",'');
        var transportType=component.get("v.serviceRecord.ETST_Transport_Type__c");
       
        
        if(transportType=='Two Way'){
            component.set("v.showPickup",true);
            component.set("v.showDropoff",true);
        }else if(transportType=='Pick up only'){
            component.set("v.showPickup",true);
            component.set("v.showDropoff",false);
        }else if(transportType =='Drop off only'){
            component.set("v.showDropoff",true);
            component.set("v.showPickup",false);
        }
        if(transportType!=null && transportType!='' && transportType!=undefined){
            helper.getServiceTypesInfo(component, event, helper,transportType);
            
        } 
        
    },
    setRenewalFare: function(component, event, helper) {
        component.set("v.serviceRecord.ETST_Fare_Charges__c",'');
        helper.getFareDetails(component, event, helper);
        
    },
    getFareDetails: function(component, event, helper) {
        // Added gov school condition --- Sreelakshmi SK 4/6/23
        //component.set('v.serviceRecord.ETST_Location__Latitude__s',0);
        //component.set('v.serviceRecord.ETST_Location__Longitude__s',0);
        component.set("v.serviceRecord.ETST_Fare_Charges__c",'');
        var servicetype=component.get("v.serviceRecord.ETST_Service_Type__c");
        var transportType=component.get("v.serviceRecord.ETST_Transport_Type__c");
        var startDate=component.get("v.serviceRecord.ETST_Pick_Up_Start_Date__c");
        console.log('startDate:'+startDate);
        var now = new Date();
        var datetoday=new Date(now.getFullYear(), now.getMonth(), now.getDate());
		var areabased=component.get('v.AreaBased');
		var starea= component.get("v.serviceRecord.ETST_Area__c");
		
        //var endDay = new Date(now.getFullYear(), now.getMonth() + 3,1);
        //alert('endDay '+endDay);
        var stDate=new Date(startDate.substring(0, 4), 
                                startDate.substring(5, 7)-1, 
                                startDate.substring(8)); 
        var endDay = new Date(stDate.getFullYear(), stDate.getMonth() + 3,1);
        console.log('check date:'+datetoday);
        
        //Added by Sreelakshmi SK-- 21 Mar 2023 --START--
        var mm=stDate.getMonth()+1;
        console.log('mm:'+mm);
        
        /*if(mm==7 || mm==8){
            component.set("v.ValidationError",true);
        }
        else{
            component.set("v.ValidationError",false);
        }*/
        
        //Added by Sreelakshmi SK-- 21 Mar 2023 --END--
        
        //alert('stDate '+stDate);
        var startDateval = new Date("1 September , 2022");
        //var startDateval = new Date("1 Septmber , "+now.getFullYear());
        //console.log('dateofsep:'+startDateval);
		if(areabased && starea=="")
		{
            if(component.get('v.schoolType')!="Government School"){
                
			var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type": "error",
                "message": 'Please select the Area '
            });
            toastEvent.fire();
                component.set("v.serviceRecord.ETST_Pick_Up_Start_Date__c",'');}
		}
        else if(stDate>=endDay){
             
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type": "error",
                "message": 'Pick up start date cannot be on or before '+endDay.toISOString().slice(0,10)
            });
            toastEvent.fire();
             component.set("v.serviceRecord.ETST_Pick_Up_Start_Date__c",'');
            //component.find('ETST_Pick_Up_Start_Date__c').messageWhenBadInput();    
        } else if(stDate < startDateval){
            var toastEvent = $A.get("e.force:showToast");
            //var msg = 'Pick up start date cannot be on or before '+startDateval.toISOString().slice(0,10);
            var msg='Please select start date from 1st September onwards, but services will commence from school start date';
            if(component.get('v.clLang') == 'ar'){
                msg = $A.get("$Label.c.ETST_Picup_Error_Message_AR");
            }
            toastEvent.setParams({
                "title": "Error!",
                "type": "error",
                "message": msg
            });
            toastEvent.fire();
            component.set("v.serviceRecord.ETST_Pick_Up_Start_Date__c",'');
        }
        else if(stDate < datetoday){
            var toastEvent = $A.get("e.force:showToast");
            var msg = 'Pick up start date cannot be on or before '+now.toISOString().slice(0,10);
          /*  if(component.get('v.clLang') == 'ar'){
                msg = $A.get("$Label.c.ETST_Picup_Error_Message_AR");
            } */
            toastEvent.setParams({
                "title": "Error!",
                "type": "error",
                "message": msg
            });
            toastEvent.fire();
            component.set("v.serviceRecord.ETST_Pick_Up_Start_Date__c",'');
        }
        else if(servicetype!=null && servicetype!='' && servicetype!=undefined
           && transportType!=null && transportType!='' && transportType!=undefined 
           && startDate!=null && startDate!='' && startDate!=undefined 
          ){
             
            helper.setServiceDates(component, event, helper);
            helper.getFareDetails(component, event, helper); 
        }
    
    },
    selectOption:function(component, event, helper) {
        console.log('---selectOption---');
        helper.getAddressDetailsByPlaceId(component, event,helper);
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
        /*var latit;
        var longit;
        if (navigator.geolocation) {
            console.log("able to retrieve your location");
            navigator.geolocation.getCurrentPosition(function(position) {
                 latit = position.coords.latitude;
                 longit = position.coords.longitude;
                component.set('v.serviceRecord.ETST_Location__Latitude__c',latit);
                component.set('v.serviceRecord.ETST_Location__Longitude__c',longit);
                
            });
            helper.getLocationDetails(component, event, helper,component.get('v.serviceRecord.ETST_Location__Latitude__c'),component.get('v.serviceRecord.ETST_Location__Longitude__c'),true);
            
        }else{
            console.log("Unable to retrieve your location");
        }
        */
        helper.getLocationDetails(component, event, helper,component.get('v.lat'),component.get('v.lon'),true);
        
    },
    getCurrentDropLocation: function(component, event, helper) {       
        helper.getLocationDetails(component, event, helper,component.get('v.lat'),component.get('v.lon'),false);
    },
    getLocationDetails: function(component, event, helper){
        component.set('v.openpickupMap',false);
        var lat=component.get('v.serviceRecord.ETST_Location__Latitude__c');
        var long=component.get('v.serviceRecord.ETST_Location__Longitude__c');
        if(lat!=null && lat!='' && lat!=undefined){
        	helper.getLocationDetails(component, event, helper,lat,long,true);
        }
        component.set("v.searchText", '');
    },
    getDropLocationDetails: function(component, event, helper){
        component.set('v.openDropoffMap',false);
        var lat=component.get('v.serviceRecord.ETST_Location__Latitude__c');
        var long=component.get('v.serviceRecord.ETST_Location__Longitude__c');
        if(lat!=null && lat!='' && lat!=undefined){
        	helper.getLocationDetails(component, event, helper,lat,long,false);
        }
        component.set("v.searchText", '');
    },
    openDeactivateServiceModal : function(component, event, helper) {
        var item=event.getSource().get('v.value');
        component.set('v.serviceRecord.ETST_Student__c',item.Id);
        component.set('v.serviceRecord',item.ETST_Transport_Requests__r[0]);
        component.set('v.deactivateServiceModal',true);
    },  
    deactivateStudent : function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        if(component.get('v.serviceRecord.ETST_Cancellation_Effective_Date__c')<=today){
            var utility = component.find("ETST_UtilityMethods");
            utility.showToast("Service Details", 'Please Enter valid effective date', "error", "dismissible");
        }else{
            helper.deactivateStudent(component, event, helper);
        }
        
    },  
    openCreateSerivceModal : function(component, event, helper) {
        var item=event.getSource().get('v.value');
        
        component.set('v.serviceRecord.ETST_Student__c',item.Id);
        component.set('v.schoolId',item.ETST_School_Name__c);
        
        component.set('v.addServiceModal',true);
        component.set('v.renewServiceModal',false);
    },
    openRenewSerivceModal  : function(component, event, helper) {
        component.set('v.addServiceModal',false);
        component.set('v.renewServiceModal',true);
        var item=event.getSource().get('v.value');
        component.set('v.serviceRecord',item.ETST_Transport_Requests__r[0]);
        
        component.set('v.serviceRecord.ETST_Student__c',item.Id);
        component.set('v.schoolId',item.ETST_School_Name__c);
        helper.getStudentSchoolAreas(component, event, helper);
        helper.getFareDetails(component, event, helper);
        
    },
    onPickupChange: function(component) {
        if(component.get('v.serviceRecord.ETST_Pick_Up_From__c').length==0){
            component.set('v.serviceRecord.ETST_Location__Latitude__s',0);
        }
    },
    onDropChange: function(component) {
        if(component.get('v.serviceRecord.ETST_Drop_Off_To__c').length==0){
            component.set('v.serviceRecord.ETST_Dropoff_Location__Latitude__s',0);
        }
    },
    
    fullYearSelected: function(component, event, helper) {
        if(event.getSource().get('v.checked')){
            component.set('v.serviceRecord.Semester_1__c',false);
            component.set('v.serviceRecord.Semester_2__c',false);
            component.set('v.serviceRecord.Semester_3__c',false);
            component.set('v.serviceRecord.Ramadan__c',false);
        }
          
           
    },
    semesterChange : function(component, event, helper) {
        if(event.getSource().get('v.checked')){
            component.set('v.serviceRecord.Full_Academic_Year__c',false);
        }
        
    },
    
    openConfirmBox: function(component, event, helper) {
        var isChecked = component.get("v.isCheckbox");
        //added
        var termsandconditions = component.find("termsandconditions");
        var checkbox = termsandconditions.doCheck();
        console.log("checkbox***"+checkbox);//till here
        
        if (!checkbox) {
            component.set("v.showError", true);
            mandatoryFieldsList.push(component.find("termsandconditions"));//added on 04th jul
        } else {
            component.set("v.showError", false);
        }
        try{
        component.set("v.disableAddSerice",false);
        var tranportType=component.get('v.serviceRecord.ETST_Transport_Type__c');
        
       if(component.get('v.schoolType')=='Government School'){
           component.set("v.serviceRecord.ETST_Service_Type__c","Yearly");           
          var servicetype = component.get("v.serviceRecord.ETST_Service_Type__c");           
           
       }else{
             var servicetype=component.get("v.serviceRecord.ETST_Service_Type__c");
       }    
      
        var pick=component.get('v.serviceRecord.ETST_Pick_Up_From__c');
        var drop=component.get('v.serviceRecord.ETST_Drop_Off_To__c');
        var rem=component.get('v.serviceRecord.Remarks__c'); // Added by Sreelakshmi SK-- 29/3/2023
        var sem1=component.get('v.serviceRecord.Semester_1__c'); // Added by Sreelakshmi SK 1/6/23
        var sem2=component.get('v.serviceRecord.Semester_2__c'); // Added by Sreelakshmi SK 1/6/23
        var sem3=component.get('v.serviceRecord.Semester_3__c'); // Added by Sreelakshmi SK 1/6/23
        var fullyr=component.get('v.serviceRecord.Full_Academic_Year__c'); // Added by Sreelakshmi SK 1/6/23
        var empName;
        var otherArea=component.get('v.serviceRecord.Other_Area__c'); // Added by Sreelakshmi SK 1/6/23
        
        var pickStreet=component.get('v.serviceRecord.Street_Name_Pick_Up__c'); // Added by Sreelakshmi SK 4/6/23
        var pickVilla=component.get('v.serviceRecord.Villa_Details_Pick_Up__c'); // Added by Sreelakshmi SK 4/6/23
        var pickBuilding=component.get('v.serviceRecord.Building_Name_Pick_Up__c'); // Added by Sreelakshmi SK 4/6/23
        var dropStreet=component.get('v.serviceRecord.Street_Name_Drop_Off__c'); // Added by Sreelakshmi SK 4/6/23
        var dropVilla=component.get('v.serviceRecord.Villa_Details_Drop_Off__c'); // Added by Sreelakshmi SK 4/6/23
        var dropBuilding=component.get('v.serviceRecord.Building_Name_Drop_Off__c'); // Added by Sreelakshmi SK 4/6/23
        var ram=component.get('v.serviceRecord.Ramadan__c'); // Added by Sreelakshmi SK 4/6/23
      
        // Added by Sreelakshmi SK 4/6/23
        if(pickStreet!=null && pickStreet!=''){
            component.set('v.serviceRecord.Street_Name_Pick_Up__c',pickStreet.trim());
            if(pickStreet.trim()!='' &&  component.get('v.serviceRecord.Street_Name_Pick_Up__c')==0){
                component.set('v.serviceRecord.Street_Name_Pick_Up__c','');
            }
        }
        if(pickVilla!=null && pickVilla!=''){
            component.set('v.serviceRecord.Villa_Details_Pick_Up__c',pickVilla.trim());
            if(pickVilla.trim()!='' &&  component.get('v.serviceRecord.Villa_Details_Pick_Up__c')==0){
                component.set('v.serviceRecord.Villa_Details_Pick_Up__c','');
            }
        }
        if(pickBuilding!=null && pickBuilding!=''){
            component.set('v.serviceRecord.Building_Name_Pick_Up__c',pickBuilding.trim());
            if(pickBuilding.trim()!='' &&  component.get('v.serviceRecord.Building_Name_Pick_Up__c')==0){
                component.set('v.serviceRecord.Building_Name_Pick_Up__c','');
            }
        }
        if(dropStreet!=null && dropStreet!=''){
            component.set('v.serviceRecord.Street_Name_Drop_Off__c',dropStreet.trim());
            if(dropStreet.trim()!='' &&  component.get('v.serviceRecord.Street_Name_Drop_Off__c')==0){
                component.set('v.serviceRecord.Street_Name_Drop_Off__c','');
            }
        }
        if(dropVilla!=null && dropVilla!=''){
            component.set('v.serviceRecord.Villa_Details_Drop_Off__c',dropVilla.trim());
            if(dropVilla.trim()!='' &&  component.get('v.serviceRecord.Villa_Details_Drop_Off__c')==0){
                component.set('v.serviceRecord.Villa_Details_Drop_Off__c','');
            }
        }
        if(dropBuilding!=null && dropBuilding!=''){
            component.set('v.serviceRecord.Building_Name_Drop_Off__c',dropBuilding.trim());
            if(dropBuilding.trim()!='' &&  component.get('v.serviceRecord.Building_Name_Drop_Off__c')==0){
                component.set('v.serviceRecord.Building_Name_Drop_Off__c','');
            }
        }
        
        
        // Added by Sreelakshmi SK 1/6/23
        if(otherArea!=null && otherArea!=''){
            component.set('v.serviceRecord.Other_Area__c',otherArea.trim());
            if(otherArea.trim()!='' &&  component.get('v.serviceRecord.Other_Area__c')==0){
                component.set('v.serviceRecord.Other_Area__c','');
            }
        }
        
        
        if(sem1==true){
            component.set('v.serviceRecord.Semester_1__c',true);
        }
        if(sem2==true){
            component.set('v.serviceRecord.Semester_2__c',true);
        }
        if(sem3==true){
            component.set('v.serviceRecord.Semester_3__c',true);
        }
        if(fullyr==true){
            component.set('v.serviceRecord.Full_Academic_Year__c',true);
            component.set('v.serviceRecord.Semester_1__c',false);
            component.set('v.serviceRecord.Semester_2__c',false);
            component.set('v.serviceRecord.Semester_3__c',false);
            component.set('v.serviceRecord.Ramadan__c',false);
        }
        
        if(ram==true){
            component.set('v.serviceRecord.Ramadan__c',true);
        }
        
        if(rem!=null && rem!=''){
            component.set('v.serviceRecord.Remarks__c',rem.trim());
            if(rem.trim()!='' &&  component.get('v.serviceRecord.Remarks__c')==0){
                component.set('v.serviceRecord.Remarks__c','');
            }
        }
        
        if(pick!=null && pick!=''){
            component.set('v.serviceRecord.ETST_Pick_Up_From__c',pick.trim());
            if(pick.trim()!='' &&  component.get('v.serviceRecord.ETST_Location__Latitude__s')==0){
                component.set('v.serviceRecord.ETST_Pick_Up_From__c','');
            }
        }
        	
        if(drop!=null && drop!=''){
            component.set('v.serviceRecord.ETST_Drop_Off_To__c',drop.trim());
            if(drop.trim()!='' &&  component.get('v.serviceRecord.ETST_Dropoff_Location__Latitude__s')==0){
                component.set('v.serviceRecord.ETST_Drop_Off_To__c','');
            }
        }
            
        var mandatoryFieldsList=[];        
        mandatoryFieldsList = component.get("v.mandatoryFields");
        if(component.get('v.serviceRecord.ETST_Paid_By__c')=='Employer'){
            mandatoryFieldsList= component.get("v.mandatoryFieldsEmp");
            var line1=component.get('v.addressRecord.ET_Line_1__c');
            var line2=component.get('v.addressRecord.ET_Line_2__c');
            var city=component.get('v.addressRecord.ET_City__c');
            empName=component.get('v.employerName');
            if(line1!=null && line1!='')
                component.set('v.addressRecord.ET_Line_1__c',line1.trim());
            if(line2!=null && line2!='')
                component.set('v.addressRecord.ET_Line_2__c',line2.trim());        
            if(city!=null && city!='')
                component.set('v.addressRecord.ET_City__c',city.trim());
            if(empName!=null && empName!=''){
                 component.set('v.employerName',empName.trim());
            }            
            
            
        }
             
         if(tranportType=='Two Way'){
            mandatoryFieldsList.push('ETST_Pick_Up_From__c');
            mandatoryFieldsList.push('ETST_Drop_Off_To__c');
        }else if(tranportType=='Pick up only' || tranportType=='One Way'){ //santosh
            component.set('v.serviceRecord.ETST_Dropoff_Location__Latitude__s','0.0'); //santosh
            component.set('v.serviceRecord.ETST_Dropoff_Location__Longitude__s','0.0'); //santosh
            
            mandatoryFieldsList.push('ETST_Pick_Up_From__c');
            component.set('v.serviceRecord.ETST_Drop_Off_To__c',$A.get("$Label.c.ETST_Not_Applicable")); 
        }else if(tranportType=='Drop off only'){
            component.set('v.serviceRecord.ETST_Location__Latitude__s', 0.0);
            component.set('v.serviceRecord.ETST_Location__Longitude__s',0.0);
            mandatoryFieldsList.push('ETST_Drop_Off_To__c');
            component.set('v.serviceRecord.ETST_Pick_Up_From__c',$A.get("$Label.c.ETST_Not_Applicable"));
        }
      
        if(servicetype=='Select Dates'){
            mandatoryFieldsList.push('ETST_Pick_Up_Start_Date__c');
            mandatoryFieldsList.push('ETST_Pick_Up_End_Date__c');
            
        }
         
            if(component.get('v.schoolType')=="Government School"){        
                mandatoryFieldsList =[];   
                
                //Govt school Validations
                var govtValidation = helper.validateDateForGovtSchool(component, event, helper);
                
                if(govtValidation){
                  try{
                        var serviceRecord = component.get('v.studentRecord');
                        // console.log('%%%%' + JSON.stringify(serviceRecord))
                        var editSection = false;
                        if(!serviceRecord.Is_Child_Data_Updated__c && !serviceRecord.is_New_Student__c && component.get('v.schoolType')!="Government School"){
                            component.set('v.isModalOpenForConfirm', true);
                        }else{
                            helper.createNewService(component, event, helper, editSection); 
                        }
                    }catch(er){
                        alert(er.message)
                    }
                } 
            }
            
        var mandatoryFieldsCmps = [];
     
        for(var id in mandatoryFieldsList){
            mandatoryFieldsCmps.push(component.find(mandatoryFieldsList[id]));
        }
    
        if(mandatoryFieldsList.length!=undefined && mandatoryFieldsList.length > 0){
           
            var allValid =mandatoryFieldsCmps.reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true); 
           
            if (allValid) {
               
                var allValidAgain = mandatoryFieldsCmps.reduce(
                    function(validSoFar, inputCmp) 
                    {                       
                        inputCmp.showHelpMessageIfInvalid();                        
                        return validSoFar && inputCmp.get('v.validity').valid;
                    }, true); 
                
                
                if(allValidAgain){
                  
                   try{
                     var serviceRecord = component.get('v.studentRecord');
                       // console.log('%%%%' + JSON.stringify(serviceRecord))
                    var editSection = false;
                    if(!serviceRecord.Is_Child_Data_Updated__c && !serviceRecord.is_New_Student__c){
                       component.set('v.isModalOpenForConfirm', true);
                    }else{
                        helper.createNewService(component, event, helper, editSection); 
                    }
                    }catch(er){
                        alert(er.message)
                    }
                   
                }
               
            }
        }
        }catch(e){
            console.log(e.message)
        }
    },
    handleClickOnCancel: function(component, event, helper) {
         component.set('v.isModalOpenForConfirm', false);
         helper.createNewService(component, event, helper, false);
    },
    
    createNewService : function(component, event, helper) {
         component.set('v.isModalOpenForConfirm', false);
       helper.createNewService(component, event, helper, true); 
           
    },
    renewService : function(component, event, helper) {
        var serviceRecord = component.get('v.studentRecord');
        var editSection = false;
        if(!serviceRecord.ETST_Student__r.Is_Child_Data_Updated__c){
             editSection = confirm("Do you want to change your child data?");
        }
         
        helper.createNewService(component, event, helper,editSection);  
    },
    closeModel: function(component, event, helper) {
        
        helper.setDefaultValues(component, event, helper);
        component.set('v.addServiceModal',false);
        component.set('v.renewServiceModal',false);
        component.set('v.deactivateServiceModal',false);
    },
    
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var searchCompleteEvent = cmp.getEvent("sendDataEvent"); 
        searchCompleteEvent.setParams({
            selectedRecords: selectedRows.length
        }).fire();
        cmp.set('v.selectedRowsCount', selectedRows.length);
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
    getEmployerAddress: function(component, event, helper) {
        helper.getEmployerAddress(component, event, helper); 
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
         
    },
    
    onchangeCheckbox : function(component, event, helper) { 
       // alert('clicked');
        console.log('fired');
        var termsandconditions = component.find("termsandconditions");
        var checkbox = termsandconditions.doCheck();
        console.log("checkbox***"+checkbox);
        if(!checkbox){
            $A.util.removeClass(component.find("TC"), "slds-hide"); 
           	mandatoryFieldsCmps.push(component.find("termsandconditions"));
        }else{
            
            $A.util.addClass(component.find("TC"), "slds-hide");
        }
    }

})
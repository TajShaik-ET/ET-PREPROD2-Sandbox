({
    doInit : function(component, event, helper) {
        //debugger;
        var values =$A.get("$Label.c.ETS_Locations");
        var nameArr = values.split(',');   
        component.set("v.LocationList", nameArr);
         helper.doInit(component, event, helper);
         helper.getServiceLocDetails(component, event, helper);
     },

    toggle:function(component, event, helper){
        try{
        var selectedLocation=component.find("Locationid1").get("v.value");
        }catch(e){
             console.log('selectedLocation '+e.message+ '  '+component.get('v.loc1'));
        }
       
        component.set('v.loc', selectedLocation);
        var school=component.get('v.serviceMap.School_Transport');
        if(school.includes(selectedLocation)){
            component.set('v.showSchool',true);
        }else{
           component.set('v.showSchool',false);
        }
        var inspection=component.get('v.serviceMap.Vehicle_Inspection');
        if(inspection.includes(selectedLocation)){
            component.set('v.showInspection',true);
        }else{
           component.set('v.showInspection',false);
        }
        var spea=component.get('v.serviceMap.SPEA_Inspection');
        if(spea){
            if(spea.includes(selectedLocation)){
                component.set('v.showSPEA',true);
            }else{
                component.set('v.showSPEA',false);
            }
        }
        var limo=component.get('v.serviceMap.Limo_Services');
        if(limo){
            if(limo.includes(selectedLocation)){
                component.set('v.showLimo',true);
            }else{
                component.set('v.showLimo',false);
            } 
        }
        var rental=component.get('v.serviceMap.Rental_Services');
        if(limo){
            if(limo.includes(selectedLocation)){
                component.set('v.showRental',true);
            }else{
                component.set('v.showRental',false);
            } 
        }
        
        helper.changeLocation(component, event, helper,selectedLocation);
        helper.updateAccChangedLocation(component, event, helper,selectedLocation);
          
    },
    
    redirectToTransport : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/etst-home-page"
        });
        urlEvent.fire();
    },
    redirectToVehicle : function(component, event, helper) {
        //var selectedLocation=component.find("Locationid").get("v.value");
        var selectedLocation=component.get('v.loc');
        if(selectedLocation == 'All'){
            
            var msg='"Vehicle Inspection" is only available for "Abu Dhabi","Fujairah & "Sharjah". Please select the Location accordingly.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("Info!",msg,"","Sticky","info");
            return false;
        }
        var loc=component.get('v.currentLocation');
        
        var urlEvent = $A.get("e.force:navigateToURL");
        // "url": "/eti-homepage?Loc=" + selectedLocation.replace(/\s/g,'')
        
        urlEvent.setParams({
            "url": "/eti-homepage"
        });
        urlEvent.fire();
    },
    
    redirectToLimoService : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/home-et-car-services"
        });
        urlEvent.fire();
    },
    redirectToRentalService : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        
        urlEvent.setParams({
            "url": "/home-rental-service?p=rentCar"
        });
        urlEvent.fire();
    },
    redirectToB2BService : function(component, event, helper) {
        window.open('https://etpdev-et.cs110.force.com/B2B','_blank');
    },
     redirectToAlWataneya :function(component, event, helper) {
        window.open('https://www.alwataneya.ae/','_blank');
    },
    redirectToET:function(component, event, helper) {
        window.open('https://et.ae/','_blank');
    },
    redirectToEmoto:function(component, event, helper) {
        window.open('https://emiratesmoto.ae/','_blank');
    },
    redirectToETDI:function(component, event, helper) {
        window.open('https://etdi.gov.ae/','_blank');
    },
    redirectToMusada :function(component, event, helper) {
        window.open('https://play.google.com/store/apps/developer?id=Emirates+Transport','_blank');
    },
    redirectToContactUs:function(component, event, helper) {
        window.open('https://et.ae/en/contact-us/','_blank');
    },
    SubmitDetails: function(component, event, helper) {
        
        if(component.get('v.loc')!=null){
            helper.updateProfile(component, event, helper);
        }        
        else{
            alert('Please enter valid details');
        }
            
   },
    
})
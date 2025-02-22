({
	myServiceCart : function(component, event, helper) {
		helper.setCommunityLanguage(component, event, helper);
        var myCartWrapper = component.get("v.myCartVehicleWrapper");
        component.set("v.allVehicleData", myCartWrapper);
        console.log('myCartWrapper '+JSON.stringify(myCartWrapper));
        component.set("v.totalRecords",myCartWrapper.length);
        console.log('totalRecords>> '+component.get("v.totalRecords"));
        component.set("v.totalPages", Math.ceil(myCartWrapper.length/component.get("v.pageSize")));
        component.set("v.currentPageNumber",1);
        console.log('totalPages length>> '+component.get("v.totalPages"));
        component.set("v.IsSpinner", false);
        var selectedVehicles=[];
        for (var idx = 0; idx < myCartWrapper.length; idx++) {
        	selectedVehicles.push(myCartWrapper[idx].customerVehicle);
        }
        console.log('SelectedVehicles '+JSON.stringify(selectedVehicles));
        component.set("v.SelectedVehicles",selectedVehicles);
        helper.buildData(component, helper);
        component.set("v.showCartDetails", true);
	},
    closeModel: function (component, event, helper) {
        component.set("v.showCartDetails", false);
    },
    showDetailsEvent : function(cmp, event) { 
        //Get the event message attribute
        var isShowButtons = event.getParam("isShowButtons"); 
        console.log('isShowButtons>> '+isShowButtons);
        //Set the handler attributes based on event data 
        cmp.set("v.showDetails", isShowButtons);         
    },
    removeVehicle: function (component, event, helper) {
        var row = event.currentTarget.getAttribute("data-value");
        console.log('row '+JSON.stringify(row));
        var vehicleWrapper=component.get("v.vehicleWrapper");
        var myCartVehicleWrp=component.get("v.myCartVehicleWrapper");
        console.log('myCartVehicleWrp '+JSON.stringify(myCartVehicleWrp));
        /*for (var idx = 0; idx < vehicleWrapper.length; idx++) {
            console.log('length '+vehicleWrapper[idx].customerVehicle.Id);
            if(vehicleWrapper[idx].customerVehicle.Id==row){
                vehicleWrapper[idx].isChecked=false;
            }
        }*/
        var selectedVehicles=[];
        /*for (var idx = 0; idx < myCartVehicleWrp.length; idx++) {
            if(myCartVehicleWrp[idx].customerVehicle.Id==row && myCartVehicleWrp[idx].isChecked){
                myCartVehicleWrp[idx].isChecked=false;
                myCartVehicleWrp.splice(idx, 1);
                console.log('isChecked '+myCartVehicleWrp[idx].isChecked);
            }else if(myCartVehicleWrp[idx].isChecked)
                selectedVehicles.push(myCartVehicleWrp[idx].customerVehicle);
        }*/
        console.log('SelectedVehicles '+JSON.stringify(selectedVehicles));
        component.set("v.SelectedVehicles",selectedVehicles);
        component.set("v.cartCount",myCartVehicleWrp.length);
        component.set("v.vehicleWrapper",vehicleWrapper);
        component.set("v.myCartVehicleWrapper", myCartVehicleWrp);
        component.set("v.allVehicleData", myCartVehicleWrp);
        helper.buildData(component, helper);
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
    requestForService: function (component, event, helper) {
        var action = component.get("c.getBookingData");
        var con = component.get("v.SelectedVehicles");
        if (con == null || con == undefined || con == 0) {
            var msg=component.get("v.Select_atleast_one_Vehicle");
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Info"),msg,"","Sticky","info");
            return null;
        }
       console.log('Selected Object Is :: '  + JSON.stringify(con));
        action.setParams({
            "lstVehicle": con
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var emirate = component.get('v.emirate');
                component.set('v.emirate', emirate.replace(/\s/g,''))
                var appEvent = $A.get("e.c:ETI_B2B_ShowButtons"); 
                //Set event attribute value
                appEvent.setParams({"isShowButtons" : false}); 
                appEvent.setParams({"booking" : response.getReturnValue()});
                appEvent.setParams({"selectedEmirate" : emirate.replace(/\s/g,'')});
                appEvent.fire(); 
                component.set("v.showCartDetails", false);
                component.set("v.showDetails", false);
            }
        });
        $A.enqueueAction(action);
    },
})
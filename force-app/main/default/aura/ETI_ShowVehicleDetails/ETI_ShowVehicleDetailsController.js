({
    getVehicleDetails : function(component, event, helper) {
        component.set("v.IsSpinner", true);
        helper.setCommunityLanguage(component, event, helper);
        //var Emirate = helper.getJsonFromUrl().Loc;
		//console.log('Emirate>> '+Emirate);
		//component.set('v.emirate',Emirate);
        var actions = [
            { label: 'Show details', name: 'show_details' },
            { label: 'Delete', name: 'delete' }
        ];
        
        component.set('v.VehicleColumns', [
            {label: 'Vehicle Number', fieldName: 'linkName', type: 'url',typeAttributes: { label:  { fieldName: 'Name' }, target:'_blank'}},
            {label: 'Chassis No', fieldName: 'Chassis_No__c', type: 'text'},
            {label: 'Plate No', fieldName: 'Plate_No__c', type: 'text'},
            {label: 'Plate Colour', fieldName: 'Plate_Color__c', type: 'text'},
            {label: 'Plate Type', fieldName: 'Plate_Type__c', type: 'text'},
            {label: 'Plate Source', fieldName: 'Plate_Source__c', type: 'text'},
            { type: 'action', typeAttributes: { rowActions: actions }}
            
        ]);
       
        helper.fetchVehicleHelper(component, event, helper) ;
    },
    
    listViewHandleAction :function(component,event,helper){
        component.set("v.gridviewChk",false);
        component.set("v.lstViewChk",true);
        
    },
    
    gridViewHandleAction :function(component,event,helper){
        component.set("v.gridviewChk",true);
        component.set("v.lstViewChk",false);
    },
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'show_details':
                //alert('Showing Details: ' + JSON.stringify(row));
                break;
            case 'delete':
                // alert('Delete action');
                helper.deleteVehicle(component, event, helper,row);
                break;
        }
    },
    getSelectedName: function (component, event) {
        try{
            var getvehiclelits=component.get("v.VehicleList");
            var target= event.target;
            var vehicledata=target.getAttribute("data-value");
            var currentindex=target.getAttribute("data-index");
            var checked=event.target.checked;
            var tablelist1=component.get("v.tablelist");
            var finallist=[];
             finallist.push(vehicledata);
            /*if(checked==true){
                console.log('checked IN'+checked);
            	finallist= tablelist1.concat(getvehiclelits[currentindex]);
            }else {
                console.log('checked else'+checked);
                finallist= tablelist1.splice(currentindex, 1);
            } */
            var selectedVehicles=[];
            var getvehiclelits1=component.get("v.vehicleWrapper");
            for (var idx = 0; idx < getvehiclelits1.length; idx++) {
                console.log('isChecked '+getvehiclelits1[idx].isChecked);
                console.log('vechileObj '+JSON.stringify(getvehiclelits1[idx].customerVehicle));
                if(getvehiclelits1[idx].isChecked==true)
                    selectedVehicles.push(getvehiclelits1[idx].customerVehicle);
            }
            console.log('selectedVehicles '+JSON.stringify(selectedVehicles));
            component.set("v.tablelist",selectedVehicles);
            var setRows=component.get("v.tablelist");
            var searchCompleteEvent = component.getEvent("DataEvent"); 
            searchCompleteEvent.setParams({
                selectedRecords : setRows 
            }); 
            searchCompleteEvent.fire();
        }
        catch(error)
        {
            console.log(error.message);
        }
        /*  var selectedRows = event.getParam('selectedRows'); 
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i]); 
        }
        // component.set("v.selectedRowsList", setRows);
        //alert('rows'+setRows);
        // var con = component.get("v.selectedRowsList");
        var searchCompleteEvent = component.getEvent("DataEvent"); 
        searchCompleteEvent.setParams({
            //selectedRecords : selectedRows.length 
            selectedRecords : setRows 
        }); 
        searchCompleteEvent.fire(); */
    },
    /*dueforRetest: function (component, event, helper) {
        var vehicleObj = [];
        vehicleObj.push(event.getSource().get("v.value"));
        console.log('vehicleObj '+JSON.stringify(vehicleObj));
        var action = component.get("c.getBookingData");
		action.setParams({
            "lstVehicle": vehicleObj
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.booking", response.getReturnValue());
                console.log('booking '+JSON.stringify(component.get("v.booking")));
                component.set("v.reSchduleBooking", true);
            }
        });
        $A.enqueueAction(action);
    },*/
    dueforRetest: function (component, event, helper) {
        var recordId = event.currentTarget.getAttribute("data-value");
        console.log('recordId '+JSON.stringify(recordId));
        var action = component.get("c.getRetestBookingData");
		action.setParams({
            "vehicleId": recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.bookingWrp", response.getReturnValue());
                console.log('booking '+JSON.stringify(component.get("v.bookingWrp")));
                component.set("v.reSchduleBooking", true);
            }
        });
        $A.enqueueAction(action);
    },
    deleteSelectedVehicle: function (component, event, helper) {
		var row = [];
        row.push(event.currentTarget.getAttribute("data-value"));
        console.log('row '+JSON.stringify(row));
        var msg ='Are you sure you want to delete this Vehicle?';
        if (!confirm(msg)) {
            return false;
        } else {
            var action = component.get("c.checkVehicleBookings");
            action.setParams({
                "rowid" : row
            });
        	action.setCallback(this, function (response) {
            	var state = response.getState();
            	console.log('state>> '+state);
                if (state === "SUCCESS") {
                    var msg='The Vehicle has been deleted successfully.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Success!",msg,"","dismissible","info");
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": '/eti-homepage?Loc='+component.get("v.emirate")+'&lang='+component.get("v.clLang")                          
                    });
                    urlEvent.fire();
                }else {
                    var msg='Unable to complete your Request, Please Try after some time.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Info!",msg,"","Sticky","info");
                }
            });
            $A.enqueueAction(action);
        }
    },
    requestforservicepage:function(component, event, helper) {
        try{
            var index = event.currentTarget.getAttribute("data-value");
            var vehicleWrapper = component.get('v.vehicleWrapper');
            var lstVehicle = vehicleWrapper[index].customerVehicle;
            var customerVehicleList = component.get('v.customerVehicleList');
            customerVehicleList.push(lstVehicle);
            var action = component.get("c.getBookingData");
            /*var data= component.get('v.VehicleInfoData');
            var VehicleInfoDataList = component.get("v.VehicleInfoDataList");
            VehicleInfoDataList.push(data);
            component.set("v.VehicleInfoDataList",VehicleInfoDataList);
            console.log(JSON.stringify(component.get("v.VehicleInfoDataList")));*/
            action.setParams({
                //"lstVehicle": data
                "lstVehicle":customerVehicleList
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state '+state);
                if (component.isValid() && state === "SUCCESS") {
                    var res = response.getReturnValue();
                    res.shift(); 
                    console.log(res);
                    component.set("{!v.booking}", response.getReturnValue());
                    console.log('booking data'+JSON.stringify(response.getReturnValue()));
                    component.set("v.isOpenRequestForService",true);
                }else if(state == "ERROR"){
                    var errors = response.getError(); 
                    console.log(errors[0].message);
                }
            });
            $A.enqueueAction(action);
        }
        catch(error)
        {
            console.log(error.message);
        }
    },
    
})
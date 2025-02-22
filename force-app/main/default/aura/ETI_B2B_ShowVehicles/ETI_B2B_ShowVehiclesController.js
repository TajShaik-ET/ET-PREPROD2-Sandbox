({
    scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded..'); 
    },
    getVehicleDetails : function(component, event, helper) {
        component.set("v.IsSpinner", true);
        console.log('emirate>> '+component.get("v.emirate"));
        console.log('isSpea>> '+component.get("v.isSpea"));
        helper.setCommunityLanguage(component, event, helper);
       /* var isSpea = helper.getJsonFromUrl().isSpea;
		console.log('isSpea>> '+isSpea);
		component.set('v.isSpea',isSpea);*/
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
        helper.accountDetails(component, event, helper) ;
    },
    
    listViewHandleAction :function(component,event,helper){
        component.set("v.gridviewChk",false);
        component.set("v.lstViewChk",true);
        if(!($.fn.dataTable.isDataTable( '#tableId' ))){
            helper.loadScriptForDataTable();
            /*setTimeout(function(){ 
                $('#tableId').DataTable({
                    "lengthChange": false,
                    "info": false,
                    "columns": [
                        { "searchable": false },
                        { "searchable": false },
                        { "searchable": false },
                        null,
                        { "searchable": false },
                        { "searchable": false },
                        null,
                        { "searchable": false },
                        { "searchable": false }
                    ]
                });
                // add lightning class to search filter field with some bottom margin..  
                $('div.dataTables_filter input').addClass('slds-input');
                $('div.dataTables_filter input').css("marginBottom", "10px");
            }, 500);*/
        }
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
            var target= event.target;
            var vehicledata=target.getAttribute("data-value");
            var currentindex=target.getAttribute("data-index");
            var checked=event.target.checked; 
            var tablelist1=component.get("v.tablelist");
            var finallist=[];
            var myCartWrapper=[];
            finallist.push(vehicledata); 
            var selectedVehicles=[];
            var getvehiclelits1=component.get("v.vehicleWrapper");
            for (var idx = 0; idx < getvehiclelits1.length; idx++) {
                if(getvehiclelits1[idx].isChecked==true){
                    selectedVehicles.push(getvehiclelits1[idx].customerVehicle);
                    myCartWrapper.push(getvehiclelits1[idx]);
                }
            }
            console.log('selectedVehicles '+JSON.stringify(selectedVehicles));
            component.set("v.cartCount",myCartWrapper.length);
        	component.set("v.myCartVehicleWrapper",myCartWrapper);
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
    addtoCart: function (component, event, helper) {
        var row = event.currentTarget.getAttribute("data-value");
        console.log('row '+JSON.stringify(row));
        var getvehiclelits1=component.get("v.vehicleWrapper");
        console.log('getvehiclelits1 '+JSON.stringify(getvehiclelits1));
        for (var idx = 0; idx < getvehiclelits1.length; idx++) {
            console.log('length '+getvehiclelits1[idx].customerVehicle.Id);
            if(getvehiclelits1[idx].customerVehicle.Id==row && !getvehiclelits1[idx].isChecked){
                getvehiclelits1[idx].isChecked=true;
            }else if(getvehiclelits1[idx].customerVehicle.Id==row && getvehiclelits1[idx].isChecked){
                getvehiclelits1[idx].isChecked=false;
            }
        }
        var selectedVehicles=[];
        var myCartWrapper=[];
        for (var idx = 0; idx < getvehiclelits1.length; idx++) {
            if(getvehiclelits1[idx].isChecked==true){
                myCartWrapper.push(getvehiclelits1[idx]);
            	selectedVehicles.push(getvehiclelits1[idx].customerVehicle);
            }
        }
        component.set("v.cartCount",myCartWrapper.length);
        component.set("v.vehicleWrapper",getvehiclelits1);
        component.set("v.myCartVehicleWrapper",myCartWrapper);
        component.set("v.tablelist",selectedVehicles);
        var setRows=component.get("v.tablelist");
        var searchCompleteEvent = component.getEvent("DataEvent"); 
        searchCompleteEvent.setParams({
            selectedRecords : setRows 
        }); 
        searchCompleteEvent.fire();
    },
    dueforRetest: function (component, event, helper) {
        var recordId = event.currentTarget.getAttribute("data-value");
            //event.getSource().get("v.value");
        console.log('recordId '+JSON.stringify(recordId));
        var action = component.get("c.getRetestBookingData");
		action.setParams({
            "vehicleId": recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.bookingWrp", response.getReturnValue());
                component.set('v.emirate', component.get('v.emirate').replace(/\s/g,''));
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
                        "url": '/Business/s/home-inspection?Loc='+component.get("v.emirate")                            
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
    /*requestforservicepage:function(component, event, helper) {
        try{
            var index = event.getSource().get("v.value");
            var vehicleWrapper = component.get('v.vehicleWrapper');
            var lstVehicle = vehicleWrapper[index].customerVehicle;
            var customerVehicleList = component.get('v.customerVehicleList');
            customerVehicleList.push(lstVehicle);
            var action = component.get("c.getBookingData");
            action.setParams({
                //"lstVehicle": data
                "lstVehicle":customerVehicleList
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state '+state);
                if (component.isValid() && state === "SUCCESS") {
                    var selectedEmirate = component.get('v.emirate').replace(/\s/g,'');
                    component.set('v.emirate', selectedEmirate);
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
    },*/
   //Select all vehicle
    handleSelectAllVehicle: function(component, event, helper) {
        var getID = component.get("v.VehicleList");
        var checkvalue = component.find("selectAll").get("v.value");        
        var checkVehicle = component.find("checkVehicle"); 
        if(checkvalue == true){
            for(var i=0; i<checkVehicle.length; i++){
                checkVehicle[i].set("v.value",true);
            }
        }
        else{ 
            for(var i=0; i<checkVehicle.length; i++){
                checkVehicle[i].set("v.value",false);
            }
        }
    },
    //Process the selected vehicle
    handleSelectedVehicle: function(component, event, helper) {
        var selectedVehicle = [];
        var checkvalue = component.find("checkVehicle");
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedVehicle.push(checkvalue.get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedVehicle.push(checkvalue[i].get("v.text"));
                }
            }
        }
        console.log('selectedVehicle***' + selectedVehicle);
    },
    selectAll: function(component, event, helper){
        try {
            var isSelectedAll = component.get('v.isSelectAll');
            var allVehicleData = component.get('v.allVehicleData');
            var vehicleWrapper = component.get('v.vehicleWrapper');
            var finallist=[];
            var selectedVehicles=[];
            var myCartWrapper=[];
            var disableFlag=false;
            for(let index = 0 ; index < allVehicleData.length; index++){
                if(isSelectedAll){
                    if(component.get('v.emirate') == 'Sharjah'){
                       if(!allVehicleData[index].isDisableSPEATest){
                           allVehicleData[index].isChecked = true;
                           finallist.push(allVehicleData[index].customerVehicle);
                           selectedVehicles.push(allVehicleData[index].customerVehicle);
                           myCartWrapper.push(allVehicleData[index]);
                           disableFlag=true;
                   	   }
                   }else{
                       allVehicleData[index].isChecked = true;
                       finallist.push(allVehicleData[index].customerVehicle);
                       selectedVehicles.push(allVehicleData[index].customerVehicle);
                       myCartWrapper.push(allVehicleData[index]);
                   }
                }else{
                    allVehicleData[index].isChecked = false;
                }
            }
            for(let index = 0 ; index < vehicleWrapper.length; index++)
                vehicleWrapper[index].isChecked = true;
            if(selectedVehicles.length==0 && disableFlag){
                component.set("v.isSelectAll",false);
                var msg='You cannot Request for Service before due date.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Error!",msg,"","dismissible","error");
                return false;
            }
            console.log('selectedVehicles length '+selectedVehicles.length);
            console.log('selectedVehicles '+JSON.stringify(selectedVehicles));
            console.log('myCartWrapper '+JSON.stringify(myCartWrapper));
            component.set("v.cartCount",myCartWrapper.length);
        	component.set("v.myCartVehicleWrapper",myCartWrapper);
            component.set("v.tablelist",selectedVehicles);
            var setRows=component.get("v.tablelist");
            var searchCompleteEvent = component.getEvent("DataEvent"); 
            searchCompleteEvent.setParams({
                selectedRecords : setRows 
            }); 
            searchCompleteEvent.fire();
            component.set('v.allVehicleData', allVehicleData);
            component.set('v.vehicleWrapper', vehicleWrapper);
        } catch (error) {
            alert(error.message)
        }
    },
    showDetailsEvent : function(cmp, event) { 
        //Get the event message attribute
        var isShowDetails = event.getParam("isShowDetails"); 
        console.log('isShowDetails>> '+isShowDetails);
        //Set the handler attributes based on event data 
        cmp.set("v.showDetails", isShowDetails);         
    },
    searchKeyUp: function (component, event,helper) {
        var queryTerm = "%" + component.find('searchField').get('v.value') + "%";
        console.log('queryTerm>> '+queryTerm);
        helper.fetchVehicleHelper(component, event, helper, queryTerm);
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
    showBookingHistory: function (component, event, helper) {
        var recordId = event.currentTarget.getAttribute("data-value");
            //event.getSource().get("v.value");
        console.log('recordId '+JSON.stringify(recordId));
        var vehicleWrapper = component.get('V.vehicleWrapper');
        for(let idx = 0 ; idx < vehicleWrapper.length; idx++){
            if(vehicleWrapper[idx].customerVehicle.Id==recordId)
                component.set("v.booking", vehicleWrapper[idx].customerVehicle.Bookings__r);
        }
        component.set("v.isShowBookingHistory", true);
    },
    closeModel: function (component, event, helper) {
        component.set("v.isShowBookingHistory", false);
    },
})
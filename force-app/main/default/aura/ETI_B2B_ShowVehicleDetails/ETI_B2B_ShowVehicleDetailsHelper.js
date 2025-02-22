({
    accountDetails : function(component, event, helper) {
        var action = component.get("c.getChangelocationFromContact");
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state>>---- '+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result onload>> '+JSON.stringify(result));
                component.set("v.emirate",result);
                if(result=='Sharjah')
                    component.set('v.isSpea',true);
                this.fetchVehicleHelper(component);
                //component.set("v.emirate",result.ET_Changed_Location__c);
            }
        });
        $A.enqueueAction(action);
     },
    fetchVehicleHelper : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var allVehicleData = component.get('v.allVehicleData');
        component.set("v.IsSpinner", true);
        var pageSize = component.get("v.pageSize");
        var action = component.get("c.getVehicles");
        action.setParams({
            "userId": userId,
            "emirate":component.get('v.emirate')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var records =response.getReturnValue();
            console.log('records '+JSON.stringify(records));
            var vehlist=[];    
            records.forEach(function(record){
                vehlist.push(record.customerVehicle);
            });
            console.log('vehlist '+JSON.stringify(vehlist));
            if(records.length>0){
                console.log('Plate_Source '+JSON.stringify(vehlist[0].Plate_Source_AR__c));
                if(!component.get("v.showSearch"))
                    component.set("v.showSearch",true)
                component.set("v.VehicleList", vehlist);
                component.set("v.allVehicleData", records);
                component.set("v.allVehicleDataWithSearch", records);
                component.set("v.totalRecords",records.length);
                console.log('totalRecords>> '+component.get("v.totalRecords"));
                component.set("v.totalPages", Math.ceil(records.length/component.get("v.pageSize")));
                component.set("v.currentPageNumber",1);
                console.log('totalPages length>> '+component.get("v.totalPages"));
                this.buildData(component, helper,records);
            }else {
                component.set("v.allVehicleDataWithSearch", records);
                component.set("v.vehicleWrapper", records);
                component.set("v.totalRecords",records.length);
                component.set("v.totalPages", 0);
                component.set("v.currentPageNumber",1);
            }
            component.set("v.IsSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    deleteVehicle : function(component, event, helper,row) {
        var rows = component.get('v.VehicleList');
        var rowIndex = rows.indexOf(row);
       // alert('rowindex'+JSON.stringify(row));
        //alert('rowid'+row.Id);
        rows.splice(rowIndex, 1);
        component.set('v.VehicleList', rows);
        var action = component.get("c.deleteVehicles");
        //alert('check'+row.Id);
        action.setParams({
            "rowid" : row.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            $A.get('e.force:refreshView').fire();      
        });
        
        $A.enqueueAction(action);
    },
    getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
     },
    /*
     * this function will build table data
     * based on current page selection
     * */
    buildData : function(component, helper,vehicleWrp) {
        var wrpData = [];
        var vehlist=[];   
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var totalRecords = component.get("v.totalRecords");
        console.log('vehicleWrp length>> '+vehicleWrp.length);
        console.log('pageNumber>> '+pageNumber);
        console.log('pageSize>> '+pageSize);
        var x = (pageNumber-1)*pageSize;
        var end=(pageNumber)*pageSize;
		console.log('x>> '+x);
        console.log('end>> '+end);
        component.set("v.recordStart", x+1);
        //creating data-table data
        console.log('end>> ',end);
        for(; x<end; x++){
            if(vehicleWrp[x]){
                console.log('rowIndex>> '+vehicleWrp[x].rowIndex);
            	wrpData.push(vehicleWrp[x]);
                vehlist.push(vehicleWrp[x].customerVehicle);
            }
        }
        //console.log('vehlist '+JSON.stringify(vehlist));
        //console.log('wrpData>> '+JSON.stringify(wrpData));
        component.set("v.vehicleWrapper", wrpData);
        component.set("v.VehicleList", vehlist);
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
    checkAllBookings: function (component, row, vehicleWrapper, isSelectAll) {
        component.set("v.bookings", []);
        var action = component.get("c.checkBookings");
		action.setParams({
            vehIds: row
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var records =response.getReturnValue();
                console.log('records 168 = '+JSON.stringify(records));
                if(records.length>0){
                    if(!isSelectAll){
                        component.set("v.bookings", records);
                        component.set("v.selectedVehicleId",row);
                    } else {
                        if(vehicleWrapper.length>0)
                    		vehicleWrapper[0].isSelectAll=false;
                        component.set("v.vehicleWrapper",vehicleWrapper);
                    }
                    component.set("v.isShowAlert",true);
                }else {
                    if(isSelectAll)
                        this.selectAllHelper(component, vehicleWrapper);
                    else 
                        this.addtoCartHelper(component, row);
                }
            }
        });
        $A.enqueueAction(action);
    },
    addtoCartHelper: function (component, row) {
        var allVehicleData=component.get("v.allVehicleData");
        var vehicleWrapper=component.get("v.vehicleWrapper");
        console.log('allVehicleData '+JSON.stringify(allVehicleData));
        for (var idx = 0; idx < allVehicleData.length; idx++) {
            if(allVehicleData[idx].customerVehicle.Id==row && !allVehicleData[idx].isChecked){
                allVehicleData[idx].isChecked=true;
            }else if(allVehicleData[idx].customerVehicle.Id==row && allVehicleData[idx].isChecked){
                allVehicleData[idx].isChecked=false;
            }
        }
        console.log('allVehicleData '+JSON.stringify(allVehicleData));
        var selectedVehicles=[];
        var myCartWrapper=[];
        for (var idx = 0; idx < allVehicleData.length; idx++) {
            console.log('isChecked '+allVehicleData[idx].isChecked);
            if(allVehicleData[idx].isChecked==true){
                myCartWrapper.push(allVehicleData[idx]);
                selectedVehicles.push(allVehicleData[idx].customerVehicle);
            }
            for (var jdx = 0; jdx < vehicleWrapper.length; jdx++) {
                if(allVehicleData[idx].isChecked==true && allVehicleData[idx].customerVehicle.Id==vehicleWrapper[jdx].customerVehicle.Id) 
            		vehicleWrapper[jdx].isChecked=true;
            }
        }
        console.log('myCartWrapper '+JSON.stringify(myCartWrapper));
        console.log('vehicleWrapper '+JSON.stringify(vehicleWrapper));
        component.set("v.cartCount",myCartWrapper.length);
        component.set("v.allVehicleData",allVehicleData);
        component.set("v.vehicleWrapper",vehicleWrapper);
        component.set("v.myCartVehicleWrapper",myCartWrapper);
        var setRows=selectedVehicles;
        var searchCompleteEvent = component.getEvent("DataEvent"); 
        searchCompleteEvent.setParams({
            selectedRecords : setRows 
        }); 
        searchCompleteEvent.fire();
    },
    selectAllHelper: function (component, vehicleWrapper) {
        var isSelectedAll = component.get('v.isSelectAll');
        var allVehicleData = component.get('v.allVehicleData');
        var selectedVehicles=[];
        var myCartWrapper=[];
        var disableFlag=false;
        for(let idx = 0 ; idx < vehicleWrapper.length; idx++){
            if(vehicleWrapper[0].isSelectAll)
                vehicleWrapper[idx].isChecked = true;
            else 
                vehicleWrapper[idx].isChecked = false;
        }
        for(let index = 0 ; index < allVehicleData.length; index++){
            for(let idx = 0 ; idx < vehicleWrapper.length; idx++){
                if(vehicleWrapper[idx].customerVehicle.Id == allVehicleData[index].customerVehicle.Id){
                    if(vehicleWrapper[idx].isChecked){
                        if(component.get('v.emirate') == 'Sharjah'){
                            if(!allVehicleData[index].isDisableSPEATest){
                                allVehicleData[index].isChecked = true;
                                disableFlag=true;
                            }
                        }else{
                            allVehicleData[index].isChecked = true;
                        }
                    }else{
                        allVehicleData[index].isChecked = false;
                    }
                }
            }
        }
        for(let index = 0 ; index < allVehicleData.length; index++){
            if(allVehicleData[index].isChecked){
                selectedVehicles.push(allVehicleData[index].customerVehicle);
                myCartWrapper.push(allVehicleData[index]);
            }
        }
        if(selectedVehicles.length==0 && disableFlag){
            component.set("v.isSelectAll",false);
            var msg='You cannot Request for Service before due date.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("Error!",msg,"","dismissible","error");
            return false;
        }else {
            console.log('selectedVehicles length '+selectedVehicles.length);
            console.log('selectedVehicles '+JSON.stringify(selectedVehicles));
            console.log('myCartWrapper '+JSON.stringify(myCartWrapper));
            component.set("v.cartCount",myCartWrapper.length);
            component.set("v.myCartVehicleWrapper",myCartWrapper);
            var searchCompleteEvent = component.getEvent("DataEvent"); 
            searchCompleteEvent.setParams({
                selectedRecords : selectedVehicles 
            }); 
            searchCompleteEvent.fire();
            component.set('v.allVehicleData', allVehicleData);
            component.set('v.vehicleWrapper', vehicleWrapper);
        }
    }
})
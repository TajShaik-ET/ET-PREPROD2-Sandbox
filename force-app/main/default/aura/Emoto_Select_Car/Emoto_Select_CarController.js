({
    doInit: function(component, event, helper){
        helper.getItenaryDetailsfromURL(component, event, helper); 
        helper.getVehInfoHelper(component, event);
        helper.getFiltersInfoHelper(component, event, helper);
        // get pagesize from custom label
        var pageSize = $A.get("$Label.c.ETM_Pagination_Page_size");
        console.log('page size = '+ pageSize);
        if(pageSize){
           component.set("v.pageSize",pageSize ); 
        }
    },
    
    closeModal: function(component, event, helper){
        component.set("v.showUnitPopup", false);
    },
    
    clearFilters : function(component, event, helper){
        component.find("types").set("v.value","");
        component.find("makes").set("v.value","");
        component.find("models").set("v.value","");
        component.find("families").set("v.value","");
        component.find("vehNumber").set("v.value","");
        //once reset the filters - reset whole search Result.
        var allRecords = component.get("v.data");
        component.set("v.searchResult" ,allRecords);
        helper.reconfigPagination(component, event, helper,allRecords);
    },
    
    getAllRecords : function(component, event, helper){
        component.set("v.msgDesc", "");
        component.set("v.Message", false);
        helper.getVehInfoHelper(component, event);
    },
    
    checkboxSelect: function(component, event, helper) {
        // on each checkbox selection update the selected record count 
        var selectedRec = event.getSource().get("v.value");
        var getSelectedNumber = component.get("v.selectedCount");
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
            component.find("selectAllId").set("v.value", false);
        }
        component.set("v.selectedCount", getSelectedNumber);
        // if all checkboxes are checked then set header checkbox with true   
        if (getSelectedNumber == component.get("v.totalRecordsCount")) {
            component.find("selectAllId").set("v.value", true);
        }
    },
    
    
    createVehicles : function(component, event, helper){
        var allRecords = component.get("v.searchResult");
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].isChecked) {
                selectedRecords.push(allRecords[i]);
            }
        }
        var records = JSON.stringify(selectedRecords);
        console.log('records = '+records );
        helper.addVehicle(component, event, records,helper);
    },
    
    /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.data");
        var pageSize = component.get("v.pageSize");
        // component.set("v.startPage",0);
        // component.set("v.endPage",pageSize-1);
        var end = component.get("v.endPage");
        console.log(end);
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
    },
    
    selectAllCheckbox: function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var updatedPaginationList = [];
        var listOfAllsearchResult = component.get("v.searchResult");
        component.set("v.PaginationList", listOfAllsearchResult);
        var PaginationList = component.get("v.PaginationList");
        // play a for loop on all records list 
        for (var i = 0; i < listOfAllsearchResult.length; i++) {
            // check if header checkbox is 'true' then update all checkbox with true and update selected records count
            // else update all records with false and set selectedCount with 0  
            if (selectedHeaderCheck == true) {
                listOfAllsearchResult[i].isChecked = true;
                component.set("v.selectedCount", listOfAllsearchResult.length);
            } else {
                listOfAllsearchResult[i].isChecked = false;
                component.set("v.selectedCount", 0);
            }
            updatedAllRecords.push(listOfAllsearchResult[i]);
        }
        // update the checkbox for 'PaginationList' based on header checbox 
        for (var i = 0; i < PaginationList.length; i++) {
            if (selectedHeaderCheck == true) {
                PaginationList[i].isChecked = true;
            } else {
                PaginationList[i].isChecked = false;
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        component.set("v.listOfAllsearchResult", updatedAllRecords);
        component.set("v.searchResult", updatedPaginationList);
    },
    
    /* Method : onTypeChange
       Description : Excecutes when Type Changes in Filter. Only Vehicles with selected 'Type' filtered and Displays.
       				 And Makes relavant to selected 'Type' displays.
    */
    
    onTypeChange: function(component, event, helper) {
        var typeSelected = component.find("types").get("v.value");
        var allRecords = component.get("v.data");
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].VehicleType == typeSelected ) {
                selectedRecords.push(allRecords[i]);
            }
        }
        component.set("v.searchResult" ,selectedRecords);
        helper.reconfigPagination(component, event, helper,selectedRecords);
        //set values for vehicle makes based on selected Type...
        var makes;
        var vehMakesOptions=[];
        var vehTyeMakeMap = component.get("v.vehTyeMakeMap");
        if(vehTyeMakeMap){
            makes = vehTyeMakeMap[typeSelected];
        }
        if(makes != null && makes.length >0){
            for(let i in makes){
                vehMakesOptions.push({label:makes[i], value:makes[i]});  
            }
            component.set("v.vehMakes",vehMakesOptions );
            console.log(JSON.stringify(component.get("v.vehMakes")));
        }
    },
    
    /* Method : onMakeChange
       Description : Excecutes when Make Changes in Filter. Only Vehicles with selected 'Make' filtered and Displays.
       				 And Models relavant to selected 'Make' displays.
    */
    
    onMakeChange : function(component, event, helper) {
        var makeSelected = component.find("makes").get("v.value");
        var allRecords = component.get("v.data");
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].Make == makeSelected ) {
                selectedRecords.push(allRecords[i]);
            }
        }
        component.set("v.searchResult" ,selectedRecords);
        helper.reconfigPagination(component, event, helper,selectedRecords);
        //set values for vehicle models based on selected Make...
        var models;
        var vehModelsOptions=[];
        var vehMakeModelsMap = component.get("v.vehMakeModelsMap");
        if(vehMakeModelsMap){
            models = vehMakeModelsMap[makeSelected];
        }
        if(models != null && models.length >0){
            for(let i in models){
                vehModelsOptions.push({label:models[i], value:models[i]});  
            }
            component.set("v.vehModels",vehModelsOptions );
            console.log(JSON.stringify(component.get("v.vehModels")));
        }
    },
    
    /* Method : onFamilyChange
       Description : Excecutes when Model Changes in Filter. Only Vehicles with selected 'Model' filtered and Displays.
    */
    onFamilyChange : function(component, event, helper) {
        var familySelected = component.find("families").get("v.value");
        var allRecords = component.get("v.data");
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].Family == familySelected ) {
                selectedRecords.push(allRecords[i]);
            }
        }
        component.set("v.searchResult" ,selectedRecords);
        helper.reconfigPagination(component, event, helper,selectedRecords);
    },
    
    onVehNoChange : function(component, event, helper) {
        var vehNoSelected = component.find("vehNumber").get("v.value");
        var allRecords = component.get("v.data");
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            if(vehNoSelected !='none'){
                if (allRecords[i].VehicleNo == vehNoSelected ) {
                    selectedRecords.push(allRecords[i]);
                }
            }
            
        }
        component.set("v.searchResult" ,selectedRecords);
        helper.reconfigPagination(component, event, helper,selectedRecords);
    },
    
    /* Method : onModelChange
       Description : Excecutes when Model Changes in Filter. Only Vehicles with selected 'Model' filtered and Displays.
    */
    onModelChange : function(component, event, helper) {
        var modelSelected = component.find("models").get("v.value");
        var familySelected = component.find("families").get("v.value");
        var makeSelected = component.find("makes").get("v.value");
        var typeSelected = component.find("types").get("v.value");
        console.log('typeSelected  = '+ typeSelected);
        console.log('makeSelected  = '+ makeSelected);
        var searchRecords = [];
        var allRecords = component.get("v.data");
        var searchResult = component.get("v.searchResult");
        console.log('type of = '+ typeof selectedRecords);
        /*debugger;
        if(typeSelected!= '' && typeSelected !='none'){
            for (var i = 0; i < allRecords.length; i++) {
                if (allRecords[i].VehicleType == typeSelected ) {
                    selectedRecords.[allRecords[i].VehicleName] = ;
                    
                        
                }
            }
        }
        
        if(makeSelected != '' && makeSelected !='none'){
            for (var i = 0; i < allRecords.length; i++) {
                if (allRecords[i].Make == makeSelected ) {
                    selectedRecords.push(allRecords[i].VehicleName,allRecords[i]);
                }
            }
        }
        
        if(familySelected != '' && familySelected !='none'){
            for (var i = 0; i < allRecords.length; i++) {
                if (allRecords[i].Family == familySelected ) {
                    selectedRecords.push(allRecords[i].VehicleName,allRecords[i]);
                }
            }
        }
        
        debugger;
        console.log('selected = '+ JSON.stringify(selectedRecords));
        if(selectedRecords && selectedRecords.length >0){
            for (var i = 0; i < selectedRecords.length; i++) {
                if(modelSelected != '' && modelSelected != 'none'){
                    if (selectedRecords[i].VehicleModel == modelSelected ) {
                        searchRecords.push(selectedRecords[i]);
                    } 
                }
                else{
                    searchRecords.push(selectedRecords[i]);
                }
            } 
        }
        else{
            
        }*/
        
        for (var i = 0; i < allRecords.length; i++) {
                if (allRecords[i].VehicleModel == modelSelected ) {
                    searchRecords.push(allRecords[i]);
                }
            } 
        
        component.set("v.searchResult" ,searchRecords);
        helper.reconfigPagination(component, event, helper,selectedRecords);
    },
    
    onRangeChange: function(component, event, helper) {
		console.log('in Range Change');
        console.log('min price = '+event.getParam("minValue") );
        console.log('max price = '+event.getParam("maxValue") );
        var minPrice = event.getParam("minValue");
        var maxPrice = event.getParam("maxValue");
        
        var allRecords = component.get("v.data");
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            console.log('price = '+ allRecords[i].Price);
            if (allRecords[i].Price >= minPrice && allRecords[i].Price <= maxPrice ) {
                selectedRecords.push(allRecords[i]);
            }   
        }
        component.set("v.searchResult" ,selectedRecords);
        helper.reconfigPagination(component, event, helper,selectedRecords);
        
	},
    
    onKmsRangeChange : function(component, event, helper) {
		console.log('in kms Range Change');
        console.log('min kms = '+event.getParam("minValue") );
        console.log('max kms = '+event.getParam("maxValue") );
        var minKms = event.getParam("minValue");
        var maxKms = event.getParam("maxValue");
        
        var allRecords = component.get("v.data");
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            console.log('KMs = '+ allRecords[i].KM);
            if (allRecords[i].KM >= minKms && allRecords[i].KM <= maxKms ) {
                selectedRecords.push(allRecords[i]);
            }   
        }
        component.set("v.searchResult" ,selectedRecords);
        helper.reconfigPagination(component, event, helper,selectedRecords);
        
	},
   
})
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
                this.fetchVehicleHelper(component,null);
                //component.set("v.emirate",result.ET_Changed_Location__c);
            }
        });
        $A.enqueueAction(action);
     },
    fetchVehicleHelper : function(component, event, helper,searchKeyword) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log('searchKeyword>> '+searchKeyword);
        component.set("v.IsSpinner", true);
        var pageSize = component.get("v.pageSize");
        var action = component.get("c.getVehicles");
        action.setParams({
            "userId": userId,
            "emirate":component.get('v.emirate'),
            "searchKeyword": searchKeyword
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
            console.log('Plate_Source '+JSON.stringify(vehlist[0].Plate_Source_AR__c));
            if(records.length>0 && !component.get("v.showSearch"))
                component.set("v.showSearch",true)
            component.set("v.VehicleList", vehlist);
            component.set("v.allVehicleData", records);
            component.set("v.vehicleWrapper", records);
            component.set("v.totalRecords",records.length);
            console.log('totalRecords>> '+component.get("v.totalRecords"));
            component.set("v.totalPages", Math.ceil(records.length/component.get("v.pageSize")));
            component.set("v.currentPageNumber",1);
            console.log('totalPages length>> '+component.get("v.totalPages"));
            component.set("v.IsSpinner", false);
            this.buildData(component, helper);
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
    buildData : function(component, helper) {
        var wrpData = [];
        var vehlist=[];   
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var vehicleWrp = component.get("v.allVehicleData");
        var vehicleData = component.get("v.VehicleList");
        console.log('vehicleWrp '+JSON.stringify(vehicleWrp));
        console.log('vehicleData>> '+JSON.stringify(vehicleData));
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
            	wrpData.push(vehicleWrp[x]);
                vehlist.push(vehicleWrp[x].customerVehicle);
            }
        }
        console.log('vehlist '+JSON.stringify(vehlist));
        console.log('wrpData>> '+JSON.stringify(wrpData));
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
    /*
     * this function generate page list
     * */
    //pagination Method
     getCurrenetPageData:function(component, event, helper,start,pageSize) {
        component.set("v.paginationList", component.get('v.vehicleWrapper').slice(start,start+pageSize));
     },    
     loadScriptForDataTable : function(){
       try{
        setTimeout(function(){ 
            // alert('Hello')
            $('#tableId').DataTable({
                "lengthChange": false,
                "info": false,
                "columns": [
                    { "searchable": false },
                    null,
                    null,
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
        }, 500);  
       }catch(err){
           alert(err.message)
       }
    },
    
})
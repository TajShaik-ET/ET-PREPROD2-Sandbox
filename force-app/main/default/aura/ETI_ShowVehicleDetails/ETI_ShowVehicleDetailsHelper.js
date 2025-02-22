({
    fetchVehicleHelper : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        // alert(userId);
        var action = component.get("c.getVehicles");
        action.setParams({
            "userId": userId
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
        component.set("v.VehicleList", vehlist);
        component.set("v.vehicleWrapper", records);
        this.accountDetails(component);
        });
        $A.enqueueAction(action);
        component.set("v.IsSpinner", false);
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
    accountDetails : function(component, event, helper) {
    	var action = component.get("c.getAccountDetails");
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state>>---- '+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result onload>> '+JSON.stringify(result));
                if(result.ET_Changed_Location__c !='Abu Dhabi')
                	component.set("v.emirate",result.ET_Changed_Location__c);
                else 
                	component.set("v.emirate",'AbuDhabi');
                console.log('Emirate>> '+component.get("v.emirate"));
            }
        });
        $A.enqueueAction(action);
     }
  /*  getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    }*/
    
})
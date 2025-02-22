({
	CSV2JSON: function (component,csv) {
        //  console.log('Incoming csv = ' + csv);
        
        //var array = [];
        var arr = []; 
        
        arr =  csv.split('\n');
        //console.log('Array  = '+array);
        // console.log('arr = '+arr);
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                obj[headers[j].trim()] = data[j].trim();
                //console.log('obj headers = ' + obj[headers[j].trim()]);
            }
            jsonObj.push(obj);
        }
        var json = JSON.stringify(jsonObj);
        //console.log('json = '+ json);
        return json;
        
        
    },
    updateInsurances : function (component,jsonstr){
         console.log('jsonstr' + jsonstr);
       var action = component.get('c.updateRenewalData');
        //  alert('Server Action' + action);    
        action.setParams({
            strfromle : jsonstr
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            
            if (state === "SUCCESS") {  
                component.set("v.ShowModule",false);
                var result=response.getReturnValue();
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Success",
                    "title":"success",
                    "message":'Your data is updated successfully',
                    "mode":"dismissible"
                });
                toastReference.fire();
                $A.get('e.force:refreshView').fire(); 
            }
            else if (state === "ERROR") {
               component.set("v.ShowModule",false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":'Please check with System admin - Err:'+errors[0].message,
                            "mode":"sticky"
                        });
                        toastReference.fire();
                    }
                } else {
                    console.log("Unknown error");
                     component.set("v.ShowModule",false);
                    //alert('Unknown');
                }
            }
        }); 
        
        $A.enqueueAction(action);  
        
    },
   
})
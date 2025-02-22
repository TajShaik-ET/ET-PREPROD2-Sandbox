({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    CSV2JSON: function (component,csv) {
        console.log('csv '+ csv);
        var arr = []; 
        arr =  csv.split('\n');
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        console.log('headers '+ headers);
        component.set("v.headers",headers);
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            console.log('data '+ data);
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                console.log('trim '+ data[j].trim());
                console.log('data[j] '+ data[j]);
                if(data[j]=='' || data[j]== null || data[j]==undefined){
                    console.log('data[j] INN '+ data[j]);
                	obj[headers[j].trim()] = null;
                }else 
                	obj[headers[j].trim()] = data[j].trim();
            }
            jsonObj.push(obj);
        }
        console.log('jsonObj '+ jsonObj);
        var json = JSON.stringify(jsonObj);
        console.log('json = '+ json);
        return json;
    },
    uploadVehiclesHelper : function (component,jsonstr,csv){
       component.set("v.IsSpinner", true);
       component.set("v.showVehiclesUploadDetails",false);
       var emirate='Abu Dhabi';
       if(component.get("v.emirate")=='Sharjah')
           emirate='Sharjah';
       console.log('csv## '+ csv);
       console.log('jsonstr## '+ jsonstr);
       var action = component.get('c.uploadBulkVehicles');
        action.setParams({
            jsonstr : jsonstr,
            fileName: component.get("v.fileName"),
            csv: csv,
            emirate: emirate
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('state --- '+state);
            console.log('result --- '+JSON.stringify(result));
            if (state === "SUCCESS") {
                component.set("v.uploadWrapper",result);
                if(result.TotoalVehicles!=undefined && result.TotoalVehicles!=null)
                	component.set("v.showVehiclesUploadDetails",true);
                if(result.errormsg==null || result.errormsg==''){
                    component.set("v.fileName", null);
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type":"Success",
                        "title":"success",
                        "message":'Your data is uploaded successfully',
                        "mode":"dismissible"
                    });
                    toastReference.fire();
                    $A.get('e.force:refreshView').fire(); 
                }else {
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type":"Error",
                        "title":"error",
                        "message":result.errormsg,
                        "mode":"dismissible"
                    });
                    toastReference.fire();
                }
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
                            "message":errors[0].message,//'Uploded File doesn\'t contain valid data, Please check and upload a valid file.',//'Please check with System admin '+errors[0].message,
                            "mode":"sticky"
                        });
                        toastReference.fire();
                    }
                } else {
                    console.log("Unknown error");
                    component.set("v.ShowModule",false);
                }
            }
            component.set("v.IsSpinner", false);
        }); 
        $A.enqueueAction(action);  
    },
    
})
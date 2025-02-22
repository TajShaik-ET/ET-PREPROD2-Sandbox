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
    insertLineItems : function (component,jsonstr){
       var recid = component.get("v.recordId");
       var action = component.get('c.insertData');
        //  alert('Server Action' + action);    
        action.setParams({
            strfromle : jsonstr,
             recordID:recid
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
                //$A.get('e.force:refreshView').fire(); 
                location.reload();

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
                            "message":'Please check with System admin'+errors[0].message,
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
    
    convertArrayOfObjectsToCSV : function(component,objRecords,type) {
        
               
        var csvStringResult,counter,keys,lineDivider,columnDivider;
        if(objRecords==null || !objRecords.length)
        {
            return null;         
        }
        columnDivider=',';
        lineDivider='\n';
        keys=['Employee__r','Job_Title__c','Finance_No__c','Zone__c','Insurance_Limit__c'];
        
        
        csvStringResult='';
        //csvStringResult+=keys.join(columnDivider);
        csvStringResult+=['Name','Job Title','Finance No.','Zone','Insurance Limit'];
        csvStringResult+=lineDivider;
        
        for(var i=0;i<objRecords.length;i++)
        {
         
            counter=0;
            for(var tempKey in keys)
            {
                var skey=keys[tempKey];
                
                if(counter>0)
                {
                    csvStringResult+=columnDivider;
                }
                
                // Querying custom related object field
                if(typeof objRecords[i][skey]==='object' && (skey==='Employee__r')){
                    csvStringResult+='"'+objRecords[i][skey].Name+'"';
                    csvStringResult+=columnDivider;
                }else{
                    csvStringResult+='"'+(objRecords[i][skey] == null ? 'null':objRecords[i][skey])+'"';
                        counter ++;
                    }
                
            }
            csvStringResult+=lineDivider;
            
        }
        
        return csvStringResult;
    },
   
})
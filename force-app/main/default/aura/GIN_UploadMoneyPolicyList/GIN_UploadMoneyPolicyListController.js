({
	doInit : function(component, event, helper) {
        
        var action = component.get('c.getInsLinesData');
       
        action.setParams({
            recordID:component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                        
            if (state === "SUCCESS") {  
               
                var result=response.getReturnValue();
                console.log(result)
                component.set("v.currentData",result);
                 
            }
            else if (state === "ERROR") {
              
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
                    
                }
            }
        }); 
        
        $A.enqueueAction(action); 
		
	},
    
    insertRecords : function (component, event, helper){
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        //alert(file);
        if (file){
            component.set("v.ShowModule",true);
            //console.log("File");
            var reader = new FileReader();
            reader.readAsText(file, "UTF-8");
            reader.onload = function (evt) {
                
                //console.log("EVT FN");
                var csv = evt.target.result;
                //console.log('csv file contains'+ csv);
                var result = helper.CSV2JSON(component,csv);
                //console.log('result = ' + result);
                //console.log('Result = '+JSON.parse(result));
                
                window.setTimeout($A.getCallback(function(){
                   helper.insertLineItems(component,result);
                }), 10);
                
            }
            reader.onerror = function (evt) {
                //console.log("error reading file");
            }
        }else {
            
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Warning",
                "title":"Warning",
                "message":'Please choose file',
                "mode":"dismissible"
            });
            toastReference.fire();
        }
    },
    
    DownloadTemplate : function(component){
        
        var jsonStr = '{"rows":[{"vals":[{"val":"12355"},{"val":"2000"}]},{"vals":[{"val":"34233"},{"val":"2000.00"}]}],"headers":[{"title":"FinanceNumber"},{"title":"InsuranceLimit"}]}';
         var jsonData = JSON.parse(jsonStr);       
        var gridData = jsonData;
        // Spliting headers form table.
        var gridDataHeaders = gridData["headers"];
        // Spliting row form table.
        var gridDataRows = gridData["rows"];
        //  CSV download.
        var csv = '';
        for(var i = 0; i < gridDataHeaders.length; i++){         
            csv += (i === (gridDataHeaders.length - 1)) ? gridDataHeaders[i]["title"] : gridDataHeaders[i]["title"] + ','; 
        }
        csv += "\n";
        var data = [];
        for(var i = 0; i < gridDataRows.length; i++){
            var gridRowIns = gridDataRows[i];
            var gridRowInsVals = gridRowIns["vals"];
            var tempRow = [];
            for(var j = 0; j < gridRowInsVals.length; j++){                                     
                var tempValue = gridRowInsVals[j]["val"];
                if(tempValue.includes(',')){
                    tempValue = "\"" + tempValue + "\"";
                }
                tempValue = tempValue.replace(/(\r\n|\n|\r)/gm,"");                 
                tempRow.push(tempValue);
            }
            data.push(tempRow); 
        }
        data.forEach(function(row){
            csv += row.join(',');
            csv += "\n";
        });
        // 6. To download table in CSV format.
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_blank';
        hiddenElement.download = 'MoneyPolicySampleTemplate'+'.csv'; 
        hiddenElement.click();
    },
    
     downloadRecords :function(component, event, helper){
         
        var allResources=component.get("v.currentData");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources); 
        if(csv==null)
        {
			return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='MoneyPolicyEmployees.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
})
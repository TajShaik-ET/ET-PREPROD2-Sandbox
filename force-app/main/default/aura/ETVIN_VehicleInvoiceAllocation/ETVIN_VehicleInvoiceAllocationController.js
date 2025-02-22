({
	doInit : function(component, event, helper) {
		
       
	},
    updateRecords : function (component, event, helper){
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
                   helper.updateInsurances(component,result);
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
    
    showfiledata :  function (component, event, helper){        
       /* var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        if (file) {
            component.set("v.showcard", true);
            //console.log("File");
            var reader = new FileReader();
            reader.readAsText(file, "UTF-8");
            reader.onload = function (evt) {
                var csv = evt.target.result;
                var table = document.createElement("table");
                var rows = csv.split("\n");
                for (var i = 0; i < rows.length; i++) {
                    var cells = rows[i].split(",");
                    if (cells.length > 1) {
                        var row = table.insertRow(-1);
                        for (var j = 0; j < cells.length; j++) {
                            var cell = row.insertCell(-1);
                            cell.innerHTML = cells[j];
                        }
                    }
                }
                var divCSV = document.getElementById("divCSV");
                divCSV.innerHTML = "";
                divCSV.appendChild(table);
            }
            reader.onerror = function (evt) {
               console.log("error reading file");
            }
        }*/
    },   
        DownloadTemplate : function(component){
        
            var jsonStr = '{"rows":[{"vals":[{"val":"B0053602"},{"val":"200"},{"val":"Debit"}]},{"vals":[{"val":"B0017298"},{"val":"200.00"},{"val":"Credit"}]}],"headers":[{"title":"VehicleInternalNumber"},{"title":"Amount"},{"title":"InvoiceType"}]}';
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
        hiddenElement.download = 'SampleTemplate'+'.csv'; 
        hiddenElement.click();
    }
     
})
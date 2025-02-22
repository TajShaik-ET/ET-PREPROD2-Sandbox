({
    doInit : function(component, event, helper) {
        helper.setCommunityLanguage(component, event, helper);
	},  
    DownloadTemplate : function(component){
        console.log('emirate '+component.get("v.emirate"));
        var jsonStr;
        if(component.get("v.emirate")=='Sharjah')
            jsonStr= '{"headers":[{"title":"Chassis Number"}]}';//WDX652023100ABC
        else 
            jsonStr= '{"rows":[{"vals":[{"val":"Vehicle"},{"val":"Without ADFCA"},{"val":""}]},{"vals":[{"val":"Trailer"},{"val":"With ADFCA"},{"val":""}]},{"vals":[{"val":"Equipment"},{"val":""},{"val":""}]}],"headers":[{"title":"Vehicle Type"},{"title":"ADFCA Type"},{"title":"Chassis Number"}]}';
        console.log('jsonStr '+jsonStr);
        var jsonData = JSON.parse(jsonStr);       
        var gridData = jsonData;
        // Spliting headers form table.
        var gridDataHeaders = gridData["headers"];
        // Spliting row form table.
        var gridDataRows = gridData["rows"];
        //  CSV download.
        console.log('gridDataHeaders '+gridDataHeaders);
        var csv = '';
        for(var i = 0; i < gridDataHeaders.length; i++){         
            csv += (i === (gridDataHeaders.length - 1)) ? gridDataHeaders[i]["title"] : gridDataHeaders[i]["title"] + ','; 
        }
        csv += "\n";
        console.log('gridDataRows '+gridDataRows);
        if(gridDataRows!=undefined && gridDataRows!=null){
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
            console.log('data '+data);
            data.forEach(function(row){
                csv += row.join(',');
                csv += "\n";
            });
        }
        // 6. To download table in CSV format.
        var hiddenElement = document.createElement('a');
        console.log('hiddenElement '+hiddenElement);
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_blank';
        hiddenElement.download = 'BulkVehicleTemplate'+'.csv'; 
        hiddenElement.click();
    },
    // File Upload Methods
    handleFilesChange: function (component, event, helper) {
        var files = event.getSource().get("v.files");
        if (files.length > 0) 
            component.set("v.fileName", files[0].name);
    },
    uploadVehicles: function(component, event, helper) {
        console.log('fileName '+component.get("v.fileName"));
        if (component.get("v.fileName")!=undefined && component.get("v.fileName")!=null
            && component.find("fileId").get("v.files").length > 0) {
            var fileInput = component.find("fileId").get("v.files");
            var file = fileInput[0];
            console.log("File "+file);
            if (file){
                //component.set("v.ShowModule",true);
                var reader = new FileReader();
                reader.readAsText(file, "UTF-8");
                reader.onload = function (evt) {
                    var csv = evt.target.result;
                    console.log('csv file contains'+ csv);
                    var result = helper.CSV2JSON(component,csv);
                    console.log('result = ' + result);
                    console.log('Result = '+JSON.parse(result));
                    window.setTimeout($A.getCallback(function(){
                       helper.uploadVehiclesHelper(component,result,csv);
                    }), 10);
                }
                reader.onerror = function (evt) {
                }
            }
        } else {
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Warning",
                "title":"Warning",
                "message":'Please choose a file',
                "mode":"dismissible"
            });
            toastReference.fire();
        }
    },
    
    closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isBulkModel", false);
    },
})
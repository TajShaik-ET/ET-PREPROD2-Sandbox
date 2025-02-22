({
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
        var vehicleData = component.get("v.myCartVehicleWrapper");
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
        component.set("v.myCartVehicleWrapper", wrpData);
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
})
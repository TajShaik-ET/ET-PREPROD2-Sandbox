({
    doInit : function(component, event, helper)  {
        var utility = component.find("ETI_UtilityMethods");
        var backendMethod = "getPaymentHistory";
        var params = {
            "stDate" : component.get("v.startDate"),
            "enDate" : component.get("v.endDate")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.paymentHistList',response);
                component.set('v.allPaymentData',response);
                component.set("v.totalRecords",response.length);
                console.log('totalRecords>> '+component.get("v.totalRecords"));
                component.set("v.totalPages", Math.ceil(response.length/component.get("v.pageSize")));
                component.set("v.currentPageNumber",1);
                console.log('totalPages length>> '+component.get("v.totalPages"));
                try{
                	helper.buildData(component, helper);
                }catch(e){
                    console.log('error '+e.message);
                }
            }),
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Vehicle Inspection", errorToShow, "error", "dismissible");
            })
        )	
    },
    getBookingAndVehicle1 : function(component, event, helper) {
        var currentservice= component.get("v.serviceid");
        var action = component.get("c.getBookingAndVehicle");
        action.setParams({
            "serviceId" : currentservice
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state>> ',state);
            if (state === "SUCCESS") {
                console.log('response>> ', JSON.stringify(response.getReturnValue()));
                var bookingList = response.getReturnValue();
                component.set('v.bookingList', bookingList);
                //alert(component.get('v.bookingList'));
            }
        });
        $A.enqueueAction(action);
    },
    /*
     * this function will build table data
     * based on current page selection
     * */
    buildData : function(component,helper) {
        var wrpData = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var vehicleWrp = component.get("v.allPaymentData");
        console.log('vehicleWrp '+JSON.stringify(vehicleWrp));
        var vehicleData = component.get("v.paymentHistList");
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
            }
        }
        console.log('wrpData>> '+JSON.stringify(wrpData));
        component.set("v.paymentHistList", wrpData);
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
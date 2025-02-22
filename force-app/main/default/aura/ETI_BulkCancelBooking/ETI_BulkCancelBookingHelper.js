({
    getVehcileBookings : function(component, event, helper,searchKeyword) {
        var recId = component.get("v.recordId");
        var allBookingData = component.get('v.allBookingData');
        var action = component.get('c.getBulkCancelBookings');
        console.log(recId);
        action.setParams({
            "recId":recId,
            "searchKeyword":searchKeyword
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                if(records.length>0){
                    if(allBookingData==undefined || allBookingData.length==0)
                         component.set('v.allBookingData', JSON.parse(JSON.stringify(records)));
                    else {
                        for (var idx = 0; idx < allBookingData.length; idx++) {
                            for (var jdx = 0; jdx < records.length; jdx++) {
                                if(allBookingData[idx].isSelected==true && allBookingData[idx].booking.Id==records[jdx].booking.Id) 
                                    records[jdx].isSelected=true;
                            }
                        }
                    }
                    component.set('v.allBookingDataWithSearch', JSON.parse(JSON.stringify(records)));
                    component.set("v.totalRecords",records.length);
                    component.set("v.totalPages", Math.ceil(records.length/component.get("v.pageSize")));
                    component.set("v.currentPageNumber",1);
                    console.log('totalPages length>> '+component.get("v.totalPages"));
                    this.buildData(component, helper);
           		}else 
                    component.set("v.showSubmit", false);
                component.set('v.showBulkCancelBookings',true);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);	
    },
    
    sendRefundRequest :function(component, helper, selectedbookings) {
        console.log('selectedbookings>> '+JSON.stringify(selectedbookings));
        console.log('totalRefundAmount>> '+component.get("v.totalRefundAmount"));
        var action = component.get('c.doBulkCancelBookings');
        action.setParams({
            bkngIds: selectedbookings,
            refundAmount: component.get("v.totalRefundAmount"),
            cancelReason: component.get("v.cancelReason")
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result =response.getReturnValue();
                console.log('result>> '+result);
                if(result){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": 'Selected Bookings has been cancelled and refunded successfully.',
                        "type": "Success"
                    });
                    toastEvent.fire();
                }else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": 'Something gone wrong please try after sometime or system admin.',
                        "type": "Error"
                    });
                    toastEvent.fire();
                }
             	// Close the action panel
                $A.get("e.force:closeQuickAction").fire();
       			$A.get('e.force:refreshView').fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": 'Something gone wrong please try after sometime or system admin.',
                    "type": "Error"
                });
                toastEvent.fire();
                component.set("v.showSubmit", true);
            }
        }));
        $A.enqueueAction(action);	
    },
    calculateRefundAmount : function(component, helper, allBookingData) {
        var totalRefundAmount = 0;
        //var allBookingData=component.get("v.allBookingData");
        console.log('allBookingData11 '+JSON.stringify(allBookingData));
        for(var i=0;i<allBookingData.length;i++){
            if(allBookingData[i].isSelected){
                totalRefundAmount+= allBookingData[i].booking.Total_Amount__c; 
            }  
        }
        component.set('v.totalRefundAmount',totalRefundAmount);
    },
    /*
     * this function will build table data
     * based on current page selection
     * */
    buildData : function(component,helper) {
        var wrpData = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allBookingData = component.get("v.allBookingDataWithSearch");
        var bookingData = component.get("v.bookingWrapper");
        console.log('searchBookingData '+JSON.stringify(allBookingData));
        console.log('bookingData>> '+JSON.stringify(bookingData));
        var totalRecords = component.get("v.totalRecords");
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
            if(allBookingData[x]){
                var data={"booking":allBookingData[x].booking,"isSelected":allBookingData[x].isSelected};
            	wrpData.push(data);
            }
        }
        for(let idx = 0; idx < allBookingData.length; idx++){
            for (var jdx = 0; jdx < wrpData.length; jdx++) {
                if(wrpData[jdx].isSelected==true && wrpData[jdx].booking.Id==allBookingData[idx].booking.Id) 
                    wrpData[idx].isSelected=true;
                if(wrpData[jdx].isSelected==false && wrpData[jdx].booking.Id==allBookingData[idx].booking.Id) 
                    wrpData[idx].isSelected=false;
            }
        }
        console.log('wrpData>> '+JSON.stringify(wrpData));
        //component.set("v.allBookingData", allBookingData);
        component.set("v.bookingWrapper", wrpData);
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
({
	showSpinner: function(component){
        component.set("v.IsSpinner",true);  
    },
    hideSpinner: function(component){
        component.set("v.IsSpinner",false);  
    },
    calculateSubTotalAmount: function(component, event, bookingData){
        console.log('bookingData>> '+JSON.stringify(bookingData));
        //var bookingData = component.get('v.feeDetails');
        var subtotal = 0;
        for(let index in bookingData){
            console.log('Total_Fee__c>> '+JSON.stringify(bookingData[index].Total_Fee__c));
            if(bookingData[index].Fee_Integration_Status__c!='E' && bookingData[index].Total_Fee__c!=0 && bookingData[index].Total_Fee__c!=0.00)
            	subtotal += bookingData[index].Total_Fee__c;
        }
        console.log('subtotal>> '+subtotal);
        component.set('v.subtotalPrice', subtotal);
        console.log('subtotalPrice>> '+component.get("v.subtotalPrice"));
    },
    removeBookingHelper: function(component, event, helper){
       try{
            var bookingFeeDetails=component.get("v.bookingFeeDetails");
            //var bookingData = component.get('v.feeDetails');
            //var index = event.getSource().get("v.value");
            //console.log('index>> '+index);
            //var bookingObj = bookingData[index];
            var action = component.get("c.removeBookings");
            action.setParams({
                obj : JSON.stringify(bookingFeeDetails),
                serviceItems: event.getSource().get("v.value")
                //JSON.parse(JSON.stringify(bookingObj.Id))
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state>> '+state);
                if (state === "SUCCESS") {
                    var bookingFeeDetails = response.getReturnValue();
                    console.log('bookingFeeDetails>> '+JSON.stringify(bookingFeeDetails));
                    if(bookingFeeDetails.length == 0){
                        component.set("v.isInspectionFeeExist", false);
                    }
                    component.set('v.bookingFeeDetails', bookingFeeDetails);
                    var feeDetails =[];
                    for(var idx = 0; idx < bookingFeeDetails.chassisNo.length; idx++){
                        for (var i = 0; i < bookingFeeDetails.chassisNo[idx].typeList.length; i++) {
                            for(var j = 0; j < bookingFeeDetails.chassisNo[idx].typeList[i].serviceItems.length; j++){
                                if(bookingFeeDetails.chassisNo[idx].typeList[i].serviceItems[j].Fee_Integration_Status__c=='S'){
                                    component.set("v.isFeeExist", true);
                                }
                                feeDetails.push(bookingFeeDetails.chassisNo[idx].typeList[i].serviceItems[j]);
                            }
                        }
                    }
                    component.set('v.feeDetails', feeDetails);
                    helper.calculateSubTotalAmount(component, event, feeDetails);
                    component.set("v.IsSpinner", false);
                }else {
                    alert("Temporary Error: There is a problem in removing booked details.");
                    component.set("v.IsSpinner", false);
                }
            });
            component.set("v.IsSpinner", true);
            $A.enqueueAction(action);
        }catch(err){
            component.set("v.IsSpinner", false);
            alert(err.message)
        }
    }
})
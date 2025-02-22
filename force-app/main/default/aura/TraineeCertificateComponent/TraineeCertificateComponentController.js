({
	doInit: function(component, event, helper) {
        let bookingReqId=component.get("v.recordId");
        var action = component.get("c.getTraineeForCertificate");
        action.setParams({
            "BookingId": bookingReqId
        });
        action.setCallback(this, function(a) {
            component.set("v.accounts", a.getReturnValue());
            //var jsonString = JSON.stringify(component.get('v.accounts'));
            
        });
        $A.enqueueAction(action);
    },
    
    showTraineeCertificate : function(component, event, helper) {
        //var currentTargetEvent = event.currentTarget;
        //var currentValue = currentTargetEvent.getAttribute("name");
        
        var accounts = component.get('v.accounts');
        
        for (var i = 0; i < accounts.length; i++) {
            var traineeId = accounts[i].Id;
            var exmReq = accounts[i].ETDI_Booking_Request__r.Exam_Required__c;
            console.log('traineeId: ' + traineeId);
            console.log('exmReq: ' + exmReq);
            var empId =  accounts[i].Employee__r.ETIN_Employee_Id__c;
            console.log('empId: ' + empId);
            if (exmReq == 'Yes') {
                var url = '/apex/Trainee_Professional_Certificate?id=' + traineeId+'&fileName=EmployeeCertificate_'+empId;
                window.open(url, "_blank");
            } else {
                var url = '/apex/Trainee_Certificate?id=' + traineeId;
                window.open(url, "_blank");
            }
        }
        
        
    }
})
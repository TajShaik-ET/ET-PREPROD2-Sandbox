({
   recordUpdate : function(component, event, helper) {
         component.set("v.studentRecord.ETST_School__c",component.get("v.studentRecord").ETST_School__c);
         component.set("v.serviceRecord.ETST_Student__c",component.get('v.recordId'));
         $A.createComponent(
            "c:ETST_AddStudentService",
            {
                "aura:id" : "studentDetailsCmp",
                "serviceRecord" : component.get('v.serviceRecord'),
                "studentRecord":  component.get('v.studentRecord'),
                "renewServiceModal":false,
                "coordinatorRequest":true,
                "isProcessed":component.get('v.isProcessed')
                
            },
            function(newcomponent){
                if (component.isValid()) {
                    var newCmp = component.find("cmpBody");
                    var body = newCmp.get("v.body");
                    body.push(newcomponent);
                    newCmp.set("v.body", body); 
                    component.set("v.isClose", true);        
                }
            }            
        );
    }

})
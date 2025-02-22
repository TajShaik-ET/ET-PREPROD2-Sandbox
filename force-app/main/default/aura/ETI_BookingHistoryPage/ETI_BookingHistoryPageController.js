({
    doinit:function(component, event, helper)
    {
        helper.setCommunityLanguage(component, event, helper); 
        $A.createComponent(
            "c:ETI_BookingHistory",
            {
                "aura:id" : "VehicleDetailsCmp"
            },
            function(newcomponent){
                if (component.isValid()) {
                    var newCmp = component.find("cmpBody");
                    var body = newCmp.get("v.body");
                    body.push(newcomponent);
                    newCmp.set("v.body", body); 
                }
            }            
        );
    }
    
})
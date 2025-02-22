({
    getFilterValuesHelper : function(component, event, helper){
        try{
            var utility = component.find("ETCAR_UtillityMethods");
            var backendMethod = "queryVehFilterValues";
            var params = {
                
            };
            var promise = utility.executeServerCall(component, backendMethod, params);
            promise.then (
                $A.getCallback(function(response) {
                    console.log('request Respone = '+ JSON.stringify(response));
                    component.set("v.segmentMap" , response.segmentMap);
                    component.set("v.vehTypesMap" , response.vehTypesMap);
                    component.set("v.segments" , response.segments);
                }),
                
                $A.getCallback(function(error) {
                    console.error('Error :'+error);
                    utility.showToast("ET Car SeSrvices", error, "error", "dismissible");
                })
            )
        }
        catch(error){
            alert(error.message);
        }
        
    },
})
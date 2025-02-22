({
    doInit : function(component) {
    	var recordID= component.get("v.recordId");
        var action= component.get("c.imageDisplayList");
        action.setParams({recordID:recordID});
        action.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log('CHECK RESULT VALUE-:'+result+'--');
                if(result==''){
                    console.log('NO RESULT');
                    component.set("v.isEmpty",true);
                    console.log('STATUS ISEMPTY:-'+component.get("v.isEmpty"));
                }else{
                    console.log('WITH RESULT');
                    var imageURL =[];
                    for(var i=0; i<result.length; i++){
                        console.log('I Value '+i+'  '+result[i]['Id']);
                        imageURL.push('/sfc/servlet.shepherd/version/download/'+result[i]['Id']);
                    }
                    //console.log('IMAGE URLS'+imageURL);
                    component.set("v.slides",imageURL);
                    
                }
                
            }
        }));
        $A.enqueueAction(action);
       
    	component.set("v.slides", [
            'https://icrm--preprod.lightning.force.com/lightning/r/ETM_Sales_Vehicle_Inventory__c/a3U3z000000dEMaEAM?'
        ]);
    },

	fullScreen : function(component) {
        component.set("v.fullScreen", true);
	},

	closeDialog : function(component) {
        component.set("v.fullScreen", false);
	}

})
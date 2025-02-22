({
    getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
    getJsonFromUrlSpea : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
    getJsonFromUrl1 : function (component, event, helper) {
        /* var query = location.search.substr(2);
            var result = {};
            query.split("&").forEach(function(part) {
                var item = part.split("=");
                result[item[0]] = decodeURIComponent(item[1]);
            });
            return result;*/
        try{
              var action = component.get("c.getChangelocation");
              action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returning = [];
                    var result = response.getReturnValue();
                    if(result != null && result != undefined && result != ''){
                         component.set("v.selectedEmirate", result.replace(/\s/g,''));
                    }
                }
            });
            $A.enqueueAction(action);
        }catch(err){
			alert(err.message)
        }
    },
     
})
({
    doInit : function(component, event, helper) {
        helper.getFilterValuesHelper(component, event, helper);
    },
    
	onsearchCars : function(component, event, helper) {
        
        // close the open sections:::  
        component.set("v.carTypesSection" , 'none');
        component.set("v.carModelsSection" , 'none');
		// get the Values selected  types 
		var selModels =  component.get("v.modelValue");
        var vehicleSegment =  component.get("v.segValue");
        var types =  component.get("v.typeValue");
        console.log('selected models = '+ selModels);
        console.log('selected vehicleSegment = '+ vehicleSegment);
        console.log('selected types = '+ types);
        debugger;
        //fire the Event
        var cmpEvent = component.getEvent("carFiltersEvent");
        // Get the value from Component and set in Event
        cmpEvent.setParams( { "carModels" : selModels,
                             "carTypes":types,
                             "carSegment":vehicleSegment
                            } );
        console.log('car models event Fired');
        cmpEvent.fire();
 
	},
    
    onSegmentSelection : function(component, event, helper) {
        // get Vehicle Types based on vehicle segment 
        //var segmentMap = new Map();
        //segmentMap.set();
        var segmentMap = component.get("v.segmentMap");
        var segment = event.getSource().get('v.value');
        console.log('segment = '+ segment);
        console.log('segmentMap = '+ JSON.stringify(segmentMap));
        if(segmentMap){
            Object.keys(segmentMap)
            .forEach(function eachKey(key) { 
                if(key ==segment ){
                    component.set("v.CarTypes" ,segmentMap[key]); 
                }
            });
            console.log('CarTypes = '+ JSON.stringify(component.get("v.CarTypes" )));
        }
        
    },
    
    onCarTypeSelection : function(component, event, helper) {
        var carType = event.getParam('value');
        console.log('sel Values = '+ carType);
        console.log('carType = '+ typeof carType);
        var sel_carTypeList = [] ;
        for(let i in carType) {
            var value = carType[i];
            sel_carTypeList.push(value);
        }
        console.log('sel_carTypeList = '+ JSON.stringify(sel_carTypeList));
        var vehTypesMap = component.get("v.vehTypesMap");
        console.log('vehTypesMap = '+ JSON.stringify(vehTypesMap));
        if(sel_carTypeList && sel_carTypeList.length>0){
            var carModels =[];
            for(var key in sel_carTypeList){
                console.log('key = '+key);
                console.log('sel_carTypeList[key] = '+sel_carTypeList[key]);
                if(vehTypesMap.hasOwnProperty(sel_carTypeList[key])){
                    carModels.push.apply(carModels,vehTypesMap[sel_carTypeList[key]]);
                }
            }
            component.set("v.CarModels" ,carModels); 
            console.log('CarModels = '+ JSON.stringify(component.get("v.CarModels")));
        }
    },
    
    handleClearFilters : function(component, event, helper) {
        component.set("v.modelValue",[]);
        component.set("v.typeValue",[]);
        component.set("v.segValue",[]);
        component.set("v.CarModels",[]);
        component.set("v.CarTypes",[]);
        // close the open sections:::  
        component.set("v.carTypesSection" , 'none');
        component.set("v.carModelsSection" , 'none');
        $A.get('e.force:refreshView').fire();
    },
})
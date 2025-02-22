({
    getItenaryDetailsfromURL : function(component, event, helper){
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
        for (i = 0; i < sURLVariables.length; i++) {

            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
            console.log('typeof ='+ typeof sParameterName);
            console.log('sParameterName '+i +' '+ sParameterName);
            if (sParameterName[0] === 'c__recId') { //lets say you are looking for param name - firstName  
                console.log('c__recId = '+ sParameterName[1]);
                component.set("v.leadId",sParameterName[1] );
            }
        }
    },
   
    getVehInfoHelper: function(component, event){
        var utility = component.find("ETM_utiliyMethods");
        component.set('v.loaded', !component.get('v.loaded'));
        var action = component.get("c.queryVehicleInfo");
        action.setParams({
            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state = '+ state);
            if (state === "SUCCESS") {
                component.set('v.loaded', !component.get('v.loaded'));
                var result = response.getReturnValue();
                console.log('result = ');
                console.log(result);
                var allresult = [];
                if(result){
                    if(result.length >0){
                        var maxPrice ;
                        var minPrice ; 
                        var maxKms ;
                        var minKms ;
                        maxPrice = result[0].Price
                        minPrice = result[0].Price; 
                        minKms   = result[0].KM;
                        maxKms	 = result[0].KM;
                        
                        for(var i=0; i< result.length; i++){
                            allresult.push(result[i]);
                            // Price
                            
                            if(result[i].Price){
                                if(result[i].Price > maxPrice){
                                    maxPrice =  result[i].Price;
                                }
                                if(result[i].Price < minPrice){
                                    minPrice =  result[i].Price;
                                }
                            }
                            
                            
                            // kms
                            if(result[i].KM){
                                
                                if(parseInt(result[i].KM) > maxKms){
                                    maxKms =  parseInt(result[i].KM);
                                }
                                if(parseInt(result[i].KM) < minKms){
                                    minKms =  parseInt(result[i].KM);
                                } 
                            }
                            
                        }
                        
                        // if minPrice & maxPrice are same in any case - Make minPrice = 0
                        if(minPrice  == maxPrice){
                            minPrice = 0;
                        }
                        component.set("v.minPrice",minPrice);
                        component.set("v.maxPrice",maxPrice);
                        
                        // if minKms & maxKms are same in any case - Make minKms = 0
                        if(minKms  == maxKms){
                            minKms = 0;
                        }
                        component.set("v.minKms",minKms);
                        component.set("v.maxKms",maxKms);
                        //Pagination attributes
                        var pageSize = component.get("v.pageSize");
                        var totalRecordsList = result;
                        var totalLength = totalRecordsList.length ;
                        component.set("v.totalRecordsCount", totalLength);
                        component.set("v.startPage",0);
                        component.set("v.endPage",pageSize-1);
                        component.set("v.data", allresult);
                        var PaginationLst = [];
                        for(var i=0; i < pageSize; i++){
                            if(component.get("v.data").length > i){
                                PaginationLst.push(result[i]);    
                            } 
                        }
                        component.set('v.PaginationList', PaginationLst);
                        component.set("v.selectedCount" , 0);
                        //use Math.ceil() to Round a number upward to its nearest integer
                        component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize));
                        component.set("v.searchResult", PaginationLst);
                    }
                }
            }
            
            else if (state === "ERROR") {
                
                var errors = response.getError();
                if (errors[0] && errors[0].message) {
                    // This is an error from the AuraHandledException
                    console.error('Error :'+errors[0].message);
                    utility.showToast("ET Moto","Internal Error. Please reach to Customer Services" , "error", "dismissible");
                    
                } else {
                    console.error('Error :'+errors[0].message);
                    utility.showToast("ET Moto","Internal Error. Please reach to Customer Services" , "error", "dismissible");
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    
    next : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        console.log('end >>' +end);
        console.log('start >>' +start);
        for(var i = end + 1; i < end + pageSize + 1; i++){
            if(sObjectList.length > i){ 
                if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{
                    Paginationlist.push(sObjectList[i]);  
                }
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
         console.log('on click end >>' +end);
        console.log('on click start >>' +start);
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set('v.searchResult', Paginationlist);
    },
    // navigate to previous pagination record set   
    previous : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{
                    Paginationlist.push(sObjectList[i]); 
                }
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set('v.searchResult', Paginationlist);
    },
    
    addVehicle : function(component, event, records,helper){
        var utility = component.find("ETM_utiliyMethods");
        var action = component.get("c.createTestDrives");
        var leadId = component.get("v.leadId");
        action.setParams({
            'testDrveRecs': records,
            'leadId' : leadId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result=response.getReturnValue();
                if(result == true){
                    utility.showToast("ET Moto", "Test Drive created Successfully", "success", "dismissible");
                    //navigate to lead record Page 
                    helper.navigateTo(component,helper,'standard__recordPage','view', 'Lead',leadId);
                }
                else{
                    //helper.showToast("Error", 'Internal Error. Please reach to Customer Services', "error", "dismissible");
                }
            } 
            else if (state === "ERROR") {
                
                var errors = response.getError();
                if (errors[0] && errors[0].message) {
                    // This is an error from the AuraHandledException
                    console.error('Error :'+errors[0].message);
                    utility.showToast("ET Moto","Internal Error. Please reach to Customer Services" , "error", "dismissible");
                    
                } else {
                    console.error('Error :'+errors[0].message);
                    utility.showToast("ET Moto","Internal Error. Please reach to Customer Services" , "error", "dismissible");
                }
                
            }
        });  
        $A.enqueueAction(action);
       // $A.get('e.force:refreshView').fire();
    },
    
    getFiltersInfoHelper :function(component, event, helper){
        var utility = component.find("ETM_utiliyMethods");
        var backendMethod = "queryVehFilters";
        var params = {
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                console.log('response  = '+ JSON.stringify(response));
                var vehTypesList =[];
                var vehMakesList =[];
                var vehModelsList =[];
                var vehFamiliesList =[];
                var vehNumbersList =[];
                if(response != null){
                    vehTypesList = response.vehTypes;
                    vehMakesList =response.vehMakes;
                    vehModelsList =response.vehModels;
                    vehFamiliesList =response.vehFamilies;
                    vehNumbersList =response.vehNumbers;
                    component.set("v.vehTyeMakeMap" , response.vehTyeMakeMap);
                    component.set("v.vehMakeFamilyMap" , response.vehMakeFamilyMap);
                }
                if(vehTypesList != null && vehTypesList.length >0){
                    var vehOptions=[];
                    for(let i in vehTypesList){
                        vehOptions.push({label:vehTypesList[i], value:vehTypesList[i]});  
                    }
                    component.set("v.vehTypes",vehOptions );
                    console.log(JSON.stringify(component.get("v.vehTypes")));
                }
                
                if(vehMakesList != null && vehMakesList.length >0){
                    var vehMakesOptions=[];
                    for(let i in vehMakesList){
                        vehMakesOptions.push({label:vehMakesList[i], value:vehMakesList[i]});  
                    }
                    component.set("v.vehMakes",vehMakesOptions );
                    console.log(JSON.stringify(component.get("v.vehMakes")));
                }
                
                if(vehModelsList != null && vehModelsList.length >0){
                    var vehModelsOptions=[];
                    for(let i in vehModelsList){
                        vehModelsOptions.push({label:vehModelsList[i], value:vehModelsList[i]});  
                    }
                    component.set("v.vehModels",vehModelsOptions );
                    console.log(JSON.stringify(component.get("v.vehModels")));
                }
                
                if(vehFamiliesList != null && vehFamiliesList.length >0){
                    var vehFamiliesOptions=[];
                    for(let i in vehFamiliesList){
                        vehFamiliesOptions.push({label:vehFamiliesList[i], value:vehFamiliesList[i]});  
                    }
                    component.set("v.vehFamilies",vehFamiliesOptions );
                    console.log(JSON.stringify(component.get("v.vehFamilies")));
                }
                
                if(vehNumbersList != null && vehNumbersList.length >0){
                    var vehNumbersOptions=[];
                    for(let i in vehNumbersList){
                        vehNumbersOptions.push({label:vehNumbersList[i], value:vehNumbersList[i]});  
                    }
                    component.set("v.vehNumbers",vehNumbersOptions );
                    console.log(JSON.stringify(component.get("v.vehNumbers")));
                }
                
            }),
            
            $A.getCallback(function(error) {
                console.error(error);
                utility.showToast("ET Moto", error, "error", "dismissible");
            })
        )
    },
    
    /* Method : reconfigPagination
       Description : To Reconfigure Pagination attributes on selecting the filters
       */
    
    reconfigPagination : function(component, event, helper,result ){
        var pageSize = component.get("v.pageSize");
        component.set("v.startPage",0);
        component.set("v.endPage",pageSize-1);
        component.set("v.selectedCount" , 0);
        if(result != null || result != undefined){
            var totalRecordsList = result;
            var totalLength = totalRecordsList.length ;
            component.set("v.totalRecordsCount", totalLength);
            component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize));
        }
        
    },
    
    navigateTo : function(component,helper,type,actionName, objectApiName,recordId){
         debugger;
        var navLink = component.find("navLink");
        var pageRef = {
            type: type,
            attributes: {
                actionName: actionName,
                objectApiName: objectApiName,
                recordId : recordId
            },
        };
        navLink.navigate(pageRef, true);
    },
        
    
    
})
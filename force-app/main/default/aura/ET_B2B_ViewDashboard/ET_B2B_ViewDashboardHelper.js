({
	getResourceData : function(component, event, helper) {        
       
        var action = component.get('c.getAssignedResources');  
         action.setParams({
                AccountId:  component.get("v.currentaccountId"),
               showAllAcc : component.get("v.showAll")
            });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue();
               
                component.set("v.resourcesCount",data.length);
                component.set("v.resourceData",data);
                console.log('resourceData: ' + JSON.stringify(data));
                try{
                    var result = data.reduce(function(r, o) {
                        r[o.Sales_Agreement__r.Customer_PO_No__c] = (r[o.Sales_Agreement__r.Customer_PO_No__c] || 0) + 1 ;
                        return r;
                    }, []);
               
                    
                    helper.showChart(result);
                    
                }catch(e){
                    
                    console.log(e.message);
                }
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);  
		
	},
    
    getVehiclesData : function(component, event, helper) {        
       
        var action = component.get('c.getAssignedVehicles'); 
         action.setParams({
                AccountId:  component.get("v.currentaccountId"),
               showAllAcc : component.get("v.showAll")
            });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue();
                component.set("v.vehiclesCount",data.length);
                component.set("v.vehicleData",data);
               console.log('vehicleData: ' + JSON.stringify(data));

                
                try{
                    var result = data.reduce(function(r, o) {
                        r[o.Sales_Agreement__r.Customer_PO_No__c] = (r[o.Sales_Agreement__r.Customer_PO_No__c] || 0) + 1 ;
                        return r;
                    }, []);
                    
                                    
                    helper.showChart5(result);
                    
                }catch(e){
                    
                    console.log(e.message);
                }
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);  
		
	},
    
    showChart : function(result) {
       
               var labelset=[] ;
                var dataset=[] ;
                    Object.keys(result).forEach(function (key) {
                        labelset.push(key);
                        dataset.push(result[key]);
                    });
        let colors=[];
       
        for(let i=0;i<labelset.length;i++){
            colors.push('#'+Math.floor(Math.random()*16777215).toString(16));
        }
         
                new Chart(document.getElementById("resources"), {
                    type: 'pie',
                    data: {
                        labels:labelset,
                        datasets: [{
                            label: "No. of resources",
                            backgroundColor: colors, //["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
                            data: dataset
                        }]
                    },
                    options: {
                        title: {
                            display: true,
                            text: 'No. of resources by contract'
                        }
                    }
                });
        
    },
     showChart2 : function(result) {
      
               var labelset=[] ;
                var dataset=[] ;
         
         try{                           
                 Object.keys(result).forEach(key => { 
                        console.log(key)
                       labelset.push(key);
                       dataset.push(result[key]);
                    });
                     
                     let colors=[];       
                     for(let i=0;i<labelset.length;i++){
                     colors.push('#'+Math.floor(Math.random()*16777215).toString(16));
                     }
              
                new Chart(document.getElementById("resources2"), {
                    type: 'doughnut',
                    data: {
                        labels:labelset,
                       
                        datasets: [{
                            label: "No. of resources",
                            backgroundColor: colors, //["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
                            data: dataset
                           
                        }]
                    },
                    options: {
                        title: {
                            display: true,
                            text: 'No. of resources by Type'
                        }
                    }
                });
             
         }catch(e){
             
             console.log(e.message)
         }
        
    },
     showChart31 : function(result) {
      
               var labelset=[] ;
                var dataset=[] ;
         
         try{                           
                 Object.keys(result).forEach(key => { 
                        console.log(key)
                       labelset.push(key);
                       dataset.push(result[key]);
                    });
                     
                     let colors=[];       
                     for(let i=0;i<labelset.length;i++){
                     colors.push('#'+Math.floor(Math.random()*16777215).toString(16));
                     }
              
                new Chart(document.getElementById("resources3"), {
                    type: 'doughnut',
                    data: {
                        labels:labelset,
                       
                        datasets: [{
                            label: "No. of resources",
                            backgroundColor: colors, //["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
                            data: dataset
                           
                        }]
                    },
                    options: {
                        title: {
                            display: true,
                            text: 'No. of resources by Employee Category'
                        }
                    }
                });
             
         }catch(e){
             
             console.log(e.message)
         }
        
    },
    showChart3 : function(result) {
      
               var labelset=[] ;
                var dataset=[] ;
         
         try{                           
                 Object.keys(result).forEach(key => { 
                        
                       labelset.push(key);
                       dataset.push(result[key]);
                    });
                 let colors=[];       
                     for(let i=0;i<labelset.length;i++){
                     colors.push('#'+Math.floor(Math.random()*16777215).toString(16));
                     }     
              
                new Chart(document.getElementById("vehicles"), {
                    type: 'pie',
                    data: {
                        labels:labelset,
                        datasets: [{
                            label: "No. of Vehicles by Type",
                            backgroundColor:colors,// ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
                            data: dataset
                        }]
                    },
                    options: {
                        title: {
                            display: true,
                            text: 'No. of Vehicles by Type'
                        }
                    }
                });
             
         }catch(e){
             
             console.log(e.message)
         }
        
    },
     showChart4 : function(result) {
      
               var labelset=[] ;
                var dataset=[] ;
         
         try{                           
                 Object.keys(result).forEach(key => { 
                      
                       labelset.push(key);
                       dataset.push(result[key]);
                    });
                     
                 let colors=[];       
                     for(let i=0;i<labelset.length;i++){
                     colors.push('#'+Math.floor(Math.random()*16777215).toString(16));
                     }     
              
                new Chart(document.getElementById("vehicles2"), {
                    type: 'doughnut',
                    data: {
                        labels:labelset,
                        datasets: [{
                            label: "No. of Vehicles by Status",
                            backgroundColor: colors,//["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
                            data: dataset
                        }]
                    },
                    options: {
                        title: {
                            display: true,
                            text: 'No. of Vehicles by Status'
                        }
                    }
                });
             
         }catch(e){
             
             console.log(e.message)
         }
        
    },
    showChart5 : function(result) {
      
               var labelset=[] ;
                var dataset=[] ;
         
         try{                           
                 Object.keys(result).forEach(key => { 
                       
                       labelset.push(key);
                       dataset.push(result[key]);
                    });
              let colors=[];       
                     for(let i=0;i<labelset.length;i++){
                     colors.push('#'+Math.floor(Math.random()*16777215).toString(16));
                     } 
                new Chart(document.getElementById("vehicles3"), {
                    type: 'doughnut',
                    data: {
                        labels:labelset,
                        datasets: [{
                            label: "No. of Vehicles by Contract",
                            backgroundColor: colors,//["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
                            data: dataset
                        }]
                    },
                    options: {
                        title: {
                            display: true,
                            text: 'No. of Vehicles by Contract'
                        }
                    }
                });
             
         }catch(e){
             
             console.log(e.message)
         }
        
    }
    
    
})
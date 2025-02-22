({
    getExecutedTripsData : function(component, event, helper) {        
        
        let schName = component.get("v.selectedSchName"); 
        let schlist = component.get("v.selectedSchList");
        if(schName)
            schlist.push(schName);
       
        
        var action = component.get('c.getExecTripDetails');  
        action.setParams({               
            schoolList: schlist,
            fromDate:component.get("v.fromDate"),
            toDate:component.get("v.toDate")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue();
                console.log(data)
                try{      
                    component.set("v.MrngTripCount","0");
                    component.set("v.EvngTripCount","0");
                    data.forEach(function(item){
                        
                        if(item.morning){
                            component.set("v.MrngTripCount",item.countVal)
                        }else{
                            component.set("v.EvngTripCount",item.countVal)
                        }
                    });
                    
                }catch(e){
                    console.log(e.message)
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
        
        try{       
            
            result.forEach(function(item){
                
                if(item.morning){
                    labelset.push('Morning');
                    dataset.push(item.countVal);
                }else{
                    labelset.push('Evenning');
                    dataset.push(item.countVal);
                }
                
                
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
        
    },
    getSeatOccupiedInfo : function(component, event, helper) {        
        
        var action = component.get('c.getSeatOccupiedDetails');  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue();
                //console.log(data)
                component.set("v.avgSeatsOcc",data.avgVal.toFixed(2));
                
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
    
    getTripsMoreThanBeforeInfo : function(component, event, helper) {        
        
        let schName = component.get("v.selectedSchName");       
        let showAll =  component.get("v.showAll");
        let schlist = component.get("v.selectedSchList");
        if(schName)
          schlist.push(schName);        
       
        var action = component.get('c.getTripsMoreThanBefore');  
        action.setParams({               
            schoolList: schlist,
            fromDate:component.get("v.fromDate"),
            toDate:component.get("v.toDate")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue();
                console.log(data)
                component.set("v.tripsStartedB46Am",data.countVal);
                
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
    getKGTripsMoreThan45Info : function(component, event, helper) {        
        
        let schName = component.get("v.selectedSchName");       
        let schlist = component.get("v.selectedSchList");
        if(schName)
            schlist.push(schName);       
       
        var action = component.get('c.getKGTripsMoreThan45');  
        action.setParams({               
            schoolList: schlist,
            fromDate:component.get("v.fromDate"),
            toDate:component.get("v.toDate")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue();
                
                component.set("v.kgStuTripMoreThan45",data.countVal);
                
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
    getTripsDuration60_75Info : function(component, event, helper) {        
        
        let schName = component.get("v.selectedSchName");       
        let schlist = component.get("v.selectedSchList");
        if(schName)
            schlist.push(schName);
       
        var action = component.get('c.getTripsDuration60_75');  
        action.setParams({               
            schoolList: schlist,
            fromDate:component.get("v.fromDate"),
            toDate:component.get("v.toDate")           
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue();
                
                component.set("v.TripsDuration60_75",data.countVal);
                
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
    getTripsDurationMore75Info : function(component, event, helper) {        
        
        let schName = component.get("v.selectedSchName");       
        let schlist = component.get("v.selectedSchList");
        if(schName)
            schlist.push(schName);
       
        var action = component.get('c.getTripsDurationMore75');  
        action.setParams({               
            schoolList: schlist,
            fromDate:component.get("v.fromDate"),
            toDate:component.get("v.toDate") 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue();
                
                component.set("v.TripsDurationMore75",data.countVal);
                
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
    getTotalStudentRegInfo : function(component, event, helper) {        
        
        let schName = component.get("v.selectedSchName");       
        let schlist = component.get("v.selectedSchList");
        if(schName)
            schlist.push(schName);
        
        var action = component.get('c.getTotalStudentRegistrations');  
        action.setParams({               
            schoolList: schlist           
        });
        component.set("v.totalStudents","0");  
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue();  
               
                if(data.countVal)
                component.set("v.totalStudents",data.countVal);               
                
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
    getBusCountFromTripsInfo : function(component, event, helper) {        
        
        let schName = component.get("v.selectedSchName");       
        let schlist = component.get("v.selectedSchList");
        if(schName)
            schlist.push(schName);       
        var action = component.get('c.getBusCountFromTrips');  
        action.setParams({               
            schoolList: schlist,
            fromDate:component.get("v.fromDate"),
            toDate:component.get("v.toDate") 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue();
                console.log(data)
                component.set("v.noOfBuses",data.countVal);
                
                
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
    getSchoolInfo : function(component, event, helper) {        
        
        var action = component.get('c.getSchoolList');  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue();
                let stationCode = [];
                let schoolList = [];
                component.set("v.schoolList",data);
                data.forEach(function(item){
                    stationCode.push(item.Station_Code__c);
                    schoolList.push(item.Name);
                });
                
                let stationCodeSet = [...new Set(stationCode)];
                component.set("v.schoolNames",schoolList.sort());
                component.set("v.stationCodeList",stationCodeSet.sort());
                //console.log(stationCode)
                //console.log(uniqueArray)
                
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
    getTotalStuWhatsappReqInfo : function(component, event, helper) {        
        
        var action = component.get('c.getTotalStuWhatsappReq');  
        action.setParams({           
            fromDate:component.get("v.fromDate"),
            toDate:component.get("v.toDate") 
        });
        component.set("v.totalStudentReg","0");
        action.setCallback(this, function(response) {           
            var state = response.getState();             
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue(); 
                if(data.stuSum)
                component.set("v.totalStudentReg",data.stuSum);               
                
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
    
    emptyAllValues : function(component, event, helper) {   
        
        component.set("v.MrngTripCount","0");
        component.set("v.EvngTripCount","0");
        component.set("v.tripsStartedB46Am","0");
        component.set("v.kgStuTripMoreThan45","0");
        component.set("v.TripsDuration60_75","0");
        component.set("v.TripsDurationMore75","0");
        component.set("v.totalStudents","0");
        component.set("v.noOfBuses","0");
       
        
        
    }
    
    
})
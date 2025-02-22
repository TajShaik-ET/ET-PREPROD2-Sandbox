({
	scriptsLoaded : function(component, event, helper) {            
       console.log('child---'+component.get("v.currentaccountId"))
        console.log('child---'+component.get("v.showAll"))
       
        helper.getResourceData(component, event, helper);
        helper.getVehiclesData(component, event, helper);
      /*  try{
        const ctx = document.getElementById('myChart').getContext('2d');
        const myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
                datasets: [{
                    label: '# of Votes',
                    data: [12, 19, 3, 5, 2, 3],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)',
                        'rgba(255, 159, 64, 0.2)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
        }catch(e){
            console.log(e.message)
        }*/
	},
    onResourceChangeHandler : function(component, event, helper) { 
      let type = component.find('selectResource').get('v.value');
      
      let data = component.get('v.resourceData');
       
        if(type == 'By Employee Type'){
            
             try{
                var result = data.reduce(function(r, o) {
                    r[o.Employee_Type__c] = (r[o.Employee_Type__c] || 0) + 1 ;
                    return r;
                }, {});
                
                helper.showChart2(result);
                
            }catch(e){
                
                console.log(e.message);
            }
        }
          if(type == 'By Employee Catogery'){
            
             try{
                var result = data.reduce(function(r, o) {
                    r[o.Driver_Category__c] = (r[o.Driver_Category__c] || 0) + 1 ;
                    return r;
                }, {});
                
                helper.showChart31(result);
                
            }catch(e){
                
                console.log(e.message);
            }
        }
        if(type =='By Contracts'){
          
             var result = data.reduce(function(r, o) {
                    r[o.Sales_Agreement__r.Customer_PO_No__c] = (r[o.Sales_Agreement__r.Customer_PO_No__c] || 0) + 1 ;
                    return r;
                }, {});
                
                helper.showChart(result);
        }
    },
    
    onVehicleChangeHandler : function(component, event, helper) { 
    
         let type = component.find('selectVehicle').get('v.value');
         let data = component.get('v.vehicleData');
        if(type == 'By Status'){
            
             var result = data.reduce(function(r, o) {
                    r[o.Vehicle_Status__c] = (r[o.Vehicle_Status__c] || 0) + 1 ;
                    return r;
                }, {});
                
                helper.showChart4(result);
        }
        if(type == 'By Vehicle Type'){
            
             var result = data.reduce(function(r, o) {
                    r[o.Vehicle_Type__c] = (r[o.Vehicle_Type__c] || 0) + 1 ;
                    return r;
                }, {});
                
                helper.showChart3(result);
        }
         
    }
    
    
})
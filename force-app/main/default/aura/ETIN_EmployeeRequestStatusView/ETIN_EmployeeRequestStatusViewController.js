({
	doInit : function(component, event, helper) {
        
        
		
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        
    /*   var exeAction = component.get("c.getEmpIRequestsDetails");
        exeAction.setParams({ 
            
            "userId":userId
            
        });
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                console.log('Ins--'+JSON.stringify(res));
                component.set("v.Insurancedata",res);
                 component.set('v.InsCurrentdata',res);               
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        ); 
        
        var exeAction = component.get("c.getEmpCaseDetails");
        exeAction.setParams({ 
            
            "userId":userId
            
        });
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                //console.log('Case--'+JSON.stringify(res));
                
                component.set("v.Casesdata",res);
           
                component.set('v.CaseCurrentData',res);
                 
            }
        ).catch(
            function(error) {
                
                //console.log('Error---'+JSON.stringify(error));
            }
        ); */
        
        var exeAction = component.get("c.geDetails");
        exeAction.setParams({ 
            
            "userId":userId
            
        });
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                //console.log('Merge--'+JSON.stringify(res));
                  component.set('v.WrapperList',res.sort(function(a, b) {
                    var dateA = new Date(a.dateRes), dateB = new Date(b.dateRes);
                    return  dateB - dateA;
                }));   
                 component.set('v.WrapperListFiltered',res.sort(function(a, b) {
                    var dateA = new Date(a.dateRes), dateB = new Date(b.dateRes);
                    return  dateB - dateA;
                })); 
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        ); 
                          
       
	},
    searchRequest : function(component, event, helper) {
        var searchKey=component.get('v.searchText').toLowerCase(); //.toLowerCase();
        
        if(searchKey.length>2){
            
             var reqData = component.get('v.WrapperList');
            //console.log('tttt'+JSON.stringify(reqData));
           var fileredData =  reqData.filter(function(item) {
              
                 return (item.RefNum.toLowerCase().indexOf(searchKey) !== -1) || (item.FirstName.toLowerCase().indexOf(searchKey) !== -1) || (item.LastName.toLowerCase().indexOf(searchKey) !== -1);
                 //return (item.FirstName.toLowerCase().indexOf(searchKey) !== -1);
                  
             });
           component.set('v.WrapperListFiltered',fileredData); 
            
         /*  var reqData = component.get('v.Casesdata');
            var reqData2 = component.get('v.Insurancedata');
            
             var fileredData =  reqData.filter(function(item) {
               
                return (item.CaseNumber.toLowerCase().indexOf(searchKey) !== -1)||
                (item.Insurance__r.First_Name__c.toLowerCase().indexOf(searchKey) !== -1)||
                (item.Insurance__r.Last_Name__c.toLowerCase().indexOf(searchKey) !== -1);
            });
            
            var fileredData2 =  reqData2.filter(function(item) {
               
                return (item.Name.toLowerCase().indexOf(searchKey) !== -1)||
                (item.First_Name__c.toLowerCase().indexOf(searchKey) !== -1)||
                (item.Last_Name__c.toLowerCase().indexOf(searchKey) !== -1);
            });
            
            console.log(JSON.stringify(component.get('v.CaseCurrentData')));
            component.set('v.CaseCurrentData',fileredData);
            component.set('v.InsCurrentdata',fileredData2); */
            
        }else {
            
             var data = component.get('v.WrapperList');
             component.set('v.WrapperListFiltered',data);
            /*
            var reqData = component.get('v.Casesdata');
            var reqData2 = component.get('v.Insurancedata');
            component.set('v.InsCurrentdata',reqData2);
            component.set('v.CaseCurrentData',reqData);
            */
        }      
        
        
    }
})
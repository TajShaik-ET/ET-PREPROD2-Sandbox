({
    doInit : function(component, event, helper)  {
        component.set('v.loadedDashboard',false);
        var exeAction = component.get("c.getBusinessType");
        exeAction.setParams({
            
        });
        this.serverSideCall(component,exeAction).then(
            function(response) {
                component.set('v.accountRec',response);//.RecordType.DeveloperName);
                if(response.ETST_Account_Type__c=='Government School'){
                    component.set('v.govtSchool',true);
                }
                
                component.set('v.loadedDashboard',true);
            }
        ).catch(
            function(error) {
                component.set('v.loadedDashboard',true);
                console.log('Error---'+JSON.stringify(error));
            }
        );
    }, 
    getSchoolDetails : function(component, event, helper)  {
        component.set('v.loaded',false);
        var exeAction = component.get("c.getDashboardData");
        exeAction.setParams({
            
        });
        this.serverSideCall(component,exeAction).then(
            function(response) {
                component.set('v.activeSalesAgreements', response.salesCount);
                component.set('v.activeVehicles', response.vehileCount);
                component.set('v.activeResources', response.resourceCount);
                component.set('v.activeInvoices', response.invCount);
                component.set('v.activeSchools', response.schoolsCount);
                component.set('v.activeStudents', response.studentsCount);                
                component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                component.set('v.loaded',true);
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
   getStudentListHelper  : function(component, event, helper)  {
       component.set('v.loaded',false);
        var exeAction = component.get("c.getStudentList");
        exeAction.setParams({
            
        });
        this.serverSideCall(component,exeAction).then(
            function(response) {
                component.set('v.studentsList', response);
                
                component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                component.set('v.loaded',true);
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    getResourceListHelper: function(component, event, helper)  {
        component.set('v.loaded',false);
        var exeAction = component.get("c.getResourceList");
        exeAction.setParams({
            
        });
        this.serverSideCall(component,exeAction).then(
            function(response) {
                component.set('v.resourceList', response);
                component.set('v.currentResourceList', response);
                component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                component.set('v.loaded',true);
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    
    getSAListHelper: function(component, event, helper)  {
        component.set('v.loaded',false);
        var exeAction = component.get("c.getSAList");
        exeAction.setParams({
            
        });
        this.serverSideCall(component,exeAction).then(
            function(response) {
                component.set('v.SAList', response);
                component.set('v.currentSAList', response);
                component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                component.set('v.loaded',true);
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    getInvoiceListHelper : function(component, event, helper)  {
        component.set('v.loaded',false);
        var exeAction = component.get("c.getvehicleList");
        
        exeAction.setParams({
            
        });
        this.serverSideCall(component,exeAction).then(
            function(response) {
                component.set('v.invoiceList', response);
                 component.set('v.currentInvoiceList', response);
                component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                component.set('v.loaded',true);
                console.log('Error---'+JSON.stringify(error));
            }
        );
    }, 
    getSchoolListHelper : function(component, event, helper)  {
        component.set('v.loaded',false);
        var exeAction = component.get("c.getSchoolList");
        exeAction.setParams({
            
        });
        this.serverSideCall(component,exeAction).then(
            function(response) {
                component.set('v.schoolsList', response);
                 component.set('v.currentSchoolsList', response);
                component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                component.set('v.loaded',true);
                console.log('Error---'+JSON.stringify(error));
            }
        );
    }, 
    getvehicleListHelper  : function(component, event, helper)  {
        component.set('v.loaded',false);
        var exeAction = component.get("c.getvehicleList");
        exeAction.setParams({
            
        });
        this.serverSideCall(component,exeAction).then(
            function(response) {
                component.set('v.vehicleList', response);
                 component.set('v.currentVehicleList', response);
                component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                component.set('v.loaded',true);
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },  
    serverSideCall : function(component,action) {
        
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, 
                               function(response) {
                                   
                                   var state = response.getState();
                                   console.log(state);
                                   if (state === "SUCCESS") {
                                       resolve(response.getReturnValue());
                                   } else {
                                       reject(new Error(response.getError()));
                                   }
                               }); 
            $A.enqueueAction(action);
        });
    },
    resetValues: function(component) {
        component.set('v.isStudent',false);	
        component.set('v.dashBoardView',false);
        component.set('v.isResource',false);
        component.set('v.isVehicle',false);
        component.set('v.isSA',false);	 
        component.set('v.isInvoice',false);	 
        component.set('v.isSchool',false);	 
    }
})
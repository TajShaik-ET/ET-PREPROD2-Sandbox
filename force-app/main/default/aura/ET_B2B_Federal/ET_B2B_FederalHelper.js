({
    getDetails : function(component, event, helper)  {
         component.set('v.loadedDashboard',false);
        var exeAction = component.get("c.getDashboardData");
        exeAction.setParams({
            
        });
        this.serverSideCall(component,exeAction).then(
            function(response) {
                component.set('v.activeSalesAgreements', response.salesCount);
                component.set('v.activeEstimations', response.estCount);
                component.set('v.activeInvoices', response.invCount);
                component.set('v.loadedDashboard',true);
            }
        ).catch(
            function(error) {
                component.set('v.loadedDashboard',true);
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
        var exeAction = component.get("c.getInvoiceListHelper");
        
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
    getEstimationsListHelper  : function(component, event, helper)  {
        component.set('v.loaded',false);
        var exeAction = component.get("c.getEstimationsList");
        exeAction.setParams({
            
        });
        this.serverSideCall(component,exeAction).then(
            function(response) {
                component.set('v.estList', response);
                component.set('v.currentEstList', response);
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
        component.set('v.dashBoardView',false);
        component.set('v.isEstimation',false);
        component.set('v.isSA',false);	 
        component.set('v.isInvoice',false);	 
         
    }
})
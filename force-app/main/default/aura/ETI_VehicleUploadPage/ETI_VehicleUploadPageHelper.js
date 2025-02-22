({
	doInit : function(component, event, helper)  {
        //component.set('v.loaded',false);
		var exeAction = component.get("c.getUserFiles");
        exeAction.setParams({
           
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                 for(var i = 0; i < res.length; i++){
                        var row = res[i];
                        //row.navUrl='/'+row.Id;
                        //if(row.ContentDocument) row.Title = row.ContentDocument.Title;
                        //if(row.ContentDocument) row.CreatedDate = row.ContentDocument.CreatedDate;
                        if(row.ETI_User__c) row.userName = row.ETI_User__r.Name;           
                         
                   }
                    component.set("v.data", res); 
                    
                //component.set('v.zoneList',res.zoneList);
                component.set('v.currentData',res);
                component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                component.set('v.loaded',true);
                console.log('getUserFiles Error---'+JSON.stringify(error));
            }
        );
    }, 
    
    
    serverSideCall : function(component,action) {
        
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, 
                               function(response) {
                                   
                                   var state = response.getState();
                                   // console.log(state);
                                   if (state === "SUCCESS") {
                                       resolve(response.getReturnValue());
                                   } else {
                                       reject(new Error(response.getError()));
                                   }
                               }); 
            $A.enqueueAction(action);
        });
    },
    viewDocument : function(component, row, helper)  {
        console.log('--viewDocument---'+row.ETI_File_Id__c)
        var exeAction = component.get("c.getFileUrl");
        exeAction.setParams({
            "docId": row.ETI_File_Id__c
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                //alert(res);
                window.open(component.get('v.prefixURL')+res);
                // component.set('v.fileURL',component.get('v.prefixURL')+response);
                /*var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": component.get('v.prefixURL')+res
                });
                urlEvent.fire();*/
            }
        ).catch(
            function(error) {
                console.log('viewDocument Error---'+JSON.stringify(error));
            }
        );
    }, 
    uploadDocument : function(component, row, helper)  {
        console.log('--uploadDocument---'+row.ETI_User__c)
        var exeAction = component.get("c.uploadFile");
        exeAction.setParams({
            "docId": row.ETI_File_Id__c,
            "userId": row.ETI_User__c
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                alert(res);
            }
        ).catch(
            function(error) {
                console.log('uploadDocument Error---'+JSON.stringify(error));
            }
        );
    }, 
    
})
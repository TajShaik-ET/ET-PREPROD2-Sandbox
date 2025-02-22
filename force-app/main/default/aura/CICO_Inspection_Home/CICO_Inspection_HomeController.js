({
    doInit : function(component, event, helper) {
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        
        component.set('v.profileUrl','/s/profile/'+userId);
        helper.getIntimationDetails(component, event, helper);
        helper.getUserLoginDetails(component, event, helper);
        helper.getUserLoginInformation(component, event, helper);
        
        let device = $A.get("$Browser.formFactor");
        console.log(device);
        
        component.set('v.device',device);
        if(device === 'PHONE'){
            component.set('v.corousalSize',4);
            
        }else {
            component.set('v.corousalSize',4);
        }
        
        if (navigator.geolocation) {
            
            navigator.geolocation.getCurrentPosition(function (p) {
                //alert(p.coords.latitude+'--'+p.coords.longitude);
            });
        }else {
            alert('Geo Location feature is not supported in this browser.');
        }
        
        
    },
    
    
    
    handleLogout : function(component, event, helper) {
        //$A.get("e.force:logout").fire();
        component.set("v.ShowSpinner",true);
        window.location.replace("/CICO/secur/logout.jsp?retUrl=/CICO/s/login");
    },
    
    
    
    VehicleRowClick : function(component, event, helper) {
        
        var vehId = event.currentTarget.dataset.filename;
        var vehType = event.currentTarget.dataset.id;
        component.set("v.assetType",vehType);  
        component.set("v.vehicelSpecId",vehId);
        component.set("v.toggleIntimationList",false);
        component.set("v.toggleInspectionForm",true);
        helper.doInitCanvasHelper(component, event, helper);
        
    },
    
    goToHomePageParent :function(component, event, helper) {
        
        component.set("v.toggleInspectionForm",false);
        component.set("v.toggleIntimationList",true);
        component.set("v.intimationLinesData",null);
        helper.getIntimationDetails(component, event, helper);
        
        
    },
    sortIntimationList : function(component, event, helper) {
        
        var keyword = component.get("v.searchKeyWord");
        var searchKey = keyword.toLowerCase()
        try{
            if(searchKey.length>2){
                var reqData =component.get("v.intimationList");
                var tempdata= [];
                
                tempdata = reqData.filter(function(item){
                    return (item.Intimation_No__c.toLowerCase().indexOf(searchKey) !== -1)
                });
                if(tempdata){
                    component.set("v.CarousalintimationList",tempdata);
                }
                
            }else{
                var reqData =component.get("v.intimationList");
                var start=component.get('v.start');
                var corousalSize=component.get('v.corousalSize');
                //start+=corousalSize;
                
                if(reqData.length > corousalSize){
                    
                    component.set("v.CarousalintimationList",reqData.slice(start,start+corousalSize));
                }else{
                    
                    component.set("v.CarousalintimationList",reqData);
                }
                
            }
        }catch(e){
            console.log('--err--'+e +'line'+e.stack);
        }
    },
    
    /* sortIntimationList : function(component, event, helper) {
        
        var keyword = component.get("v.searchKeyWord");
        var searchKey = keyword.toLowerCase()
        try{
            if(searchKey.length>2){
               
                var reqData =component.get("v.intimationList");
                var tempdata= [];
                
                for (var i = 0; i < reqData.length; i++) {
                    
                    for(var j = 0; j < reqData[i].Intimation_Lines.records.length; j++){
                        
                        for(var k = 0; k < reqData[i].Intimation_Lines.records[j].Vehicle_Spec__r.records.length; k++){
                            tempdata.push(reqData[i].Intimation_Lines.records[j].Vehicle_Spec__r.records[k]);
                        }
                        
                        
                    }
                }
                tempdata = tempdata.filter(function(item){
                    return (item.Name.toLowerCase().indexOf(searchKey) !== -1)
                });
                
                console.log(tempdata);
                if(tempdata){
                    
                    component.set('v.FilteredData',tempdata);
                    component.set('v.toggleIntimationView',false);
                }else {
                    console.log('else')
                    
                    component.set('v.FilteredData',null);
                    component.set('v.toggleIntimationView',true);
                }
                
            }else {
                 
                component.set('v.FilteredData',null);
                component.set('v.toggleIntimationView',true);
                
            }
        }catch(e){
            console.log('--err--'+e +'line'+e.stack);
        }
    },*/
    
    submitIntimation : function(component, event, helper) {
        
        component.set("v.ShowSpinner",true);
        var action = component.get('c.submitIntimationReq');
        action.setParams({
            RecId : event.getSource().get("v.name")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                // var data =JSON.parse('['+response.getReturnValue()+']');
                component.set("v.ShowSpinner",false);
                let repsonse = response.getReturnValue();
                console.log(repsonse);
                
                if(repsonse.Status == 'S'){
                    helper.getIntimationDetails(component, event, helper);
                    component.set("v.intimationLinesData",null);
                    helper.showToast('Success','success','Your request has been submitted successfully and GRN no -'+repsonse.InspectionNo);
                }else if(repsonse.Status == 'E'){
                    component.set("v.ShowSpinner",false);
                    helper.showToast('Error','error','Internal error'+repsonse.Message);
                    
                }
                
                if(repsonse.Status == 'No_Data'){
                    component.set("v.ShowSpinner",false);
                    helper.showToast('Warning','Warning','No approved/Reject lines to submit');
                }
                
                
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.ShowSpinner",false);
                        console.log("Error message: " + errors[0].message);
                        helper.showToast('error','error','We are unable to submit your request, please contact ET');
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);  
        //alert('submit--'+ )
        
    },
    
    handleSelectTab : function(component, event, helper) {
        
        let tab = component.get('v.selectedTab');
        
        if(tab == 'checkout'){
            component.set("v.showCheckout",true);
            component.set("v.showCheckin",false);
            component.set("v.showInspection",false);
            component.set("v.showMotoInspection",false);
            component.set("v.showReceivingForm",false);
            
        }
        
        if(tab == 'checkin'){
            component.set("v.showCheckin",true);
            component.set("v.showCheckout",false);
            component.set("v.showInspection",false);
            component.set("v.showMotoInspection",false);
            component.set("v.showReceivingForm",false);
            
        }
        
        if(tab == 'inspection'){
           
            component.set("v.showCheckin",false);
            component.set("v.showCheckout",false);
            component.set("v.showInspection",true);
            component.set("v.showMotoInspection",false);
            component.set("v.showReceivingForm",false);
            
        }
        if(tab == 'ReceivingForm'){      
            
            component.set("v.showCheckin",false);
            component.set("v.showCheckout",false);
            component.set("v.showInspection",false);
            component.set("v.showMotoInspection",false);
            component.set("v.showReceivingForm",true);
            
        }
        if(tab == 'motoInspection'){
            component.set("v.showCheckin",false);
            component.set("v.showCheckout",false);
            component.set("v.showInspection",false);
            component.set("v.showMotoInspection",true);
            component.set("v.showReceivingForm",false);
            
        }
        
    },
    
    showLines : function(component, event, helper) {
        var vehId = event.currentTarget.dataset.filename;
        var id = event.currentTarget.dataset.id;
        
        var reqData =component.get("v.intimationList");
        
        
        for (var i = 0; i < reqData.length; i++) {
            
            if(reqData[i].Id === vehId){
                component.set("v.intimationLinesData",reqData[i].Intimation_Lines.records);
                
            }           
            
        }
        var Elements = component.find('itemVal');
        for (var i = 0; i < Elements.length; i++) {
            var val = Elements[i].getElement().getAttribute('data-id');
            
            if(val != id){
                $A.util.removeClass(Elements[i], "itemBorder");
            } else {
                $A.util.addClass(Elements[i], "itemBorder");
            }
        }
        
        
    },
    
    getPreviousList: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start-=corousalSize;
        var intimList=component.get('v.intimationList'); 
        component.set('v.CarousalintimationList',intimList.slice(start,start+corousalSize)); 
        component.set('v.start',start);
        
    },
    getNextList: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start+=corousalSize;
        var intimList=component.get('v.intimationList'); 
        component.set('v.CarousalintimationList',intimList.slice(start,start+corousalSize)); 
        component.set('v.start',start); 
    },
    onMenuClickHandler : function(component, event, helper) {
        var cmpTarget = component.find('dropDown');
        $A.util.toggleClass(cmpTarget, 'slds-show');
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    },
    
    OpenInspection :function(component, event, helper) {
        
        component.set("v.selectedTab","inspection");
        component.set("v.showCheckin",false);
        component.set("v.showCheckout",false);
        component.set("v.showInspection",true);
        component.set("v.showMotoInspection",false);
        component.set("v.showReceivingForm",false);
        
        
        var cmpTarget = component.find('dropDown');
        $A.util.toggleClass(cmpTarget, 'slds-hide');
        
        
    },
    
    OpenCheckOut:function(component, event, helper) {
        component.set("v.selectedTab","checkout");
        component.set("v.showCheckout",true);
        component.set("v.showCheckin",false);
        component.set("v.showInspection",false);
        component.set("v.showMotoInspection",false);
        component.set("v.showReceivingForm",false);
        
        var cmpTarget = component.find('dropDown');
        $A.util.toggleClass(cmpTarget, 'slds-hide');
        
        //console.log('checkout');
    },
    
    OpenCheckIn:function(component, event, helper) {
        
        component.set("v.selectedTab","checkin");
        component.set("v.showCheckin",true);
        component.set("v.showCheckout",false);
        component.set("v.showInspection",false);
        component.set("v.showMotoInspection",false);
        component.set("v.showReceivingForm",false);
        
        var cmpTarget = component.find('dropDown');
        $A.util.toggleClass(cmpTarget, 'slds-hide');
        
        
    },
    OpenMotoInspection:function(component, event, helper) {
        
        component.set("v.selectedTab","motoInspection");
        component.set("v.showMotoInspection",true);
        component.set("v.showReceivingForm",false);
        component.set("v.showCheckin",false);
        component.set("v.showCheckout",false);
        component.set("v.showInspection",false);
        
        var cmpTarget = component.find('dropDown');
        $A.util.toggleClass(cmpTarget, 'slds-hide');
        
        
    },
    OpenReceivingForm:function(component, event, helper) {
        
        component.set("v.selectedTab","ReceivingForm");
        component.set("v.showReceivingForm",true);
        component.set("v.showMotoInspection",false);
        component.set("v.showCheckin",false);
        component.set("v.showCheckout",false);
        component.set("v.showInspection",false);
        
        var cmpTarget = component.find('dropDown');
        $A.util.toggleClass(cmpTarget, 'slds-hide');
        
        
    },
    reloadPage : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
    
    
})
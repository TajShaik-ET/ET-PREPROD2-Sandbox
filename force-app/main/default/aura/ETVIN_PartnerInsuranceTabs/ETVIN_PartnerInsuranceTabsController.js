({
    doInit : function(component, event, helper) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
        
        for (i = 0; i < sURLVariables.length; i++) {
            //console.log('type of = '+ typeof sURLVariables);
            //console.log('url Params = '+ JSON.stringify(sURLVariables.BookingReq));
            
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
            console.log('typeof ='+ typeof sParameterName);
            console.log('sParameterName '+i +' '+ sParameterName);
            if (sParameterName[0] === 'recordId') { //lets say you are looking for param name - firstName  
                console.log('recordId = '+ sParameterName[1]);
                component.set("v.recordId",sParameterName[1] );
                component.set("v.detailpage",true );
            }
            if (sParameterName[0] === 'tab') { //lets say you are looking for param name - firstName  reqType
                console.log('selectedTabId = '+ sParameterName[1]);
                component.set("v.selectedTabId",sParameterName[1] ); 
                component.set("v.detailpage",true );
            }
            
        }
    },
    handleActive: function (component, event, helper) {
        component.set("v.recordId",'');
        component.set("v.detailpage",false );
        //alert(cmp.get('v.selectedTabId'))
    },
    sendToComponents :function (component, event, helper) {
        
        var keyword = component.get("v.searchKeyWord");
        var selectTab =component.get("v.selectedTabId");
        if(selectTab == 'Vehiclepolicy'){
             var childCmp = component.find("vehiclepolicytab");
             childCmp.callingFromParentCmp(keyword);
        }
        if(selectTab == 'Claimpolicy'){
            var childCmp2 = component.find("claimstab");
            childCmp2.callingFromParentCmp(keyword);
        }
        if(selectTab == 'Correction'){
            
            var childCmp3 = component.find("CorrectionDetails");
            childCmp3.callingFromParentCmp(keyword);
        }
        
        if(selectTab == 'Cancellation'){
            
            var childCmp4 = component.find("Cancellation");
            childCmp4.callingFromParentCmp(keyword);
        }
        
        if(selectTab == 'Mulkiya'){
            
            var childCmp5 = component.find("Mulkiya");
            childCmp5.callingFromParentCmp(keyword);
        }
     
     
       
    }
   
})
({
    doInit : function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    filterZones: function(component, event, helper) {
        if(component.get("v.selectedZone")!='')
            helper.getLocations(component, event, helper);
    },
    getInvoiceDetails: function(component, event, helper) {
        if(helper.validateForm(component)){
            helper.getInvoiceDetailsHelper(component, event, helper);
        }
    }, 
    closeModel: function(component, event, helper) {
        component.set('v.invoiceModal',false);
    },
    openInvoiceModal: function(component, event, helper) {
        component.set('v.invoiceModal',true);
        var item=event.getSource().get('v.value');
        console.log('item in openInvoiceModal:'+JSON.stringify(item));
        console.log('SchoolName:'+item.SchoolName);
        helper.getInvoiceListHelper(component, event, helper,item.coordinatorName,item.SchoolName);
    },
    publishFinDetails: function(component, event, helper) {
        if(helper.validateForm(component)){
            //var invoiceListVar=component.get('v.invoiceList');
            //console.log('invoiceListVar:'+JSON.stringify(invoiceListVar));
            var invSize=component.get('v.invoiceList').length;
           // var item=event.getSource().get('v.value'); // added by Sreelakshmi SK 31/3/2023
            //console.log('item:'+JSON.stringify(item));
            //console.log('invSize:'+invSize);
            if(invSize>0){
                console.log('Entered invSize if loop');
                //console.log('item.coordinatorName:'+item.coordinatorName);
                //console.log('item.SchoolName:'+item.SchoolName);
                helper.publishFinDetailsHelper(component, event, helper); 
                component.set("v.hideButton", false); // added by Sreelakshmi SK 07/March/2023
            }else{
                alert('There is no invoice details to publish');
            }
        }
    },
    downloadData :function(component, event, helper){
   		event.preventDefault();
        var allResources=component.get("v.invoicesDetails");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources); 
        if(csv==null)
        {
			return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='RecieptData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
       // $A.get('e.force:refreshView').fire(); // commented by Sreelakshmi SK 07/March/2023
        
    },
})
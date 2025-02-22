({
    checkOppStageIsValid : function(component,recordId) {
        var objectName = component.get('v.sObjectName');
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__PRI_CreateCustomerQuoteContainer'
            },
            state: {
                c__recordId: recordId,
                c__objectName: objectName
            }
        };
        component.set("v.pageReference", pageReference);
        const navService = component.find('navService');
        const pageRef = component.get('v.pageReference');

        const handleUrl = (url) => {
            window.open(url);
        };
        const handleError = (error) => {
            console.log(error);
        };
        navService.generateUrl(pageRef).then(handleUrl, handleError);
        
        $A.get("e.force:closeQuickAction").fire();
        
    },
})
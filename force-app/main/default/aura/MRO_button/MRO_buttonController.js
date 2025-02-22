({
    doInit : function(component, event, helper) {
    }, 
    handlecase : function(component, event, helper) {
        var modalBody;
        var modalFooter;
        $A.createComponents([
            ["c:MRO_CREATECASE",{
                "recordId": '',
            }]
        ],
                            function(components, status){
                                if (status === "SUCCESS") {
                                    modalBody = components[0];
                                    console.log('&&&&&&&&&&&3');
                                    component.find('overlayLib').showCustomModal({
                                        header: "Create MRO Request",
                                        body: modalBody,
                                        footer: modalFooter,
                                        showCloseButton: true,
                                        cssClass: "my-modal,my-custom-class,my-other-class",
                                        closeCallback: function() {
                                            //alert('You closed the alert!');
                                            $A.get('e.force:refreshView').fire();
                                            console.log('popoclose');
                                        }
                                    });
                                }
                            });
    }
    
})
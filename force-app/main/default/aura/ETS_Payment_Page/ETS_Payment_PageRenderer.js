({
    rerender : function(component, helper){
        this.superRerender();
        if(component.get("v.isSDKLoaded") && component.get("v.processSDKRerendering")) {
            // do custom rendering here
            const style = {
                main: {} /* the style for the main wrapper div around the card input*/,
                base: {} /* this is the default styles that comes with it */,
                input: {} /* custom style options for the input fields */,
                invalid: {} /* custom input invalid styles */
            };
            var apiKey = 'YWJjMjQyZDEtZWJlMC00NDc1LTlkMmItMWY3Y2ZmYWY0MGFkOjFmMmRlNWY2LTM1NTYtNDU3Yi05ZDVhLTExMGQ4MTU5M2ViNg==';
            var outletRef = 'e209b88c-9fb6-4be8-ab4b-e4b977ad0e0d';
            console.log('Is called');
            try{
                //your logics
                console.log(window);
                console.log(window.NI);
                
                /* Method call to mount the card input on your website */
                window.NI.mountCardInput('mount-id', {
                    style,
                    apiKey,
                    outletRef,
                    onSuccess: () => {
                        console.log('The load was succeeded!');
                    },
                    onFail: () => {
                        console.log('The load was failed!');
                    },
                    onChangeValidStatus: ({
                        isCVVValid,
                        isExpiryValid,
                        isNameValid,
                        isPanValid
                    }) => {
                        console.log(isCVVValid, isExpiryValid, isNameValid, isPanValid);
                    }
                    });
            }
            catch(error){
                    console.log(error);        
            }    
                    
            component.set("v.processSDKRerendering",false); // this will not fire rerender again
         }
    }
})
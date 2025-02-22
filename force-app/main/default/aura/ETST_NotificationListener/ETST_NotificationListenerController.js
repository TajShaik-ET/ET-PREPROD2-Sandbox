({
    doInit: function (component, event, helper) {
        component.set('v.subscription', null);
        component.set('v.notifications', []);
        // Get empApi component.
        const empApi = component.find('empApi');
        console.log('empApi');
        console.log(empApi);
        
        // Define an error handler function that prints the error to the console.
        const errorHandler = function (message) {
            console.error('Received error ', JSON.stringify(message));
        };
        // Register empApi error listener and pass in the error handler function.
        empApi.onError($A.getCallback(errorHandler));
        helper.subscribe(component, event, helper);
    },
    // Clear notifications in console app.
    onClear: function (component, event, helper) {
        component.set('v.notifications', []);
    },
    // Mute toast messages and unsubscribe/resubscribe to channel.
    onToggleMute: function (component, event, helper) {
        const isMuted = !(component.get('v.isMuted'));
        component.set('v.isMuted', isMuted);
        if (isMuted) {
            helper.unsubscribe(component, event, helper);
        } else {
            helper.subscribe(component, event, helper);
        }
        helper.displayToast(component, 'success', 'Notifications ' +
                            ((isMuted) ? 'muted' : 'unmuted') + '.');
    }
})
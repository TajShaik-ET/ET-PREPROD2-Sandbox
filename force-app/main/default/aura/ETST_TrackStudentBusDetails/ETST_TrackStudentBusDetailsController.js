({
    closeModel: function(component, event, helper) {
        component.set('v.isTrackModal',false);
           
    },
    doInit: function(component, event, helper){
        
        component.set('v.mapMarkers', [
            {
                location: {
                    Street: '1600 Pennsylvania Ave NW',
                    City: 'Washington',
                    State: 'DC'
                },

                title: 'The White House',
                description: 'Landmark, historic home & office of the United States president, with tours for visitors.'
            }
        ]);
        component.set('v.zoomLevel', 10);
        component.set('v.markersTitle', 'Locations');
        //helper.doInit(component, event, helper);
    } 
})
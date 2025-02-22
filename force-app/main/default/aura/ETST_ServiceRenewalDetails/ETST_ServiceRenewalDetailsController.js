({
    doInit: function (component, event, helper) {
        /*  component.set('v.mapMarkers', [
              {
                  location: {
                      City: 'San Francisco',
                      Country: 'USA',
                      PostalCode: '94105',
                      State: 'CA',
                      Street: 'The Landmark @ One Market, Suite 300'
                  },
  
                  title: 'Emirates Tranport',
                  description: 'Near RTA Head Office'
              }
          ]);
          component.set('v.zoomLevel', 8);*/
  
          component.set('v.vfUrl','/apex/ETPaymentForm?recordId='+component.get('v.recordId')+'&src=etst');
          var urlString=window.location.href;
          //console.log('urlString  '+urlString);
          var vfOrigin = urlString.substring(0, urlString.indexOf("/s"));
          console.log('vfOrigin  '+vfOrigin);
          component.set("v.vfHost", vfOrigin);
          //var vfOrigin =component.get("v.vfHost");
          //console.log('vfOrigin-->'+vfOrigin);
          window.addEventListener("message", $A.getCallback(function(event) {
              
              if (event.origin !== vfOrigin) {
                  // Not the expected origin: Reject the message!
                  //console.log(event.data);
                  return;
              }
              // Handle the message
              console.log(event);
              var message = event.data;
              console.log('message-->'+message);
              if(message=='PaymentCancelled'){
                  component.set("v.currentStep",'Coordinator Confirmed');
                  return;
              }
              var res = message.split("~");
              var source = '';
              var messageText = '';
              var messageType = '';
              
              
              if(res.length > 0){
                  source = res[0];
                  messageText = res[1];
                  messageType = res[2];
                  console.log('messageText  '+messageText);
                  console.log('messageType  '+messageType);
              }
              
              if(messageType == 'Success!'){
                    component.set("v.currentStep",'Payment success');
                    
              }
              
              console.log(event.origin);
              console.log(vfOrigin);
              
          }), false);
  
         
      },
      
      recordUpdate : function(component, event, helper) {
          component.set("v.currentStep",component.get("v.serviceRecord").ETST_Status__c);
      },
      handleLoad: function(component, event, helper) {
          //alert('record'+component.find("firstNameField").get("v.value"));
          //component.set("v.currentStep",component.get("v.recordId.ETST_Status__c"));
      },
      cancelSave: function(component, event, helper) {
          var urlEvent = $A.get("e.force:navigateToURL");
          urlEvent.setParams({
              "url": '/etst-home-page'
          });
          urlEvent.fire();
      },
      proceedToPay: function(component, event, helper) {
          component.set('v.currentStep','Payment Pending');
      },
      viewBookingDetails: function(component, event, helper) {
          component.set("v.currentStep",'Renewal completed');
      }
})
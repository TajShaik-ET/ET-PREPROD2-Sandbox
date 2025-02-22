public class ETI_BookingTestResultController{
    public String BookingName{get;set;}
    public list<serviceLineItem> serviceLineItemWrp{get;set;}
    public class serviceLineItem{
        public Integer srN{get;set;}
        public string chassis{get;set;}
        public ETI_Service_Line_Item__c srLineItem{get;set;}
        public string testResult{get;set;}
        public string testResultLink{get;set;}
        public serviceLineItem(Integer srN1,string chassis1,ETI_Service_Line_Item__c srLineItem1,string testResult1, String testResultLink){
            srN=srN1;
            chassis=chassis1;
            srLineItem=srLineItem1;
            testResult=testResult1;
            this.testResultLink = testResultLink;
        }
    }
    
    public ETI_BookingTestResultController(){
        Id bkngId=ETI_VehicleController.getDecryptedData(ApexPages.currentPage().getParameters().get('Id').replace(' ','+'));
        serviceLineItemWrp =new list<serviceLineItem>();
        integer i=1;
        if(bkngId!=NULL){
            for(ETI_Service_Line_Item__c item: [Select Id, Name,Booking__r.Name,Booking__r.Chassis_No__c,Booking__r.Vehicle_Number__c,Description__c,
                                                Booking__r.ET_Location__r.Name,Booking__r.Booking_Date__c,Service_Name__c,Test_Result__c,Plate_No__c,Plate_Color__c
                                                From ETI_Service_Line_Item__c Where Booking__c =: bkngId]){
                                                    string plateDetails;
                                                    if(item.Service_Name__c != 'SPEA Inspection'){                                       
                                                        serviceLineItemWrp.add(new serviceLineItem(i,item.Plate_Color__c!=null && item.Plate_No__c!=null?item.Plate_Color__c+'-'+item.Plate_No__c:item.Booking__r.Chassis_No__c,item,item.Description__c!=null?item.Description__c:item.Test_Result__c,null));
                                                    }
                                                    else if(item.Service_Name__c == 'SPEA Inspection'){    
                                                        ServiceAppointment sap = [SELECT Id,RecordType.DeveloperName,CreatedBy.Name,(SELECT Id,LinkedEntityId,ContentDocumentId,ContentDocument.Title,ContentDocument.FileType FROM ContentDocumentLinks WHERE ContentDocument.Title LIKE 'SA-%') FROM ServiceAppointment WHERE ETI_Booking__c =: bkngId ORDER BY createdDate DESC LIMIT 1];
                                                        System.debug('sap>>> '+sap);
                                                        if(sap.ContentDocumentLinks.Size()>0){
                                                            String doclink = null;
                                                            if(sap.ContentDocumentLinks[0].ContentDocumentId != null){
                                                                System.debug('sap doc>>> '+sap.ContentDocumentLinks[0].ContentDocumentId);
                                                                doclink = URL.getSalesforceBaseUrl().toExternalForm()+'/Business/sfc/servlet.shepherd/document/download/'+sap.ContentDocumentLinks[0].ContentDocumentId;
                                                                System.debug('doclink>>> '+doclink);
                                                                serviceLineItemWrp.add(new serviceLineItem(i,item.Plate_Color__c!=null && item.Plate_No__c!=null?item.Plate_Color__c+'-'+item.Plate_No__c:item.Booking__r.Chassis_No__c,item,item.Test_Result__c,doclink!=null?doclink:URL.getSalesforceBaseUrl().toExternalForm()+'/Business/s/home-inspection'));
                                                            }
                                                        }else{
                                                            serviceLineItemWrp.add(new serviceLineItem(i,item.Plate_Color__c!=null && item.Plate_No__c!=null?item.Plate_Color__c+'-'+item.Plate_No__c:item.Booking__r.Chassis_No__c,item,item.Test_Result__c,item.Description__c!=null?item.Description__c:URL.getSalesforceBaseUrl().toExternalForm()+'/Business/s/home-inspection'));
                                                        }
                                                    }
                                                    i++;
                                                }
            if(!serviceLineItemWrp.isEmpty())
                BookingName=serviceLineItemWrp[0].srLineItem.Booking__r.Name;
        }
    }
}
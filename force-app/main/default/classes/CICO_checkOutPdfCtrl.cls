public class CICO_checkOutPdfCtrl {
  
    public string markedDiagramId{get;set;}
    public String signId{get;set;}
    public list<CICO_Child_Asset__c> childAsset{get;set;} 
    
    public CICO_checkOutPdfCtrl(ApexPages.StandardController controller) {
    
        String recId = Apexpages.currentPage().getParameters().get('id');
        
        
         for(ContentDocumentLink  cd : [SELECT id,ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE id != null AND LinkedEntityId=:recId ]){
            
            system.debug('--'+cd.ContentDocument.Title);
            
            if(cd.ContentDocument.Title.contains('MarkedDiagram')){
               
               markedDiagramId= cd.ContentDocument.LatestPublishedVersionId;
            
            }
            if(cd.ContentDocument.Title.contains('Sign')){
              signId = cd.ContentDocument.LatestPublishedVersionId;
            }
            
        }
        
       childAsset = [select id,Name,Asset_Description__c,Issued__c,Received__c from CICO_Child_Asset__c where Check_Out__c=:recId];
    }
}
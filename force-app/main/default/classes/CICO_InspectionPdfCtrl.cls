public class CICO_InspectionPdfCtrl {

    public string markedDiagramId{get;set;}
    public String signId{get;set;}
    public String signId2{get;set;}
    public String signId3{get;set;}
    public String signId4{get;set;}

    public CICO_InspectionPdfCtrl(ApexPages.StandardController controller) {
    
        String recId = Apexpages.currentPage().getParameters().get('id');
        
        
        
         for(ContentDocumentLink  cd : [SELECT id,ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE id != null AND LinkedEntityId=:recId ]){
            
            system.debug('--'+cd.ContentDocument.Title);
            
            if(cd.ContentDocument.Title.contains('MarkedDiagram')){
               
               markedDiagramId= cd.ContentDocument.LatestPublishedVersionId;
            
            }
            if(cd.ContentDocument.Title.contains('Sign')){
              signId = cd.ContentDocument.LatestPublishedVersionId;
            }
            if(cd.ContentDocument.Title.contains('Sign2')){
              signId2 = cd.ContentDocument.LatestPublishedVersionId;
            }
            if(cd.ContentDocument.Title.contains('Sign3')){
              signId3 = cd.ContentDocument.LatestPublishedVersionId;
            }
            if(cd.ContentDocument.Title.contains('Sign4')){
              signId4 = cd.ContentDocument.LatestPublishedVersionId;
            }
            
            
            
        }
        system.debug('--'+signId );
        


    }

}
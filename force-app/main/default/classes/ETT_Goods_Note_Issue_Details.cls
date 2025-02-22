public class ETT_Goods_Note_Issue_Details {
    public Id recordId { get; set; }
    public ETT_Goods_Issue_Note__c goodsNoteIssue { get; set; }
    public List<ETT_Goods_Issue_Lines__c> goodsIssueLines { get; set; }
    
    // Variables to hold the totals
    public Decimal totalIssuedQuantity { get; set; }
    public Decimal totalPrice { get; set; }
  
    
    public ETT_Goods_Note_Issue_Details(ApexPages.StandardController controller) {
        recordId = controller.getRecord().Id;
        
        // Fetch the goods issue note details
        goodsNoteIssue = [
            SELECT 
                Id, 
                Name,
                Issue_Type__c,
                Transaction_Date__c
            FROM ETT_Goods_Issue_Note__c 
            WHERE Id = :recordId
            LIMIT 1
        ];

        // Fetch the related child records (ETT_Goods_Issue_Lines__c)
        goodsIssueLines = [
              SELECT 
              Id,
              Name,
              Goods_Issue_Note__c,
              Total_Price__c,
              Process_Name__c,
              Item_Code__c,
              Tool_Material_Name__r.Name,
              Tool_Material_Name__r.Main_Stock_Average_Price__c,
              Tool_Material_Name__r.Factory_Stock_Average_Price__c,
              Issued_Quantity__c
            FROM ETT_Goods_Issue_Lines__c
            WHERE Goods_Issue_Note__c = :recordId
        ];

        // Calculate the total issued quantity and main stock price
        totalIssuedQuantity = 0;
        totalPrice = 0;
      
        for (ETT_Goods_Issue_Lines__c line : goodsIssueLines) {
            totalIssuedQuantity += line.Issued_Quantity__c != null ? line.Issued_Quantity__c : 0;
            totalPrice += line.Tool_Material_Name__r.Main_Stock_Average_Price__c != null ? line.Tool_Material_Name__r.Main_Stock_Average_Price__c * line.Issued_Quantity__c : 0;
           
        }
    }
}
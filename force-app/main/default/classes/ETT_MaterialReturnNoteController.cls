public class ETT_MaterialReturnNoteController {
    
    @AuraEnabled(cacheable=true)
    public static List<ETT_Goods_Issue_Lines__c> getGoodsIssueLines(String ginId) {
        return [
            SELECT Id, Name, Total_Price__c, Process_Name__c, Item_Code__c, Goods_Issue_Note__c,
                   Tool_Material_Name__r.Name, Issued_Quantity__c,
                   Tool_Material_Name__r.Factory_Stock_Average_Price__c, Tool_Material_Name__r.ETT_Allocated_Units__c, 
                   Tool_Material_Name__r.ETT_Main_Stock_Units__c 
            FROM ETT_Goods_Issue_Lines__c
            WHERE Goods_Issue_Note__c = :ginId
        ];
    }

    @AuraEnabled
    public static void createMaterialReturnLines(List<Map<String, Object>> goodsIssueLineData, Id materialReturnNoteId) {
        System.debug('Line ID'+goodsIssueLineData);
        System.debug('Lien Id'+materialReturnNoteId);
      
        List<Material_Return_Lines__c> returnLines = new List<Material_Return_Lines__c>();
        Set<Id> lineIds = new Set<Id>();
        

        // Collect all line IDs to avoid multiple queries
        for (Map<String, Object> lineData : goodsIssueLineData) {
            Id lineId = (Id) lineData.get('id');
            lineIds.add(lineId);
        }
        System.debug('Id'+lineIds);
        // Fetch all necessary goods issue lines in one query
        Map<Id, ETT_Goods_Issue_Lines__c> goodsLinesMap = new Map<Id, ETT_Goods_Issue_Lines__c>(
            [SELECT Id, Total_Price__c, Process_Name__c, Item_Code__c, Issued_Quantity__c, Goods_Issue_Note__c
             FROM ETT_Goods_Issue_Lines__c
             WHERE Id IN :lineIds]
        );

        // Loop through the input data and create new return lines
        for (Map<String, Object> lineData : goodsIssueLineData) {
            Id lineId = (Id) lineData.get('id');
             // Quantity is received
          
            Decimal quantity = (Decimal) lineData.get('quantity');  
            System.debug('quantity'+quantity);
            // Check if the goods line exists in the map
            if (goodsLinesMap.containsKey(lineId)) {
                ETT_Goods_Issue_Lines__c goodsLine = goodsLinesMap.get(lineId);

                // Create a new Material Return Line
                Material_Return_Lines__c newLine = new Material_Return_Lines__c();
                newLine.Goods_Issue_Lines__c = goodsLine.Id;
                newLine.Process_Name__c = goodsLine.Process_Name__c;
                newLine.GIN_No__c = goodsLine.Goods_Issue_Note__c;
                newLine.Item_Description__c = goodsLine.Item_Code__c;
                newLine.Return_Qty__c = quantity;

                // Set the Material_Return_Note__c field with the passed ID
                newLine.Material_Return_Note__c = materialReturnNoteId;
                
                returnLines.add(newLine);

            }
        }
        System.debug('lines records'+returnLines);

        // Insert new return lines
        if (!returnLines.isEmpty()) {
              try {
                insert returnLines;
            } catch (DmlException e) {
                System.debug('Error inserting Material Return Lines: ' + e.getMessage());
                throw new AuraHandledException('Failed to create material return lines: ' + e.getMessage());
            }
          
        }

    }
}
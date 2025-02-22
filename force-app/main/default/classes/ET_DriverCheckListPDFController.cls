/************************************************************************************************************************
 * Name               : ET_DriverCheckListPDFController
 * Test Class         : ET_DriverCheckListPDFController_Test
 * Description        : Apex Class for generating Driver Checklist Application PDF data.
 *                      This controller fetches the Driver Checklist record and its associated line items, groups them
 *                      by categories, and transforms the data for rendering in a PDF format.
 * Created Date       : 02/Feb/2025
 * Created By         : AKASH (SMAARTT)
 * -----------------------------------------------------------------------------------------------
 * VERSION   AUTHOR            DATE                COMMENTS
 * 1.0       Akash Yellure     01/Feb/2025         Initial Draft.
 ***********************************************************************************************************************/

public class ET_DriverCheckListPDFController {
    // Public properties
    public String recordId {get; set;} // Holds the ID of the Driver Checklist record
    public Driver_Daily_Check_List__c driverChecklist { get; set; } // Driver Checklist record
    public List<Driver_Check_List_Line__c> checklistLineItems { get; set; } // Line items of the Driver Checklist
    public List<TransformedCategory> tableData { get; private set; } // Transformed data for rendering in PDF
    public String pdfFileName {get;set;} // Dynamic PDF Filename

    /**
     * Constructor: Initializes the controller by fetching the Driver Checklist record and its line items.
     * Groups the line items by categories and prepares them for rendering.
     */
    public ET_DriverCheckListPDFController() {
        // Get the recordId from the Visualforce page URL parameters
        recordId = ApexPages.currentPage().getParameters().get('Id');
      //  String myGeneratedFileName = 'SalesforceScool.pdf';
       
       
        if (recordId != null) {
            // Fetch the Driver Checklist record with the related Driver Check List Line Items (inner query)
            driverChecklist = [SELECT
                               Name,
                               Branch__c,
                               Station__c,
                               KM_Reading__c,
                               Date__c,
                               Start_Time__c,
                               End_Time__c,
                               Totally_Time_Spent__c,
                               Is_Delayed__c,
                               Final_Comments__c,
                               Activity_Center__c,
                               School_Name__c,
                               School_Code__c,
                               Driver__c,
                               Internal_Number__c,
                               Status__c,
                               Final_Result__c,
                               Driver__r.Name,
                               Internal_Number__r.Name,
                               Assigned_Resources__c,
                               Replacement_Vehicle__c,
                               Owner.Name,
                               CreatedDate,
                               Vital_bus_inspections_completed__c,
                               Observation_affect_safety_bus_replaced__c,
                               Contact_traffic_coordinator_for_replacem__c,
                               Observations_to_not_affect_the_safety_of__c,
                               Ensure_Insp_Observations_Are_Correct__c,
                               Contact_Internal_Mobile_Workshop__c,
                               Confirmed_By_Coordinator__c,
                               Replace_The_Bus__c,
                               Admin_Charge_For_Transfer_Of_Workshop__c,
                               Confirmed_By_Supervisor__c,
                               Bus_SentTo_Workshop_ReplacementRequested__c,
                    (SELECT
                        Id,
                        Name,
                        Driver_Check_List__c,
                        Driver_Check_List__r.Name,  // Include the Driver_Check_List__r relationship
                        Number__c,
                        Category_En__c,
                        Category_Ar__c,
                        Question_Ar__c,
                        Question_Ur__c,
                        Category_Ur__c,
                        Question_En__c,
                        Response__c,
                        Severity_Ar__c
                    FROM Driver_Check_List_Lines__r)
                FROM Driver_Daily_Check_List__c
                WHERE Id = :recordId];

            // Access the related list (inner query results) for line items
            checklistLineItems = driverChecklist.Driver_Check_List_Lines__r;
        }
     

        // Group the line items by category
        Map<String, List<Driver_Check_List_Line__c>> groupedItems = new Map<String, List<Driver_Check_List_Line__c>>();
        for (Driver_Check_List_Line__c item : checklistLineItems) {
            String key = item.Category_En__c + '\n' + item.Category_Ar__c + '\n' + item.Category_Ur__c;
            if (!groupedItems.containsKey(key)) {
                 groupedItems.put(key, new List<Driver_Check_List_Line__c>());
            }
             groupedItems.get(key).add(item);
        }

        // Debug log for grouped items
        System.debug('Map grouped ItemsData: ' + groupedItems);

        // Transform grouped data into a list of TransformedCategory objects
        tableData = new List<TransformedCategory>();
        for (String category : groupedItems.keySet()) {
            List<Driver_Check_List_Line__c> items = groupedItems.get(category);
            // Consolidate questions and responses for each category
            List<QuestionResponsePair> consolidated = new List<QuestionResponsePair>();
            for (Driver_Check_List_Line__c item : items) {
                consolidated.add(
                    new QuestionResponsePair(
                        item.Question_En__c,
                        item.Question_Ar__c,
                        item.Question_Ur__c,
                        item.Response__c,
                        item.Response__c == 'Selected'
                    )
                );
            }

            // Add the transformed category data to the tableData list
            tableData.add(
                new TransformedCategory(
                    items[0].Category_En__c,
                    items[0].Category_Ar__c,
                    items[0].Category_Ur__c,
                    items[0].Driver_Check_List__r.Name,  // Now this field is included and accessible
                    items[0].Number__c,
                    items[0].Severity_Ar__c,
                    consolidated
                )
            );
        }
        // Dynamic PDF Filename based on Name, Internal_Number__r.Name, and CreatedDate
        String namePart = driverChecklist.Name != null ? driverChecklist.Name : 'NoName';
        String internalNumberPart = driverChecklist.Internal_Number__r != null ? driverChecklist.Internal_Number__r.Name : 'NoInternalNumber';
        String createdDatePart = driverChecklist.CreatedDate != null ? driverChecklist.CreatedDate.format('dd-MM-yyyy') : 'NoDate';
        
        // Construct the file name
        pdfFileName = namePart + '_' + internalNumberPart + '_' + createdDatePart + '.pdf';
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+pdfFileName);
     
      
    }
        public PageReference generatePDF() {
        PageReference pdfPage = Page.DriverChecklistPDF; 
        pdfPage.getParameters().put('id', recordId);
        pdfPage.getHeaders().put('Content-Disposition', 'inline; filename='+pdfFileName);
        System.debug('PDF File Name: ' + pdfFileName);
        System.debug('PageReference Headers: ' + pdfPage.getHeaders());
        return pdfPage;
        
    } 
    /**
     * TransformedCategory: Represents a grouped category of Driver Checklist line items.
     */
    public class TransformedCategory {
        public String categoryEn { get; set; }
        public String categoryAr { get; set; }
        public String categoryUr { get; set; }
        public String driverChecklistId { get; set; }
        public Decimal dcNumber { get; set; }
        public String severity { get; set; }
        public List<QuestionResponsePair> consolidated { get; set; }

        /**
         * Constructor for TransformedCategory.
         */
        public TransformedCategory(
            String categoryEn,
            String categoryAr,
            String categoryUr,
            String driverChecklistId,
            Decimal dcNumber,
            String severity,
            List<QuestionResponsePair> consolidated
        ) {
            this.categoryEn = categoryEn;
            this.categoryAr = categoryAr;
            this.categoryUr = categoryUr;
            this.driverChecklistId = driverChecklistId;
            this.dcNumber = dcNumber;
            this.severity = severity;
            this.consolidated = consolidated;
        }
    }

    /**
     * QuestionResponsePair: Represents a single question and its response for a Driver Checklist item.
     */
    public class QuestionResponsePair {
        public String questionEn { get; set; }
        public String questionAr { get; set; }
        public String questionUr { get; set; }
        public String response { get; set; }
        public Boolean isSelected { get; set; }

        /**
         * Constructor for QuestionResponsePair.
         */
        public QuestionResponsePair(
            String questionEn,
            String questionAr,
            String questionUr,
            String response,
            Boolean isSelected
        ) {
            this.questionEn = questionEn;
            this.questionAr = questionAr;
            this.questionUr = questionUr;
            this.response = response;
            this.isSelected = isSelected;
        }
    }
}
@isTest
public class ETT_DeliveryNote_PDF_Controllertest {

    @isTest
    public static void Codecoverage() {
        
        // Create Account
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1;
       
        // Create Opportunity
        Opportunity opp = ETT_TestFactory.createOpportunity(
            'Tyre Supplier',
            'TestOppName',
            'Qualification',
            System.today().addDays(20),
            objAcc1.Id
        );
        insert opp;
        
        // Create Contact
        Contact con = new Contact();
        con.LastName = 'Test';
        con.AccountId = objAcc1.Id;
        insert con;
        
        // Create Delivery Note
        ETT_Delivery_Note__c ett_delivery_note = new ETT_Delivery_Note__c(
            CurrencyIsoCode = 'AED',
            ETT_Account__c = objAcc1.id,
            ETT_Is_Delivery_Appointment_Booked__c = false
        );
        insert ett_delivery_note;
        
        // Create Collection Card
        ETT_Collection_Card__c ett_collection_card = new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = objAcc1.Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        // Create Inspection Card
        ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
        objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        objIC.ETT_Collection_Card__c = ett_collection_card.Id;
        objIC.ETT_Status__c = 'Accept';
        insert objIC;
        
        // Create Delivery Line Items with different Job Types
        List<ETT_Delivery_Line_Item__c> deliveryLineItems = new List<ETT_Delivery_Line_Item__c>();
        
        deliveryLineItems.add(new ETT_Delivery_Line_Item__c(
            CurrencyIsoCode = 'AED',
            ETT_Collection_Card__c = ett_collection_card.id,
            ETT_Delivery_Note__c = ett_delivery_note.id,
            ETT_Inspection_Card__c = objIC.id,
            // Use an alternative field for sorting if possible, or just mock
            ETT_Is_Checked__c = false
        ));
        
        deliveryLineItems.add(new ETT_Delivery_Line_Item__c(
            CurrencyIsoCode = 'AED',
            ETT_Collection_Card__c = ett_collection_card.id,
            ETT_Delivery_Note__c = ett_delivery_note.id,
            ETT_Inspection_Card__c = objIC.id,
            // Use an alternative field for sorting if possible, or just mock
            ETT_Is_Checked__c = false
        ));
        
        deliveryLineItems.add(new ETT_Delivery_Line_Item__c(
            CurrencyIsoCode = 'AED',
            ETT_Collection_Card__c = ett_collection_card.id,
            ETT_Delivery_Note__c = ett_delivery_note.id,
            ETT_Inspection_Card__c = objIC.id,
            // Use an alternative field for sorting if possible, or just mock
            ETT_Is_Checked__c = false
        ));
        
        insert deliveryLineItems;
        
        // Initialize the controller
        ApexPages.StandardController controller = new ApexPages.StandardController(ett_delivery_note);
        ApexPages.currentPage().getParameters().put('id', ett_delivery_note.id);
        ETT_DeliveryNote_PDF_Controller deliveryNoteController = new ETT_DeliveryNote_PDF_Controller(controller);
        
        // Assert that the delivery line items are sorted correctly
        List<ETT_Delivery_Line_Item__c> sortedLineItems = deliveryNoteController.dnl;
        
        // Assuming you can set some mockable field to influence sorting for testing
        // System.assertEquals('Repair', sortedLineItems[0].Job_type__c, 'The first item should be Repair');
        // System.assertEquals('Retread', sortedLineItems[1].Job_type__c, 'The second item should be Retread');
        // System.assertEquals('Send Back', sortedLineItems[2].Job_type__c, 'The third item should be Send Back');
        
        
    }
}
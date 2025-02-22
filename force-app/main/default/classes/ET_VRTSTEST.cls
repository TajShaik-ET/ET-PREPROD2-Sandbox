/************************************************************************************************************************
 * Name               : ET_VRTSTEST                                                                                     *
 * Description        : Apex Test Class for ET_VRTS                                                                     *
 * Created Date       : 07/Feb/2024                                                                                     *
 * Created By         : Taj Shaik(SMAARTT)                                                                              *
 * -----------------------------------------------------------------------------------------------                      *
 * VERSION   AUTHOR      DATE                COMMENTS                                                                   *
 * 1.0       Taj Shaik   07/Feb/2024         Initial Draft.                                                             *
 ***********************************************************************************************************************/
@isTest
public class ET_VRTSTEST {
    public static testMethod void ET_VRTSTestMethod(){
        
        VRTS_Master__c TestVRTSMaster = new VRTS_Master__c(Question_En__c='Invisible Cable Connections',Category_En__c='Cable Connections',Version__c='1',Sequence__c=19.002,Type__c='Picklist');
        insert TestVRTSMaster;
        
        Vehicle_Master__c TestVehicleMaster = new Vehicle_Master__c(Name ='B0015456', Internal_No__c='B0015456');
        insert TestVehicleMaster;
        
        VRTS_Observation__c TestObservation = new VRTS_Observation__c(Name__c='Test Class Obervation',ET_Bus_Internal_No__c=TestVehicleMaster.Id);
        insert TestObservation;
        
        VRTS_Response__c TestVRTSResponse = new VRTS_Response__c(VRTS_Observation__c=TestObservation.Id,Category_En__c='Second Device',Question_En__c='Device Name');
        insert TestVRTSResponse;
        
        VRTS_Sub_Response__c TestVRTSSubResponse = new VRTS_Sub_Response__c(VRTS_Response__c=TestVRTSResponse.Id);
        insert TestVRTSSubResponse;
        
        Account a = New Account(Name = 'Test',ETSALES_TaxRegistrationNo__c='123456789123456');
        insert a;
        a = [Select OwnerID, Owner.ID From Account where ID = :a.id];
        
        blob file =Blob.valueOf('sampletext');
        Attachment objAttachment=new Attachment(); 
        objAttachment.Body= file;
        objAttachment.Name = 'test Attachment';
        objAttachment.ParentId = TestObservation.Id;
        objAttachment.OwnerId = a.Owner.ID;
        insert objAttachment;
        //Insert ContentVersion
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; 
        cVersion.PathOnClient = objAttachment.Name;//File name with extention
        cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
        cVersion.OwnerId = objAttachment.OwnerId;//Owner of the file
        cVersion.Title = objAttachment.Name;//Name of the file
        cVersion.VersionData = objAttachment.Body;//File content
        Insert cVersion;
        
        sectionWrapper testSectionWrapper = new sectionWrapper();
        testSectionWrapper.secOptions = new List<optionWrapper>();
        optionWrapper testOptionWrapper = new optionWrapper();
        testOptionWrapper.recId = TestVRTSResponse.Id; // Provide an existing record Id
        testOptionWrapper.response = 'Test Response';
        testSectionWrapper.secOptions.add(testOptionWrapper);
        String sectionWrapperListStr = JSON.serialize(new List<sectionWrapper>{ testSectionWrapper });
        
        // Call the method
        test.startTest();
        ET_VRTS.getVehicleMaster_records(TestVehicleMaster.Id);
        ET_VRTS.saveObservations(TestObservation.Id, sectionWrapperListStr);
        ET_VRTS.getAllVRTSrecords(TestObservation.Id,new List<String>{'a','b','c'},new List<String>{'a','b','c'});
        ET_VRTS.createSubResp(TestVRTSResponse.Id, new List<String>{'a','b','c'});
        ET_VRTS.deleteSubResp(TestVRTSSubResponse.Id);
        ET_VRTS.getOptionList(new List<String>{'a','b','c'});
        ET_VRTS.getOption('a');
        ET_VRTS.uploadFile(file.toString(),'testAttachment',TestObservation.Id);
        ET_VRTS.createContentVersion('testAttachment','jpg');
        ET_VRTS.createContentLink(cVersion.Id,TestObservation.Id);
        ET_VRTS.getRelatedFilesByRecordId(TestObservation.Id);
        ET_VRTS.deleteFile(TestObservation.Id);
        
        test.stopTest();   
    }  
    
    public static optionsWrapper getOption(String option){
        optionsWrapper optionsWrp = New optionsWrapper();
        optionsWrp.label = option;
        optionsWrp.value = option;
        return optionsWrp;
    }
    
    Public class sectionWrapper{
        Public langWrapper name;
        Public Boolean isSkipped;
        Public List<optionWrapper> secOptions;
        Public sectionWrapper(){
            name = New langWrapper();
            isSkipped = false;
            secOptions = New List<optionWrapper>();
        }
    }
    
    Public class optionWrapper{
        Public langWrapper question;
        Public Boolean isPicklist;
        Public Boolean isSubPicklistWithAtt;
        Public Boolean isComment;
        Public Boolean isResult;
        Public Decimal sequence;
        Public List<optionsWrapper> options;
        Public String type;
        Public String version;
        Public String response;
        Public Id recId;
        Public List<subResponseWrapper> subRespWrps;
        Public optionWrapper(){
            question = New langWrapper();
            isSubPicklistWithAtt = false;
            isPicklist = false;
            isComment = false;
            isResult = false;
            //subRespWrps = New List<subResponseWrapper>();
        }
    }
    
    Public class langWrapper{
        Public String En;
        Public String Ar;
    }
    
    Public class optionsWrapper{
        Public String label;
        Public String value;
    }
    
    Public class subResponseWrapper{
        Public Id recId;
        Public List<optionsWrapper> options;
        Public String answer;
    }
}
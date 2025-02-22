/************************************************************************************************************************
 * Name               : ET_VRTS                                                                                         *
 * Test Class		  : ET_VRTSTEST                                                                                     *
 * Description        : Apex Class for VRTS Application                                                                 *
 * Created Date       : 07/Feb/2024                                                                                     *
 * Created By         : Taj Shaik(SMAARTT)                                                                              *
 * -----------------------------------------------------------------------------------------------                      *
 * VERSION   AUTHOR      DATE                COMMENTS                                                                   *
 * 1.0       Taj Shaik   07/Feb/2024         Initial Draft.                                                             *
 ***********************************************************************************************************************/
public class ET_VRTS {
    
    @AuraEnabled(cacheable=true)
    public static List<Vehicle_Master__c> getVehicleMaster_records(String recId){
        return [SELECT Id,Plate_Number__c,Plate_Source__c,Plate_Type__c,Plate_colour_code__c FROM Vehicle_Master__c WHERE Id =:recId LIMIT 1];
    }
    
    @AuraEnabled
    public static void saveObservations(Id ObsRecId, String sectionWrapperListStr){ 
        List<VRTS_Response__c> respList = New List<VRTS_Response__c>();
        List<VRTS_Sub_Response__c> subRespList = New List<VRTS_Sub_Response__c>();
        List<sectionWrapper> sectionWrpList = (List<sectionWrapper>) System.JSON.deserialize(sectionWrapperListStr, List<sectionWrapper>.class);
        List<optionWrapper> optionWrapperList = New List<optionWrapper>();
        List<subResponseWrapper> subRespWrps = New List<subResponseWrapper>();
        for(sectionWrapper sectionWrp: sectionWrpList){
            optionWrapperList.addAll(sectionWrp.secOptions);
        }
        for(optionWrapper secOption: optionWrapperList){
            VRTS_Response__c resp = New VRTS_Response__c();
            resp.Answer__c = secOption.response;
            resp.Id = secOption.recId; 
            resp.VRTS_Observation__c = ObsRecId;
            respList.add(resp);
            if(secOption.isSubPicklistWithAtt)
                subRespWrps.addAll(secOption.subRespWrps);
        }
        for(subResponseWrapper subRespWrp: subRespWrps){
            VRTS_Sub_Response__c subResp = New VRTS_Sub_Response__c();
            if(subRespWrp.answer != null && subRespWrp.answer != ''){
                subResp.Answer__c = subRespWrp.answer;
                subResp.Id = subRespWrp.recId;
                subRespList.add(subResp);
            }
        }
        System.debug('respList Size: '+respList.Size());
        System.debug('subRespList Size: '+subRespList.Size());
        if(respList.Size()>0)
            Update respList;
        if(subRespList.Size()>0)
            Update subRespList;
    }
    
    @AuraEnabled
    public static List<sectionWrapper> getAllVRTSrecords(String ObsRecId, List<String> statusOfElectricalConnections, List<String> deviceName){
        List<sectionWrapper> sectionWrpList = New List<sectionWrapper>();
        //List<VRTS_Master__c> vrtsList = [SELECT Id,Sequence__c,Version__c,Question_En__c,Question_Ar__c,Category_En__c,Category_Ar__c,Type__c FROM VRTS_Master__c WHERE Category_En__c IN ('Internal Siren (Speaker)','Temp. - Humidity','Automatic Fire Suppression System','Automatic Fire Suppression (Except SUNWIN)','Automatic Fire Suppression (SUNWIN)','Cable Connections','Second Device') ORDER BY Sequence__c ASC NULLS LAST];
        List<VRTS_Master__c> vrtsList = [SELECT Id,Sequence__c,Version__c,Question_En__c,Question_Ar__c,Category_En__c,Category_Ar__c,Type__c FROM VRTS_Master__c WHERE Version__c = '1' ORDER BY Sequence__c ASC NULLS LAST];
        List<VRTS_Response__c> respList = New List<VRTS_Response__c>();
        for(VRTS_Master__c master: vrtsList){
            VRTS_Response__c resp = New VRTS_Response__c(); 
            resp.Category_En__c = master.Category_En__c;
            resp.Category_Ar__c = master.Category_Ar__c;
            resp.Question_En__c = master.Question_En__c;
            resp.Question_Ar__c = master.Question_Ar__c;
            resp.Answer__c = '';
            resp.Sequence__c = master.Sequence__c;
            resp.Version__c = master.Version__c;
            resp.Type__c = master.Type__c;
            resp.VRTS_Observation__c = ObsRecId;
            respList.add(resp);
        }
        System.debug('respList Size: '+respList.Size());
        if(respList.Size()>0)
            Insert respList;
        Map<String, List<VRTS_Response__c>> mapVRTS = New Map<String, List<VRTS_Response__c>>();
        Map<String, List<optionWrapper>> mapOptionsVRTS = New Map<String, List<optionWrapper>>();
        for(VRTS_Response__c rec: respList){
            //System.debug(rec.Question_En__c+' rec '+rec.Version__c);
            if(!mapVRTS.containsKey(rec.Category_En__c))
                mapVRTS.put(rec.Category_En__c,New List<VRTS_Response__c>{rec});
            else if(mapVRTS.containsKey(rec.Category_En__c))
                mapVRTS.get(rec.Category_En__c).add(rec);
            optionWrapper optionWrp = New optionWrapper();
            optionWrp.recId = rec.Id;
            optionWrp.question.En = rec.Question_En__c;
            optionWrp.question.Ar = rec.Question_Ar__c;
            if(rec.Type__c == 'Picklist' || rec.Type__c == 'Sub Picklist with Attachment'){
                if(rec.Type__c == 'Picklist')
                    optionWrp.isPicklist = true;
                if(rec.Type__c == 'Sub Picklist with Attachment')
                    optionWrp.isSubPicklistWithAtt = true;
                List<optionsWrapper> optionsWrps = New List<optionsWrapper>();
                if(rec.Type__c == 'Picklist'){
                    if(rec.Category_En__c == 'Second Device'){
                        optionsWrps.addAll(getOptionList(statusOfElectricalConnections));
                    }
                    if(rec.Category_En__c != 'Second Device'){
                        optionsWrps.add(getOption('Yes'));
                        optionsWrps.add(getOption('No'));
                    }
                    if(rec.Category_En__c != 'Automatic Fire Suppression System' && rec.Category_En__c != 'Cable Connections' && rec.Category_En__c != 'Second Device')
                        optionsWrps.add(getOption('No Device'));
                    optionWrp.options = New List<optionsWrapper>(optionsWrps);
                }
                if(rec.Type__c == 'Sub Picklist with Attachment'){
                    if(rec.Category_En__c == 'Second Device'){
                        optionsWrps.addAll(getOptionList(deviceName));
                    }
                    optionWrp.options = New List<optionsWrapper>(optionsWrps);
                    subResponseWrapper subRespWrp = createSubResp(rec.Id,deviceName);
                    optionWrp.subRespWrps = New List<subResponseWrapper>();
                    optionWrp.subRespWrps.add(subRespWrp);
                }
            }
            if(rec.Type__c == 'Comment')
                optionWrp.isComment = true;
            if(rec.Type__c == 'Result')
                optionWrp.isResult = true;
            optionWrp.sequence = rec.Sequence__c;
            optionWrp.version = rec.Version__c;
            optionWrp.type = rec.Type__c;
            optionWrp.response = '';
            if(!mapOptionsVRTS.containsKey(rec.Category_En__c))
                mapOptionsVRTS.put(rec.Category_En__c,New List<optionWrapper>{optionWrp});
            else if(mapOptionsVRTS.containsKey(rec.Category_En__c))
                mapOptionsVRTS.get(rec.Category_En__c).add(optionWrp);
        }
        for(String sec: mapVRTS.KeySet()){
            sectionWrapper sectionWrp = New sectionWrapper();
            sectionWrp.name.En = sec;
            if(mapVRTS.containsKey(sec))
                sectionWrp.name.Ar = mapVRTS.get(sec)[0].Category_Ar__c;
            sectionWrp.secOptions = mapOPtionsVRTS.get(sec);
            sectionWrpList.add(sectionWrp);
        }
        System.debug('sectionWrpList Size: '+sectionWrpList.Size());
        return sectionWrpList;
    }
    
    @AuraEnabled
    public static subResponseWrapper createSubResp(Id respId, List<String> deviceName){
        System.debug('respId: '+respId);
        List<optionsWrapper> optionsWrps = New List<optionsWrapper>();
        optionsWrps.addAll(getOptionList(deviceName));
        subResponseWrapper subRespWrp = New subResponseWrapper();
        subRespWrp.options = New List<optionsWrapper>(optionsWrps);
        VRTS_Sub_Response__c subRsp = New VRTS_Sub_Response__c();
        subRsp.VRTS_Response__c = respId;
        subRsp.Answer__c = '';
        try{
            Insert subRsp;
        }
        catch(Exception ex){
            System.debug('ex: '+ex);
        }
        subRespWrp.recId = subRsp.Id;    
        return subRespWrp;        
    }
    
    @AuraEnabled
    public static Boolean deleteSubResp(String SubIdStr){
        Boolean isDeleted = false;
        List<String> SubIds = New List<String>();
        if(SubIdStr != null){
            if(SubIdStr.containsIgnoreCase(';'))
                SubIds = SubIdStr.Split(';');
            else
                SubIds.add(SubIdStr);
        }
        System.debug('SubIds: '+SubIds);
        if(SubIds.Size()>0){
            List<VRTS_Sub_Response__c> subRspList = [SELECT Id FROM VRTS_Sub_Response__c WHERE Id =: SubIds];
            if(subRspList.Size()>0){
                try{
                    Delete subRspList;
                    isDeleted = true; 
                }
                catch(Exception ex){
                    System.debug('ex: '+ex);
                    isDeleted = false; 
                }   
            }
        }
        return isDeleted;        
    }
    
    public static List<optionsWrapper> getOptionList(List<String> options){
        List<optionsWrapper> optionsWrps = New List<optionsWrapper>();
        if(options.size()>0){
            for(String str :options){
                optionsWrps.add(getOption(str));
            }
        }
        return optionsWrps;
    }
    
    public static optionsWrapper getOption(String option){
        optionsWrapper optionsWrp = New optionsWrapper();
        optionsWrp.label = option;
        optionsWrp.value = option;
        return optionsWrp;
    }
    
    Public class sectionWrapper{
        @AuraEnabled Public langWrapper name;
        @AuraEnabled Public Boolean isSkipped;
        @AuraEnabled Public List<optionWrapper> secOptions;
        Public sectionWrapper(){
            name = New langWrapper();
            isSkipped = false;
            secOptions = New List<optionWrapper>();
        }
    }
    
    Public class optionWrapper{
        @AuraEnabled Public langWrapper question;
        @AuraEnabled Public Boolean isPicklist;
        @AuraEnabled Public Boolean isSubPicklistWithAtt;
        @AuraEnabled Public Boolean isComment;
        @AuraEnabled Public Boolean isResult;
        @AuraEnabled Public Decimal sequence;
        @AuraEnabled Public List<optionsWrapper> options;
        @AuraEnabled Public String type;
        @AuraEnabled Public String version;
        @AuraEnabled Public String response;
        @AuraEnabled Public Id recId;
        @AuraEnabled Public List<subResponseWrapper> subRespWrps;
        Public optionWrapper(){
            question = New langWrapper();
            isSubPicklistWithAtt = false;
            isPicklist = false;
            isComment = false;
            isResult = false;
        }
    }
    
    Public class langWrapper{
        @AuraEnabled Public String En;
        @AuraEnabled Public String Ar;
    }
    
    Public class optionsWrapper{
        @AuraEnabled Public String label;
        @AuraEnabled Public String value;
    }
    
    Public class subResponseWrapper{
        @AuraEnabled Public Id recId;
        @AuraEnabled Public List<optionsWrapper> options;
        @AuraEnabled Public String answer;
    }
    
    @AuraEnabled
    public static String uploadFile(String base64, String filename, String recordId) {
        ContentVersion cv = createContentVersion(base64, filename);
        ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
        if (cv == null || cdl == null)
        { 
            return null; 
        }
        return cdl.Id;
    }
    @TestVisible
    private static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
            Insert cv;
            return cv;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    @TestVisible
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersionId
        ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        // ShareType is either 'V', 'C', or 'I'
        // V = Viewer, C = Collaborator, I = Inferred
        cdl.ShareType = 'V';
        try {
            Insert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static Map<ID, String> getRelatedFilesByRecordId(String recordId) {
        List<ContentDocumentLink> files = New List<ContentDocumentLink> (); 
        Map<ID, String> mapIdTitle = new Map<ID, String>(); 
        if(!String.isEmpty(recordId))    
            files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        List<ID> fileIDs = new List<ID>();
        if(files.Size()>0){
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
            List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                                         FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
            for (ContentVersion docLink : docs) {
                mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
            }
        }
        System.debug('mapIdTitle Size: '+mapIdTitle.Size());
        if(mapIdTitle.Size()>0)
            return mapIdTitle;
        else return null;
    }
    
    @AuraEnabled
    public static Boolean deleteFile(String ContentDocId) {
        Boolean isSuccess;
        System.debug('ContentDocId: '+ContentDocId);
        try{
            delete new ContentDocument(Id = ContentDocId);
            isSuccess = true;
        }catch(Exception e){
            System.debug(e);
            isSuccess = false;
        }
        return isSuccess;
    }
}
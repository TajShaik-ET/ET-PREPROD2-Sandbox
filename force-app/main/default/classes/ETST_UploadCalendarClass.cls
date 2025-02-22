public class ETST_UploadCalendarClass {
    
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    List<ETST_Calendar__c> calendarstoupload;
    
    /***This function reads the CSV file and inserts records into the Pricelist object. ***/
    public Pagereference ReadFile(){
        try{
            //Convert the uploaded file which is in BLOB format into a string
            // Blob  contentFile1=EncodingUtil.base64Decode(contentFile);
            nameFile =blobToString( contentFile,'UTF-8');
            
            //Now sepatate every row of the excel file
            filelines = nameFile.split('\n');
            
            //Iterate through every line and create a Account record for each row
            calendarstoupload = new List<ETST_Calendar__c>();
            
            Id SchoolRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId(); 
            
            for (Integer i=1;i<filelines.size();i++){
                //System.debug('filelines-->'+filelines[i]);
                String[] inputvalues = new String[]{};
                    inputvalues = filelines[i].split(',');
                ETST_Calendar__c cldr = new ETST_Calendar__c();
                cldr.ETST_School_Id__c = inputValues[0];
                cldr.ETST_Academic_Start_Date__c=date.parse(inputValues[2]);
                cldr.ETST_Academic_End_Date__c=date.parse(inputValues[3]);
                cldr.ETST_Active__c=true;
                calendarstoupload.add(cldr);
            }
        }
        catch(Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file'+e.getMessage());
            ApexPages.addMessage(errormsg);
        }               
        try{
            List<string> schoolIds=new List<string>();                       
            Map<String,Id> schoolIdMap=new Map<String,Id>();  
            
            for(ETST_Calendar__c calender:calendarstoupload){
                schoolIds.add(calender.ETST_School_Id__c);
            }
         
            for(Account acc: [select id, ETST_SchoolRefID__c from Account where ETST_SchoolRefID__c IN :schoolIds]){
                schoolIdMap.put(acc.ETST_SchoolRefID__c, acc.id);
            }
            
            
            for(ETST_Calendar__c calendar :calendarstoupload){
                calendar.ETST_School__c=schoolIdMap.get(calendar.ETST_School_Id__c);    
            }
            
            //insert calendarstoupload;
            
        }
        catch (Exception e)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records'+e.getMessage());
            ApexPages.addMessage(errormsg);
        }    
        return null;
    }
    
    /**** This function sends back to the visualforce page the list of account records that were inserted ****/ 
    public List<ETST_Calendar__c> getuploadedCalendars()
    {
        if (calendarstoupload!= NULL)
            if (calendarstoupload.size() > 0)
            return calendarstoupload;
        else
            return null;                    
        else
            return null;
    }  
    public void insertCalendar(){
        insert calendarstoupload;
    }
    /**
This function convers the input CSV file in BLOB format into a string
@param input    Blob data representing correct string in @inCharset encoding
@param inCharset    encoding of the Blob data (for example 'ISO 8859-1')
*/
    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }
    
     
}
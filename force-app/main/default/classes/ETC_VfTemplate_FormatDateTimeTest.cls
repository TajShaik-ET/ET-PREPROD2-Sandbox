@isTest
public class ETC_VfTemplate_FormatDateTimeTest {
    
    public static testmethod void FormatDateTime(){
        ETC_VfTemplate_FormatDateTime et = new ETC_VfTemplate_FormatDateTime();
        
         et.getFormattedDatetime();
        
        Datetime GMTDate = Datetime.newInstanceGmt(2011,6,1,12,1,5);
        et.date_time =GMTDate;
        et.defined_format='EEE MMM d kk:mm:ss z yyyy';
        et.getFormattedDatetime();
        
        
    }

}
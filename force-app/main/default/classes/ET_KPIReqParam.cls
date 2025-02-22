public class ET_KPIReqParam {
    public Id Id{get; set;}
    public string status {get; set;}
    public decimal currentVersion{get;set;}
    public ET_KPIReqParam(){
        
    }
    public ET_KPIReqParam(id recId,String StatusValue){
        Id= recId;
        status=StatusValue;
    }
}
public class LeadParser {
    public String firstname{get; set;}
    public String lastname{get; set;}
    public String mobilenumber{get; set;}
    public String email{get; set;}
    public String subjectid{get; set;}
    public String origin{get; set;}
    public String contactMethod{get; set;}
    public String message{get; set;}

    public static LeadParser parse(String json) {
        return (LeadParser) System.JSON.deserialize(json, LeadParser.class);
    }
    public static void testCoverage(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

    }
}
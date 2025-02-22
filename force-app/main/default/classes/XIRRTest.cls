@isTest
public class XIRRTest {

    private static testmethod void test(){
        list<double> lsit = new list<double>();
        lsit.add(-138000);
        lsit.add(355840);
        lsit.add(483030);     
      
        XIRR.calculateExcelIRR(lsit);
        
    }
}
@isTest
public class ETST_LocationController_Test {
    
    public static testMethod void getLocationDetailsTest(){
        
        System.Test.startTest();
        ETST_LocationController.getLocationDetails('123', '123');
        
        ETST_LocationController.southwest sw = new  ETST_LocationController.southwest();
        sw.lng = 12.2;
        sw.lat = 13.2;
        
        ETST_LocationController.northeast ne = new  ETST_LocationController.northeast();
        ne.lng = 12.2;
        ne.lat = 13.2;
        
        ETST_LocationController.location loc = new  ETST_LocationController.location();
        loc.lng = 12.2;
        loc.lat = 13.2;
        
        ETST_LocationController.plus_code pc = new  ETST_LocationController.plus_code();
        pc.global_code = 'globalcode';
        pc.compound_code = 'code';
        
        ETST_LocationController.viewport vp = new  ETST_LocationController.viewport();
        vp.northeast=ne;
        vp.southwest=sw;
        
        ETST_LocationController.geometry gm = new  ETST_LocationController.geometry();
        gm.location=loc;
        gm.location_type='test';
        gm.viewport=vp;
        
        List<String> typeList = new List<String>();
        
        ETST_LocationController.address_components acmp = new  ETST_LocationController.address_components();
        acmp.long_name='Name';
        acmp.short_name='name';
        acmp.types = typeList;
        
        
        ETST_LocationController.results res = new  ETST_LocationController.results();
        res.plus_code=pc;
        res.formatted_address = 'Address';
        res.geometry=gm;
        res.types = typeList;
        res.place_id='1234';
        
        ETST_LocationController.ET_LocationWrapper locw = new  ETST_LocationController.ET_LocationWrapper();
        locw.plus_code=pc;
        locw.status='Test';
        
       // ETST_LocationController.testData();
        System.Test.stopTest();
    }
}
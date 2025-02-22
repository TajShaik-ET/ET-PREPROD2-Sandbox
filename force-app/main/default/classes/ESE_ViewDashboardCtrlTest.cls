@isTest
public class ESE_ViewDashboardCtrlTest {
    
    private static testmethod void createReqData(){
        
        list<string> schList = new list<string>();
        schList.add('Test School');
        ESE_ViewDashboardCtrl.getExecTripDetails(schList,system.today(),system.today());
        
        Account acc = new Account();
        acc.Name ='Test';
        acc.Station_Code__c =1234;
        insert acc;
        ESE_ViewDashboardCtrl.getSchoolList();
        
        ESE_ViewDashboardCtrl.getSeatOccupiedDetails();
        ESE_ViewDashboardCtrl.getTripsMoreThanBefore(schList,system.today(),system.today());
        ESE_ViewDashboardCtrl.getKGTripsMoreThan45(schList,system.today(),system.today());
        ESE_ViewDashboardCtrl.getTripsDuration60_75(schList,system.today(),system.today());
        ESE_ViewDashboardCtrl.getTripsDurationMore75(schList,system.today(),system.today());
        ESE_ViewDashboardCtrl.getTotalStudentRegistrations(schList);
        ESE_ViewDashboardCtrl.getTotalStuWhatsappReq(system.today(),system.today());
        ESE_ViewDashboardCtrl.getBusCountFromTrips(schList,system.today(),system.today());
        
    }

}
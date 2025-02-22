public class ETST_StudentTriggerHandler {
   /* public static void termsAndConditions(List<ETST_Student__c>stdList){
        for (ETST_Student__c std : stdList) {
                // Generate the PDF and convert it to a Blob
                Blob pdfBlob = generatePDF(std);
                
                // Create a new File record and set the necessary fields
                ContentVersion cv = new ContentVersion();
                cv.Title = 'Terms and Conditions PDF';
                cv.PathOnClient = 'Terms and Conditions PDF.pdf';
                cv.VersionData = pdfBlob;
                cv.FirstPublishLocationId = std.Id;
                
                // Insert the new File record
                insert cv;
        }
        
    }
    public static Blob generatePDF(ETST_Student__c std) {
            // Instantiate the Visualforce page and set the student record
            PageReference pageRef = new PageReference('/apex/TermsAndConditions_pdf');
            pageRef.getParameters().put('id', std.Id);
            pageRef.setRedirect(false);
            
            // Render the page as a PDF
            Blob pdfBlob = pageRef.getContent();
            
            return pdfBlob;
        }*/
/*
 * Method: changeStudentSchool
 * Author: Sreelakshmi SK
 * Date: 23 Mar 2023
 * Description: Update the School field in Student when parent changes the student school.
*/    
    public static void changeStudentSchool(Map<Id,ETST_Student__c>newStudentMap,Map<Id,ETST_Student__c>oldStudentMap){ 
        List<ETST_Student__c> updateStudentList=new List<ETST_Student__c>();
        
        set<Id>schoolIds=new set<Id>();
        for(ETST_Student__c student:newStudentMap.values()){
             if(student.ETST_School_Name__c!=null && student.ETST_School_Name__c!=oldStudentMap.get(student.Id).ETST_School_Name__c)
				schoolIds.add(student.ETST_School_Name__c);
        }
        
        if(schoolIds.size()>0){
            Map<id,id>schoolIdVsAccountId=new Map<id,id>();
            for(ETST_School__c school:[Select id,name,Customer__c from ETST_School__c where id IN: schoolIds]){
                schoolIdVsAccountId.put(school.id,school.Customer__c);
            }
            
            for(ETST_Student__c student:newStudentMap.values()){
                if(student.ETST_School_Name__c!=null && student.ETST_School_Name__c!=oldStudentMap.get(student.Id).ETST_School_Name__c){
                    ETST_Student__c tempStudent=new ETST_Student__c();
                    tempStudent.id=student.id;
                    tempStudent.ETST_School__c=schoolIdVsAccountId.get(student.ETST_School_Name__c);
                    
                    updateStudentList.add(tempStudent);
                }
            }
            
            if(updateStudentList.size()>0)
            	update updateStudentList;
            
        }      
    }
    
    /*
 * Method: populateStudentSchool
 * Author: Sreelakshmi SK
 * Date: 4 May 2023
 * Description: Populate the School field in Student when new student is added.
*/    
    
    public static void populateStudentSchool(Map<Id,ETST_Student__c>newStudentMap){ 
        List<ETST_Student__c> updateStudentList=new List<ETST_Student__c>();
        
        set<Id>schoolIds=new set<Id>();
        for(ETST_Student__c student:newStudentMap.values()){
             if(student.ETST_School_Name__c!=null)
				schoolIds.add(student.ETST_School_Name__c);
        }
        
        if(schoolIds.size()>0){
            Map<id,id>schoolIdVsAccountId=new Map<id,id>();
            for(ETST_School__c school:[Select id,name,Customer__c from ETST_School__c where id IN: schoolIds]){
                schoolIdVsAccountId.put(school.id,school.Customer__c);
            }
            
            for(ETST_Student__c student:newStudentMap.values()){
                if(student.ETST_School_Name__c!=null){
                    ETST_Student__c tempStudent=new ETST_Student__c();
                    tempStudent.id=student.id;
                    tempStudent.ETST_School__c=schoolIdVsAccountId.get(student.ETST_School_Name__c);
                    
                    updateStudentList.add(tempStudent);
                }
            }
            
            if(updateStudentList.size()>0)
            	update updateStudentList;
            
        }      
    }
}
public class Common_PostRefreshErrorEmailQueuable implements Queueable {
    
    public List<Messaging.SingleEmailMessage> emailList;
    public Common_PostRefreshErrorEmailQueuable(List<Messaging.SingleEmailMessage> emailList){
        this.emailList=emailList;
    }
    public void execute(QueueableContext context) {
        if(emailList!=null && emailList.size()>0){
            Messaging.SendEmailResult [] emailResults=Messaging.sendEmail(emailList);
        }
    }
}
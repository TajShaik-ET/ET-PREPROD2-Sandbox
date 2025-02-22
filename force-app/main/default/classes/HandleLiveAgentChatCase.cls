public class HandleLiveAgentChatCase {

    @AuraEnabled
    public static LiveChatTranscript getLiveChatRecordData(Id LiveChatTranscriptId){
        system.debug(LiveChatTranscriptId);
        return [Select Id,ContactId,AccountId from LiveChatTranscript where id=:LiveChatTranscriptId];
    }
}
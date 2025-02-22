@isTest
private class HandleLiveAgentChatCase_Test {
    
    @isTest public static void method1(){
        LiveChatVisitor lcv = new LiveChatVisitor();
        try{
            insert lcv;
        }catch(Exception e){}
                LiveChatTranscript lct = new LiveChatTranscript();
        lct.LiveChatVisitorid = lcv.id;
        try{
            insert lct;
        }catch(Exception e){}
        system.debug('lct' + lct);
        LiveChatTranscriptEvent le = new LiveChatTranscriptEvent();
        le.LiveChatTranscriptId = lct.id;
        le.type = 'ChatRequest';
        le.time = system.now();
        try{
            insert le;
        }
        catch(Exception e){}
        Test.startTest();
        HandleLiveAgentChatCase.getLiveChatRecordData(lct.id);
        Test.stopTest();
    }

}
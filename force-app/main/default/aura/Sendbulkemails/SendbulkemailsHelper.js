({
    SendEmail : function(component) {
        var email=this._e('txtEmail').value;
        var Subject=this._e('txtSubject').value;
        var Message=component.get("v.myMessage");   
        var action=component.get("c.processEmail");
        action.setParams({
            email:email,
            Subject:Subject,
            Message:Message
        })
        action.setCallback(this,function(e){
            if(e.getState()=='SUCCESS'){
                var result=e.getReturnValue();
                if(result=='Success'){
                    alert('Email Send Successfully!');
                }
                else{
                    alert(result);
                }
            }
            else{
                alert(JSON.stringify(e.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    _e:function(ele){
        return document.getElementById(ele);
    },
})
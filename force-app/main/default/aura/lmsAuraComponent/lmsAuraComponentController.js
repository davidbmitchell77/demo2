({
    handleMessage : function(component, message)
    {
        if (message != null && message.getParam("message") != null) {
            component.set("v.messageReceived", message.getParam("message").value);
        }
    },
    inputHandler : function(component, event)
    {
        component.set("v.messageValue", event.target.value);
    },
    publishMessage : function(component)
    {
        let msg = component.get("v.messageValue");
        let message =
        {
            message: {
                value: msg
            },
            senderId: {
                value: 'dddd'
            },
            senderAlias: {
                value: 'dmitc'
            },
            senderEmail: {
                value: 'davidbmitchel77@outlook.com'
            },
            senderUsername: {
                value: 'davidbmitchel77@outlook.com.lightning'
            },
            timestamp: {
                 value: new Date()
            }
        };
        component.find("SampleMessageChannel").publish(message);
        component.set("v.messageValue", null);
    },
    initialize : function(component, event, helper)
    {
        component.set("v.noInput", false);
        helper.getToday(component);
    }
})
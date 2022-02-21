({
    initialize: function(component, event, helper)
    {
        console.log("Performing initialization...");
    },
    handleMsg: function(component, event, helper)
    {
        var msg = event.getParam("msg");
        component.set("v.message", msg);
    }
})

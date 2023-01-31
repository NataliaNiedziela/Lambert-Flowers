({
    init : function(component, event, helper) {
        var action = component.get("c.createOrder");
        var oppId = component.get("v.recordId");
		var isactive=component.get("c.get(Order_Created__c)");
        c.set('v.isButtonActive',isactive);

        action.setParams({oppId : oppId});
		action.setCallback(this,function(response){
		});
		$A.enqueueAction(action);
	}
})
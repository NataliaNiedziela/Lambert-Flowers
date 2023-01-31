public class OpportunityOrder {
 @AuraEnabled
     public static list<Order> createOrder(Id oppId) {
		List<OpportunityLineItem > opl = [
            SELECT  UnitPrice, Id, Quantity, TotalPrice  
            FROM OpportunityLineItem  
            WHERE OpportunityId =:oppId Order By CreatedDate 	ASC];
		
         List<Order> ol = new List<Order>();
         
        if(opl.size() > 0 && oppId != null){
            Opportunity OpportunityInfo = [SELECT Pricebook2Id,  AccountId, ContactId, OwnerId  FROM Opportunity WHERE Id =:oppId];
            List<OpportunityLineItem> OpportunityLineItems = [SELECT  UnitPrice, Quantity, PricebookEntryId,Id FROM OpportunityLineItem WHERE Id IN :opl];
            //Insert Order
            Order  Oobj = New Order();
            Oobj.AccountId = OpportunityInfo.AccountId;
            Oobj.BillToContactId = OpportunityInfo.ContactId;
            Oobj.EffectiveDate = date.today();
            Oobj.Status='Draft';
            Oobj.Pricebook2Id=OpportunityInfo.Pricebook2Id;
           	Oobj.EndDate  = date.today()+30;
            Oobj.OpportunityId=OpportunityInfo.Id;
            Insert Oobj;

            List<OrderItem> OrderLineItems = New List<OrderItem>();
            
            List<OpportunityLineItem> oplineItems = New List<OpportunityLineItem>();
            
            for(OpportunityLineItem opli : OpportunityLineItems){
                OrderItem OLobj = New OrderItem();
                OLobj.Quantity = opli.Quantity;
                PricebookEntry pb = [
                    SELECT Product2Id, Pricebook2Id   
                    FROM PricebookEntry 
                    WHERE Id =:opli.PricebookEntryId];
                
                OLobj.Product2Id = pb.Product2Id;
                OLobj.OrderId =Oobj.Id;
                OLobj.UnitPrice  = opli.UnitPrice;
                OLobj.PricebookEntryId=opli.PricebookEntryId;
                OrderLineItems.add(OLobj);
            }
            Insert OrderLineItems;

         
           	OpportunityInfo.StageName='Closed Won';
            upsert OpportunityInfo;

            ol=[select Id from Order where Id = :Oobj.Id];

       }
	   return ol;
    }
}
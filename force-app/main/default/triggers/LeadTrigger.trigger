trigger LeadTrigger on Lead (before insert, before update) {
    if(Trigger.isInsert && Trigger.isBefore){
        Set<string> setFirstName = new set<String>();
        Set<string> setLastName = new set<String>();
        Set<string> setEmail = new set<String>();


        for (Lead el : Trigger.new) {
            setFirstName.add(el.FirstName);
            setLastName.add(el.LastName);
            setEmail.add(el.Email);

        }

        Map<String, Lead> LeadsByFullName = new Map<String, Lead>();
        Map<String, Lead> LeadsByFullNameAndEmail = new Map<String, Lead>();

        for (Lead elExisting : [
                SELECT Id, FirstName, LastName, Email
                FROM Lead
                WHERE (
                        FirstName IN :setFirstName
                        AND LastName IN :setLastName
                ) OR Email IN :setEmail
        ]) {
            LeadsByFullName.put(elExisting.FirstName + elExisting.LastName, elExisting);
            LeadsByFullNameAndEmail.put(elExisting.FirstName + elExisting.LastName + elExisting.Email, elExisting);
        }

        System.debug('LeadsByFullName: ' + LeadsByFullName.keySet());
        System.debug('LeadsByFullNameAndEmail: ' + LeadsByFullNameAndEmail.keySet());

        For (Lead el : trigger.new) {
            if (LeadsByFullNameAndEmail.containsKey(el.FirstName + el.LastName +el.Email)) {
                el.addError('Already Lead Exist with this Name and Last Name and Email');
                break;
            }
            if (LeadsByFullName.containsKey(el.FirstName + el.LastName)) { //ZROBIC POLE I IF FALSE
                el.addError('Already Lead Exist with this Name and Last Name');
            }
        }
    }
}
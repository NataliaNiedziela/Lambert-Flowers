/**
 * Created by natalia.niedziela on 24.01.2023.
 */

public with sharing class fetchLeads {

        public static List<lead> getleads(){
            List<lead> leadList = [SELECT Id, FirstName, LastName, Email FROM Lead];
            return leadList;

    }
}
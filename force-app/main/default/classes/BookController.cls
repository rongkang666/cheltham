public with sharing class BookController {

   @AuraEnabled
   //return a list of books by tags, the search keyword can be part text of tags
    public static List<Book__c> getBooksByTag(string keyword) {

        String key = '%' + keyword + '%';


        //check if Book__c, Book_Tag__c, Tag__c are accessible
        if(!Book__c.SObjectType.getDescribe().isAccessible()
           || !Book_Tag__c.SObjectType.getDescribe().isAccessible()
           || !Tag__c.SObjectType.getDescribe().isAccessible()){
            return null;
        }else {
            return [SELECT Id, Name, Author__c, Summary__c, ISBN__c 
            FROM Book__c 
            WHERE Id IN (SELECT Book__c FROM Book_Tag__c WHERE Tag__r.Name LIKE :key)];    
        }

    }

   @AuraEnabled
   //return a list of books by book name or book summary, or book author
   //or ISBN number. The search keyword can be part text of these book fields
    public static List<Book__c> getBooks(string keyword) {

        String key = '%' + keyword + '%';

        //check if Book__c is accessible
        if(!Book__c.SObjectType.getDescribe().isAccessible()){
                return null;
         }else {
                return [SELECT Id, Name, Author__c, Summary__c, ISBN__c 
                    FROM Book__c 
                    WHERE Name LIKE :key 
                    OR Author__c LIKE :key 
                    OR ISBN__c LIKE :key]; 
         }

    
        
    }

}





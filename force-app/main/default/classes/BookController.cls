public with sharing class BookController {
   @AuraEnabled
   //return a list of books by tags, the search keyword can be part text of tags
    public static List<Book__c> getBooksByTag(string keyword) {
        String key = '%' + keyword + '%';

        List<Book__c> books = [SELECT Id, Name, Author__c, Summary__c, ISBN__c 
        FROM Book__c 
        WHERE Id IN (SELECT Book__c FROM Book_Tag__c WHERE Tag__r.Name LIKE :key)]; 

        return books;
    }
   @AuraEnabled
   //return a list of books by book name or book summary, or book author
   //or ISBN number. The search keyword can be part text of these book fields
    public static List<Book__c> getBooks(string keyword) {
        String key = '%' + keyword + '%';

        List<Book__c> books = [SELECT Id, Name, Author__c, Summary__c, ISBN__c 
        FROM Book__c 
        WHERE Name LIKE :key 
        OR Author__c LIKE :key 
        OR ISBN__c LIKE :key]; 

        return books;
    }

}





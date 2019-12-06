public class BookScraperController {

   
	private ApexPages.StandardSetController setController;
    
    Book__c book = new Book__c();

    public String isbn { get; set; }

   
    
    public BookScraperController(ApexPages.StandardSetController bookStdController) {
        if(isbn == null) {
            isbn = 'input isbn number';
        }
    
    }
  	
    /*
     *storeInfo() is used to retrive Book information from Google Book Api and 
	 *insert Book record with selected data
     * 
     */
    
    public PageReference storeInfo() {
        Map<string,string> info = new Map<string, string> ();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.googleapis.com/books/v1/volumes?q=isbn:' + isbn);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
        	// Deserialize the JSON string into collections of primitive data types.
        
        	Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    
       		List<Object> dataMap = (List<Object>)results.get('items');
            
            // checkItems is used to check if an ISBN is available in Google Book Api
            Object totalItems = results.get('totalItems');
            String checkItems = String.valueOf(totalItems);
            
            /*
            if(checkItems == '1') {
                System.debug('No Problem');
            }else{
                System.debug('Problem');
            }
			*/
            
            
            //System.debug(totalItems);
            
            if(checkItems == '1') {
                
            Map<String, Object> item = (Map<String, Object>)dataMap[0];
        	Map<String, Object> vol = (Map<String, Object>)item.get('volumeInfo');
            Map<string, Object> image = (Map<String, Object>)vol.get('imageLinks');


            //Convert oject to string
           	info.put( 'authors' ,String.valueOf(vol.get('authors')));
            info.put( 'categories' ,String.valueOf(vol.get('categories')));
            info.put( 'title' , String.valueOf(vol.get('title')));
            info.put( 'description' , String.valueOf(vol.get('description')));
            info.put( 'publishedDate' , String.valueOf(vol.get('publishedDate')));
            info.put( 'image' , String.valueOf(image.get('thumbnail')));
            
            
              //Populate Book object fields
        	book.Author__c = info.get('authors');
        	book.Title__c = info.get('title'); 
            book.Name = info.get('title'); 
        	book.Summary__c = info.get('description');
        	book.ISBN__c = isbn;
        	book.Book_Image_Url__c = info.get('image');
       
                try{
                    
                    //prevent insert repeat ISBN
                   	
                   // isbn = ISBN_validation.ISBNConverter(isbn);
                    
                    Book__c[] exist_book = [Select ISBN__c From Book__c Where ISBN__c =: isbn Limit 1];
                    
                    if(exist_book.size() > 0) {
                        
                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Book already exists.'));
                        
                    }else{
                    	insert book;
        
        				//Reinitialize Book to clean Book object
    					book = new Book__c();
                
            			//Show user the insert is successful
             
          				ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully.Thank you!'));
                        
                    }
   
                }catch(DmlException e){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                               'Failed to insert.'));
                }
        	
                
             return null;   
            }else {
                //Show user a message that book is not available in API
                
              ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ISBN cannot be found on API.'));
              return null;  
            }
    
        	
            
        }else {
            
            //Show user response failed
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Failed to reach the API, please make sure to input 10 or 13 ISBN numbers correctly'));
            return null;
        }
        
         
        
    
        	
    }

}
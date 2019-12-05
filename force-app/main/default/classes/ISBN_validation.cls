public class ISBN_validation {
    
    Private Static Final List<Integer> ThirteenISBN_weights = new List<Integer>{1,3,1,3,1,3,1,3,1,3,1,3,0};
    Private Static Final List<Integer> TenISBN_weights = new List<Integer>{10,9,8,7,6,5,4,3,2,0};
    
        public static String CheckDigitGenerator(String partial_ISBN, Integer number_Of_ISBN_digits){
            
            if(number_Of_ISBN_digits == 13){
                // It is the last digit predicted by the first 12 digits of any given 13 digit ISBN code
                Integer lastDigit = 0;
                
                // It is an auxiliary variable to keep track index of elements in ISBN_weights
                Integer ISBN_weights_Index = 0;
                
                // Use the split method to save string as list of its characters
                for(String digits: partial_ISBN.split('')){
                            
                    // It is a formula that calculates the last digit of the ISBN code
                    lastDigit  += Integer.valueOf(digits)* ThirteenISBN_weights[ISBN_weights_Index];
                    ISBN_weights_Index++;
                }
                //Calculating the ISBN's check digit  
                lastDigit = math.mod(10 - math.mod(lastDigit,10), 10 );
                
                return String.valueOf(lastDigit);
            }
            // It checks the check digit of a 10 digit ISBN
            else{
                // It is the last digit predicted by the first 12 digits of any given 13 digit ISBN code
                Integer lastDigit = 0;
                
                // It is an auxiliary variable to keep track index of elements in ISBN_weights
                Integer ISBN_weights_Index = 0;
                
                // Use the split method to save string as list of its characters
                for(String digits: partial_ISBN.split('')){
                            
                    // It is a formula that calculates the last digit of the ISBN code
                    lastDigit  += Integer.valueOf(digits)* TenISBN_weights[ISBN_weights_Index];
                    ISBN_weights_Index++;
                }
                //Calculating the ISBN's check digit  
                lastDigit = math.mod(11 - math.mod(lastDigit,11), 11 );
                
                return String.valueOf(lastDigit);
            }
        }
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////

    // This method converts a 10 digit ISBN to its corresponding 13 digit ISBN
    public static String ISBNConverter(String singleBookISBNString){
        List<String> listOfDigits = singleBookISBNString.split('');
        listOfDigits.remove(singleBookISBNString.length()-1);
        
        listOfDigits.add(0, '8');
        listOfDigits.add(0,'7');
        listOfDigits.add(0, '9');
      
        String expected_Check_digit = CheckDigitGenerator(String.join(listOfDigits,''), 13);
        listOfDigits.add(expected_Check_digit);
        
        return String.join(listOfDigits, '');
    }

    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    
    // This class takes singleBook object in order to add an error if its ISBN is incorrect 
    public static void Validator(Book__c singleBook, String singleBookISBNString, Integer number_Of_ISBN_digits){
    
        if(number_Of_ISBN_digits == 13){
            String expected_Check_digit = CheckDigitGenerator(singleBookISBNString, 13);
            
            // It is checking whether the predicted check digit matches the actual check digit of the ISBN
            if( expected_Check_digit != (singleBookISBNString.split(''))[singleBookISBNString.length()-1] ){
                 singleBook.ISBN__c.addError('This is not a valid ISBN');
            }
        }
        else{
            String expected_Check_digit = CheckDigitGenerator(singleBookISBNString, 10);
            
            // It is checking whether the predicted check digit matches the actual check digit of the ISBN
            if( expected_Check_digit != (singleBookISBNString.split(''))[singleBookISBNString.length()-1] ){
                 singleBook.ISBN__c.addError('This is not a valid ISBN');
            }
        }
    }
 
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

    public static void ISBNFormatChecker(List<Book__c> listOfBooks){
        
        // Creating Pattern in order to check for allowed characters in ISBN, i.e. no letter nor period, etc
        Pattern legitimate_ISBN_pattern;
        
        for(Book__c singleBook: listOfBooks){
            if(singleBook.ISBN__c != NULL){
                // Converting the ISBN into a string
                String singleBookISBNString = String.valueOf(singleBook.ISBN__c);
                               
                // This is checking whether the ISBN is made of only 13 digits
                if(Pattern.matches('[0-9]{13}',singleBookISBNString)){
                    Validator(singleBook, singleBookISBNString, 13);
                }
                // This is checking whether the ISBN is made of only 10 digits
                else if(Pattern.matches('[0-9]{10}',singleBookISBNString)){
                    Validator(singleBook, singleBookISBNString,10);
                    singleBook.ISBN__c = ISBNConverter(singleBookISBNString);
                }
                // This part deals with invalid ISBNs
                else{
                    singleBook.ISBN__c.addError('ISBN is a 13 or 10 digit code. Please enter 13 or 10 digits only');

                }
            }
        }
     }
}
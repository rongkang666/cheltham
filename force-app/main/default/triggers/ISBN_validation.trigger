trigger ISBN_validation on Book__c (before insert, before update) {
    ISBN_validation.ISBNFormatChecker(trigger.new);
}
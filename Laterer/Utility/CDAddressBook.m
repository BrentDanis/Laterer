//
//  CDAddressBook.m
//  ContactList
//
//  Created by Nimble Chapps on 27/02/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "CDAddressBook.h"
@import AddressBook;

@interface CDAddressBook () {
    
    NSArray *contactIndexTitles;
    NSMutableArray *contactSectionTitles;
    NSArray *contactList;
    NSMutableArray *sortedContactList;
    NSMutableDictionary *alphabaticallyGroupedContactList;
}

@end

@implementation CDAddressBook

-(id) init {
    if (self = [super init]) {
        
        contactIndexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
        contactSectionTitles = [[NSMutableArray alloc] init];
        contactList = [[NSArray alloc] init];
        sortedContactList = [[NSMutableArray alloc] init];
        alphabaticallyGroupedContactList = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


-(NSArray *) getContactIndexTitles {
    
    return contactIndexTitles;
}

-(NSArray *) getContactSectionTitles {
    if (alphabaticallyGroupedContactList.count == 0) {
        [self getAlphabeticallyGroupedContactList];
    }
    
    return contactSectionTitles;
}

-(NSArray *) getContactList {
    
    if ([self isContactAccessible]) {
        
        NSMutableArray *contacts = [[NSMutableArray alloc] init];
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        
        for(int i = 0; i < numberOfPeople; i++) {
            
            ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
            
            //record id
            NSNumber *recordId = [CDAddressBook recordIdFromPersonRecord:person];
            
            // name
            NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            NSString *fullName = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
            
            // phone
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            NSMutableArray *phoneNumberList = (__bridge NSMutableArray *)(ABMultiValueCopyArrayOfAllValues(phoneNumbers));
            
            // email
            ABMultiValueRef emailMultiValue = ABRecordCopyValue(person, kABPersonEmailProperty);
            NSMutableArray *emailAddresses = (__bridge NSMutableArray *)ABMultiValueCopyArrayOfAllValues(emailMultiValue);
            
            // making dictionary
            if (phoneNumberList.count > 0 || emailAddresses.count > 0) { //
                
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setObject:recordId forKey:@"recordID"];
                [tempDict setObject:fullName forKey:@"fullName"];
                
                if (phoneNumberList == nil) {
                    [tempDict setObject:[NSNull null] forKey:@"phones"];
                    NSLog(@"ABAddressBook - Phone list nil");
                } else {
                    [tempDict setObject:phoneNumberList forKey:@"phones"];
                }
                
                if (emailAddresses == nil) {
                    [tempDict setObject:[NSNull null] forKey:@"emails"];
                    NSLog(@"ABAddressBook - email list nil");
                } else {
                    [tempDict setObject:emailAddresses forKey:@"emails"];
                }
                
                [contacts addObject:tempDict];
            }
        }
        contactList = [contacts copy];
    }
   
    return  contactList;
}

-(NSMutableArray *) getSortedContactList {
    if (contactList.count == 0) {
        [self getContactList];
    }
    [sortedContactList removeAllObjects];
    [sortedContactList addObjectsFromArray:contactList];
    [sortedContactList sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES]]];
   
    return sortedContactList;
}

-(NSDictionary *) getAlphabeticallyGroupedContactList {
    if (sortedContactList.count == 0) {
        [self getSortedContactList];
    }
    
    // Alphabatically Group
    if ( !(alphabaticallyGroupedContactList.count > 0)) {
        
        int contactPosition = 0;
        BOOL isMatched = NO;
        for(int i = 0; i < contactIndexTitles.count; i++) {
            
            NSMutableArray *categoryContacts = [[NSMutableArray alloc] init];
            
            for (int j = contactPosition; j < sortedContactList.count; j++ ) {
                
                NSString *name = sortedContactList[j][@"fullName"];
                if ([contactIndexTitles[i] isEqualToString:[name substringToIndex:1]]) {
                    
                    [categoryContacts addObject:sortedContactList[j]];
                    contactPosition = j;
                    isMatched = YES;
                }
            }
            
            if(isMatched) {
                [contactSectionTitles addObject:contactIndexTitles[i]];
                [alphabaticallyGroupedContactList setValue:categoryContacts forKey:[NSString stringWithFormat:@"%@", contactIndexTitles[i]]];
                isMatched = NO;
            }
        }
    }
    return alphabaticallyGroupedContactList;
}

-(BOOL)isContactAccessible {
    
    __block BOOL isAccessible = NO;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                isAccessible = YES;
            } else {
                isAccessible = NO;
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        isAccessible = YES;
    }
    else {
        isAccessible = NO;
    }
    NSLog(@"Phone book access - %@",isAccessible ? @"Yes" : @"No");
    return isAccessible;
}

+ (NSNumber *)recordIdFromPersonRecord:(ABRecordRef)personRecord
{
    ABRecordID recordId = ABRecordGetRecordID(personRecord);
    return [NSNumber numberWithInt:(int)recordId];
}

/*
 all phones
 
 //            for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
 //                NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
 //                NSLog(@"phone:%@", phoneNumber);
 //            }
 
 */

@end

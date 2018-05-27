//
//  CDAddressBook.h
//  ContactList
//
//  Created by Nimble Chapps on 27/02/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDAddressBook : NSObject

-(NSArray *) getContactIndexTitles;
-(NSArray *) getContactSectionTitles;
-(NSArray *) getContactList;
-(NSMutableArray *) getSortedContactList;
-(NSDictionary *) getAlphabeticallyGroupedContactList;

@end

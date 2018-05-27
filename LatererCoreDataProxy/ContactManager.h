//
//  ContactManager.h
//  laterer
//
//  Created by Nimble Chapps on 14/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataManager.h"

@interface ContactManager : NSObject

+ (id)sharedContactManager;

+(NSArray *)fetchAllContacts;

+(void)saveContact:(NSDictionary *)contactDetail;
+(void)updateContactDetail:(NSDictionary *)contactDetail;

+(void)updateContactForImage:(NSData *)imageData contactId:(NSNumber*)contactId;

@end

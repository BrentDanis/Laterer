//
//  ContactManager.m
//  laterer
//
//  Created by Nimble Chapps on 14/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "ContactManager.h"

@implementation ContactManager

+(id)sharedContactManager {
    static ContactManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+(void)saveContact:(NSDictionary *)contactDetail {
    NSManagedObject *newContact = [NSEntityDescription insertNewObjectForEntityForName:@"LatererContacts" inManagedObjectContext:[DataManager getContext]];
    
    NSNumber *numId = @([contactDetail[@"iContactID"] intValue]);
    [newContact setValue:numId forKey:@"id"];
    [newContact setValue:contactDetail forKey:@"contactDetail"];
//    [newContact setValue:nil forKey:@"contactImage"];
    
    [DataManager saveManagedContext];
    NSLog(@"save contact");
}

+(void)updateContactDetail:(NSDictionary *)contactDetail {

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"LatererContacts"];
    request.predicate = [NSPredicate predicateWithFormat:@"id==%@",contactDetail[@"iContactID"]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]];
    NSArray *results = [[DataManager getContext] executeFetchRequest:request error:nil];
    
    if (results.count > 0) {
        NSManagedObject *contactObject = [results objectAtIndex:0];
        [contactObject setValue:contactDetail forKey:@"contactDetail"];
        [DataManager saveManagedContext];
        NSLog(@"Contact detail Updated in DB");
    }

}

+(void)updateContactForImage:(NSData *)imageData contactId:(NSNumber*)contactId {

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"LatererContacts"];
    request.predicate = [NSPredicate predicateWithFormat:@"id==%@",contactId];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]];
    NSArray *results = [[DataManager getContext] executeFetchRequest:request error:nil];

    if (results.count > 0) {
        NSManagedObject *contactObject = [results objectAtIndex:0];
        [contactObject setValue:imageData forKey:@"contactImage"];
        [DataManager saveManagedContext];
        NSLog(@"Contact Image Updated in DB");
    }
}

+(NSArray *)fetchAllContacts {

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"LatererContacts"];
    NSArray *array = [[[DataManager getContext] executeFetchRequest:fetchRequest error:nil] copy];
    
    NSMutableArray *contactArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        
        NSManagedObject *contactObject = [array objectAtIndex:i];
        NSMutableDictionary *contactDict = [[NSMutableDictionary alloc] init];
        [contactDict setObject:[contactObject valueForKey:@"id"] forKey:@"id"];
        [contactDict setObject:[contactObject valueForKey:@"contactDetail"] forKey:@"contactDetail"];
        if ([contactObject valueForKey:@"contactImage"] != nil) {
            [contactDict setObject:[contactObject valueForKey:@"contactImage"] forKey:@"contactImage"];
        }

        [contactArray addObject:contactDict];
//        NSLog(@"id    - %@",[contactObject valueForKey:@"id"]);
//        NSLog(@"data  - %@",[contactObject valueForKey:@"contactDetail"]);
//        NSLog(@"image - %@",[contactObject valueForKey:@"contactImage"]);
    }
    
    return contactArray;
}

@end

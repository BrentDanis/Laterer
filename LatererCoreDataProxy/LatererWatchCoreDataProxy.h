//
//  DataManager.h
//  laterer
//
//  Created by Nimble Chapps on 14/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LatererWatchCoreDataProxy : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

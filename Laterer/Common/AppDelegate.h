//
//  AppDelegate.h
//  Laterer
//
//  Created by Nimble Chapps on 02/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDLocation.h"
#import <CoreData/CoreData.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;

-(void)uploadPhoneContacts;

//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//
//- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;

@end


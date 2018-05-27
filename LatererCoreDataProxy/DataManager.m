//
//  DataManager.m
//  laterer
//
//  Created by Nimble Chapps on 14/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "DataManager.h"
#import "LatererWatchCoreDataProxy.h"

@implementation DataManager

+(NSManagedObjectContext *)getContext {
    LatererWatchCoreDataProxy *sharedInstance = [LatererWatchCoreDataProxy sharedInstance];
    return sharedInstance.managedObjectContext;
}

+(void) saveManagedContext {
    NSError *error;
    if (![[self getContext] save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

@end

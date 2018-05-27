//
//  DataManager.h
//  laterer
//
//  Created by Nimble Chapps on 14/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

+(NSManagedObjectContext *)getContext;
+(void) saveManagedContext;

@end

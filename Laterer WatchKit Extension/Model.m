//
//  Model.m
//  WatchHelloWorld
//
//  Created by JAVIER CALATRAVA LLAVERIA on 27/12/14.
//  Copyright (c) 2014 JAVIER CALATRAVA LLAVERIA. All rights reserved.
//

#import "Model.h"
#import "Constant.h"


@interface Model() {
//    NSUserDefaults *sharedDefaults;
}
@end

@implementation Model;

static Model *aModelClassInstance;

-(id)init
{
    self = [super init];
    if(self)
    {
        aModelClassInstance=self;
    }
    return self;
}

+(id)getInstance
{
    return aModelClassInstance;
}

// User Id
+(void)setLatererUserId:(NSString*)userId {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:__APP_GROUP__];
    [sharedDefaults setObject:userId forKey:kLatererUserID];
}

+(NSString*)getLatereUserId {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:__APP_GROUP__];
    return [sharedDefaults objectForKey:kLatererUserID];
}

+(void)removeLatererUserIdAndDetail {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:__APP_GROUP__];
    [sharedDefaults removeObjectForKey:kLatererUserID];
    [sharedDefaults removeObjectForKey:kLatererUserDetail];
}

// User Detail
+(void)setLatererUserDetail:(NSDictionary*)userDetail {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:__APP_GROUP__];
    [sharedDefaults setObject:userDetail forKey:kLatererUserDetail];
}

+(NSDictionary *)getLatererUserDetail {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:__APP_GROUP__];
    return [sharedDefaults objectForKey:kLatererUserDetail];
}

+(void)removeLatererUserDetail {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:__APP_GROUP__];
    [sharedDefaults removeObjectForKey:kLatererUserDetail];
}

// Lat Long

+(void)setLatLong:(float)lat andLong:(float)longtitude {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:__APP_GROUP__];
    [sharedDefaults setFloat:lat forKey:kLatererUserLatitude];
    [sharedDefaults setFloat:longtitude forKey:kLatererUserLongitude];
}

+(float)getLatitude {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:__APP_GROUP__];
    return [[sharedDefaults objectForKey:kLatererUserLatitude] floatValue];
}

+(float)getLongitude {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:__APP_GROUP__];
    return [[sharedDefaults objectForKey:kLatererUserLongitude] floatValue];
}

@end

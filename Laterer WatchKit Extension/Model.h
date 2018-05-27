//
//  Model.h
//  WatchHelloWorld
//
//  Created by JAVIER CALATRAVA LLAVERIA on 27/12/14.
//  Copyright (c) 2014 JAVIER CALATRAVA LLAVERIA. All rights reserved.
//

#import <Foundation/Foundation.h>

//#ifdef TARGET_APP_NO_WATCH
//#else
#import "InterfaceController.h"
//#endif

@interface Model : NSObject

+(Model*)getInstance;

+(void)setLatererUserId:(NSString*)userId;
+(NSString*)getLatereUserId;

+(void)setLatererUserDetail:(NSDictionary*)userDetail;
+(NSDictionary *)getLatererUserDetail;

+(void)removeLatererUserIdAndDetail;
+(void)removeLatererUserDetail;

// Lat Long
+(void)setLatLong:(float)lat andLong:(float)longtitude;
+(float)getLatitude;
+(float)getLongitude;
@end

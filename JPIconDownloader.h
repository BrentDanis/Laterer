//
//  XMLDownload.h
//  SmartAppTest
//
//  Created by Chirag Leuva on 5/20/13.
//  Copyright (c) 2013 AppMaggot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void(^JPSuccessBlock)(NSMutableData *data);
typedef  void(^JPFailBlock)(NSString *error);

@interface JPIconDownloader : NSOperation

+(id)downloadFromUrl:(NSString*)urlString
   complicationBlock:(JPSuccessBlock)complicationBlock
         failerBlock:(JPFailBlock)failerBlock;

+(id)downloadFromUrl:(NSString*)urlString
   complicationBlock:(JPSuccessBlock)block;


@end

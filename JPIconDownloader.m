//
//  XMLDownload.m
//  SmartAppTest
//
//  Created by Chirag Leuva on 5/20/13.
//  Copyright (c) 2013 AppMaggot. All rights reserved.
//

#import "JPIconDownloader.h"

@interface JPIconDownloader () <NSURLConnectionDataDelegate> {
    
    JPSuccessBlock  _block;
    JPFailBlock     _failBlock;
    NSMutableData *mutableData;
    
}


@end

@implementation JPIconDownloader


+(id)downloadFromUrl:(NSString*)urlString
   complicationBlock:(JPSuccessBlock)block
{
    JPIconDownloader *object = [[JPIconDownloader alloc]init];
    [object downloadWithUrl:urlString
          complicationBlock:block
                failerBlock:nil];
    return object;
}


+(id)downloadFromUrl:(NSString*)urlString
   complicationBlock:(JPSuccessBlock)block
         failerBlock:(JPFailBlock)failerBlock

{
    JPIconDownloader *object = [[JPIconDownloader alloc]init];
    [object downloadWithUrl:urlString
          complicationBlock:block
                failerBlock:failerBlock];
    return object;
}



-(void)downloadWithUrl:(NSString*)urlString
     complicationBlock:(JPSuccessBlock)complicationBlock
           failerBlock:(JPFailBlock)failerBlock
{
    _block = complicationBlock;
    _failBlock = failerBlock;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:100];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if([self isCancelled]) return;
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if([self isCancelled]) return;
    mutableData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if([self isCancelled]) return;
    [mutableData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([self isCancelled]) return;
    if(_failBlock)
        _failBlock([error localizedDescription]);
}

-(void)cancelDownloading
{
    if(_failBlock)
        _failBlock(@"Operation Cancelled");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([self isCancelled]) return;
    _block(mutableData);
}

-(void)dealloc
{
    [self cancelDownloading];
}


@end

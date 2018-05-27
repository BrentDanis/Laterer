//
//  JPLazyImageDownloader.m
//  LazyTableImages
//
//  Created by Chirag Leuva on 7/1/13.
//
//

#import "JPLazyImageDownloader.h"
#import "JPIconDownloader.h"
#import "DocumentDirectoryAccess.h" 

@interface JPLazyImageDownloader ()
{
    NSMutableDictionary  *_allDownloadObjects;
    DocumentDirectoryAccess *storeRoom;
    UIImage *_holder;
}

@property(nonatomic,strong) NSCache *allImages;

@end


@implementation JPLazyImageDownloader



-(id)init
{
    self = [super init];
    if(self){
        _allDownloadObjects = [[NSMutableDictionary alloc]init];
        storeRoom           = [DocumentDirectoryAccess object];
    }
    return self;
}

-(void)downloadImageFromUrl:(NSString*)thumbString
               forIndexPath:(NSIndexPath*)indexPath
            completionBlock:(JPLazyBlock)block
{
    
    if(!_holder)
        _holder = [UIImage imageNamed:@"NoProfile"];
    
    block(_holder,nil);
    
    if(![thumbString length])
        return;
    
    NSString *fileName =  [thumbString lastPathComponent];
    
    if(![fileName length])
        return;
    
     NSString *thumbName  =  [NSString stringWithFormat:@"thumb-%@",fileName];

    if([storeRoom doesFileExistForKey:thumbName])
    {
        UIImage *img = [storeRoom imageForKey:thumbName];
        if(img)
            block(img,nil);
    }
    else
    {
        JPIconDownloader *obj =
        [JPIconDownloader downloadFromUrl:thumbString
                        complicationBlock:^(NSMutableData *data)
         {
             UIImage *img = [UIImage imageWithData:data];
             if(img)
             {
                 [storeRoom setImage:img forKey:thumbName];
                 block(img,indexPath);
             }
         }];
        [_allDownloadObjects setObject:obj forKey:indexPath];
    }
    
}

-(void)downloadImageFromUrl:(NSString*)urlString
                   thumbUrl:(NSString*)thumbString
               forIndexPath:(NSIndexPath*)indexPath
            completionBlock:(JPLazyBlock)block
{
    
    if(!_holder)
        _holder = [UIImage imageNamed:@"NoProfile"];
    
    NSString *thumbName  =  [NSString stringWithFormat:@"thumb-%@",[thumbString lastPathComponent]];
    if([storeRoom doesFileExistForKey:thumbName])
    {
        UIImage *img = [storeRoom imageForKey:thumbName];
        if(img)
            block(img,nil);
    }
    else
        block(_holder,nil);
    
    if(![urlString length])
        return;
    
    NSString *fileName  =  [urlString lastPathComponent];
    if(![fileName length])
        return;
    
    
    if([storeRoom doesFileExistForKey:fileName])
    {
        UIImage *img = [storeRoom imageForKey:fileName];
        if(img)
            block(img,nil);
    }
    else
    {
        void (^mainImageBlock)(void) = ^{
            JPIconDownloader *mainDownloader =
            [JPIconDownloader downloadFromUrl:urlString
                            complicationBlock:^(NSMutableData *data)
             {
                 UIImage *imgMain = [UIImage imageWithData:data];
                 if(imgMain){
                     [storeRoom setImage:imgMain forKey:fileName];
                     block(imgMain,indexPath);
                 }
             }];
            [_allDownloadObjects setObject:mainDownloader forKey:indexPath];
        };
        
        if(![storeRoom doesFileExistForKey:thumbName])
            [JPIconDownloader downloadFromUrl:thumbString
                            complicationBlock:^(NSMutableData *data)
             {
                 UIImage *imgThumb = [UIImage imageWithData:data];
                 if(imgThumb){
                     [storeRoom setImage:imgThumb forKey:thumbName];
                     block(imgThumb,indexPath);
                 }
                 mainImageBlock();
             }];
        else
        {
            mainImageBlock();
        }
        
    }
}

- (void)setPlaceHolderImage:(UIImage*)imgPlace
{
    _holder = imgPlace;
}

-(void)cancelDownlingForIndexPath:(id)indexPath
{
    JPIconDownloader *objDownloader = _allDownloadObjects[indexPath];
    if(objDownloader){
        [objDownloader cancel];
    }
}

-(void)cancelAlldownloading:(NSIndexPath*)indexpath
{
    [_allDownloadObjects enumerateKeysAndObjectsUsingBlock:^(id key, JPIconDownloader *obj, BOOL *stop) {
        [obj cancel];
    }];
}



@end

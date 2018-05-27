//
//  DocumentDirectoryAccess.m
//  PurchaseAssistant
//
//  Created by indianic on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DocumentDirectoryAccess.h"


@interface DocumentDirectoryAccess ()

@property (nonatomic,copy)  NSString *imgFolderPath;
@property (nonatomic,copy)  NSString *objectFolderPath;
@property (nonatomic,strong) NSFileManager *fileManager;

@end


@implementation DocumentDirectoryAccess

static DocumentDirectoryAccess *object = nil;

+ (instancetype) object
{
    if(!object)
    object = [[DocumentDirectoryAccess alloc]init];
	return object;
}


#pragma mark - Getter Methods

-(NSFileManager *)fileManager
{
    if(_fileManager)
        return _fileManager;
    _fileManager = [NSFileManager defaultManager];
    return _fileManager;
}

-(NSString *)imgFolderPath
{
    if(_imgFolderPath)
        return _imgFolderPath;
    _imgFolderPath = [self cachePathWithFolderName:@"assets"];
    return _imgFolderPath;
}

-(NSString *)objectFolderPath
{
    if(_objectFolderPath)
        return _objectFolderPath;
    _objectFolderPath = [self cachePathWithFolderName:@"objects"];
    return _objectFolderPath;
}

- (NSString*)cachePathWithFolderName:(NSString*)folderName
{
    NSArray *paths              =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory    = [paths objectAtIndex:0];
    NSString *aPath             = [cacheDirectory stringByAppendingPathComponent:folderName];
    
    if(![self.fileManager fileExistsAtPath:aPath])
        [self.fileManager createDirectoryAtPath:aPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return aPath;
}


#pragma mark - Image Methods

- (BOOL)setImage:(UIImage *)image forKey:(NSString *)fileName
{
    NSData *imageData  = UIImageJPEGRepresentation(image,1);
    NSString *fullPath = [self.imgFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
    return [self.fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
}

- (UIImage *)imageForKey:(NSString *)fileName
{
    NSString *fullPath = [self.imgFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
    if([self.fileManager fileExistsAtPath:fullPath])
        return [UIImage imageWithContentsOfFile:fullPath];
    
    return nil;
}

- (BOOL)removeImageForKey:(NSString*)fileName
{
    NSString *fullPath = [self.imgFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
    if([self.fileManager fileExistsAtPath:fullPath])
        return [self.fileManager removeItemAtPath: fullPath error:NULL];
    return NO;
}


#pragma mark - Object Methods

- (id)objectForKey:(NSString*)fileName
{
    NSString *fullPath = [self.objectFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
    if([self.fileManager fileExistsAtPath:fullPath])
        return [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
    return nil;
}

- (BOOL)setObject:(id)object forKey:(NSString*)fileName
{
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSString *fullPath = [self.objectFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
    return [self.fileManager createFileAtPath:fullPath contents:archivedData attributes:nil];
}

- (BOOL)removeObjectForKey:(NSString*)fileName
{
    NSString *fullPath = [self.objectFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
    if([self.fileManager fileExistsAtPath:fullPath])
        return [self.fileManager removeItemAtPath: fullPath error:NULL];
    return NO;
}

- (void)setObject:(id)obj forKeyedSubscript:(NSString*)key
{
    [self setObject:obj forKey:key];
}

- (id)objectForKeyedSubscript:(NSString*)key
{
    return [self objectForKey:key];
}


#pragma mark - Common Methods

-(BOOL)doesFileExistForKey:(NSString*)filename
{
    if(![filename length])
        return NO;
    
    NSString *fullImagePath = [self.imgFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", filename]];
    if([self.fileManager fileExistsAtPath:fullImagePath])
        return YES;
    
    NSString *fullObjectPath = [self.objectFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", filename]];
    if([self.fileManager fileExistsAtPath:fullObjectPath])
        return YES;
    
    return NO;
}




@end

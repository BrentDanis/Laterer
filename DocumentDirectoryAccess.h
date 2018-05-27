//
//  DocumentDirectoryAccess.h
//  PurchaseAssistant
//
//  Created by indianic on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentDirectoryAccess : NSObject

+ (DocumentDirectoryAccess *) object;

- (BOOL)setImage:(UIImage *)image forKey:(NSString *)fileName;
- (UIImage *)imageForKey:(NSString *)fileName;
- (BOOL)removeImageForKey:(NSString*)fileName;

/* object methods can be user for images */
- (id)objectForKey:(NSString*)fileName;
- (BOOL)setObject:(id)object forKey:(NSString*)fileName;
- (BOOL)removeObjectForKey:(NSString*)fileName;

- (BOOL)doesFileExistForKey:(NSString*)filename;

/* for objectiv-c Object literals */
- (void)setObject:(id)obj forKeyedSubscript:(NSString*)key;
- (id)objectForKeyedSubscript:(NSString*)key;

- (void)removeAllObjects;

@end

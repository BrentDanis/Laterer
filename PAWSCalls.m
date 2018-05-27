//
//  WSCalls.m
//  Wizit
//
//  Created by iOSDeveloper2 on 18/06/14.
//  Copyright (c) 2014 Yudiz Pvt Solution Ltd. All rights reserved.
//

#import "PAWSCalls.h"
#import "AFNetworking.h"

#define kUserID @"iUserID"
#define kMessage @"vMessageTitle"
#define kLat @"fLat"
#define kLong @"fLong"

static AFHTTPSessionManager *manager;

@interface PAWSCalls()

+ (NSURLSessionDataTask*)simpleGetRequestWithRelativePath:(NSString*)relativePath
                                                paramater:(NSDictionary*)param
                                                    block:(WebCallBlockSession)block;

+ (NSURLSessionDataTask*)simpleMultipartPostRequestWithRelativePath:(NSString*)relativePath
                                                          parameter:(NSDictionary*)param
                                                              image:(UIImage*)image
                                                              block:(WebCallBlockSession)block;

+ (NSURLSessionDataTask *)simpleGetRequestWithRelativePathAndData:(NSString*)relativePath
                                                        paramater:(NSData*)param
                                                            block:(WebCallBlockSession)block;

@end


@implementation PAWSCalls


+ (void)initialize
{
    manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBasePath]];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable){
            showAlertViewWithMessageAndTitle(@"Internet connection seems to be down.", @"No Internet");
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
}


/*
 --------------------------------------------------------------------------------
 */

// Registration
+ (void)registerUserWithParam:(NSDictionary*)param image:(UIImage*)image completionBlock:(WebCallBlockSession)block {
    NSLog(@"------------------- Registration -------------------");
    [self simpleMultipartPostRequestWithRelativePath:@"registration"
                                           parameter:param image:image block:block];
}

// Login
+ (void)loginUserWithUsername:(NSString*)username password:(NSString*)password completionBlock:(WebCallBlockSession)block {
    NSLog(@"------------------- Login -------------------");
    
    
    [self simpleGetRequestWithRelativePath:@"login"
                                 paramater:@{ @"vUsername" : username,
                                              @"vPassword" : password,
                                              @"vDeviceToken" : [userDefault objectForKey:kDeviceToken],
                                              @"vDeviceType"  : @"iphone"}
                                     block:block];
}

// Fetch All Contacts
+ (void)fetchAllContactsWithCompletionBlock:(NSString *)userID  completionBlock:(WebCallBlockSession)block
{
    NSLog(@"------------------- All Contacts -------------------");
    [self simpleGetRequestWithRelativePath:@"contact" paramater:@{@"iUserID" : userID} block:block];
}

// Upload Phone Contacts
+ (void)uploadPhoneContactsWithParam:(NSDictionary*)contactList completionBlock:(WebCallBlockSession)block
{
    NSLog(@"------------------- Upload Contacts -------------------");

    [self simplePostRequestWithRelativePath:@"contact/add" paramater:contactList block:block];
}

// push notification
+ (void)sendPushNotificationWithCompletionBlock:(NSDictionary *)pushNotificationData completionBlock:(WebCallBlockSession)block {

    NSLog(@"------------------- Push Notification -------------------");
    
    [self simpleGetRequestWithRelativePath:@"notification" paramater:pushNotificationData block:block];
}

// Logout
+ (void)logoutUserWithUserId:(NSString*)userId completionBlock:(WebCallBlockSession)block {

    NSLog(@"------------------- Logout -------------------");

    [self simpleGetRequestWithRelativePath:@"logout" paramater:@{@"iUserID" : userId} block:block];
}

// Change Password
+ (void)changePassword:(NSString*)oldPassword newPassword:(NSString*)newPassword completionBlock:(WebCallBlockSession)block {
    
    NSLog(@"------------------- Change Password -------------------");

    NSLog(@"%@ - %@ -- %@", oldPassword, newPassword, [Model getLatereUserId]);
    
    [self simpleGetRequestWithRelativePath:@"user/changePassword"
                                 paramater:@{ @"iUserID"      : [Model getLatereUserId],
                                              @"vOldPassword" : oldPassword,
                                              @"vNewPassword" : newPassword
                                            }
                                     block:block];
}

// Update User Profile
+ (void)updateUserProfileWithParam:(NSDictionary*)param image:(UIImage*)image completionBlock:(WebCallBlockSession)block {
    NSLog(@"------------------- Update User Profile -------------------");
    [self simpleMultipartPostRequestWithRelativePath:@"user/editProfile"
                                           parameter:param image:image block:block];
}

// Block User
+ (void)blockUserWithUserId:(NSString*)userId
                  contactId:(NSString*)contactId
            completionBlock:(WebCallBlockSession)block {

    [self simpleGetRequestWithRelativePath:@"contact/blockcontact"
                                 paramater:@{
                                              @"iUserID" : userId,
                                              @"iContactID" : contactId
                                            }
                                     block:block];
}

//Unblock
+ (void)unBlockUserWithUserId:(NSString*)userId
                    contactId:(NSString*)contactId
              completionBlock:(WebCallBlockSession)block {
    
    [self simpleGetRequestWithRelativePath:@"contact/unBlockContact"
                                 paramater:@{
                                             @"iUserID" : userId,
                                             @"iContactID" : contactId
                                             }
                                     block:block];

}
/****************************************************************************************/

// Registration
// Update User Profile
+ (NSURLSessionDataTask*)simpleMultipartPostRequestWithRelativePath:(NSString*)relativePath
                                                          parameter:(NSDictionary*)param
                                                              image:(UIImage*)image
                                                              block:(WebCallBlockSession)block
{
    NSLog(@"Relative Path : %@",relativePath);
    NSLog(@"Param : %@",param);
    NSLog(@"Image : %@",image);
    
    return  [manager POST:relativePath
               parameters:param
constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
             {
                 if(image)
                     [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.9)
                                                 name:@"vImage"
                                             fileName:[NSString stringWithFormat:@"%@.jpeg",NSImageNameStringFromCurrentDate()]
                                             mimeType:@"image/jpeg"];
                 // NSImageNameStringFromCurrentDate()
             } success:^(NSURLSessionDataTask *task, id responseObject)
             {
                 NSLog(@"Response : %@",responseObject);
                 /*  Check if object is array or dictionary.
                  If Dictionary, check for error_code flag.
                  If its availabke than check its value. */
                 if([responseObject isKindOfClass:[NSArray class]]) {
                     block(responseObject,WebServiceResultSuccess);
                 }
                 else {
                     if(responseObject[@"error_code"])
                     {
                         // if value of error code is 1, It will be error.
                         int errorCode = [responseObject[@"error_code"] intValue];
                         if(errorCode == 0)
                             block(responseObject,WebServiceResultSuccess);
                         else {
                             showAlertViewWithMessage(responseObject[@"error_message"]);
                             block(responseObject,WebServiceResultFail);
                         }
                     }
                     else
                         block(responseObject,WebServiceResultSuccess);
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error)
             {
                 NSLog(@"localizedDescription %@",error);
                 NSLog(@"localizedFailureReason %@",error.localizedFailureReason);
                 NSLog(@"localizedRecoverySuggestion %@",error.localizedRecoverySuggestion);
                 block(nil,WebServiceResultError);
                 if(error.code != -1009)
                     showAlertViewWithMessage(error.localizedDescription);
             }];
}

// Login
// Fetch contacts
// Logout
// Block User
+ (NSURLSessionDataTask *)simpleGetRequestWithRelativePath:(NSString*)relativePath
                                                 paramater:(NSDictionary*)param
                                                     block:(WebCallBlockSession)block
{
    NSLog(@"Relative Path : %@",relativePath);
    NSLog(@"Param : %@",param);
    
    return [manager GET:relativePath
             parameters:param
                success:^(NSURLSessionDataTask *task, id responseObject)
                {
                    NSLog(@"Response: %@",responseObject);
                    /*  Check if object is array or dictionary.
                     If Dictionary, check for error_code flag.
                     If its availabke than check its value. */
                    if([responseObject isKindOfClass:[NSArray class]]) {
                        block(responseObject,WebServiceResultSuccess);
                    }
                    else {
                        if(responseObject[@"error_code"])
                        {
                            // if value of error code is 1, It will be error.
                            int errorCode = [responseObject[@"error_code"] intValue];
                            if(errorCode == 0)
                                block(responseObject,WebServiceResultSuccess);
                            else {
                                showAlertViewWithMessage(responseObject[@"error_message"]);
                                block(responseObject,WebServiceResultFail);
                            }
                        }
                        else
                            block(responseObject,WebServiceResultSuccess);
                    }
                }
                failure:^(NSURLSessionDataTask *task, NSError *error)
                {
                    NSLog(@"Error: %@",error);
                    block(nil,WebServiceResultError);
                    /* If error code is this ignore aler view. its due to internet connection. */
                    if(error.code != -1009)
                        showAlertViewWithMessage(error.localizedDescription);
                }];
}


// Upload Contacts with post
+ (NSURLSessionDataTask *)simplePostRequestWithRelativePath:(NSString*)relativePath
                                                 paramater:(NSDictionary*)param
                                                     block:(WebCallBlockSession)block
{
    NSLog(@"Relative Path : %@",relativePath);
    NSLog(@"Param : %@",param);
    
    return [manager POST:relativePath
             parameters:param
                success:^(NSURLSessionDataTask *task, id responseObject)
            {
                NSLog(@"Response: %@",responseObject);
                /*  Check if object is array or dictionary.
                 If Dictionary, check for error_code flag.
                 If its availabke than check its value. */
                if([responseObject isKindOfClass:[NSArray class]]) {
                    block(responseObject,WebServiceResultSuccess);
                }
                else {
                    if(responseObject[@"error_code"])
                    {
                        // if value of error code is 1, It will be error.
                        int errorCode = [responseObject[@"error_code"] intValue];
                        if(errorCode == 0)
                            block(responseObject,WebServiceResultSuccess);
                        else {
                            showAlertViewWithMessage(responseObject[@"error_message"]);
                            block(responseObject,WebServiceResultFail);
                        }
                    }
                    else
                        block(responseObject,WebServiceResultSuccess);
                }
            }
                failure:^(NSURLSessionDataTask *task, NSError *error)
            {
                NSLog(@"Error: %@",error);
                block(nil,WebServiceResultError);
                /* If error code is this ignore aler view. its due to internet connection. */
                if(error.code != -1009)
                    showAlertViewWithMessage(error.localizedDescription);
            }];
}


// NSData as a parameter
+ (NSURLSessionDataTask *)simpleGetRequestWithRelativePathAndData:(NSString*)relativePath
                                                 paramater:(NSData*)param
                                                     block:(WebCallBlockSession)block
{
    NSLog(@"Relative Path : %@",relativePath);
    NSLog(@"Param : %@",param);
    
    return [manager GET:relativePath
             parameters:param
                success:^(NSURLSessionDataTask *task, id responseObject)
            {
                NSLog(@"Response: %@",responseObject);
                /*  Check if object is array or dictionary.
                 If Dictionary, check for error_code flag.
                 If its availabke than check its value. */
                if([responseObject isKindOfClass:[NSArray class]]) {
                    block(responseObject,WebServiceResultSuccess);
                }
                else {
                    if(responseObject[@"error_code"])
                    {
                        // if value of error code is 1, It will be error.
                        int errorCode = [responseObject[@"error_code"] intValue];
                        if(errorCode == 0)
                            block(responseObject,WebServiceResultSuccess);
                        else {
                            showAlertViewWithMessage(responseObject[@"error_message"]);
                            block(responseObject,WebServiceResultFail);
                        }
                    }
                    else
                        block(responseObject,WebServiceResultSuccess);
                }
            }
                failure:^(NSURLSessionDataTask *task, NSError *error)
            {
                NSLog(@"Error: %@",error);
                block(nil,WebServiceResultError);
                /* If error code is this ignore aler view. its due to internet connection. */
                if(error.code != -1009)
                    showAlertViewWithMessage(error.localizedDescription);
            }];
}

/****************************************************************************************/



@end

//
//  WSCalls.h
//  Wizit
//
//  Created by iOSDeveloper2 on 18/06/14.
//  Copyright (c) 2014 Yudiz Pvt Solution Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#define kBasePath @"http://projects.developmentshowcase.com/leterer/ws/"
//#define kNotificationPath @"http://app-locker-pro.com/leterer/ws/"

#define kBasePath @"http://app-locker-pro.com/leterer/ws/"


typedef NS_ENUM (NSInteger, WebServiceResult)
{
    WebServiceResultSuccess = 0,
    WebServiceResultFail,
    WebServiceResultError
};

typedef void(^WebCallBlockSession)(id JSON,WebServiceResult result);


@interface PAWSCalls : NSObject


// Register
+ (void)registerUserWithParam:(NSDictionary*)param
                        image:(UIImage*)image
              completionBlock:(WebCallBlockSession)block;

// Login
+ (void)loginUserWithUsername:(NSString*)username
                     password:(NSString*)password
              completionBlock:(WebCallBlockSession)block;

// Upload Contacts
+ (void) uploadPhoneContactsWithParam:(NSDictionary *)contactList
                      completionBlock:(WebCallBlockSession)block;

// Fetch All Contacts
+ (void)fetchAllContactsWithCompletionBlock:(NSString *)userID
                            completionBlock:(WebCallBlockSession)block;

// Push Notification
//+ (void)sendPushNotificationWithPayload:(NSDictionary *)pushNotificationData;

// Push notification with session manager
+ (void)sendPushNotificationWithCompletionBlock:(NSDictionary *)pushNotificationData completionBlock:(WebCallBlockSession)block;

// Logout
+ (void)logoutUserWithUserId:(NSString*)userId completionBlock:(WebCallBlockSession)block;

// Change Password
+ (void)changePassword:(NSString*)oldPassword
                     newPassword:(NSString*)newPassword
              completionBlock:(WebCallBlockSession)block;

// Update User Profile
+ (void)updateUserProfileWithParam:(NSDictionary*)param image:(UIImage*)image completionBlock:(WebCallBlockSession)block;

// Block User
+ (void)blockUserWithUserId:(NSString*)userId
                     contactId:(NSString*)contactId
              completionBlock:(WebCallBlockSession)block;

// Block User
+ (void)unBlockUserWithUserId:(NSString*)userId
                  contactId:(NSString*)contactId
            completionBlock:(WebCallBlockSession)block;

@end

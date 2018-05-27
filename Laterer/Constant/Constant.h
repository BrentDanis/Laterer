//
//  Constant.h
//  Laterer
//
//  Created by Nimble Chapps on 03/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constant : NSObject

#define __APP_NAME__ [NSString stringWithFormat:@"Laterer"]

#define __APP_GROUP__ @"group.laterer.watchkit"

#define kDeviceToken @"deviceToken"

#define kLatererUserID @"LatererUserId"

#define kLatererUserDetail @"LatererUserDetail"

#define kLatererUserLatitude @"LatererUserLatitude"

#define kLatererUserLongitude @"LatererUserLongitude"

#define kFontName @"HelveticaNeue"

#define userDefault [NSUserDefaults standardUserDefaults]

#define BUTTON_BORDER_COLOR [UIColor colorWithRed:0.86 green:0.93 blue:0.39 alpha:1.0].CGColor

extern inline NSString* DisplayDateFomString(NSString* date);

extern inline void showAlertViewWithMessageAndTitle(NSString *message, NSString *messageTitle);

extern inline void showAlertViewWithMessage(NSString *message);

extern inline NSString* NSImageNameStringFromCurrentDate ();

extern inline BOOL textFieldNotNull(NSString *textFieldValue);

extern inline BOOL validateEmailWithString(NSString *email);

extern inline BOOL validateNumbersWithString(NSString *numericString);

extern inline BOOL ValidateStringForAlphabets(NSString *alphabetString);

extern inline NSString* removeSpecialCharactersFromPhone(NSString *phoneString);

@end


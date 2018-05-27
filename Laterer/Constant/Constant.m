//
//  Constant.m
//  Laterer
//
//  Created by Nimble Chapps on 03/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "Constant.h"
#import <UIKit/UIKit.h>
#import "SIAlertView.h"

@implementation Constant


inline NSString* DisplayDateFomString(NSString* date)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSDate *intermediateConversion = [formatter dateFromString:date];
    NSDateFormatter *formatter1 = [NSDateFormatter new];
    [formatter1 setDateFormat:@"dd MMM hh:mm"];
    return [formatter1 stringFromDate:intermediateConversion];
}

inline void showAlertViewWithMessageAndTitle(NSString *message, NSString *messageTitle) {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:messageTitle andMessage:message];
    [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

inline void showAlertViewWithMessage(NSString *message) {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:__APP_NAME__ andMessage:message];
    [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

inline NSString* NSImageNameStringFromCurrentDate () {
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    return [format stringFromDate:currentDate];
}

/*
 
 Validation
 
 */
inline BOOL textFieldNotNull(NSString *textFieldValue) {
    textFieldValue = [textFieldValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if (textFieldValue.length > 0) {
        return YES;
    }
    return NO;
}

inline BOOL validateEmailWithString(NSString *email) {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

inline BOOL validateNumbersWithString(NSString *numericString) {
    //    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSString *phoneRegex = @"^[0-9]{6,14}$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [numberTest evaluateWithObject:numericString];
}

inline BOOL ValidateStringForAlphabets(NSString *alphabetString) {
    NSString *myRegex = @"[A-Za-z]*";
    NSPredicate *stringValidator = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    return [stringValidator evaluateWithObject:alphabetString];
}

inline NSString* removeSpecialCharactersFromPhone(NSString *phoneString) {
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return [[phoneString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
}

@end

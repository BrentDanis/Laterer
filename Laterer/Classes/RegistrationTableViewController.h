//
//  RegistrationTableViewController.h
//  Laterer
//
//  Created by Nimble Chapps on 05/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationTableViewController : UITableViewController <UIActionSheetDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

-(IBAction)imageSelectorTapped:(id)sender;
-(IBAction)signUpTapped:(id)sender;

@end

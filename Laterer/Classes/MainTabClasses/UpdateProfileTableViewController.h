//
//  UpdateProfileTableViewController.h
//  laterer
//
//  Created by Nimble Chapps on 19/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateProfileTableViewController : UITableViewController

<UIActionSheetDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

-(IBAction)imageSelectorTapped:(id)sender;
-(IBAction)signUpTapped:(id)sender;

@end
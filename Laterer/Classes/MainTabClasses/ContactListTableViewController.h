//
//  ContactListTableViewController.h
//  Laterer
//
//  Created by Nimble Chapps on 02/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactListTableViewController : UIViewController <NSURLSessionDataDelegate, ABNewPersonViewControllerDelegate>

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)btnAddNewContact:(id)sender;

@end

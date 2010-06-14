//
//  SettingsViewController.h
//  TabViewController
//
//  Created by Roy Martin on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h> 
#import <AddressBookUI/AddressBookUI.h>

@interface SettingsViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate> {
	IBOutlet UILabel *firstName;
	IBOutlet UILabel *lastName;
	
	
}

@property (nonatomic, retain) UILabel * firstName;
@property (nonatomic, retain) UILabel *lastName;

- (IBAction)showPicker:(id)sender;

@end

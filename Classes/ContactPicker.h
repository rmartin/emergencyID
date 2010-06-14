//
//  ContactPicker.h
//  Emergency ID
//
//  Created by Roy Martin on 5/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h> 
#import <AddressBookUI/AddressBookUI.h>

@interface ContactPicker : UIView <ABPeoplePickerNavigationControllerDelegate> {
	IBOutlet UILabel *firstName; 
	IBOutlet UILabel *lastName;
}

@property (nonatomic, retain) UILabel *firstName; 
@property (nonatomic, retain) UILabel *lastName;

- (IBAction)showPicker:(id)sender; 

@end
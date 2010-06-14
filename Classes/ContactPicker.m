//
//  ContactPicker.m
//  Emergency ID
//
//  Created by Roy Martin on 5/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ContactPicker.h"


@implementation ContactPicker

@synthesize firstName; 
@synthesize lastName;

- (IBAction)showPicker:(id)sender { 
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	picker.peoplePickerDelegate = self;
	[self presentModalViewController:picker animated:NO];
		

	[self dismissModalViewControllerAnimated:NO];
	
	[picker release];
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[self dismissModalViewControllerAnimated:NO];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
	NSString* name = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	self.firstName.text = name; [name release];
	name = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty); 
	
	self.lastName.text = name;
	
	[name release]; [self dismissModalViewControllerAnimated:YES];
    
	return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

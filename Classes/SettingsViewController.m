//
//  SettingsViewController.m
//  TabViewController
//
//  Created by Roy Martin on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
@implementation SettingsViewController


@synthesize firstName;
@synthesize lastName;


- (IBAction)showPicker:(id)sender { 
	
	ABPeoplePickerNavigationController *picker =
	[[ABPeoplePickerNavigationController alloc] init]; 
	picker.peoplePickerDelegate = self;
	[self presentModalViewController:picker animated:YES]; 
	[picker release];
	 
}


- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[self dismissModalViewControllerAnimated:NO];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	NSString* name = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	self.firstName.text = name; [name release];
	name = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty); 
	
	self.lastName.text = name;
	
	[name release]; 
	[self dismissModalViewControllerAnimated:YES]; 
	
	return NO;
	
	
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}



- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[firstName release];
	[lastName release];
    [super dealloc];
}


@end

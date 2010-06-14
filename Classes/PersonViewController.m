//
//  PersonViewController.m
//  Emergency ID
//
//  Created by Roy Martin on 5/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PersonViewController.h"

@implementation PersonViewController

- (void) viewDidLoad
{
    personController = [[ABPersonViewController alloc] init];
	
    [personController setPersonViewDelegate:self];
    [personController setAllowsEditing:NO];
    personController.addressBook = ABAddressBookCreate();   
	
    personController.displayedProperties = [NSArray arrayWithObjects:
											[NSNumber numberWithInt:kABPersonPhoneProperty], 
											nil];
	
    [self setView:personController.view];
}

- (void) viewDidUnload
{
    [personController release];
}

- (void) displayContactInfo: (ABRecordRef)person
{
    [personController setDisplayedPerson:person];
}

- (BOOL) personViewController:(ABPersonViewController*)personView shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    // This is where you pass the selected contact property elsewhere in your program
    [[self navigationController] dismissModalViewControllerAnimated:YES];
    return NO;
}

@end

//
//  PersonViewController.h
//  Emergency ID
//
//  Created by Roy Martin on 5/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface PersonViewController : UIViewController <ABPersonViewControllerDelegate> 
{
    ABPersonViewController *personController;
}

- (void) displayContactInfo: (ABRecordRef)person;

@end
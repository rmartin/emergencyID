//
//  EmergencyContactController.h
//  Emergency ID
//
//  Created by Roy Martin on 3/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <uiKit/UIKit.h>
#import <AddressBook/AddressBook.h> 
#import <AddressBookUI/AddressBookUI.h>
#import "SecondLevelViewController.h"
#import <sqlite3.h> // Import the SQLite database framework


@class EmergencyContact; 

#define kDatabasename        @"emergencyid.sqlite3"
#define kContactDataKey         @"Contact"

#define kNumberOfEditableRows        4
#define kNameRowIndex                0
#define kPhoneRowIndex                 1
#define kRelationshipRowIndex             2
#define kOtherRowIndex           3
#define kNameRow2Index               4
#define kPhoneRow2Index                5
#define kRelationshipRow2Index            6
#define kOtherRow2Index          7

#define kLabelTag                    4096
@interface EmergencyContactController : SecondLevelViewController <UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,ABNewPersonViewControllerDelegate> {
    EmergencyContact *emergencycontact;
    NSArray *fieldLabels;
    NSMutableDictionary *tempValues;
    UITextField *textFieldBeingEdited;   
	
	IBOutlet UILabel *firstName;
	IBOutlet UILabel *lastName;
	
	
	// Database variables
	NSString *databaseName;
	NSString *databasePath;
	
	// Array to store the animal objects
	NSMutableArray *contacts;
	
}

@property (nonatomic, retain) UILabel * firstName;
@property (nonatomic, retain) UILabel *lastName;
@property (nonatomic, retain) EmergencyContact *emergencycontact;
@property (nonatomic, retain) NSArray *fieldLabels;
@property (nonatomic, retain) NSMutableDictionary *tempValues;
@property (nonatomic, retain) UITextField *textFieldBeingEdited;

@property (nonatomic, retain) NSMutableArray *contacts;

- (IBAction)showPicker:(id)sender;
- (IBAction)addNew:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)textFieldDone:(id)sender;
- (NSString *)dataFilePath;
@end


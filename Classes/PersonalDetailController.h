//
//  PersonalDetailController.h
//  Emergency ID
//
//  Created by Roy Martin on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <uiKit/UIKit.h>
#import "SecondLevelViewController.h"

@class PersonalInformation; 

#define kFilename        @"archive3"
#define kDataKey         @"Data3"

#define kNumberOfEditableRows        5
#define kNameRowIndex                0
#define kDOBRowIndex                 1
#define kHeightRowIndex              2
#define kWeightRowIndex              3
#define kBloodTypeRowIndex           4

#define kLabelTag                    4096
@interface PersonalDetailController : SecondLevelViewController <UITextFieldDelegate> {
    PersonalInformation *personalinformation;
    NSArray *fieldLabels;
    NSMutableDictionary *tempValues;
    UITextField *textFieldBeingEdited;   
	
}
@property (nonatomic, retain) PersonalInformation *personalinformation;
@property (nonatomic, retain) NSArray *fieldLabels;
@property (nonatomic, retain) NSMutableDictionary *tempValues;
@property (nonatomic, retain) UITextField *textFieldBeingEdited;



- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)textFieldDone:(id)sender;
- (NSString *)dataFilePath;
@end


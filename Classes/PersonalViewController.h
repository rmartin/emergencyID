//
//  PersonalViewController.h
//  Emergency ID
//
//  Created by Roy Martin on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelViewController.h";
@class PersonalInformation; 

#define kFilename        @"archive3"
#define kDataKey         @"Data3"

#define kNumberOfSections            3

#define kSectionOneEditableRows      5

#define kNameRowIndex                0
#define kDOBRowIndex                 1
#define kHeightRowIndex              2
#define kWeightRowIndex              3
#define kBloodTypeRowIndex           4


#define kSectionTwoEditableRows      1

#define kPhotoIndex                  0

#define kSectionThreeEditableRows    5

#define kAddressRowIndex             0
#define kAddress2RowIndex            1
#define kAddressStateRowIndex        2
#define kAddressCityRowIndex         3
#define kPostalCodeRowIndex          4

@interface PersonalViewController : SecondLevelViewController {

    PersonalInformation *personalinformation;
    NSArray *fieldLabelsOne, *fieldLabelsTwo, *fieldLabelsThree, *controllers;
	NSString *fieldLabel;
    NSMutableDictionary *tempValues;
	  
}

@property (nonatomic, retain) PersonalInformation *personalinformation;
@property (nonatomic, retain) NSArray *fieldLabelsOne, *fieldLabelsTwo, *fieldLabelsThree, *controllers;
@property (nonatomic, retain) NSString *fieldLabel;
@property (nonatomic, retain) NSMutableDictionary *tempValues;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)textFieldDone:(id)sender;
- (NSString *)dataFilePath;

@end

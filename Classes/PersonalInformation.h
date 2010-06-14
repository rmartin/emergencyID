//
//  PersonalInformation.h
//  Personal ID
//
//  Created by Roy Martin on 3/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define kPersonalNameKey            @"Name"
#define kPersonalDOBKey             @"dob"
#define kPersonalHeightKey          @"height"
#define kPersonalWeightKey          @"weight"
#define kPersonalBloodTypeKey       @"bloodType"

#define kPersonalPhotoKey           @"photo"

#define kPersonalAddressOneKey      @"addressOne"
#define kPersonalAddressTwoKey      @"addressTwo"
#define kPersonalAddressStateKey    @"addressState"
#define kPersonalAddressCityKey     @"addressCity"
#define kPersonalAddressPostalKey   @"addressPostal"

@interface PersonalInformation : NSObject <NSCoding, NSCopying> {
    NSString    *name;
    NSString    *dob;
    NSString    *pHeight;
    NSString    *pWeight;
    NSString    *bloodType;
	NSString    *photo;
	NSString    *addressOne;
	NSString    *addressTwo;
	NSString    *addressCity;
	NSString    *addressState;
	NSString    *addressPostal;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *dob;
@property (nonatomic, retain) NSString *pHeight;
@property (nonatomic, retain) NSString *pWeight;
@property (nonatomic, retain) NSString *bloodType;
@property (nonatomic, retain) NSString *photo;
@property (nonatomic, retain) NSString *addressOne;
@property (nonatomic, retain) NSString *addressTwo;
@property (nonatomic, retain) NSString *addressCity;
@property (nonatomic, retain) NSString *addressState;
@property (nonatomic, retain) NSString *addressPostal;
@end



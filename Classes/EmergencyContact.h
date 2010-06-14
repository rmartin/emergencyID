//
//  Presidents.h
//  Emergency ID
//
//  Created by Roy Martin on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kEmergencyNameKey           @"Name"
#define kEmergencyPhoneKey            @"Phone"
#define kEmergencyRelationshipKey        @"Relationship"
#define kEmergencyOtherKey      @"Other"

#define kEmergencyNameKey2           @"Name2"
#define kEmergencyPhoneKey2            @"Phone2"
#define kEmergencyRelationshipKey2        @"Relationship2"
#define kEmergencyOtherKey2      @"Other2"

@interface EmergencyContact : NSObject <NSCoding, NSCopying> {
    NSString    *name;
    NSString    *phone;
    NSString    *relationship;
    NSString    *other;    
	
	NSString    *name2;
	NSString	*phone2;
	NSString	*relationship2;
	NSString	*other2;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *relationship;
@property (nonatomic, retain) NSString *other;


@property (nonatomic, retain) NSString *name2;
@property (nonatomic, retain) NSString *phone2;
@property (nonatomic, retain) NSString *relationship2;
@property (nonatomic, retain) NSString *other2;
@end

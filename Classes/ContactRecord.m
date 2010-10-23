//
//  ContactRecord.m
//  Emergency ID
//
//  Created by Roy Martin on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ContactRecord.h"

@implementation ContactRecord
@synthesize contactId, firstName, lastName, primaryPhoneNumber;

-(id)initWithName:(NSNumber *)cid firstName:(NSString *)fName lastName:(NSString *)lName primaryPhoneNumber:(NSString *)pNumber{
	self.contactId = cid;
	self.firstName = fName;
	self.lastName = lName;
	self.primaryPhoneNumber = pNumber;
	return self;
}
@end

//
//  ContactRecord.m
//  Emergency ID
//
//  Created by Roy Martin on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ContactRecord.h"

@implementation ContactRecord
@synthesize contactId, firstName, lastName;

-(id)initWithName:(NSString *)cid firstName:(NSString *)fName lastName:(NSString *)lName {
	self.contactId = cid;
	self.firstName = fName;
	self.lastName = lName;
	return self;
}
@end

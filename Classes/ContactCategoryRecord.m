//
//  ContactRecord.m
//  Emergency ID
//
//  Created by Roy Martin on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ContactCategoryRecord.h"

@implementation ContactCategoryRecord
@synthesize contactCategoryId, title, ranking, isReadOnly;

-(id)initWithName:(NSString *)cid title:(NSString *)aTitle ranking:(NSString *)aRank isReadOnly:aisReadOnly {
	self.contactCategoryId = cid;
	self.title = aTitle;
	self.ranking = aRank;
	self.isReadOnly = aisReadOnly;
	return self;
}
@end

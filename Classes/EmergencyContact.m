//
//  Presidents.m
//  Emergency ID
//
//  Created by Roy Martin on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EmergencyContact.h"


@implementation EmergencyContact

@synthesize name;
@synthesize phone;
@synthesize relationship;
@synthesize other;

@synthesize name2;
@synthesize phone2;
@synthesize relationship2;
@synthesize other2;


-(void)dealloc{
    [name release];
    [phone release];
    [relationship release];
    [other release];
	
	
    [name2 release];
    [phone2 release];
    [relationship2 release];
    [other2 release];
	
    [super dealloc];
}
#pragma mark -
#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:kEmergencyNameKey];
    [coder encodeObject:self.phone forKey:kEmergencyPhoneKey];
    [coder encodeObject:self.relationship   forKey:kEmergencyRelationshipKey];
    [coder encodeObject:self.other forKey:kEmergencyOtherKey];
    
    [coder encodeObject:self.name2 forKey:kEmergencyNameKey2];
    [coder encodeObject:self.phone2 forKey:kEmergencyPhoneKey2];
    [coder encodeObject:self.relationship2   forKey:kEmergencyRelationshipKey2];
    [coder encodeObject:self.other2 forKey:kEmergencyOtherKey2];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        
        self.name = [decoder decodeObjectForKey:kEmergencyNameKey];
        self.phone = [decoder decodeObjectForKey:kEmergencyPhoneKey];
        self.relationship = [decoder decodeObjectForKey:kEmergencyRelationshipKey];
        self.other = [decoder decodeObjectForKey:kEmergencyOtherKey];
		
		
        self.name2 = [decoder decodeObjectForKey:kEmergencyNameKey2];
        self.phone2 = [decoder decodeObjectForKey:kEmergencyPhoneKey2];
        self.relationship2 = [decoder decodeObjectForKey:kEmergencyRelationshipKey2];
        self.other2 = [decoder decodeObjectForKey:kEmergencyOtherKey2];
    }
    return self;
}
#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    EmergencyContact *copy = [[[self class] allocWithZone: zone] init];
    copy.name = [[self.name copyWithZone:zone] autorelease];
    copy.phone = [[self.phone copyWithZone:zone] autorelease];
    copy.relationship = [[self.relationship copyWithZone:zone] autorelease];
    copy.other = [[self.other copyWithZone:zone] autorelease];
	
	copy.name2 = [[self.name2 copyWithZone:zone] autorelease];
    copy.phone2 = [[self.phone2 copyWithZone:zone] autorelease];
    copy.relationship2 = [[self.relationship2 copyWithZone:zone] autorelease];
    copy.other2 = [[self.other2 copyWithZone:zone] autorelease];
    
    return copy;
}
@end

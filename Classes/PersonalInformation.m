//
//  PersonalInformation.m
//  Personal ID
//
//  Created by Roy Martin on 3/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PersonalInformation.h"


@implementation PersonalInformation

@synthesize name;
@synthesize dob;
@synthesize pHeight;
@synthesize pWeight;
@synthesize bloodType;
@synthesize photo;
@synthesize addressOne;
@synthesize addressTwo;
@synthesize addressCity;
@synthesize addressState;
@synthesize addressPostal;


-(void)dealloc{
    [name release];
    [dob release];
	[pHeight release];
	[pWeight release];
	[bloodType release];
	[photo release];
	[addressOne release];
	[addressTwo release];
	[addressCity release];
	[addressState release];
	[addressPostal release];
    [super dealloc];
}
#pragma mark -
#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:kPersonalNameKey];
    [coder encodeObject:self.dob forKey:kPersonalDOBKey];
    [coder encodeObject:self.pHeight   forKey:kPersonalHeightKey];
    [coder encodeObject:self.pWeight forKey:kPersonalWeightKey];
	[coder encodeObject:self.bloodType forKey:kPersonalBloodTypeKey];
	
    [coder encodeObject:self.photo forKey:kPersonalPhotoKey];
	
	
    [coder encodeObject:self.addressOne   forKey:kPersonalAddressOneKey];
    [coder encodeObject:self.addressTwo forKey:kPersonalAddressTwoKey];
	[coder encodeObject:self.addressState   forKey:kPersonalAddressStateKey];
    [coder encodeObject:self.addressCity   forKey:kPersonalAddressCityKey];
    [coder encodeObject:self.addressPostal   forKey:kPersonalAddressPostalKey];
    
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        
        self.name = [decoder decodeObjectForKey:kPersonalNameKey];
        self.dob = [decoder decodeObjectForKey:kPersonalDOBKey];
        self.pWeight = [decoder decodeObjectForKey:kPersonalHeightKey];
        self.pHeight = [decoder decodeObjectForKey:kPersonalWeightKey];
		self.bloodType = [decoder decodeObjectForKey:kPersonalBloodTypeKey];
		
        self.photo = [decoder decodeObjectForKey:kPersonalPhotoKey];
        
		self.addressOne = [decoder decodeObjectForKey:kPersonalAddressOneKey];
        self.addressTwo = [decoder decodeObjectForKey:kPersonalAddressTwoKey];
		self.addressState = [decoder decodeObjectForKey:kPersonalAddressStateKey];
        self.addressCity = [decoder decodeObjectForKey:kPersonalAddressCityKey];
        self.addressPostal = [decoder decodeObjectForKey:kPersonalAddressPostalKey];
    }
    return self;
}
#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    PersonalInformation *copy = [[[self class] allocWithZone: zone] init];
    copy.name = [[self.name copyWithZone:zone] autorelease];
    copy.dob = [[self.dob copyWithZone:zone] autorelease];
    copy.pWeight = [[self.pWeight copyWithZone:zone] autorelease];
    copy.pHeight = [[self.pHeight copyWithZone:zone] autorelease];
	copy.bloodType = [[self.bloodType copyWithZone:zone] autorelease];
	
    copy.photo = [[self.photo copyWithZone:zone] autorelease];
	
    copy.addressOne = [[self.addressOne copyWithZone:zone] autorelease];
	copy.addressTwo = [[self.addressTwo copyWithZone:zone] autorelease];
    copy.addressState = [[self.addressState copyWithZone:zone] autorelease];
    copy.addressCity = [[self.addressCity copyWithZone:zone] autorelease];
    copy.addressPostal = [[self.addressPostal copyWithZone:zone] autorelease];
    
    return copy;
}
@end
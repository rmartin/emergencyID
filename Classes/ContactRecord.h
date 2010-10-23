//
//  ContactRecord.h
//  Emergency ID
//
//  Created by Roy Martin on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ContactRecord : NSObject {
	NSNumber *contactId;
	NSString *firstName;
	NSString *lastName;
	NSString *primaryPhoneNumber;
}

@property (nonatomic, retain) NSNumber *contactId;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *primaryPhoneNumber;

-(id)initWithName:(NSNumber *)cid firstName:(NSString *)fName lastName:(NSString *)lName primaryPhoneNumber:(NSString *)pNumber;

@end

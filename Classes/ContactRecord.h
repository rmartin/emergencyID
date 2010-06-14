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
}

@property (nonatomic, retain) NSNumber *contactId;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;

-(id)initWithName:(NSNumber *)cid description:(NSString *)f url:(NSString *)l;

@end

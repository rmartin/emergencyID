//
//  ContactRecord.h
//  Emergency ID
//
//  Created by Roy Martin on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ContactCategoryRecord : NSObject {
	NSNumber *contactCategoryId;
	NSString *title;
	NSNumber *ranking;
	NSNumber *isReadOnly;
}

@property (nonatomic, retain) NSNumber *contactCategoryId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *ranking;
@property (nonatomic, retain) NSNumber *isReadOnly;

-(id)initWithName:(NSNumber *)cid title:(NSString *)aTitle ranking:(NSNumber *)aRank isReadOnly:(NSNumber *)aisReadOnly;

@end

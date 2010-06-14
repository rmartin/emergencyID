//
//  MedicalIdTableViewController.h
//  TabViewController
//
//  Created by Roy Martin on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MedicalIdDetailViewController;


@interface MedicalIdTableViewController : UITableViewController {

	UITableView *medicalIdTableView;
	NSMutableArray *booksArray;
	
	MedicalIdDetailViewController *medicalIdDetailViewController;
	
	
	NSArray *controllers; 
	
}


@property (nonatomic, retain) IBOutlet UITableView *medicalIdTableView;
@property (nonatomic, retain) IBOutlet NSMutableArray *booksArray;
@property (nonatomic, retain) IBOutlet MedicalIdDetailViewController *medicalIdDetailViewController;

@property (nonatomic, retain) NSArray *controllers;


@end

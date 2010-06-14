//
//  MedicalIdTableViewController.m
//  TabViewController
//
//  Created by Roy Martin on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MedicalIdTableViewController.h"
#import "MedicalIdDetailViewController.h"
#import "MedicalIdViewController.h"
#import "EmergencyIDAppDelegate.h"

#import "SecondLevelViewController.h"
#import "PersonalDetailController.h"
#import "EmergencyContactController.h"
#import "CameraViewController.h"

#import "PersonalViewController.h"


@implementation MedicalIdTableViewController

@synthesize booksArray;
@synthesize medicalIdDetailViewController;
@synthesize controllers;


/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Emergency ID", @"Emergency ID");
	
	
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	
	/*
    PersonalDetailController *personaldetailController = 
    [[PersonalDetailController alloc] 
     initWithStyle:UITableViewStyleGrouped];
	
	
	
	personaldetailController.title = @"Personal Info";
	personaldetailController.rowImage = [UIImage imageNamed:@"detailEditIcon.png"];
	
	[array addObject:personaldetailController];
	[personaldetailController release];
	 */
	
	PersonalViewController *personaldetailController = 
	[[PersonalViewController alloc]
	 initWithStyle:UITableViewStyleGrouped];
	
	personaldetailController.title = @"Personal Information";
	personaldetailController.rowImage = [UIImage imageNamed:@"detailEditIcon.png"];
	[array addObject:personaldetailController];
	[personaldetailController release];
	
	
	
	EmergencyContactController *emergencycontactConroller = 
    [[EmergencyContactController alloc] 
     initWithStyle:UITableViewStyleGrouped];
	
	emergencycontactConroller.title = @"Emergency Contact";
	emergencycontactConroller.rowImage = [UIImage imageNamed:@"detailEditIcon.png"];
	
	[array addObject:emergencycontactConroller];
	[emergencycontactConroller release];
	
	
	
	CameraViewController *cameraviewcontroller = 
    [CameraViewController alloc];
	
	cameraviewcontroller.title = @"Image Manager";
	cameraviewcontroller.rowImage = [UIImage imageNamed:@"detailEditIcon.png"];
	
	[array addObject:cameraviewcontroller];
	[cameraviewcontroller release];
	
	self.controllers = array;
	[array release];
	 
	

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark - 
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [self.controllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *FirstLevelCell= @"Emergency ID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: 
                             FirstLevelCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier: FirstLevelCell] autorelease];
    }
    // Configure the cell
    NSUInteger row = [indexPath row];
    SecondLevelViewController *controller =
    [controllers objectAtIndex:row];
    cell.textLabel.text = controller.title;
    cell.imageView.image = controller.rowImage;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    SecondLevelViewController *nextController = [self.controllers
                                                 objectAtIndex:row];
    
    [self.navigationController pushViewController:nextController animated:YES];
}

- (void)dealloc {
	[medicalIdDetailViewController release];
    [super dealloc];
}


@end


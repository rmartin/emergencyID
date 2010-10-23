//
//  PersonalDetailController.m
//  Emergency ID
//
//  Created by Roy Martin on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "PersonalViewController.h"
#import "PersonalInformation.h"
#import "PersonalDetailController.h"

@implementation PersonalViewController

@synthesize personalinformation;
@synthesize fieldLabelsOne, fieldLabelsTwo, fieldLabelsThree, controllers;
@synthesize tempValues;
@synthesize fieldLabel;


- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (void)viewWillAppear:(BOOL)animated{
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

-(IBAction)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender
{
		
    [self.navigationController popViewControllerAnimated:YES];
    
 //   NSArray *allControllers = self.navigationController.viewControllers;
 //   UITableViewController *parent = [allControllers lastObject];
 //   [parent.tableView reloadData];
}

#pragma mark -
- (void)viewDidLoad {
    
    NSArray *arrayOne = [[NSArray alloc] initWithObjects:@"Name", @"DOB", 
                      @"Height", @"Weight", @"Blood Type", nil];

	NSArray *arrayTwo = [[NSArray alloc] initWithObjects:@"Photo", nil];
	
	NSArray *arrayThree = [[NSArray alloc] initWithObjects:@"Add. One", @"Add. Two", 
						 @"City", @"State", @"Zip-code", nil];
	
	
    self.fieldLabelsOne = arrayOne;
	self.fieldLabelsTwo = arrayTwo;
	self.fieldLabelsThree = arrayThree;
	self.fieldLabel = @"";
	
	
    [arrayOne release];
	[arrayTwo release];
	[arrayThree release];
	
	
	personalinformation = [[PersonalInformation alloc] init];
	
	
	NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSMutableData alloc]
                        initWithContentsOfFile:[self dataFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] 
                                         initForReadingWithData:data];
        PersonalInformation *loadpersonalinformation = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
		
		personalinformation.name = loadpersonalinformation.name;
		personalinformation.dob = loadpersonalinformation.dob;
		personalinformation.pHeight = loadpersonalinformation.pHeight;
		personalinformation.pWeight = loadpersonalinformation.pWeight;
		personalinformation.bloodType = loadpersonalinformation.bloodType;
        
        [unarchiver release];
        [data release];        
    }
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save" 
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    self.tempValues = dict;
    [dict release];
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	PersonalDetailController *personaldetailController = [[PersonalDetailController alloc] initWithStyle:UITableViewStylePlain];
	personaldetailController.title = @"Personal Information";
	
    personaldetailController.personalinformation = 	personalinformation ;
	
	[array addObject:personaldetailController];
	[personaldetailController release];
	
	self.controllers = array;
	[array release];
    [super viewDidLoad];
}

- (void)viewDidUnLoad {
	self.controllers = nil;
	[super viewDidLoad];
}

- (void)dealloc {
    [tempValues release];
    [personalinformation release];
    [fieldLabelsOne release];
	[fieldLabelsTwo release];
	[fieldLabelsThree release];
	[controllers release];
    
    [super dealloc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = [self tableView: tableView cellForRowAtIndexPath: indexPath];
	
	NSArray *arr = [cell.textLabel.text componentsSeparatedByString:@"\r\n"];
	
	return [arr count]*18;
	
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PersonalCellIdentifier = @"PersonalCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             PersonalCellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
                                       reuseIdentifier:PersonalCellIdentifier] autorelease];
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.text = @"";
		
		cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
		cell.detailTextLabel.numberOfLines = 0;
		cell.detailTextLabel.text = @"";
	}
	
	
	
	
    NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	NSNumber *rowAsNum = [[NSNumber alloc] initWithInt:row];
	
	//add the disclosure button to all rows
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	
	if(section == 0){
		
		//write the text to the label
		//fieldLabel = [fieldLabel stringByAppendingString:[fieldLabelsOne objectAtIndex:row]];
		
		
		for(NSString *currString in fieldLabelsOne){
			cell.textLabel.text = [NSString stringWithFormat:@"%@%@:\r\n", cell.textLabel.text, currString];
		}
		
		//cell.detailTextLabel.text =@"This is a test123 what would happen if this was really long \r\nThis is a test123\r\n";
		
		int i;
		for(i=0; i < [fieldLabelsOne count]; i++){
		  	switch (i) {
				case kNameRowIndex:
					//if ([[tempValues allKeys] containsObject:rowAsNum])
					//	cell.detailTextLabel.text = [tempValues objectForKey:rowAsNum];
					//else
						cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@\r\n", cell.detailTextLabel.text, personalinformation.name];
					break;
				case kDOBRowIndex:
					//if ([[tempValues allKeys] containsObject:rowAsNum])
					//	cell.detailTextLabel.text = [tempValues objectForKey:rowAsNum];
					//else
						cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@\r\n", cell.detailTextLabel.text, personalinformation.dob];
					break;
				case kHeightRowIndex:
					//if ([[tempValues allKeys] containsObject:rowAsNum])
					//	cell.detailTextLabel.text = [tempValues objectForKey:rowAsNum];
					//else
						cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@\r\n", cell.detailTextLabel.text, personalinformation.pHeight];
					break;
				case kWeightRowIndex:
					//if ([[tempValues allKeys] containsObject:rowAsNum])
					//	cell.detailTextLabel.text = [tempValues objectForKey:rowAsNum];
					//else
						cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@\r\n", cell.detailTextLabel.text, personalinformation.pWeight];
					break;
				case kBloodTypeRowIndex:
					//if ([[tempValues allKeys] containsObject:rowAsNum])
					//	cell.detailTextLabel.text = [tempValues objectForKey:rowAsNum];
					//else
						cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@\r\n", cell.detailTextLabel.text, personalinformation.bloodType];
					break;
				default:
					break;
			}
		}
		 
		 
		
		
		//cell.textLabel.text = @"Test123";
		 
		
		  
	}else if(section == 1){
		
		//write the text to the label
		cell.textLabel.text = [fieldLabelsTwo objectAtIndex:row];
		
		
		cell.detailTextLabel.text =@"This is a test123\r\n";
		
		
		switch (row) {
			case kPhotoIndex:
				if ([[tempValues allKeys] containsObject:rowAsNum])
					cell.detailTextLabel.text = [tempValues objectForKey:rowAsNum];
				else
					cell.detailTextLabel.text = personalinformation.photo;
				break;
			default:
				break;
		}
		 
		 
		
	}else if(section == 2){
		
		for(NSString *currString in fieldLabelsThree){
			cell.textLabel.text = [NSString stringWithFormat:@"%@%@\r\n", cell.textLabel.text, currString];
		}
		
		cell.detailTextLabel.text = @"this is a test";
		
		
		int i;
		for(i=0; i < [fieldLabelsOne count]; i++){
		  	switch (i) {
							case kAddressRowIndex:
				if ([[tempValues allKeys] containsObject:rowAsNum])
					cell.detailTextLabel.text = [tempValues objectForKey:rowAsNum];
				else
					cell.detailTextLabel.text = personalinformation.addressOne;
				break;
			case kAddress2RowIndex:
				if ([[tempValues allKeys] containsObject:rowAsNum])
					cell.detailTextLabel.text = [tempValues objectForKey:rowAsNum];
				else
					cell.detailTextLabel.text = personalinformation.addressTwo;
				break;
			case kAddressStateRowIndex:
				if ([[tempValues allKeys] containsObject:rowAsNum])
					cell.detailTextLabel.text = [tempValues objectForKey:rowAsNum];
				else
					cell.detailTextLabel.text = personalinformation.addressState;
				break;
			case kAddressCityRowIndex:
				if ([[tempValues allKeys] containsObject:rowAsNum])
					cell.detailTextLabel.text = [tempValues objectForKey:rowAsNum];
				else
					cell.detailTextLabel.text = personalinformation.addressCity;
			case kPostalCodeRowIndex:
				if ([[tempValues allKeys] containsObject:rowAsNum])
					cell.detailTextLabel.text = [tempValues objectForKey:rowAsNum];
				else
					cell.detailTextLabel.text = personalinformation.addressPostal;
			default:
				break;
		}
		}
		
		
	}
	 
	 
	
    return cell;
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
	
	if(section == 0){
		return 1;
	}else if(section == 1){
		return kSectionTwoEditableRows;
	}else if(section == 2){
		return 1;
	}
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return kNumberOfSections;
}

#pragma mark -
#pragma mark Table Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView 
   titleForHeaderInSection:(NSInteger)section {
	if(section == 0){
		return @"Personal Information";
	}else if(section == 1){
		return @"Photo";
	}else if(section == 2){
		return @"Address";
	}
}

#pragma mark -
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = [indexPath row];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Hey!"
													message: @"hello"
												   delegate: nil
										  cancelButtonTitle:@"get me out of here"
										  otherButtonTitles: nil];
	
	
	//PersonalDetailController *personaldetailController = [self.controllers objectAtIndex:0];
	//[self.navigationController pushViewController:personaldetailController	animated:YES];
	
	[alert show];
	[alert release];
	
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	PersonalDetailController *personaldetailController = [self.controllers objectAtIndex:0];
	[self.navigationController pushViewController:personaldetailController	animated:YES];
	
}

@end


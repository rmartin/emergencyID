//
//  PersonalDetailController.m
//  Emergency ID
//
//  Created by Roy Martin on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "PersonalDetailController.h"
#import "PersonalInformation.h"

@implementation PersonalDetailController
@synthesize personalinformation;
@synthesize fieldLabels;
@synthesize tempValues;
@synthesize textFieldBeingEdited;


- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

-(IBAction)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender
{
	
	
    
    if (textFieldBeingEdited != nil)
    {
        NSNumber *tagAsNum= [[NSNumber alloc] 
                             initWithInt:textFieldBeingEdited.tag];
        [tempValues setObject:textFieldBeingEdited.text forKey: tagAsNum];
        [tagAsNum release];
        
    }
    for (NSNumber *key in [tempValues allKeys])
    {
        switch ([key intValue]) {
            case kNameRowIndex:
                personalinformation.name = [tempValues objectForKey:key];
                break;
            case kDOBRowIndex:
                personalinformation.dob = [tempValues objectForKey:key];
                break;
            case kHeightRowIndex:
                personalinformation.pHeight = [tempValues objectForKey:key];
                break;
            case kWeightRowIndex:
                personalinformation.pWeight = [tempValues objectForKey:key];
				break;
			case kBloodTypeRowIndex:
				personalinformation.bloodType = [tempValues objectForKey:key];
				break;
            default:
                break;
        }
    }
    
	NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
	
    [archiver encodeObject:personalinformation forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
    [archiver release];
    [data release];    
	
	
    [self.navigationController popViewControllerAnimated:YES];
    
    NSArray *allControllers = self.navigationController.viewControllers;
    UITableViewController *parent = [allControllers lastObject];
	
	
	//update the parent view information
	UIViewController *parentViewController = parent.tableView;
	
    [parent.tableView reloadData];
}
-(IBAction)textFieldDone:(id)sender {
    UITableViewCell *cell =
    (UITableViewCell *)[[sender superview] superview];
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    if (row >= kNumberOfEditableRows)
        row = 0;
    NSUInteger newIndex[] = {0, row};
    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex 
                                                         length:2];
    UITableViewCell *nextCell = [self.tableView 
                                 cellForRowAtIndexPath:newPath];
    UITextField *nextField = nil;
    for (UIView *oneView in nextCell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            nextField = (UITextField *)oneView;
    }
    [nextField becomeFirstResponder];
}
#pragma mark -
- (void)viewDidLoad {
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"Name", @"DOB", 
	@"Height", @"Weight", @"Blood Type", nil];
	
    self.fieldLabels = array;
    [array release];
	
	/*
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
    */
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
    [super viewDidLoad];
}
- (void)dealloc {
    [textFieldBeingEdited release];
    [tempValues release];
  // [personalinformation release];
    [fieldLabels release];
	
    
    [super dealloc];
}
#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return kNumberOfEditableRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PersonalCellIdentifier = @"PersonalCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             PersonalCellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:PersonalCellIdentifier] autorelease];
        UILabel *label = [[UILabel alloc] initWithFrame:
                          CGRectMake(10, 10, 75, 25)];
        label.textAlignment = UITextAlignmentRight;
        label.tag = kLabelTag;
        label.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:label];
        [label release];
        
        
        UITextField *textField = [[UITextField alloc] initWithFrame:
                                  CGRectMake(90, 12, 200, 25)];
        textField.clearsOnBeginEditing = NO;
        [textField setDelegate:self];
        [textField addTarget:self 
                      action:@selector(textFieldDone:) 
            forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:textField];
    }
    NSUInteger row = [indexPath row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];
    UITextField *textField = nil;
    for (UIView *oneView in cell.contentView.subviews)
    {
        if ([oneView isMemberOfClass:[UITextField class]])
            textField = (UITextField *)oneView;
    }
	
    label.text = [fieldLabels objectAtIndex:row];
	
	NSNumber *rowAsNum = [[NSNumber alloc] initWithInt:row];
    		
	switch (row) {
		case kNameRowIndex:
			if ([[tempValues allKeys] containsObject:rowAsNum])
				textField.text = [tempValues objectForKey:rowAsNum];
			else
				textField.text = personalinformation.name;
			break;
		case kDOBRowIndex:
			if ([[tempValues allKeys] containsObject:rowAsNum])
				textField.text = [tempValues objectForKey:rowAsNum];
			else
				textField.text = personalinformation.dob;
			break;
		case kHeightRowIndex:
			if ([[tempValues allKeys] containsObject:rowAsNum])
				textField.text = [tempValues objectForKey:rowAsNum];
			else
				textField.text = personalinformation.pHeight;
			break;
		case kWeightRowIndex:
			if ([[tempValues allKeys] containsObject:rowAsNum])
				textField.text = [tempValues objectForKey:rowAsNum];
			else
				textField.text = personalinformation.pWeight;
			break;
		case kBloodTypeRowIndex:
			if ([[tempValues allKeys] containsObject:rowAsNum])
				textField.text = [tempValues objectForKey:rowAsNum];
			else
				textField.text = personalinformation.bloodType;
			break;
		default:
			break;
	}
    if (textFieldBeingEdited == textField)
        textFieldBeingEdited = nil;
    
    textField.tag = row;
    [rowAsNum release];
    return cell;
}
#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

#pragma mark -
#pragma mark Table Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView 
	 titleForHeaderInSection:(NSInteger)section {
	return @"Personal Information";
}

#pragma mark Text Field Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFieldBeingEdited = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSNumber *tagAsNum = [[NSNumber alloc] initWithInt:textField.tag];
    [tempValues setObject:textField.text forKey:tagAsNum];
    [tagAsNum release];
}


@end


//
//  EmergencyContactController.m
//  Emergency ID
//
//  Created by Roy Martin on 3/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "EmergencyContactController.h"
#import "EmergencyContact.h"
#import "ContactRecord.h"
#import "ContactCategoryRecord.h"

@implementation EmergencyContactController
@synthesize emergencycontact;
@synthesize fieldLabels;
@synthesize tempValues;
@synthesize textFieldBeingEdited;

@synthesize firstName;
@synthesize lastName;
@synthesize contacts;
@synthesize	contactCategories;

static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt = nil;

static sqlite3_stmt *stmt = nil;



/**
 *SQL database
 */

/**
 * Load the database filepath
 */
- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kDatabasename];
}

/**
 * setup database and load the database locally if needed
 */
-(void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if(!success){
	
		// If not then proceed to copy the database from the application to the users filesystem
		
		// Get the path to the database in the application package
		NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
		
		// Copy the database from the package to the users filesystem
		[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
		
		[fileManager release];
	}
	//set the filepath to the database
	NSString *filePath = [self dataFilePath];
	
	//Ensure the database exists and that it can be opened
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		//connect to the database and ensure it is setup correctly
		if(sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
			sqlite3_close(database);
			NSAssert(0, @"Failed to open database");
		}
	}
	
	char *errorMsg;
	
	
	//Create the table for contact if they do not exist
	NSString *createSQL = @"CREATE TABLE IF NOT EXISTS contact ( contactId Integer PRIMARY KEY NOT NULL, contactCategoryId Integer NOT NULL, userId Integer NULL, firstName Varchar NULL, lastName Varchar NULL, phone Varchar NULL, image Varchar NULL);";
	if(sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert1(0, @"Error creating table: %s", errorMsg);
	}
	
	//Create the table for contact category if they do not exist
	createSQL = @"CREATE TABLE IF NOT EXISTS contactCategory (contactCategoryId Integer PRIMARY KEY NOT NULL, title varchar NOT NULL, rank Integer NOT NULL DEFAULT '0', isReadOnly Integer NOT NULL DEFAULT '0');";
	if(sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert1(0, @"Error creating table: %s", errorMsg);
	}
	 
}

//close the database
-(void) closeDatabase{
	//close all the statements
	if(stmt){ sqlite3_reset(stmt); }
	
	//close the database connection
	sqlite3_close(database);
}

-(void) readContactsFromDatabase {
	// Setup the database object
	//sqlite3 *database;
	
	// Init the animals Array
	NSMutableArray *currContacts = [[NSMutableArray alloc] init];
	
	// Setup the SQL Statement and compile it for faster access
	char *query = "SELECT contactId,firstName,lastName FROM contact";
	if(sqlite3_prepare_v2(database, query, -1, &stmt, nil) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		while(sqlite3_step(stmt) == SQLITE_ROW) {
			// Read the data from the result row
			NSNumber *aContactId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
			NSString *aFirstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
			NSString *aLastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
			
			// Create a new contact object with the data from the database
			ContactRecord *contact = [[ContactRecord alloc] initWithName:aContactId firstName:aFirstName lastName:aLastName];
			
			// Add the animal object to the animals Array
			[currContacts addObject:contact];
			
			[contact release];
		}
	}else{
		NSLog(@"Error while creating update statement.: %s\n", sqlite3_errmsg(database));  
    }
	// Release the compiled statement from memory
	sqlite3_reset(stmt);
	
	self.contacts = currContacts;
}


-(void) readContactCategoriesFromDatabase {
	// Setup the database object
	//sqlite3 *database;
	
	// Init the animals Array
	NSMutableArray *currContactCatgories = [[NSMutableArray alloc] init];
	
	// Setup the SQL Statement and compile it for faster access
	char *query = "SELECT contactCategoryId, title, rank, isReadOnly FROM contactCategory";
	if(sqlite3_prepare_v2(database, query, -1, &stmt, nil) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		while(sqlite3_step(stmt) == SQLITE_ROW) {
			// Read the data from the result row
			NSNumber *currContactCategoryId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
			NSString *currTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
			NSNumber *currRank = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
			NSNumber *currIsReadOnly = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
			
			// Create a new contact object with the data from the database
			ContactCategoryRecord *category = [[ContactCategoryRecord alloc] initWithName:currContactCategoryId title:currTitle ranking:currRank isReadOnly:currIsReadOnly];
			
			// Add the animal object to the animals Array
			[currContactCatgories addObject:category];
			
			[category release];
		}
	}else{
		NSLog(@"Error while creating update statement.: %s\n", sqlite3_errmsg(database));  
    }
	// Release the compiled statement from memory
	sqlite3_reset(stmt);
	
	self.contactCategories = currContactCatgories;
}

-(void) readContactCategoriesByCategoryFromDatabase:(NSString *)contactCategoryId{
	// Setup the database object
	//sqlite3 *database;
	
	// Init the animals Array
	NSMutableArray *currContacts = [[NSMutableArray alloc] init];
	
	// Setup the SQL Statement and compile it for faster access
	//char *query = "SELECT contactId,firstName,lastName FROM contact WHERE contactCategoryId = '?'";
	
	const char *query = [[NSString stringWithFormat:@"SELECT contactId,firstName,lastName FROM contact WHERE contactCategoryId = '%@'",contactCategoryId] cStringUsingEncoding:NSUTF8StringEncoding];
	
	if(sqlite3_prepare_v2(database, query, -1, &stmt, nil) == SQLITE_OK) {
	
		// Loop through the results and add them to the feeds array
		while(sqlite3_step(stmt) == SQLITE_ROW) {
			// Read the data from the result row
			NSNumber *aContactId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
			NSString *aFirstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
			NSString *aLastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
			
			// Create a new contact object with the data from the database
			ContactRecord *contact = [[ContactRecord alloc] initWithName:aContactId firstName:aFirstName lastName:aLastName];
			
			
			// Add the animal object to the animals Array
			[currContacts addObject:contact];
			
			[contact release];
		}
	}else{
		NSLog(@"Error while creating update statement.: %s\n", sqlite3_errmsg(database));  
    }
	// Release the compiled statement from memory
	sqlite3_reset(stmt);
	
	self.contacts = currContacts;
}


-(IBAction)cancel:(id)sender{
	[self closeDatabase];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Opens a add new contact view and presents this to the user
 *
 */
- (IBAction)addNew:(id)sender
{
/*
	ABPeoplePickerNavigationController *picker =
	[[ABPeoplePickerNavigationController alloc] init]; 
	picker.peoplePickerDelegate = self;
	[self presentModalViewController:picker animated:YES]; 
	[picker release];
*/
	
	ABNewPersonViewController *view = [[ABNewPersonViewController alloc] init]; 
	
	view.newPersonViewDelegate = self;
	UINavigationController *newNavigationController = [UINavigationController alloc]; 
	
	[newNavigationController initWithRootViewController:view]; 
	[self presentModalViewController:newNavigationController animated:YES]; 
	
	[view release];
	[newNavigationController release];
	
}

/**
 * Opens a existing contact selector to grab contacts that already exist
 */
- (IBAction)showPicker:(id)sender { 
	
	ABPeoplePickerNavigationController *picker =
	[[ABPeoplePickerNavigationController alloc] init]; 
	picker.peoplePickerDelegate = self;
	
	[self presentModalViewController:picker animated:YES]; 
	[picker release];
	
}

/**
 * Save a new contact record that completed with a new person
 */
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person{
	
	ABRecordID personID = ABRecordGetRecordID(person);
	NSNumber *personIDAsNumber = [NSNumber numberWithInt:personID];
	NSString *currfirstName, *currlastName; 
	currfirstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty); 
	currlastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	
	char *query = "INSERT OR REPLACE INTO contact(contactId,contactCategoryId,userId,firstName,lastName) VALUES (?, ?, ?, ?, ?);";
	
	if(sqlite3_prepare_v2(database, query, -1, &stmt, nil) == SQLITE_OK) {
		sqlite3_bind_int(stmt, 1, [personIDAsNumber intValue]);
		sqlite3_bind_int(stmt, 2, 1);
		sqlite3_bind_int(stmt, 3, 1);
		sqlite3_bind_text(stmt, 4, [currfirstName UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 5, [currlastName UTF8String], -1, NULL);
		
	}else{
		NSLog(@"Error while creating update statement.: %s\n", sqlite3_errmsg(database));  
    }
	
	if(sqlite3_step(stmt) != SQLITE_DONE){
		NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
	}
	// Release the compiled statement from memory
	sqlite3_reset(stmt);
	
	//load the new contacts into memory
	[self readContactsFromDatabase];
	
	[self dismissModalViewControllerAnimated:YES]; 
}

/**
 CREATE TABLE contact(contactId INTEGER PRIMARY KEY, userId INTEGER,firstName VARCHAR(2000), lastName VARCHAR(2000), image VARCHAR(2000));
 sqlite> INSERT INTO contact(contactId, userId,firstName,lastName,image) VALUES (1,1,'Roy','Martin','test');
*/

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[self dismissModalViewControllerAnimated:NO];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	NSString* name = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	self.firstName.text = name; [name release];
	name = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty); 
	
	self.lastName.text = name;
	
	[name release]; 
	[self dismissModalViewControllerAnimated:YES]; 
	
	return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
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
                emergencycontact.name = [tempValues objectForKey:key];
                break;
            case kPhoneRowIndex:
                emergencycontact.phone = [tempValues objectForKey:key];
                break;
            case kRelationshipRowIndex:
                emergencycontact.relationship = [tempValues objectForKey:key];
                break;
            case kOtherRowIndex:
                emergencycontact.other = [tempValues objectForKey:key];
				break;
            case kNameRow2Index:
                emergencycontact.name2 = [tempValues objectForKey:key];
                break;
            case kPhoneRow2Index:
                emergencycontact.phone2 = [tempValues objectForKey:key];
                break;
            case kRelationshipRow2Index:
                emergencycontact.relationship2 = [tempValues objectForKey:key];
                break;
            case kOtherRow2Index:
                emergencycontact.other2 = [tempValues objectForKey:key];
            default:
                break;
        }
    }
    /*
	NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
	
    [archiver encodeObject:emergencycontact forKey:kContactDataKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
    [archiver release];
    [data release];    
	*/
	[self closeDatabase];
		
    [self.navigationController popViewControllerAnimated:YES];
    
    NSArray *allControllers = self.navigationController.viewControllers;
    UITableViewController *parent = [allControllers lastObject];
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
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"Name:", @"Phone #:", 
                      @"Relationship:", @"Other:", @"Name:", @"Phone #:", @"Relationship:",@"Other:", nil];
    self.fieldLabels = array;
    [array release];
	
	// Setup some globals
	databaseName = @"emergencyid.sqlite3";
	
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	emergencycontact = [[EmergencyContact alloc] init];
	
	// Execute the "checkAndCreateDatabase" function
	[self checkAndCreateDatabase];
	
	// Query the database for all animal records and construct the "animals" array
	[self readContactsFromDatabase];
	
	[self readContactCategoriesFromDatabase];
	
	
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
	/*
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save" 
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(save:)];
	*/
	
	UIBarButtonItem *newButton = [[UIBarButtonItem alloc]
initWithTitle:@"Add New"
style:UIBarButtonItemStyleDone
target:self
								  action:@selector(addNew:)];
	
    self.navigationItem.rightBarButtonItem = newButton;
    [newButton release];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    self.tempValues = dict;
    [dict release];
    [super viewDidLoad];
}
- (void)dealloc {
	
	
	[contacts release];
    [textFieldBeingEdited release];
    [tempValues release];
    [emergencycontact release];
    [fieldLabels release];
	
    
    [super dealloc];
}
#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
	
	//get the current category
	NSArray *currContactCategory = [contactCategories objectAtIndex:section]; // can change index and it's fine
	NSString *currCatCategoryId = [currContactCategory valueForKey:@"contactCategoryId"]; // works fine
	
	[self readContactCategoriesByCategoryFromDatabase:currCatCategoryId];
	
	
    return [self.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PersonalCellIdentifier = @"PersonalCellIdentifier";
	
	
	NSUInteger section = [indexPath section];
    
	//get the current category
	NSArray *currContactCategory = [contactCategories objectAtIndex:section]; // can change index and it's fine
	NSString *currCatCategoryId = [currContactCategory valueForKey:@"contactCategoryId"]; // works fine
	
	[self readContactCategoriesByCategoryFromDatabase:currCatCategoryId];
	
	
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             PersonalCellIdentifier];
	
	
		
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                       reuseIdentifier:PersonalCellIdentifier] autorelease];
        UILabel *label = [[UILabel alloc] initWithFrame:
                          CGRectMake(10, 10, 75, 25)];
        label.textAlignment = UITextAlignmentRight;
        label.tag = kLabelTag;
        label.font = [UIFont boldSystemFontOfSize:14];
      //  [cell.contentView addSubview:label];
        [label release];
        
        
        UITextField *textField = [[UITextField alloc] initWithFrame:
                                  CGRectMake(90, 12, 200, 25)];
        textField.clearsOnBeginEditing = NO;
        [textField setDelegate:self];
        [textField addTarget:self 
                      action:@selector(textFieldDone:) 
            forControlEvents:UIControlEventEditingDidEndOnExit];
    //    [cell.contentView addSubview:textField];
		
	
    }
	
	
	//if there are no contacts, then remove then break;
	if([self.contacts count] == 0){
		return cell;
	}
    
	NSUInteger row = [indexPath row];
	
	NSArray *currContact = [contacts objectAtIndex:section]; // can change index and it's fine
	NSNumber *currContactId = [currContact valueForKey:@"contactId"]; // works fine
	NSString *currFirstName = [currContact valueForKey:@"firstName"]; // works fine
	NSString *currLastName = [currContact valueForKey:@"lastName"];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", currFirstName, currLastName];
	cell.detailTextLabel.text = @"555-555-5555";
	    
    
	return cell;
}
#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return [self.contactCategories count];
	//return [self.contacts count];
	
	//return 0;
}

#pragma mark -
#pragma mark Table Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
	return nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView 
   titleForHeaderInSection:(NSInteger)section {
	NSArray *currContactCategory = [contactCategories objectAtIndex:section]; // can change index and it's fine
	NSString *currCatTitle = [currContactCategory valueForKey:@"title"]; // works fine
	
	return currCatTitle;
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
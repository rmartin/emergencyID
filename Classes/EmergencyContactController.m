//
//  EmergencyContactController.m
//  Emergency ID
//
//  Created by Roy Martin on 3/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "EmergencyContactController.h"
//#import "EmergencyContact.h"
#import "ContactRecord.h"
#import "ContactCategoryRecord.h"

@implementation EmergencyContactController
//@synthesize emergencycontact;
@synthesize fieldLabels;
@synthesize tempValues;
@synthesize textFieldBeingEdited;

@synthesize firstName;
@synthesize lastName;
@synthesize contacts;
@synthesize	contactCategories;
@synthesize fileManager;
@synthesize currPersonRecordId;
id contactsArray[2][1];

static sqlite3 *database = nil;
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
	fileManager = [NSFileManager defaultManager];
	
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
	/*
	 NSString *createSQL = @"DROP TABLE contact;";
	 if(sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
	 sqlite3_close(database);
	 NSAssert1(0, @"Error creating table: %s", errorMsg);
	 }
	 */
	
	
	//Create the table for contact if they do not exist
	NSString *createSQL = @"CREATE TABLE IF NOT EXISTS contact ( contactId Integer PRIMARY KEY NOT NULL, contactCategoryId Integer NOT NULL, userId Integer NULL, firstName Varchar NULL, lastName Varchar NULL, phone Varchar NULL, image Varchar NULL, rank NOT NULL DEFAULT '0');";
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
	
	char *query1 = "INSERT OR REPLACE INTO contactCategory(contactCategoryId,title,rank,isReadOnly) VALUES (?, ?, ?, ?);";
	
	if(sqlite3_prepare_v2(database, query1	, -1, &stmt, nil) == SQLITE_OK) {
		sqlite3_bind_int(stmt, 1, 1);
		sqlite3_bind_text(stmt, 2, "Primary Contact",-1, NULL);
		sqlite3_bind_int(stmt, 3, 1);
		sqlite3_bind_int(stmt, 4, 1);
		
	}else{
		NSLog(@"Error while creating update statement.: %s\n", sqlite3_errmsg(database));  
    }
	
	if(sqlite3_step(stmt) != SQLITE_DONE){
		NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(stmt);
	
	
	char *query2 = "INSERT OR REPLACE INTO contactCategory(contactCategoryId,title,rank,isReadOnly) VALUES (?, ?, ?, ?);";
	
	if(sqlite3_prepare_v2(database, query2, -1, &stmt, nil) == SQLITE_OK) {
		sqlite3_bind_int(stmt, 1, 2);
		sqlite3_bind_text(stmt, 2, "Secondary Contact",-1,NULL);
		sqlite3_bind_int(stmt, 3, 2);
		sqlite3_bind_int(stmt, 4, 1);
		
	}else{
		NSLog(@"Error while creating update statement.: %s\n", sqlite3_errmsg(database));  
    }
	
	if(sqlite3_step(stmt) != SQLITE_DONE){
		NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
	}
	
	
	// Release the compiled statement from memory
	sqlite3_reset(stmt);
	
}

//close the database
-(void) closeDatabase{
	//close all the statements
	if(stmt){ sqlite3_reset(stmt); }
	
	//close the database connection
	sqlite3_close(database);
}


/**
 * SQL: Select all contacts from the database
 */
-(void) readContactsFromDatabase {
	// Setup the database object
	//sqlite3 *database;
	
	// Init the animals Array
	NSMutableArray *currContacts = [[NSMutableArray alloc] init];
	// Release the compiled statement from memory
	sqlite3_reset(stmt);
	// Setup the SQL Statement and compile it for faster access
	char *query = "SELECT contactId, firstName, lastName, phone FROM contact ORDER BY rank";
	if(sqlite3_prepare_v2(database, query, -1, &stmt, nil) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		while(sqlite3_step(stmt) == SQLITE_ROW) {
			// Read the data from the result row
			NSNumber *aContactId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
			NSString *aFirstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
			NSString *aLastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
			//NSString *aPhoneNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
			NSString *aPhoneNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
			
			
			// Create a new contact object with the data from the database
			ContactRecord *contact = [[ContactRecord alloc] initWithName: aContactId firstName:aFirstName lastName:aLastName primaryPhoneNumber:aPhoneNumber];
			
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

/**
 * SQL: Load the individual categories from the database
 */
-(void) readContactCategoriesFromDatabase {
	// Setup the database object
	//sqlite3 *database;
	
	// Init the animals Array
	NSMutableArray *currContactCatgories = [[NSMutableArray alloc] init];
	
	// Setup the SQL Statement and compile it for faster access
	char *query = "SELECT contactCategoryId, title, rank, isReadOnly FROM contactCategory ORDER BY rank";
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
			
			//[category release];
		}
	}else{
		NSLog(@"Error while creating update statement.: %s\n", sqlite3_errmsg(database));  
    }
	// Release the compiled statement from memory
	sqlite3_reset(stmt);
	
	self.contactCategories = currContactCatgories;
}

/**
 * SQL / Objective-C: Load in all the records into the database
 */
-(void) readContactCategoriesByCategoryFromDatabase:(NSString *)contactCategoryId forSectionId:(NSUInteger)currSectionId{
	// Setup the database object
	//sqlite3 *database;
	
	// Init the animals Array
	NSMutableArray *currContacts = [[NSMutableArray alloc] init];
	NSNumber *currContactCategoryId = [NSNumber numberWithInt:[contactCategoryId intValue]];
	
	
	
	// Setup the SQL Statement and compile it for faster access
	//char *query = "SELECT contactId,firstName,lastName FROM contact WHERE contactCategoryId = '?'";
	
	const char *query = [[NSString stringWithFormat:@"SELECT contactId,firstName,lastName,phone,contactCategoryId,userId,rank  FROM contact WHERE contactCategoryId = '%@' ORDER BY rank",contactCategoryId] cStringUsingEncoding:NSUTF8StringEncoding];
	
	if(sqlite3_prepare_v2(database, query, -1, &stmt, nil) == SQLITE_OK) {
		
		// Loop through the results and add them to the feeds array
		while(sqlite3_step(stmt) == SQLITE_ROW) {
			// Read the data from the result row
			NSNumber *aContactId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
			NSString *aFirstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
			NSString *aLastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
			NSString *aPhoneNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
			
			NSNumber *aContactCategoryId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
			NSNumber *aUserId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
			NSNumber *aRank = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
			
			// Create a new contact object with the data from the database
			ContactRecord *contact = [[ContactRecord alloc] initWithName:aContactId firstName:aFirstName lastName:aLastName primaryPhoneNumber:aPhoneNumber contactCategoryId:currContactCategoryId userId:aUserId rank:aRank];
			
			
			// Add the animal object to the animals Array
			[currContacts addObject:contact];
			
			[contact release];
		}
	}else{
		NSLog(@"Error while creating update statement.: %s\n", sqlite3_errmsg(database));  
    }
	// Release the compiled statement from memory
	sqlite3_reset(stmt);
	
	// add a last record to add a new contact
	NSNumber *aContactId = 0;
	NSString *aFirstName = @"Add";
	NSString *aLastName = @"New";
	NSString *aPhoneNumber = @"";
	NSNumber *aUserId = [NSNumber numberWithInt:[@"1" intValue]];
	NSNumber *aRank = [NSNumber numberWithInt:[@"99" intValue]];
	
	
	// Create a new contact object with the data from the database
	ContactRecord *contact = [[ContactRecord alloc] initWithName:aContactId firstName:aFirstName lastName:aLastName primaryPhoneNumber:aPhoneNumber contactCategoryId:currContactCategoryId userId:aUserId rank:aRank];
	
	// Add the animal object to the animals Array
	[currContacts addObject:contact];
	
	[contact release];
	contactsArray[currSectionId][0] = currContacts;
	//[self.contacts addObject:currContacts];
}

/**
 * UI: close the window for the picker (EID Button on listing page)
 */
-(IBAction)cancelWindow:(id)sender{
	//[self closeDatabase];
    [self.navigationController popViewControllerAnimated:YES];
	
	//[self peoplePickerNavigationControllerDidCancel];
}

/**
 * UI: close the window for the picker
 */
-(IBAction)cancel:(id)sender{
	//[self closeDatabase];
    [self.navigationController popViewControllerAnimated:YES];
	
	//[self peoplePickerNavigationControllerDidCancel];
}

/**
 * UI: Opens a add new contact view and presents this to the user
 */
- (IBAction)addNew:(id)sender
{
	
	ABNewPersonViewController *view = [[ABNewPersonViewController alloc] init]; 
	
	view.newPersonViewDelegate = self;
	UINavigationController *newNavigationController = [UINavigationController alloc]; 
	
	[newNavigationController initWithRootViewController:view]; 
	[self presentModalViewController:newNavigationController animated:YES]; 	
	
	[view release];
	[newNavigationController release];
}

- (IBAction)toggleEdit{
	[self.tableView setEditing:!self.tableView.editing animated:YES];
	
	if(self.tableView.editing){
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
	}else{
		[self.navigationItem.rightBarButtonItem	setTitle:@"Edit"];
	}
	
	[self.tableView reloadData];
}

/**
 * UI: Opens a existing contact selector to grab contacts that already exist
 */
- (IBAction)showPicker:(id)sender { 
	
	ABPeoplePickerNavigationController *picker =
	[[ABPeoplePickerNavigationController alloc] init]; 
	picker.peoplePickerDelegate = self;
	
	[self presentModalViewController:picker animated:YES]; 
	[picker release];
}

/**
 * UI: Show an individual contact record
 */
- (IBAction)showPersonById:(NSUInteger)personRecordId forSectionId:(NSInteger)sectionId{
	
	NSArray *currContacts = contactsArray[sectionId][0];
	NSArray *currContact = [currContacts objectAtIndex:personRecordId]; // can change index and it's fine
	NSNumber *currContactId = [currContact valueForKey:@"contactId"]; // works fine
	NSString *currFirstName = [currContact valueForKey:@"firstName"]; // works fine
	NSString *currLastName = [currContact valueForKey:@"lastName"];
	NSString *currPhoneNumber = [currContact valueForKey:@"primaryPhoneNumber"];
	
	//ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);

	ABRecordRef person = ABPersonCreate(); 
	CFErrorRef anError = NULL;
	ABRecordSetValue(person, kABPersonFirstNameProperty, currFirstName, &anError); 
	ABRecordSetValue(person, kABPersonLastNameProperty, currLastName, &anError);

	
	//ABMultiValueIdentifier *multivalueIdentifier; 
	ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	ABMultiValueAddValueAndLabel(multiPhone, currPhoneNumber, kABPersonPhoneMainLabel, NULL);
	ABRecordSetValue(person, kABPersonPhoneProperty, multiPhone,nil);
	CFRelease(multiPhone);
	
		
		ABNewPersonViewController *view = [[ABNewPersonViewController alloc] init]; 
		
		view.newPersonViewDelegate = self;
		view.displayedPerson = person; 
		UINavigationController *newNavigationController = [UINavigationController alloc]; 
		
		[newNavigationController initWithRootViewController:view]; 
		[self presentModalViewController:newNavigationController animated:YES]; 
		
		[view release];
		[newNavigationController release];
	
	
	//[person release];
	
	self.currPersonRecordId = currContactId;
	
}

/**
 * Objective-C: Save a new contact record that completed with a new person
 *
 * newPersonViewContraller(newPersonViewController,person)
 * 
 */
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person{
	
	//if it was a cancel, then exit
	if(person == nil){
		[self dismissModalViewControllerAnimated:YES];
		return;
	}
	
	ABRecordID personID = ABRecordGetRecordID(person);
	NSNumber *personIDAsNumber = [NSNumber numberWithInt:personID];
	NSString *currfirstName, *currlastName; 
	int currPersonId = [personIDAsNumber intValue];
	
	
	
	
	currfirstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty); 
	currlastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	
	ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	
	CFStringRef phoneNumber, phoneNumberLabel;
	
	multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
	for (CFIndex i = 0; i < ABMultiValueGetCount(multi); i++) { 
		phoneNumberLabel = ABMultiValueCopyLabelAtIndex(multi, i); 
		phoneNumber	= ABMultiValueCopyValueAtIndex(multi, i);
	}
	
	int primaryKey = [self.currPersonRecordId intValue];
	if(primaryKey == 0){
		char *query = "INSERT OR REPLACE INTO contact(contactCategoryId,userId,firstName,lastName, phone) VALUES (?, ?, ?, ?, ?);";
	
	if(sqlite3_prepare_v2(database, query	, -1, &stmt, nil) == SQLITE_OK) {
		sqlite3_bind_int(stmt, 1, 1);
		sqlite3_bind_int(stmt, 2, 1);
		sqlite3_bind_text(stmt, 3, [currfirstName UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 4, [currlastName UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 5, [phoneNumber UTF8String], -1, NULL);
		
	}else{
		NSLog(@"Error while creating update statement.: %s\n", sqlite3_errmsg(database));  
    }
	}else{
		char *query = "INSERT OR REPLACE INTO contact(contactId,contactCategoryId,userId,firstName,lastName, phone) VALUES (?, ?, ?, ?, ?, ?);";
		
		if(sqlite3_prepare_v2(database, query	, -1, &stmt, nil) == SQLITE_OK) {
			//sqlite3_bind_int(stmt, 1, [personIDAsNumber intValue]);
			sqlite3_bind_int(stmt, 1, primaryKey);
			sqlite3_bind_int(stmt, 2, 1);
			sqlite3_bind_int(stmt, 3, 1);
			sqlite3_bind_text(stmt, 4, [currfirstName UTF8String], -1, NULL);
			sqlite3_bind_text(stmt, 5, [currlastName UTF8String], -1, NULL);
			sqlite3_bind_text(stmt, 6, [phoneNumber UTF8String], -1, NULL);
			
		}else{
			NSLog(@"Error while creating update statement.: %s\n", sqlite3_errmsg(database));  
		}
		
	}
	
	if(sqlite3_step(stmt) != SQLITE_DONE){
		NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
	}
	
	CFRelease(phoneNumberLabel); 
	CFRelease(phoneNumber);
	
	// Release the compiled statement from memory
	sqlite3_reset(stmt);
	
	//load the new contacts into memory
	//[self readContactsFromDatabase];
	
	//reload the parent data
	NSArray *allControllers = self.navigationController.viewControllers;
    UITableViewController *parent = [allControllers lastObject];
    [parent.tableView reloadData];
	
	[self dismissModalViewControllerAnimated:YES]; 
}

/**
 CREATE TABLE contact(contactId INTEGER PRIMARY KEY, userId INTEGER,firstName VARCHAR(2000), lastName VARCHAR(2000), image VARCHAR(2000));
 sqlite> INSERT INTO contact(contactId, userId,firstName,lastName,image) VALUES (1,1,'Roy','Martin','test');
 */

/**
 * UI: Cancel the person picker
 */
- (void)peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *)peoplePicker {
	[self dismissModalViewControllerAnimated:YES];
}

/**
 * UI: Show the user after a selection has been made
 */
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

/**
 * UI: Show the user after a selection has been made by name, id
 */
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}


/**
 * Objective-C: Save the individual record 

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
    
	
    [self.navigationController popViewControllerAnimated:YES];
    
    NSArray *allControllers = self.navigationController.viewControllers;
    UITableViewController *parent = [allControllers lastObject];
    [parent.tableView reloadData];
}
 */

/**
 * UI: Load the main display for the list of users
 */
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
	
	//emergencycontact = [[EmergencyContact alloc] init];
	
	// Execute the "checkAndCreateDatabase" function
	[self checkAndCreateDatabase];
	
	// Query the database for all animal records and construct the "animals" array
	//[self readContactsFromDatabase];
	
	[self readContactCategoriesFromDatabase];
	
	
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Home"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancelWindow:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
								  initWithTitle:@"Edit"
								  style:UIBarButtonItemStyleDone
								  target:self
								  action:@selector(toggleEdit)];
	
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    self.tempValues = dict;
    [dict release];
    [super viewDidLoad];
}

/**
 * Objective-C: dealloc all variables for the class 
 */
- (void)dealloc {
	
	
	[contacts release];
    [textFieldBeingEdited release];
    [tempValues release];
   // [emergencycontact release];
    [fieldLabels release];
	
    
    [super dealloc];
}

/**
 * UI: Determine the number of rows for each category 
 */ 
#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
	
	//get the current category
	NSArray *currContactCategory = [contactCategories objectAtIndex:section]; // can change index and it's fine
	NSString *currCatCategoryId = [currContactCategory valueForKey:@"contactCategoryId"]; // works fine
	
	[self readContactCategoriesByCategoryFromDatabase:currCatCategoryId forSectionId:section];
	NSArray *currContacts = contactsArray[section][0];
	
	
	// Hide the add new rows if the table is not in edit mode
	if(self.tableView.editing){
		return [currContacts count];
	}else{
		return [currContacts count]-1;	
	}
}


/**
 * UI: Display list of contacts
 */
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PersonalCellIdentifier = @"PersonalCellIdentifier";
	
	
	NSUInteger section = [indexPath section];
    
	//get the current category
	NSArray *currContactCategory = [contactCategories objectAtIndex:section]; // can change index and it's fine
	NSString *currCatCategoryId = [currContactCategory valueForKey:@"contactCategoryId"]; // works fine
	
	[self readContactCategoriesByCategoryFromDatabase:currCatCategoryId forSectionId:section];
	NSArray *currContacts = contactsArray[section][0];
	
	
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
	if([currContacts count] == 0){
		return cell;
	}
	    
	NSUInteger row = [indexPath row];
	
	NSArray *currContact = [currContacts objectAtIndex:row]; // can change index and it's fine
	NSNumber *contactId = [currContact valueForKey:@"contactId"];
	NSString *currFirstName = [currContact valueForKey:@"firstName"]; // works fine
	NSString *currLastName = [currContact valueForKey:@"lastName"];
	NSString *currPhoneNumber = [currContact valueForKey:@"primaryPhoneNumber"];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", currFirstName, currLastName];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",currPhoneNumber];
	
	return cell;
}

/**
 * UI: determines the look and feel when editing a cell
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
	
	//get the row and sections
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	NSArray *currContactArray = contactsArray[section][0];
	
	if(row == ([currContactArray count]-1)){
		return NO;
	}else{
		return YES;
	}
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath {
	
	NSUInteger fromSection = [fromIndexPath section];
	NSUInteger fromRow = [fromIndexPath row];
	NSInteger toRow = [toIndexPath row];
	NSUInteger toSection = [toIndexPath section];
	
	//get the current category
	NSArray *currContactCategory = [contactCategories objectAtIndex:fromSection]; // can change index and it's fine
	NSString *currCatCategoryId = [currContactCategory valueForKey:@"contactCategoryId"]; // works fine
	
	[self readContactCategoriesByCategoryFromDatabase:currCatCategoryId forSectionId:fromSection];
	NSArray *currContacts = contactsArray[fromSection][0];
	
	NSArray *currContact = [currContacts objectAtIndex:fromRow]; // can change index and it's fine
	NSNumber *contactId = [currContact valueForKey:@"contactId"];
	
	NSNumber *contactId2 = [currContact valueForKey:@"contactId"];
}


/**
 * UI: determine the number of categories to display
 */
#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return [self.contactCategories count];
}

/**
 * UI: User selection of a contact record
 */
#pragma mark -
#pragma mark Table Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	
	
	//load a person record
	[self showPersonById:row forSectionId:section];
	
	return nil;
}

/**
 * UI: setup the header for each of the categories
 */
- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section {
	NSArray *currContactCategory = [contactCategories objectAtIndex:section]; // can change index and it's fine
	NSString *currCatTitle = [currContactCategory valueForKey:@"title"]; // works fine
	
	return currCatTitle;
}

/**
 * UI: MARKED FOR DELETION: setup each text field for editing
 */
#pragma mark Text Field Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFieldBeingEdited = textField;
}


/**
 * UI: MARKED FOR DELETION: callback for finished editing a row
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSNumber *tagAsNum = [[NSNumber alloc] initWithInt:textField.tag];
    [tempValues setObject:textField.text forKey:tagAsNum];
    [tagAsNum release];
}


/**
 * UI: MARKED FOR DELETION: callback for finished editing a row
 */
- (void)textFieldDone:(UITextField *)textField
{
    NSNumber *tagAsNum = [[NSNumber alloc] initWithInt:textField.tag];
    [tempValues setObject:textField.text forKey:tagAsNum];
    [tagAsNum release];
}

@end
//
//  TabViewControllerAppDelegate.m
//  TabViewController
//
//  Created by Roy Martin on 4/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


#import "MedicalIdViewController.h"
#import "EmergencyIDAppDelegate.h"

@implementation EmergencyIDAppDelegate

@synthesize window;
@synthesize rootController;
@synthesize medNavController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	
	[window addSubview:rootController.view];                                          
	[window makeKeyAndVisible];   
}


- (void)dealloc {
	[rootController release];
	[medNavController release];
	[window release];
[super dealloc];
}


@end

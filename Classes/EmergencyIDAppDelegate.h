//
//  TabViewControllerAppDelegate.h
//  TabViewController
//
//  Created by Roy Martin on 4/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MedicalViewController;

@interface EmergencyIDAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
    UITabBarController *rootController;
    MedicalIdViewController *medNavController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) IBOutlet MedicalIdViewController *medNavController;

@end


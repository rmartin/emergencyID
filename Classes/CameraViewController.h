//
//  CameraViewController.h
//  Emergency ID
//
//  Created by Roy Martin on 3/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SecondLevelViewController.h"

@interface CameraViewController : UIViewController 
<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImageView *imageView;
    UIButton *takePictureButton;
    UIButton *selectFromCameraRollButton;
	UIImage *rowImage;
}
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet UIButton *selectFromCameraRollButton;
@property (nonatomic, retain) UIImage *rowImage;
- (IBAction)getCameraPicture:(id)sender;
- (IBAction)selectExistingPicture;
@end


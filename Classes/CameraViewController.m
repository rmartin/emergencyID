//
//  CameraViewController.m
//  Emergency ID
//
//  Created by Roy Martin on 3/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "CameraViewController.h"

@implementation CameraViewController
@synthesize imageView;
@synthesize takePictureButton;
@synthesize selectFromCameraRollButton;
@synthesize rowImage;


-(IBAction)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender
{
	
	UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
	
    [self.navigationController popViewControllerAnimated:YES];
}
	
- (void)viewDidLoad {
    if (![UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera]) {
        takePictureButton.hidden = YES;
        selectFromCameraRollButton.hidden = YES;
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
	
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.imageView = nil;
    self.takePictureButton = nil;
    self.selectFromCameraRollButton = nil;
    [super viewDidUnload];
}
- (void)dealloc {
    [imageView release];
    [takePictureButton release];
    [selectFromCameraRollButton release];
    [super dealloc];
}
#pragma mark -
- (IBAction)getCameraPicture:(id)sender {
    UIImagePickerController *picker =
    [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsImageEditing = YES;
    picker.sourceType = (sender == takePictureButton) ? 
    UIImagePickerControllerSourceTypeCamera :
    UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
    [self presentModalViewController:picker animated:YES];
    [picker release];
    
}
- (IBAction)selectExistingPicture {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error accessing photo library" 
                              message:@"Device does not support a photo library" 
                              delegate:nil 
                              cancelButtonTitle:@"Drat!" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
#pragma mark  -
- (void)imagePickerController:(UIImagePickerController *)picker 
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
	
	UIImage *img2 = [self addText:image text:@"Roy Martin" primaryContact:@"Ted Smith: 555-555-5555" secondaryContact:@"Ted Bundy: 666-666-6666"]; 
	
	UIImageView *imgView = [[UIImageView alloc] initWithImage:img2]; 
	
    imageView.image = img2;
    [picker dismissModalViewControllerAnimated:YES];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

//Add text to UIImage
-(UIImage *)addText:(UIImage *)img text:(NSString *)text1 primaryContact:(NSString *)text2 secondaryContact:(NSString *)text3{
    int w = img.size.width;
    int h = img.size.height; 
    //lon = h - lon;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1);
	
	char* textIntro	= (char *)[@"In Case Of Emergency" cStringUsingEncoding:NSASCIIStringEncoding];// "05/05/09";
    char* text	= (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];// "05/05/09";
    char* primaryContact	= (char *)[text2 cStringUsingEncoding:NSASCIIStringEncoding];// "05/05/09";
	char* secondaryContact	= (char *)[text3 cStringUsingEncoding:NSASCIIStringEncoding];// "05/05/09";
	
    CGContextSelectFont(context, "Helvetica", 18, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
	
	
    //rotate text
    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( 0 ));
	
	
	
	CGContextShowTextAtPoint(context, 4, h-50, textIntro, strlen(textIntro));
    CGContextShowTextAtPoint(context, 4, h-75, text, strlen(text));
	CGContextShowTextAtPoint(context, 4, h-100, primaryContact, strlen(primaryContact));
	CGContextShowTextAtPoint(context, 4, h-125, secondaryContact, strlen(secondaryContact));
	
	
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	
    return [UIImage imageWithCGImage:imageMasked];
}
@end
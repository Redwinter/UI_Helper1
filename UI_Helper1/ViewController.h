//
//  ViewController.h
//  UI_Helper1
//
//  Created by Erik Fleuter on 4/7/14.
//  Copyright (c) 2014 Erik Fleuter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate,UIPopoverControllerDelegate>


@property (strong,nonatomic) CIContext *context;
@property (strong, nonatomic) IBOutlet UIView *viewEditMenu;
@property (strong, nonatomic) IBOutlet UIView *editVisMenu;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong,nonatomic) IBOutlet UIPickerView *filterPicker;
@property (strong) UIPopoverController *popoverImageViewController;

- (IBAction)pickImage:(id)sender;
- (IBAction)showVisEditMenu:(id)sender;
- (IBAction)showViewPropsMenu:(id)sender;
- (IBAction)showHideView:(id)sender;
- (IBAction)enableViewMoves:(id)sender;
- (IBAction)showInfoDeets:(id)sender;


@end

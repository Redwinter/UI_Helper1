//
//  ViewController.h
//  UI_Helper1
//
//  Created by Erik Fleuter on 4/7/14.
//  Copyright (c) 2014 Erik Fleuter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong,nonatomic) CIContext *context;
@property (strong, nonatomic) IBOutlet UIView *viewEditMenu;
@property (strong, nonatomic) IBOutlet UIView *editVisMenu;
@property (strong, nonatomic) IBOutlet UISwitch *BBar_Vis;
@property (strong, nonatomic) IBOutlet UISwitch *TBar_Vis;
@property (strong, nonatomic) IBOutlet UISwitch *HudL_Vis;
@property (strong, nonatomic) IBOutlet UISwitch *HudR_Vis;
@property (strong, nonatomic) IBOutlet UISwitch *BigLabel_Vis;
@property (strong, nonatomic) IBOutlet UISwitch *MedLabel_Vis;


@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong,nonatomic) IBOutlet UIPickerView *filterPicker;
@property (strong) UIPopoverController *popoverImageViewController;

- (IBAction)pickImage:(id)sender;
- (IBAction)showVisEditMenu:(id)sender;
- (IBAction)showViewPropsMenu:(id)sender;
- (IBAction)showHideView:(id)sender;
- (IBAction)enableViewMoves:(id)sender;


@end

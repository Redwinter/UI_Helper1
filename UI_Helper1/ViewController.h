//
//  ViewController.h
//  UI_Helper1
//
//  Created by Erik Fleuter on 4/7/14.
//  Copyright (c) 2014 Erik Fleuter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DraggableView.h"
#import "PropsMenuView.h"
#import "FXMenuView.h"

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate,UIPopoverControllerDelegate>

@property (nonatomic) BOOL isEditing;

// touch stuff
@property (nonatomic, strong) IBOutlet UIView *dropTarget; //TODO: can create a snap to location with this
@property (nonatomic, strong) DraggableView *dragObject; // indicates what is being dragged
@property (nonatomic, strong) DraggableView *editObject; // indicates what is being edited
@property (nonatomic, assign) CGPoint touchOffset;
@property (nonatomic, assign) CGPoint homePosition;

@property (strong,nonatomic) CIContext *context;
@property (strong, nonatomic) IBOutlet PropsMenuView *viewPropsMenu; 
@property (strong, nonatomic) IBOutlet UIView *editVisMenu;
@property (strong, nonatomic) IBOutlet FXMenuView *viewFXMenu;

@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong,nonatomic) IBOutlet UIPickerView *filterPicker;
@property (strong) UIPopoverController *popoverImageViewController;
@property (strong,nonatomic) IBOutlet UIView *controlsView;
@property (strong, nonatomic) IBOutlet UIView *editLabelView;

// buttons for triggering touch up after drag w custom touches
@property (strong)IBOutlet UIButton *viewVisButton;
@property (strong)IBOutlet UIButton *editButton;
@property (strong)IBOutlet UIButton *testButton;

// buttons in zones for sliding up and down menus from top or bottom. TODO: use touch zones instead?
@property (strong)IBOutlet UIButton *slideUpButton;
@property (strong)IBOutlet UIButton *slideDownButton;

@property (strong)IBOutlet NSMutableDictionary *currentViewEdits;

- (IBAction)pickImage:(id)sender;
- (IBAction)clearBGImage:(id)sender;

- (IBAction)flipCenterOrigin:(UIButton*)sender;

- (IBAction)showVisEditMenu:(id)sender;

- (IBAction)showViewPropsMenu:(id)sender;
- (IBAction)dismissViewPropsMenu:(id)sender;
- (IBAction)resetToDefault:(id)sender;
- (IBAction)tapSlideUpUI:(id)sender;
- (IBAction)tapSlideDownUI:(id)sender;
- (IBAction)toggleCorners:(id)sender rounded:(BOOL)round;
- (IBAction)toggleShadow:(id)sender show:(BOOL)show;

- (IBAction)showHideView:(id)sender;
- (IBAction)enableViewEdits:(id)sender;
- (IBAction)doneEditing:(id)sender;


- (IBAction)showInfoDeets:(id)sender;

- (IBAction)showControls:(id)sender;

- (void) showBorder:(DraggableView*)view;
- (void) hideBorder:(DraggableView*)view;


@end

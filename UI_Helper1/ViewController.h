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

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate,UIPopoverControllerDelegate>

@property (nonatomic) BOOL isEditing;

// touch stuff
@property (nonatomic, strong) IBOutlet UIView *dropTarget; //TODO: can create a snap to location with this
@property (nonatomic, strong) DraggableView *dragObject; // indicates what is being dragged
@property (nonatomic, strong) UIView *editObject; // indicates what is being edited
@property (nonatomic, assign) CGPoint touchOffset;
@property (nonatomic, assign) CGPoint homePosition;

@property (strong,nonatomic) CIContext *context;
@property (strong, nonatomic) IBOutlet UIView *viewPropsMenu; // TODO: determine when best to show
@property (strong, nonatomic) IBOutlet UIView *editVisMenu;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong,nonatomic) IBOutlet UIPickerView *filterPicker;
@property (strong) UIPopoverController *popoverImageViewController;
@property (strong,nonatomic) IBOutlet UIView *controlsView;
@property (strong, nonatomic) IBOutlet UIView *editLabelView;

// buttons for triggering touch up after drag w custom touches
@property (strong)IBOutlet UIButton *viewVisButton;
@property (strong)IBOutlet UIButton *editButton;
@property (strong)IBOutlet UIButton *testButton;



- (IBAction)pickImage:(id)sender;

- (IBAction)showVisEditMenu:(id)sender;

- (IBAction)showViewPropsMenu:(id)sender;
- (IBAction)dismissViewPropsMenu:(id)sender;
- (IBAction)resetToDefault:(id)sender;

- (IBAction)showHideView:(id)sender;
- (IBAction)enableViewEdits:(id)sender;
- (IBAction)doneEditing:(id)sender;


- (IBAction)showInfoDeets:(id)sender;

- (IBAction)showControls:(id)sender;

- (void) showBorder:(DraggableView*)view;
- (void) hideBorder:(DraggableView*)view;


@end

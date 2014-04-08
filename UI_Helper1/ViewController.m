//
//  ViewController.m
//  UI_Helper1
//
//  Created by Erik Fleuter on 4/7/14.
//  Copyright (c) 2014 Erik Fleuter. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}




- (IBAction)pickImage:(id)sender
{
    
}

- (IBAction)showVisEditMenu:(id)sender
{
    self.editVisMenu.hidden = !self.editVisMenu.hidden;
}

- (IBAction)showViewPropsMenu:(id)sender
{
    // NOTE: temp on button trigger. remove and have AFTER a view touched & moved
    // & have button enable dragging views around and pos
    self.viewEditMenu.hidden = !self.viewEditMenu.hidden;
}

- (IBAction)showHideView:(id)sender
{
    BOOL show = NO;
    if ([sender isKindOfClass:[UISwitch class] ]) {
        UISwitch *sw = (UISwitch*)sender;
        show = sw.on;
    }
    /**using tags to show/hide views. Any buttons tag +100 = the View's tag it shows/hides **/
    UIView *sendingView = (UIView*)sender;
    UIView *tgtView = [self.view viewWithTag:sendingView.tag+100];
#ifdef DEBUG
    NSLog(@"Showing/Hiding view tagged: %i which is a %@",sendingView.tag, [tgtView class]);
#endif
    if (show) {
        tgtView.hidden = NO;
    }
    else{
        tgtView.hidden = YES;
    }
    
}

- (IBAction)enableViewMoves:(id)sender
{
    
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

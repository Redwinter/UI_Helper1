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

- (IBAction)enableViewMoves:(id)sender
{
    
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

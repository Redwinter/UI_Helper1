//
//  ViewController.m
//  UI_Helper1
//
//  Created by Erik Fleuter on 4/7/14.
//  Copyright (c) 2014 Erik Fleuter. All rights reserved.
//

#import "ViewController.h"
#define BACKGROUND_TAG 333

@interface ViewController ()

@end

@implementation ViewController

@synthesize isEditing, touchOffset, dragObject, homePosition, dropTarget, editButton, viewVisButton, testButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //create a context for images
    self.context = [CIContext contextWithOptions:nil];
    self.isEditing = NO;
}


#pragma mark - Menus -


// currently this flips it back n forth between hide/show for speed
- (IBAction)showVisEditMenu:(id)sender
{
    self.editVisMenu.hidden = !self.editVisMenu.hidden;
    [self hideControls:sender];
}



- (IBAction)showViewPropsMenu:(id)sender
{
    // NOTE: temp on button trigger. remove and have AFTER a view touched & moved
    // & have button enable dragging views around and pos
    if(self.viewPropsMenu.hidden)self.viewPropsMenu.hidden = NO;
    [self.view bringSubviewToFront:self.viewPropsMenu];
    self.editObject = (UIView*)self.dragObject;
    [self hideControls:sender];
}

- (IBAction)dismissViewPropsMenu:(id)sender
{
  // TODO: apply (& save paid) props for edited view
    self.viewPropsMenu.hidden = YES;
    
    [self hideBorder:self.dragObject];
#ifdef DEBUG
    NSLog(@"Dismissing View Props for View %@", self.editObject);
#endif
    self.editObject = nil;
    [self hideControls:sender];
}




// will use this now for most show/hide behavior
- (IBAction)showHideView:(id)sender
{
    BOOL show = NO;
    /**using tags to show/hide views. Any buttons tag +100 = the View's tag it shows/hides **/
    UIView *sendingView = (UIView*)sender;
    
    if ([sender isKindOfClass:[UISwitch class] ]) {
        UIView *tgtView = [self.view viewWithTag:sendingView.tag+100];
        UISwitch *sw = (UISwitch*)sender;
        show = sw.on;
        
        if (show) {
            tgtView.hidden = NO;
        }
        else{
            tgtView.hidden = YES;
        }
#ifdef DEBUG
        NSLog(@"Showing/Hiding view tagged: %i which is a %@",sendingView.tag, [tgtView class]);
#endif
    }
    else{
        sendingView.hidden = !sendingView.hidden;
        
        // TODO: can do alpha fades here instead of snap hide
#ifdef DEBUG
        NSLog(@"Showing/Hiding view tagged: %i which is a %@",sendingView.tag, [sendingView class]);
#endif
    }
    
}

- (IBAction)enableViewEdits:(id)sender
{
    self.isEditing = YES;
    self.editLabelView.hidden = NO;
    [self.view bringSubviewToFront:self.editLabelView];
    [self hideControls:sender];
}

- (IBAction)doneEditing:(id)sender
{
    self.editLabelView.hidden = YES;
    self.isEditing = NO;
    if (self.dragObject) {
        [self hideBorder:self.dragObject];
        self.dragObject = nil;
    }
    self.editObject = nil;
}

- (IBAction)resetToDefault:(id)sender
{
    // TODO: set this to take tag & set that view back to default state
}

- (IBAction)showInfoDeets:(id)sender
{
    // TODO: this could eventually pull up a panel of info steps about how to use the app

    //for now, it will just throw test images and stuff
    if(!self.bgImageView.image){
        UIImage* tempBg = [UIImage imageNamed:@"selfie_bg.png"];
        self.bgImageView.image = tempBg;
    }
    else{
        self.bgImageView.image = nil;
    }
    [self.bgImageView reloadInputViews];
    
    [self hideControls:sender];
    
}

- (IBAction)showControls:(id)sender
{
    // hide control on touchup (if not editing & not hid)
    [self.view bringSubviewToFront:self.controlsView];
    if (self.controlsView.alpha < 1.0f) {
        CGFloat alphaTime = 1-self.controlsView.alpha;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: alphaTime * 0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        self.controlsView.alpha = 1.0f;
        
        [UIView commitAnimations];
    }
}

- (IBAction)hideControls:(id)sender
{
    // hide control on touchup (if not editing)
    if (self.controlsView.alpha > 0.0f) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        self.controlsView.alpha = 0.0;
        
        [UIView commitAnimations];

    }
}


#pragma mark -FX-

- (void) showBorder:(DraggableView*)view
{
    view.layer.borderColor = [UIColor redColor].CGColor;
    view.layer.borderWidth = 3.0f;
}

- (void) hideBorder:(DraggableView*)view
{
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth = 0.0f;
}

- (void)fadeView:(UIView*)view toVisible:(BOOL)visible
{
    if (visible == NO) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        self.controlsView.alpha = 0.0;
        
        [UIView commitAnimations];
        
    }
    else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        self.controlsView.alpha = 1.0;
        
        [UIView commitAnimations];
        
    }
}

#pragma mark -Touch Actions-

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    
    if (isEditing && [touches count] == 1) {
        
        // clear old border & check for new object
        if (self.dragObject)[self hideBorder:self.dragObject];
        self.dragObject = nil;
        
        // one finger
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        
        // this should clear out old drag object visibly, and make clear state change
        CGRect fingerRect = CGRectMake(touchPoint.x-5, touchPoint.y-5, 10, 10);
        if(!self.viewPropsMenu.hidden && !CGRectIntersectsRect(fingerRect, self.viewPropsMenu.frame))
        {
            [self dismissViewPropsMenu:nil];
        }
        
        for (DraggableView *iView in self.view.subviews) {
            if ( [iView isMemberOfClass:[DraggableView class]] && !iView.hidden ) {
                if (touchPoint.x > iView.frame.origin.x &&
                    touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
                    touchPoint.y > iView.frame.origin.y &&
                    touchPoint.y < iView.frame.origin.y + iView.frame.size.height)
                {
                    self.dragObject = iView;
                    self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x,
                                                   touchPoint.y - iView.frame.origin.y);
                    self.homePosition = CGPointMake(iView.frame.origin.x,
                                                    iView.frame.origin.y);
                    //[self.view bringSubviewToFront:self.dragObject]; // TODO: z-pos after neeeds to effect?
                    
                    // highlight selected object
                    [self showBorder:self.dragObject];
                }
            }
        }
    }
    else if (!self.isEditing){
        // have the controls show on touches outside edit mode
        [self showControls:self.controlsView];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isEditing) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        CGRect newDragObjectFrame = CGRectMake(touchPoint.x - touchOffset.x,
                                               touchPoint.y - touchOffset.y,
                                               self.dragObject.frame.size.width,
                                               self.dragObject.frame.size.height);
        self.dragObject.frame = newDragObjectFrame;
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
     if (self.isEditing) {
        
         
         if (self.viewPropsMenu.hidden && self.dragObject) {
             [self showViewPropsMenu:self.dragObject];
         }
         
         
//        if (touchPoint.x > self.dropTarget.frame.origin.x &&
//            touchPoint.x < self.dropTarget.frame.origin.x + self.dropTarget.frame.size.width &&
//            touchPoint.y > self.dropTarget.frame.origin.y &&
//            touchPoint.y < self.dropTarget.frame.origin.y + self.dropTarget.frame.size.height )
//        {
//            self.dropTarget.backgroundColor = self.dragObject.backgroundColor;
//            
//        }
         
         //FIXME: drop it in its new position (can use homePosition X & y if we want to lock it somewhere)
         
         
        
         
         
     }
    
     // hide the controls view if you touch up outside its zone
     CGRect fingerRect = CGRectMake(touchPoint.x-5, touchPoint.y-5, 10, 10);
     if(!CGRectIntersectsRect(fingerRect, self.controlsView.frame)){
         [self hideControls:self.controlsView];
     }
    
 // Tried to trigger buttons on touchup
//     if (CGRectIntersectsRect(fingerRect, self.editButton.frame)){
//         [self.editButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//     }
//     else if  (CGRectIntersectsRect(fingerRect, self.viewVisButton.frame)){
//         [self.viewVisButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//     }
//     else if  (CGRectIntersectsRect(fingerRect, self.testButton.frame)){
//         [self.testButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//     }

    
    [super touchesEnded:touches withEvent:event];
}



#pragma mark -Photo picker action-


// get image from photos
-(IBAction)pickImage:(id)sender{
    UIImagePickerController *imagePicker;
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    [imagePicker setAllowsEditing:YES];
    [imagePicker setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    // forced to call this view this way due to errors
    UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    popOver.delegate = self;
    self.popoverImageViewController = popOver;
    [self.popoverImageViewController presentPopoverFromRect:CGRectMake(0, 0, 160, 40) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    //[self presentViewController:imagePicker animated:YES completion:^{}];
}



#pragma mark -Delegate Methods-



//do this when a photo is picked

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // clear the VC (adjusted for popover req)
    [self.popoverImageViewController dismissPopoverAnimated:YES];
    
    // add the image to our view (284x213px for 4:3 aspect ratio)
    self.bgImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
}

// picker datasource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return @"title goes here";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;{
//    NSLog(@"Selected Row:%ld",(long)row);
//    
//    // get the filter propList based on the row/key name
//    self.currentFilter = [self.filterList objectForKey:[self.filterKeys objectAtIndex:row]];
//    NSLog(@"Filter %@ selected", [self.currentFilter objectForKey:@"filterType"]);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    // TODO: more here if mem is issue
    // FIXME: look here if crashed
    self.editButton = nil;
    self.testButton = nil;
    self.viewVisButton = nil;
}

@end

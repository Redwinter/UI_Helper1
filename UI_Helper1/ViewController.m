//
//  ViewController.m
//  UI_Helper1
//
//  Created by Erik Fleuter on 4/7/14.
//  Copyright (c) 2014 Erik Fleuter. All rights reserved.
//

#import "ViewController.h"
#define BACKGROUND_TAG 333
#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@interface ViewController ()

@end

@implementation ViewController

@synthesize isEditing, touchOffset, dragObject, homePosition, dropTarget, editButton, viewVisButton, testButton, currentViewEdits, slideDownButton,slideUpButton,viewFXMenu, shadowSwitch, rounderSwitch, slideSwitch;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //create a context for images
    self.context = [CIContext contextWithOptions:nil];
    self.isEditing = NO;
    self.currentViewEdits = [NSMutableDictionary dictionary];
}


#pragma mark - Menus -
- (IBAction)showControls:(id)sender
{
    // hide control on touchup (if not editing & not hid)
    //[self.view bringSubviewToFront:self.controlsView];
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

#pragma mark -Visibility Menu-

// currently this flips it back n forth between hide/show for speed
- (IBAction)showVisEditMenu:(id)sender
{
    self.editVisMenu.hidden = !self.editVisMenu.hidden;
    [self hideControls:sender];
}

#pragma mark -Editing Menus-

- (IBAction)showViewPropsMenu:(id)sender
{
    // NOTE: temp on button trigger. remove and have AFTER a view touched & moved
    // & have button enable dragging views around and pos
    if(self.viewPropsMenu.hidden)self.viewPropsMenu.hidden = NO;
    //[self.view bringSubviewToFront:self.viewPropsMenu];
    self.editObject = self.dragObject;
    
    [self loadPropsForView:self.editObject];// note: no need to pass var here yet
    
    // set this for views that we want to show addtl edit props for
    if (YES)
    {
        [self showFXEditMenu:self.dragObject];
    }
    
    [self hideControls:sender];
}

// currently this flips it back n forth between hide/show for speed
- (void)showFXEditMenu:(DraggableView*)sender
{
    //TODO: link switches for auto set on load. now is tag on menu with some extra features for each view
    for (UISwitch*sw in self.viewFXMenu.subviews) {
        // a rough way to sync switches to corresp views but reuse menu via tagging
        sw.tag = sender.tag -100;
#ifdef DEBUG
        NSLog(@"FX menu: Tagging switch: %li to work with %li",(long)sw.tag,(long)sender.tag );
#endif
    }
//    self.viewFXMenu.center = CGPointMake(self.viewPropsMenu.center.x+self.viewFXMenu.frame.size.width/2+20, self.viewPropsMenu.center.y);
    self.viewFXMenu.hidden = !self.viewFXMenu.hidden;
}

- (IBAction)enableViewEdits:(id)sender
{
    self.isEditing = YES;
    self.editLabelView.hidden = NO;
    //[self.view bringSubviewToFront:self.editLabelView];
    [self hideControls:sender];
    
    self.slideDownButton.hidden = YES;
    self.slideUpButton.hidden = YES;
}

- (void)loadPropsForView:(id)sender;
{
    if (sender == nil) {
        NSLog(@"ERROR: Trying to loadProps for nil editObject! Bailing");
        return;
    }
    // tgt View is self.editObject/dragObject here for now (remembered, not sent in to method)
    // TODO: can actually load in from saved plists later, for now just fill with what's shown
    
    // size
    self.viewPropsMenu.tgtWidth_.text = [NSString stringWithFormat:@"%.1f", self.editObject.frame.size.width];
    self.viewPropsMenu.tgtHeight_.text = [NSString stringWithFormat:@"%.1f", self.editObject.frame.size.height];
    
    
    // position (NOTE: THESE ARE FROM ORIGIN) // TODO: add option to convert to center pos
    self.viewPropsMenu.tgtX_.text = [NSString stringWithFormat:@"%.1f", self.editObject.frame.origin.x];
    self.viewPropsMenu.tgtY_.text = [NSString stringWithFormat:@"%.1f", self.editObject.frame.origin.y];
    self.viewPropsMenu.tgtZ_.text = [NSString stringWithFormat:@"%.1f", self.editObject.layer.zPosition];
    
    // rotation
    CGFloat radians = atan2f(self.editObject.transform.b, self.editObject.transform.a);
    CGFloat degreesRot = radians * (180 / M_PI);
    self.viewPropsMenu.tgtRot_.text = [NSString stringWithFormat:@"%.2f", degreesRot];
    
    //TODO: skew
    //    CGFloat radians = atan2f(self.editObject.transform.b, self.editObject.transform.a);
    //    CGFloat degreesRot = radians * (180 / M_PI);
    //    self.viewPropsMenu.tgtRot_.text = [NSString stringWithFormat:@"%f", degreesRot];
    
    //BgColor
    const CGFloat* components = CGColorGetComponents(self.editObject.backgroundColor.CGColor);
    self.viewPropsMenu.tgtBGColor_R_.text =[NSString stringWithFormat:@"%.2f", components[0]];
    self.viewPropsMenu.tgtBGColor_G_.text = [NSString stringWithFormat:@"%.2f", components[1]];
    self.viewPropsMenu.tgtBGColor_B_.text = [NSString stringWithFormat:@"%.2f", components[2]];
    self.viewPropsMenu.tgtBGColor_A_.text = [NSString stringWithFormat:@"%.2f", CGColorGetAlpha(self.editObject.backgroundColor.CGColor)];
    
    // label_1
    if(self.editObject.label_1){
        self.viewPropsMenu.tgtLabel_1_.text = self.editObject.label_1.text;
    }
    else{
        self.viewPropsMenu.tgtLabel_1_.text = @"-no-label-";
    }
}

- (IBAction)dismissViewPropsMenu:(id)sender
{
    // TODO: apply (& save paid) props for edited view
    // set all the values for the new edits if they have changed
    // apply & updateConstraints
    
    
    self.viewPropsMenu.hidden = YES;
    
    [self hideBorder:self.dragObject];
#ifdef DEBUG
    NSLog(@"Dismissing View Props for View %@", self.editObject);
#endif
    [self updateEditedPropsForView:self.dragObject];
    
    self.editObject = nil;
    self.viewFXMenu.hidden = YES;
    [self hideControls:sender];
    
}

- (void)updateEditedPropsForView:(id)sender;
{
    if (sender == nil) {
        NSLog(@"ERROR: Trying to updateEditedProps for nil editObject! Bailing");
        return;
    }
    
    // size & position
    CGFloat newWidth = [self.viewPropsMenu.tgtWidth_.text floatValue];
    CGFloat newHeight = [self.viewPropsMenu.tgtHeight_.text floatValue];
    CGFloat newX = [self.viewPropsMenu.tgtX_.text floatValue];
    CGFloat newY = [self.viewPropsMenu.tgtY_.text floatValue];
    
   
    if (newHeight != self.dragObject.frame.size.height || newWidth != self.dragObject.frame.size.width) {

        // set new size after rotation mess check
        if ([self.viewPropsMenu.tgtRot_.text floatValue] == 0.0){
            self.dragObject.frame = CGRectMake(newX, newY, newWidth, newHeight);
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"View Resized" message:@"Resetting Rotation to 0 to prevent frame errors. Must edit rotation and size sep. for this version." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
            [alert show];
            
            self.dragObject.transform =  CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0.0));
            self.dragObject.frame = CGRectMake(newX, newY, newWidth, newHeight);
        }

    }
    else {
         // rotation
        CGFloat newRotDeg = [self.viewPropsMenu.tgtRot_.text floatValue];
        self.dragObject.transform =  CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(newRotDeg));
    }
    
    CGFloat newZ = [self.viewPropsMenu.tgtZ_.text floatValue];
    self.dragObject.layer.zPosition = newZ;
    
    
    // TODO: skew
    
    // BG colors
    CGFloat RColor = [self.viewPropsMenu.tgtBGColor_R_.text floatValue];
    CGFloat GColor = [self.viewPropsMenu.tgtBGColor_G_.text floatValue];
    CGFloat BColor = [self.viewPropsMenu.tgtBGColor_B_.text floatValue];
    CGFloat Alpha = [self.viewPropsMenu.tgtBGColor_A_.text floatValue];
    self.dragObject.backgroundColor = [UIColor colorWithRed:RColor green:GColor blue:BColor alpha:Alpha];
    
    //labels
    self.dragObject.label_1.text = self.viewPropsMenu.tgtLabel_1_.text;

    // TODO: check this
    [self.view updateConstraints];
    //[self.view layoutSubviews];
    
  // TODO: update the edit view with changes made via menu
    // TODO: farther out: save states in plists for each view for later revisiting
}


- (void)saveEditedViewWithChanges:(NSMutableDictionary*)changes
{
    
}

- (IBAction)resetToDefault:(id)sender
{
    // TODO: set this to take tag & set that view back to default state
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
    
    self.slideDownButton.hidden = NO;
    self.slideUpButton.hidden = NO;
}

// TODO: rewire this to set a BG screen image in labeling too
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

// Can use this for most show/hide behavior
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
        NSLog(@"Showing/Hiding view tagged: %li which is a %@",(long)sendingView.tag, [tgtView class]);
#endif
    }
    else{
        sendingView.hidden = !sendingView.hidden;
        
        // TODO: can do alpha fades here instead of snap hide
#ifdef DEBUG
        NSLog(@"Showing/Hiding view tagged: %li which is a %@",(long)sendingView.tag, [sendingView class]);
#endif
    }
    
}

-(IBAction)setSlideUpDownUI:(id)sender{
    UISwitch *sendingSwitch = (UISwitch*)sender;
    UIView *tgtView;
    BOOL isBottom = NO;
    if ([sender isKindOfClass:[UISwitch class]]) {
       
        tgtView = [self.view viewWithTag:sendingSwitch.tag+100];
    }
    
    //crude setters for temp
    if(tgtView.tag == 111){
        isBottom = YES;
    }
    
    if (isBottom) {
        self.slideDownButton.enabled = sendingSwitch.on;
    }
    else{
        self.slideUpButton.enabled = sendingSwitch.on;
    }
    
    self.dragObject.slidesUpDown = sendingSwitch.on;
    
}

-(IBAction)tapSlideUpUI:(id)sender
{
    // note: must use a distinct button + tag assoc draggable view in this case currently
    // using tagging so the view it targets can be reconfigured that way
    DraggableView *tgtView = (DraggableView*)[self.view viewWithTag:self.slideUpButton.tag+100];
    float down = tgtView.bounds.size.height/2;
    float curY = tgtView.center.y;
    if (curY < down){
        // slide down on
        [UIView beginAnimations:@"slideDown" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.25];
        tgtView.center = CGPointMake(tgtView.center.x, tgtView.bounds.size.height/2);
        [UIView commitAnimations];
        
    }
    else{
        //slide back up
        [UIView beginAnimations:@"slideDown" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.25];
        tgtView.center = CGPointMake(tgtView.center.x, -1.0 * tgtView.bounds.size.height);
        [UIView commitAnimations];
    }
    
}

-(IBAction)tapSlideDownUI:(id)sender
{
    // note: must use a distinct button + tag assoc draggable view in this case currently
    // using tagging so the view it targets can be reconfigured that way
    DraggableView *tgtView = (DraggableView*)[self.view viewWithTag:self.slideDownButton.tag+100];
 
    //TODO:set for orientations messy here but.. button ctr is safe ref
    float up = self.slideDownButton.center.y;
    float curY = tgtView.center.y;
    if (curY > up){
        // its farther off screen than it should be, slide it back up
        [UIView beginAnimations:@"slideDown" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.25];
        tgtView.center = CGPointMake(tgtView.center.x, up);
        [UIView commitAnimations];
        
    }
    else{
        //slide down off
        [UIView beginAnimations:@"slideDown" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.25];
        tgtView.center = CGPointMake(tgtView.center.x, up+tgtView.bounds.size.height);
        [UIView commitAnimations];
    }
    
}

-(IBAction)toggleShadow:(id)sender show:(BOOL)show;
{
    UIView *tgtView;
    
    if ([sender isKindOfClass:[UISwitch class]]) {
        UISwitch *sendingSwitch = (UISwitch*)sender;
        tgtView = [self.view viewWithTag:sendingSwitch.tag+100];
        UISwitch *sw = (UISwitch*)sender;
        show = sw.on;
    }
    else{
        tgtView = (UIView*)sender;
    }
    
    if (show) {
        [tgtView.layer setShadowColor:[UIColor blackColor].CGColor];
        [tgtView.layer setShadowOpacity:0.8];
        [tgtView.layer setShadowOffset:CGSizeMake(-2, -2)];
    }
    else{
        [tgtView.layer setShadowOpacity:0.0];
        [tgtView.layer setShadowOffset:CGSizeMake(0, 0)];
    }
    
    self.dragObject.isShadowed = show;
	
}

-(IBAction)toggleCorners:(id)sender rounded:(BOOL)round;
{
    UIView *tgtView;
    
    if ([sender isKindOfClass:[UISwitch class]]) {
        UISwitch *sendingSwitch = (UISwitch*)sender;
        tgtView = [self.view viewWithTag:sendingSwitch.tag+100];
        UISwitch *sw = (UISwitch*)sender;
        round = sw.on;
    }
    else{
        tgtView = (UIView*)sender;
    }

    [tgtView.layer setMasksToBounds:YES];
    if(round)
    {
        [tgtView.layer setCornerRadius:4.0];
    }
    else{
        [tgtView.layer setCornerRadius:1.0];
    }
    
     self.dragObject.isRounded = round;
    
}

-(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius;
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
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
        CGPoint newDragCenter = CGPointMake(touchPoint.x, touchPoint.y);
        self.dragObject.center = newDragCenter;
        
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
     if (self.isEditing) {
        
         
         if (self.viewPropsMenu.hidden && self.dragObject) {
             [self showViewPropsMenu:self.dragObject];
         }
         
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

//do this when a photo is picked

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // clear the VC (adjusted for popover req)
    [self.popoverImageViewController dismissPopoverAnimated:YES];
    
    //self.bgImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(self.editObject){
        self.editObject.backgroundImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    else{
        NSLog(@"ERROR: No editObject found for setting BG Image");
    }
    
}

- (IBAction)clearBGImage:(id)sender
{
    //self.bgImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(self.editObject)self.editObject.backgroundImage.image = nil;
    
}



#pragma mark -Picker Delegate Methods-


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
    self.currentViewEdits = nil;
}

@end

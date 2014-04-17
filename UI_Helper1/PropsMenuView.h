//
//  PropsMenuView.h
//  UI_Helper1
//
//  Created by Erik Fleuter on 4/13/14.
//  Copyright (c) 2014 Erik Fleuter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropsMenuView : UIView

@property (nonatomic) BOOL shouldSave;
@property (nonatomic) BOOL tgtViewLocked;
@property (nonatomic) BOOL posIsCenter;
@property (nonatomic, strong) IBOutlet UITextField *tgtWidth_;
@property (nonatomic, strong) IBOutlet UITextField *tgtHeight_;
@property (nonatomic, strong) IBOutlet UITextField *tgtX_;
@property (nonatomic, strong) IBOutlet UITextField *tgtY_;
@property (nonatomic, strong) IBOutlet UITextField *tgtZ_;
@property (nonatomic, strong) IBOutlet UITextField *tgtRot_;
@property (nonatomic, strong) IBOutlet UITextField *tgtSkew_;
@property (nonatomic, strong) IBOutlet UITextField *tgtBGColor_R_;
@property (nonatomic, strong) IBOutlet UITextField *tgtBGColor_G_;
@property (nonatomic, strong) IBOutlet UITextField *tgtBGColor_B_;
@property (nonatomic, strong) IBOutlet UITextField *tgtBGColor_A_;
@property (nonatomic, strong) IBOutlet UITextField *tgtLabel_1_;



@end

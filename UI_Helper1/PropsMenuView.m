//
//  PropsMenuView.m
//  UI_Helper1
//
//  Created by Erik Fleuter on 4/13/14.
//  Copyright (c) 2014 Erik Fleuter. All rights reserved.
//

#import "PropsMenuView.h"

@implementation PropsMenuView

@synthesize tgtViewLocked, tgtBGColor_B_,tgtBGColor_G_,tgtBGColor_R_,tgtHeight_,tgtLabel_1_,tgtRot_,tgtSkew_,tgtWidth_,tgtX_,tgtY_,tgtZ_,tgtBGColor_A_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//
//- (void)dealloc
//{
//    self.tgtBGColor_R_ = nil;
//    self.tgtBGColor_G_=nil;
//    self.tgtBGColor_B_=nil;
//    self.tgtX_=nil;
//    self.tgtY_=nil;
//    self.tgtZ_=nil;
//    self.tgtWidth_=nil;
//    self.tgtHeight_=nil;
//    self.tgtRot_=nil;
//    self.tgtSkew_=nil;
//    self.tgtLabel_1_=nil;
//    self.tgtBGColor_A_=nil;
//}

@end

//
//  DraggableView.h
//  UI_Helper1
//
//  Created by Erik Fleuter on 4/9/14.
//  Copyright (c) 2014 Erik Fleuter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraggableView : UIView

@property (nonatomic) BOOL isDragging;
@property (nonatomic) BOOL canDrag;
@property (nonatomic) IBOutlet UIImageView *backgroundImage;



@end

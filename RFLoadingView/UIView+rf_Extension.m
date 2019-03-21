//
//  UIView+rf_Extension.m
//  RFLoadingView
//
//  Created by 王若风 on 9/10/16.
//  Copyright © 2016 王若风. All rights reserved.
//

#import "UIView+rf_Extension.h"

@implementation UIView (rf_Extension)

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

@end

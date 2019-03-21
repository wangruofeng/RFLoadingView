//
//  RFLoadingView.h
//  RFLoadingView
//
//  Created by 王若风 on 9/10/16.
//  Copyright © 2016 王若风. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFLoadingView : UIView

+ (void)showViewAddedTo:(UIView *)view animated:(BOOL)animated;
+ (void)hideViewForView:(UIView *)view animated:(BOOL)animated;

@end

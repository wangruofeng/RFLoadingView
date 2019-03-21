//
//  RFLoadingView.m
//  RFLoadingView
//
//  Created by 王若风 on 9/10/16.
//  Copyright © 2016 王若风. All rights reserved.
//

#import "RFLoadingView.h"
#import "UIView+rf_Extension.h"

#define RFMainThreadAssert() NSAssert([NSThread isMainThread], @"RFLoadingView needs to be accessed on the main thread.");
#define kCenterViewSize 100

@interface RFLoadingView ()

@property (nonatomic, strong) UIView      *centralView;
@property (nonatomic, strong) UIImageView *firstView;
@property (nonatomic, strong) UIImageView *secondView;

@property (nonatomic, strong) NSArray     *images; // of UIImage
@property (nonatomic, assign) NSInteger   firstIndex;
@property (nonatomic, assign) NSInteger   secondIndex;

@end

@implementation RFLoadingView

#pragma mark - Class methods

+ (void)showViewAddedTo:(UIView *)view animated:(BOOL)animated
{
    RFLoadingView *loadingView = [self loadingViewForView:view];
    
    // 保证一个View上只添加一个loadingView
    if (loadingView) {
        return;
    }
    
    loadingView = [[self alloc] initWithView:view];
    [view addSubview:loadingView];
    
    [loadingView showAnimated:animated];
}

+ (void)hideViewForView:(UIView *)view animated:(BOOL)animated;
{
    RFLoadingView *loadingView = [self loadingViewForView:view];
    
    if (loadingView != nil) {
        [loadingView hideAnimated:animated];
    }
}

+ (RFLoadingView *)loadingViewForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (RFLoadingView *)subview;
        }
    }
    
    return nil;
}

#pragma mark - Lifecycle

- (void)commonInit
{
    self.firstIndex = 0;
    self.secondIndex = 1;
    self.images = @[[UIImage imageNamed:@"loadImage1"],
                    [UIImage imageNamed:@"loadImage2"],
                    [UIImage imageNamed:@"loadImage3"],
                    [UIImage imageNamed:@"loadImage4"],
                    [UIImage imageNamed:@"loadImage5"],
                    [UIImage imageNamed:@"loadImage6"]];
    
    // Transparent background
    self.opaque = NO;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    // Make it invisible for now
    self.alpha = 0.0f;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.layer.allowsGroupOpacity = NO;
    
    //
    [self setupViews];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}

#pragma mark - UI

- (void)setupViews
{
    //
    _centralView = [[UIView alloc] init];
    _centralView.bounds = CGRectMake(0, 0, kCenterViewSize, kCenterViewSize);
    _centralView.center = self.center;
    _centralView.layer.cornerRadius = 6;
    _centralView.layer.masksToBounds = YES;
    _centralView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _centralView.backgroundColor = [UIColor whiteColor];
    _centralView.alpha = 0.f;
    
    [self addSubview:_centralView];
    
    
    //
    _firstView = [[UIImageView alloc] init];
    _firstView.bounds = CGRectInset(_centralView.bounds, 15, 15);
    _firstView.center = CGPointMake(CGRectGetWidth(_centralView.frame) * 0.5, CGRectGetHeight(_centralView.frame) * 0.5);
    _firstView.contentMode = UIViewContentModeScaleAspectFill;
    _firstView.image = self.images[self.firstIndex];
    
    [_centralView addSubview:_firstView];
    
    
    //
    _secondView = [[UIImageView alloc] init];
    _secondView.bounds = CGRectInset(_centralView.bounds, 15, 15);
    _secondView.center = CGPointMake(CGRectGetWidth(_centralView.frame) * 0.5, -CGRectGetHeight(_centralView.frame) * 0.5);
    _secondView.contentMode = UIViewContentModeScaleAspectFill;
    _secondView.image = self.images[self.secondIndex];
    
    [_centralView addSubview:_secondView];
    
}

#pragma mark - Animation

- (void)animatedImageFromTopToBottom
{
    [UIView animateWithDuration:0.3 delay:0.5 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _firstView.centerY  += kCenterViewSize;
        _secondView.centerY += kCenterViewSize;
    } completion:^(BOOL finished) {
        _firstView.centerX += kCenterViewSize;
        _firstView.centerY -= kCenterViewSize;
        
        [self changeFirstImage];
        [self animatedImageFromRightToLeft];
    }];
}

- (void)animatedImageFromRightToLeft
{
    
    [UIView animateWithDuration:0.3 delay:0.5 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _firstView.centerX  -= kCenterViewSize;
        _secondView.centerX -= kCenterViewSize;
    } completion:^(BOOL finished) {
        _secondView.centerX += kCenterViewSize;
        _secondView.centerY -= kCenterViewSize;
        
        if (self.alpha && self) {
            [self changeSecondImage];
            [self animatedImageFromTopToBottom];
        }
        
    }];
}

- (void)changeFirstImage
{
    self.firstIndex += 2;
    
    if (self.firstIndex >= self.images.count) {
        self.firstIndex = self.firstIndex % self.images.count;
    }
    
    self.firstView.image = self.images[self.firstIndex];
}

- (void)changeSecondImage
{
    self.secondIndex += 2;
    
    if (self.secondIndex >= self.images.count) {
        self.secondIndex = self.secondIndex % self.images.count;
    }
    
    self.secondView.image = self.images[self.secondIndex];
}

#pragma mark - Show & hide

- (void)showAnimated:(BOOL)animated
{
    RFMainThreadAssert();
    
    self.alpha = 1;
    
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        _centralView.alpha = 1;
    } completion:^(BOOL finished) {
        [self animatedImageFromTopToBottom];
    }];
}

- (void)hideAnimated:(BOOL)animated
{
    RFMainThreadAssert();
    
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

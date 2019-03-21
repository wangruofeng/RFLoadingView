//
//  ViewController.m
//  RFLoadingView
//
//  Created by 王若风 on 9/10/16.
//  Copyright © 2016 王若风. All rights reserved.
//

#import "ViewController.h"
#import "RFLoadingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // show
    [RFLoadingView showViewAddedTo:self.view animated:YES];
    
    // hide
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [RFLoadingView hideViewForView:self.view animated:YES];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

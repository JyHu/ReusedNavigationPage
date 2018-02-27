//
//  CustomNavigationViewController.m
//  ReusedNavigationPage
//
//  Created by 胡金友 on 2018/2/27.
//  Copyright © 2018年 胡金友. All rights reserved.
//

#import "CustomNavigationViewController.h"

@implementation CustomNavigationViewController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    NSLog(@"poping");
    return [super popViewControllerAnimated:animated];
}

@end

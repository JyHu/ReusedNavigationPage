//
//  SingletonViewController.m
//  ReusedNavigationPage
//
//  Created by 胡金友 on 2018/2/27.
//  Copyright © 2018年 胡金友. All rights reserved.
//

#import "SingletonViewController.h"

@implementation SingletonViewController

+ (instancetype)sharedPage {
    static SingletonViewController *page = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        page = [storyboard instantiateViewControllerWithIdentifier:@"ReusedNavigationPageIdentifier"];
    });
    return page;
}

@end

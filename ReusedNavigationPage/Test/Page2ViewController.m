//
//  Page2ViewController.m
//  ReusedNavigationPage
//
//  Created by 胡金友 on 2018/2/27.
//  Copyright © 2018年 胡金友. All rights reserved.
//

#import "Page2ViewController.h"
#import "SingletonViewController.h"

@implementation Page2ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[SingletonViewController sharedPage] animated:YES];
}

@end

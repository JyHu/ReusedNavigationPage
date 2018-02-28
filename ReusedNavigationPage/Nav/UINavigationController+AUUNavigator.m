//
//  UINavigationController+AUUNavigator.m
//  ReusedNavigationPage
//
//  Created by 胡金友 on 2018/2/27.
//  Copyright © 2018年 胡金友. All rights reserved.
//

#import "UINavigationController+AUUNavigator.h"
#import <objc/runtime.h>

/**
 占位的视图控制器，不做任何实际的展示需要
 */
@interface _AUUPlaceholderViewController: UIViewController

/**
 当前占位视图所代表的被重复使用的视图
 */
@property (nonatomic, weak) UIViewController *_associatedReusedPage;

@end
@implementation _AUUPlaceholderViewController
@end

@implementation UINavigationController (AUUNavigator)

+ (void)methodExchangeWithOriginSelector:(SEL)originSelector swizedSelector:(SEL)swizedSelector {
    Method originMethod = class_getInstanceMethod([self class], originSelector);
    Method swizedMethod = class_getInstanceMethod([self class], swizedSelector);
    method_exchangeImplementations(swizedMethod, originMethod);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodExchangeWithOriginSelector:@selector(pushViewController:animated:) swizedSelector:@selector(_pushViewController:animated:)];
        [self methodExchangeWithOriginSelector:@selector(popViewControllerAnimated:) swizedSelector:@selector(_popViewControllerAnimated:)];
    });
}

- (void)_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果当前的视图栈内包含当前要跳转的视图的话，就使用占位视图占位做替换
    if ([self.viewControllers containsObject:viewController]) {
        _AUUPlaceholderViewController *tempVC = [[_AUUPlaceholderViewController alloc] init];
        tempVC._associatedReusedPage = viewController;
        
        NSMutableArray *viewControllers = [self.viewControllers mutableCopy];
        [viewControllers replaceObjectAtIndex:[viewControllers indexOfObject:viewController] withObject:tempVC];
        self.viewControllers = viewControllers;
    }
    
    [self _pushViewController:viewController animated:animated];
}

- (UIViewController *)_popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count >= 2) {
        UIViewController *nextPage = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
        // 对返回事件做拦截，如果上个视图是个占位视图，就将其保存的对应视图放在这个位置
        if ([nextPage isKindOfClass:[_AUUPlaceholderViewController class]]) {
            _AUUPlaceholderViewController *placeholderPage = (_AUUPlaceholderViewController *)nextPage;
            
            NSMutableArray *viewControllers = [self.viewControllers mutableCopy];
            [viewControllers replaceObjectAtIndex:viewControllers.count - 2 withObject:placeholderPage._associatedReusedPage];
            self.viewControllers = viewControllers;
        }
    }
    
    return [self _popViewControllerAnimated:animated];
}

@end


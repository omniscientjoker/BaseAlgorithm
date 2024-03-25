//
//  CTMediator+ModuleBActions.m
//  CXRouterDemo
//
//  Created by Xu Chen on 2019/7/5.
//  Copyright © 2019 xu.yzl. All rights reserved.
//

#import "CTMediator+PageJump.h"

//  1. 字符串 是类名 Target_xxx.h 中的 xxx 部分
NSString * const kCTMediatorTarget_PageA = @"CTMediatorAVC";
NSString * const kCTMediatorTarget_PageB = @"CTMediatorBVC";
//  2. 字符串是 Target_xxx.h 中 定义的 Action_xxxx 函数名的 xxx 部分
NSString * const kCTMediatorActionNativTo_nativeCourseListPage = @"nativeHomeViewController";


@implementation CTMediator (ModuleBActions)
- (UIViewController *)mediator_viewControllerForPageAWithParams:(NSDictionary *)dict {
    UIViewController *viewController = [self performTarget:kCTMediatorTarget_PageA
                                                    action:kCTMediatorActionNativTo_nativeCourseListPage
                                                    params:dict
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    } else {
        NSLog(@"%@ 未能实例化页面", NSStringFromSelector(_cmd));
        return [[UIViewController alloc] init];
    }
}

- (UIViewController *)mediator_viewControllerForPageBWithParams:(NSDictionary *)dict {
    UIViewController *viewController = [self performTarget:kCTMediatorTarget_PageB
                                                    action:kCTMediatorActionNativTo_nativeCourseListPage
                                                    params:dict
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    } else {
        NSLog(@"%@ 未能实例化页面", NSStringFromSelector(_cmd));
        return [[UIViewController alloc] init];
    }
}
@end

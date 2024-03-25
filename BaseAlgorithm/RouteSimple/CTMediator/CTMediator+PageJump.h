//
//  CTMediator+ModuleBActions.h
//  CXRouterDemo
//
//  Created by Xu Chen on 2019/7/5.
//  Copyright © 2019 xu.yzl. All rights reserved.
//

#import "CTMediator.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (PageJump)
// 外部调用的方法
- (UIViewController *)mediator_viewControllerForPageAWithParams:(NSDictionary *)dict;
- (UIViewController *)mediator_viewControllerForPageBWithParams:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END

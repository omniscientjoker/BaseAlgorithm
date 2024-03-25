//
//  CTMediator+ModuleBActions.m
//  CXRouterDemo
//
//  Created by Xu Chen on 2019/7/5.
//  Copyright © 2019 xu.yzl. All rights reserved.
//

#import "CTMediator+Fundication.h"

//  1. 字符串 是类名 Target_xxx.h 中的 xxx 部分
NSString * const kCTMediatorTarget_ClassTool = @"CTMediatorToolCommon";
//  2. 字符串是 Target_xxx.h 中 定义的 Action_xxxx 函数名的 xxx 部分
NSString * const kCTMediatorAction_createMessageForA = @"createMessageForA";


@implementation CTMediator (Fundication)
- (void)mediator_createMessageForAWithParams:(NSDictionary *)dict {
    [self performTarget:kCTMediatorTarget_ClassTool
                 action:kCTMediatorAction_createMessageForA
                 params:dict
      shouldCacheTarget:NO];
}
@end

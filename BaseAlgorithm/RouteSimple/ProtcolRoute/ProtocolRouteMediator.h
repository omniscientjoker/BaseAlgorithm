//
//  ProtocolRouteMediator.h
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/25.
//  Copyright © 2024 joker. All rights reserved.
//
//  中间件提供模块的注册和获取模块的功能

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface ProtocolRouteMediator : NSObject
+ (instancetype)sharedInstance;
- (void)registerProtocol:(Protocol *)proto forClass:(Class)cls;
- (Class)classForProtocol:(Protocol *)proto;
@end
NS_ASSUME_NONNULL_END

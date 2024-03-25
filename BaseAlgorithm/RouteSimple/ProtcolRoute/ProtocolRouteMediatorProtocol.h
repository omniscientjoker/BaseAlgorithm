//
//  ProtocolRouteMediatorProtocol.h
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/25.
//  Copyright © 2024 joker. All rights reserved.
//
//  实现不同模块的跳转协议 可分模块进行处理

#import <Foundation/Foundation.h>

@protocol ProtocolPageRouteProtocol <NSObject>
-(void)action_A:(NSString*)para1;
-(void)action_B:(NSString*)para para2:(NSInteger)para2 para3:(NSInteger)para3 para4:(NSInteger)para4;
@end

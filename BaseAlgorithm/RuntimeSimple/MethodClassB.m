//
//  MethodClassB.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/17.
//  Copyright © 2024 joker. All rights reserved.
//

#import "MethodClassB.h"

@implementation MethodClassB
-(void)methodB{
    NSLog(@"methodB = %@",NSStringFromClass([self class]));
    [self methodBTest];
}
-(void)methodBTest{
    NSLog(@"methodBTest = %@",NSStringFromClass([self class]));
}
@end

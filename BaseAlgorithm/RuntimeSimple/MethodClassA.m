//
//  MethodClassA.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/17.
//  Copyright © 2024 joker. All rights reserved.
//

#import "MethodClassA.h"

@implementation MethodClassA
-(void)methodA{
    NSLog(@"methodA = %@",NSStringFromClass([self class]));
    [self methodATest];
}
-(void)methodATest{
    NSLog(@"methodATest = %@",NSStringFromClass([self class]));
}
@end

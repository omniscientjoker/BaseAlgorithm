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
    if ([self.delegate respondsToSelector:@selector(getOriginalAName:)]) {
        [self.delegate getOriginalAName:@"MethodClassA"];
    }
}
-(void)methodATest{
    NSLog(@"methodATest = %@",NSStringFromClass([self class]));
}
@end

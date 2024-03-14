//
//  RuntimrSimple.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/14.
//  Copyright © 2024 joker. All rights reserved.
//

#import "RuntimrSimple.h"
#import <objc/runtime.h>

@implementation RuntimrSimple
+(void)test{
    Class test_cls    = NSClassFromString(@"testManager");
    id test_ins = [[test_cls alloc] init];
    SEL sel = sel_registerName("justTest:");
    Method methodA = class_getInstanceMethod(test_cls, sel);
    Method methodB = class_getClassMethod(test_cls,sel);
    IMP impA = method_getImplementation(methodA);
    IMP impB = method_getImplementation(methodB);
    
    id resultA = impA(test_ins, sel, @"testA");
    id resultB = impB(test_cls, sel, @"testB");
}
@end

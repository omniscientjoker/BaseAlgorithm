//
//  RuntimrSimple.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/14.
//  Copyright © 2024 joker. All rights reserved.
//

#import "RuntimrSimple.h"

#import <objc/runtime.h>

#import "MethodClassA.h"
#import "MethodClassB.h"

@implementation testManager
-(void)justTest:(NSString*)message{
    NSLog(@"testManager instance method %@",message);
}
+(void)justTest:(NSString*)message{
    
    NSLog(@"testManager class method %@",message);
}
@end


@implementation RuntimrSimple
-(void)test{
    Class test_cls    = NSClassFromString(@"testManager");
    id test_ins = [[test_cls alloc] init];
    SEL sel = sel_registerName("justTest:");
    Method methodA = class_getInstanceMethod(test_cls, sel);
    Method methodB = class_getClassMethod(test_cls,sel);
    IMP impA = method_getImplementation(methodA);
    IMP impB = method_getImplementation(methodB);
    impA(test_ins, sel, @"testA");
    impB(test_cls, sel, @"testB");
    [MethodClassA isSubclassOfClass:[NSObject class]];
}

-(void)changeMethodSwizzle{
    MethodClassA * classA = [[MethodClassA alloc] init];
    [classA methodA];
    [MethodClassA isKindOfClass:[NSObject class]];
    [classA isKindOfClass:[NSObject class]];
    [MethodClassA isSubclassOfClass:[NSObject class]];
    MethodClassB * classB = [[MethodClassB alloc] init];
    [classB methodB];
    Method Bmethod = class_getInstanceMethod([MethodClassB class], @selector(methodB));
    Method Amethod = class_getInstanceMethod([MethodClassA class], @selector(methodA));
    method_exchangeImplementations(Bmethod, Amethod);
    NSLog(@"MethodSwizzleAfter");
    [classA methodA];
    [classB methodB];
}

-(void)changeMethodSwizzle2{
    MethodClassA * classA = [[MethodClassA alloc] init];
    [classA methodA];
    [MethodClassA isKindOfClass:[NSObject class]];
    [classA isKindOfClass:[NSObject class]];
    [MethodClassA isSubclassOfClass:[NSObject class]];
    MethodClassB * classB = [[MethodClassB alloc] init];
    [classB methodB];
    Method Bmethod = class_getInstanceMethod([MethodClassB class], @selector(methodB));
    Method Amethod = class_getInstanceMethod([MethodClassA class], @selector(methodA));
    method_exchangeImplementations(Bmethod, Amethod);
    NSLog(@"MethodSwizzleAfter");
    [classA methodA];
    [classB methodB];
}

void changeMethodSwizzle2(Class class, SEL originalSEL, SEL replacementSEL){
    //如果子类没有实现相应的方法，则会返回父类的方法。
    Method originMethod = class_getInstanceMethod(class, originalSEL);
    Method replaceMethod = class_getInstanceMethod(class, replacementSEL);
    //可用BaseClass实验
    if(class_addMethod(class,originalSEL,method_getImplementation(replaceMethod),method_getTypeEncoding(replaceMethod))){
        // 返回YES时，说明子类未实现此方，class_addMethod会添加（名字为originalSEL，实现为replaceMethod）的方法
        // 此时在将replacementSEL的实现替换为originMethod的实现即可。
        class_replaceMethod(class,replacementSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else {
        // 返回NO时，说明子类中有该实现方法，即使只是单纯的调用super，一样算重写了父类的方法
        // 此时直接调用method_exchangeImplementations交换两个方法的实现即可
        method_exchangeImplementations(originMethod, replaceMethod);
    }
}
@end

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

@interface RuntimrSimple()<MethodClassADelegate,MethodClassBDelegate>
@property(nonatomic,strong)MethodClassA * classA;
@property(nonatomic,strong)MethodClassB * classB;
@end
@implementation RuntimrSimple
// 组合引入 实现多继承
- (void)runFundication{
    self.classA = [[MethodClassA alloc] init];
    self.classB = [[MethodClassB alloc] init];
    [self.classA methodA];
    [self.classB methodB];
}
// 多个代理 实现多继承
-(void)getOriginalAName:(NSString *)name{
    NSLog(@"%@",name);
}
-(void)getOriginalBName:(NSString *)name{
    NSLog(@"%@",name);
}
// 消息转发 - 快速转发
- (id)forwardingTargetForSelector:(SEL)aSelector{
    // 判断方法名 来决定是否转发
    if ([NSStringFromSelector(aSelector) isEqualToString:@"methodB"]) {
        // 根据 类名 获取类
        Class class = NSClassFromString(@"MethodClassB");
        // 判断是否为类方法
        if (class_respondsToSelector(class,aSelector)) {
            return class;
        }
        // 判断是否为实例方法
        id b = [[class alloc] init];
        if ([b respondsToSelector:aSelector]) {
            return b;
        }
    }
    return nil;
}
// 消息转发 - 标准转发
// 在转发消息前先对方法重新签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    // 尝试自行实现方法签名
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    // 若无法实现，尝试通过多继承得到的方法实现
    if (signature == nil) {
        Class classA = NSClassFromString(@"MethodClassA");
        Class classB = NSClassFromString(@"MethodClassB");
        // 判断该方法是哪个父类的，并通过其创建方法签名
        if ([classA respondsToSelector:aSelector]) {
            signature = [classA instanceMethodSignatureForSelector:aSelector];
        }else if ([classB respondsToSelector:aSelector]) {
            signature = [classB instanceMethodSignatureForSelector:aSelector];
        }else {
            id  a = [[classA alloc] init];
            id  b = [[classB alloc] init];
            if ([a respondsToSelector:aSelector]) {
                signature = [a methodSignatureForSelector:aSelector];
            } else if ([b respondsToSelector:aSelector]){
                signature = [b methodSignatureForSelector:aSelector];
            } else {
                // 所有都查找不到 手动生成签名 防止崩溃
                signature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
            }
        }
    }
    return signature;
}
// 为方法签名后，转发消息
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = [anInvocation selector];
    Class classB = NSClassFromString(@"MethodClassB");
    Class classA = NSClassFromString(@"MethodClassA");
    id a = [[classA alloc] init];
    id b = [[classB alloc] init];
    if ([classB respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:classB];
    }
    if ([classA respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:classA];
    }
    if ([a respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:a];
    }
    if ([b respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:b];
    }
}


#pragma mark ---- test
- (void)test{
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
    
    [self performSelector:@selector(methodATest)];
    [self performSelector:@selector(methodATestFake)];
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

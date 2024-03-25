//
//  runtime.m
//  ProjectExecises
//
//  Created by 姜淼 on 2019/1/17.
//  Copyright © 2019 姜淼. All rights reserved.
//

#import "runtime.h"
#import <objc/runtime.h>

@implementation runtime

#pragma mark swizzleMethod
+(void)swizzleMethods:(Class)class originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel {
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method swizMethod = class_getInstanceMethod(class, swizSel);
    BOOL didAddMethod = class_addMethod(class, origSel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, swizMethod);
    }
}
+(void)addMethodWithSEL:(SEL)methodSEL methodIMP:(SEL)methodIMP{
    Method method = class_getInstanceMethod([self class], methodIMP);
    IMP getMethodIMP = method_getImplementation(method);
    const char * type = method_getTypeEncoding(method);
    class_addMethod([self class], methodSEL, getMethodIMP, type);
}
@end

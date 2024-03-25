//
//  AspectsSimple.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/25.
//  Copyright © 2024 joker. All rights reserved.
//

#import "AspectsSimple.h"
#import "Aspects.h"
@implementation AspectsSimple
+(void)aspectChangeMethod{
    SEL sel              = NSSelectorFromString(@"methodA");
    AspectOptions option = AspectPositionBefore;
    Class instance       = NSClassFromString(@"MethodClassA");
    if (![instance instancesRespondToSelector:sel] && ![instance respondsToSelector:sel]) {
        return;
    }
//    Class class = [instance instancesRespondToSelector:sel] ? instance : objc_getMetaClass(class_getName(instance));
//    void(^block)(id<AspectInfo>) = ^(id<AspectInfo>){
//        
//    }
//    void(^moreBlock)(id<AspectInfo>,...) = ^(id<AspectInfo>,...){
//        
//    }
}
@end

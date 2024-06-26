//
//  CTMediator+ModuleBActions.m
//  CXRouterDemo
//
//  Created by Xu Chen on 2019/7/5.
//  Copyright © 2019 xu.yzl. All rights reserved.
//

#import "NSArray+Safe.h"

#import "runtime.h"
#import <objc/runtime.h>

@implementation NSArray(Safe)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *tmpStr = @"objectAtIndex:";
        NSString *tmpFirstStr = @"safe_ZeroObjectAtIndex:";
        NSString *tmpThreeStr = @"safe_objectAtIndex:";
        NSString *tmpSecondStr = @"safe_singleObjectAtIndex:";
        NSString *tmpSubscriptStr = @"objectAtIndexedSubscript:";
        NSString *tmpSecondSubscriptStr = @"safe_objectAtIndexedSubscript:";
        [runtime swizzleMethods:NSClassFromString(@"__NSArray0")
               originalSelector:NSSelectorFromString(tmpStr)
               swizzledSelector:NSSelectorFromString(tmpFirstStr)];
        [runtime swizzleMethods:NSClassFromString(@"__NSSingleObjectArrayI")
               originalSelector:NSSelectorFromString(tmpStr)
               swizzledSelector:NSSelectorFromString(tmpSecondStr)];
        [runtime swizzleMethods:NSClassFromString(@"__NSArrayI")
               originalSelector:NSSelectorFromString(tmpStr)
               swizzledSelector:NSSelectorFromString(tmpThreeStr)];
        [runtime swizzleMethods:NSClassFromString(@"__NSArrayI")
               originalSelector:NSSelectorFromString(tmpSubscriptStr)
               swizzledSelector:NSSelectorFromString(tmpSecondSubscriptStr)];
    });
}


#pragma mark --- implement method
/**
 取出NSArray 第index个 值 对应 __NSArrayI
  @param index 索引 index
  @return 返回值
 */
- (id)safe_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_objectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSSingleObjectArrayI
  @param index 索引 index
  @return 返回值
 */
- (id)safe_singleObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_singleObjectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSArray0
  @param index 索引 index
  @return 返回值
 */
- (id)safe_ZeroObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_ZeroObjectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSArrayI
  @param idx 索引 idx
  @return 返回值
 */
- (id)safe_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count){
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:idx];
}
@end

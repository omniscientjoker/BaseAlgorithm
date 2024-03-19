//
//  KVOSimple.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/18.
//  Copyright © 2024 joker. All rights reserved.
//

#import "KVOSimple.h"
#import <objc/runtime.h>
@implementation SimpleClass
@end

@implementation KVOSimple
- (void)testKVO{
    self.simpleClassA = [[SimpleClass alloc] init];
    self.simpleClassA.simplePropertyA = 1;
    self.simpleClassA.simplePropertyB = @"simpleClassA-simplePropertyB";
   
    self.simpleClassB = [[SimpleClass alloc] init];
    self.simpleClassB.simplePropertyA = 1;
    self.simpleClassB.simplePropertyB = @"simpleClassB-simplePropertyB";
    NSLog(@"simpleClassA添加KVO监听之前");
    NSLog(@"simpleClassA添加KVO监听之前 - %@ %@",
              object_getClass(self.simpleClassA),
              object_getClass(self.simpleClassB));
    NSLog(@"simpleClassA添加KVO监听之前 - %p %p",
          [self.simpleClassA methodForSelector:@selector(setSimpleClassA:)],
          [self.simpleClassA methodForSelector:@selector(setSimpleClassB:)]);
          
    // 给person1对象添加KVO监听
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.simpleClassA addObserver:self forKeyPath:@"simplePropertyA" options:options context:@"test"];
    // 打印添加监听之后person1和person2对应的isa指针指向的类型
    NSLog(@"simpleClassA添加KVO监听之后");
    NSLog(@"simpleClassA添加KVO监听之后 - %@ %@",
              object_getClass(self.simpleClassA),
              object_getClass(self.simpleClassB));
    NSLog(@"simpleClassA添加KVO监听之后 - %p %p",
          [self.simpleClassA methodForSelector:@selector(setSimpleClassA:)],
          [self.simpleClassA methodForSelector:@selector(setSimpleClassB:)]);
    NSLog(@"simpleClassA添加KVO监听之后 方法列表：");
    [self printMethodNamesOfClass:object_getClass(self.simpleClassA)];
    [self printMethodNamesOfClass:object_getClass(self.simpleClassB)];
    [self.simpleClassA willChangeValueForKey:@"simpleClassA"];
    [self.simpleClassA didChangeValueForKey:@"simpleClassA"];
}

- (void)changeValue{
    self.simpleClassA.simplePropertyA += 1;
}

- (void)dealloc {
    [self.simpleClassA removeObserver:self forKeyPath:@"simplePropertyA"];
}

// 当监听对象的属性值发生改变时，就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"监听到%@的%@属性值改变了 - %@ - %@", object, keyPath, change, context);
}

- (void)printMethodNamesOfClass:(Class)cls{
    unsigned int count;
    // 获得方法数组
    Method *methodList = class_copyMethodList(cls, &count);
    // 存储方法名
    NSMutableString *methodNames = [NSMutableString string];
    // 遍历所有的方法
    for (int i = 0; i < count; i++) {
        // 获得方法
        Method method = methodList[i];
        // 获得方法名
        NSString *methodName = NSStringFromSelector(method_getName(method));
        // 拼接方法名
        [methodNames appendString:methodName];
        [methodNames appendString:@", "];
    }
    // 释放
    free(methodList);
    // 打印方法名
    NSLog(@"%@ %@", cls, methodNames);
}
@end

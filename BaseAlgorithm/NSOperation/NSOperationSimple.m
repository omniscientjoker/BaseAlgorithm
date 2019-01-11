//
//  NSOperationSimple.m
//  BaseAlgorithm
//
//  Created by 姜淼 on 2019/1/11.
//  Copyright © 2019 joker. All rights reserved.
//

#import "NSOperationSimple.h"
#import "JMOperation.h"

@implementation NSOperationSimple
#pragma mark CREATE Operation
-(void)useCustomOperation{
    JMOperation * op = [[JMOperation alloc] init];
    [op start];
}
-(void)useNSInvocationOperation{
    NSInvocationOperation * op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationTest) object:nil];
    [op start];
}
-(void)useNSBlockOperation{
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^  {
        for (NSInteger i = 0 ; i < 2 ; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    }];
    [op start];
    
    //为nsblockoperation 添加新的操作
    [op addExecutionBlock:^{
        for (NSInteger i = 0 ; i < 2 ; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (NSInteger i = 0 ; i < 2 ; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (NSInteger i = 0 ; i < 2 ; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"4---%@", [NSThread currentThread]);
        }
    }];
    [op start];
}

-(void)detach{
    [NSThread detachNewThreadSelector:@selector(useNSInvocationOperation) toTarget:self withObject:nil];
}

-(void)operationTest{
    for (NSInteger i = 0 ; i < 2 ; i ++) {
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@", [NSThread currentThread]);
    }
}


#pragma mark Create Queue
-(void)createMainQueue{
    NSOperationQueue * queue = [NSOperationQueue mainQueue];
    queue.maxConcurrentOperationCount = 4;
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
}

-(void)createCustomQueue{
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation * op_1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationTest) object:nil];
    NSBlockOperation * op_2 = [NSBlockOperation blockOperationWithBlock:^  {
        for (NSInteger i = 0 ; i < 2 ; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        }
    }];
    [op_2 addExecutionBlock:^{
        for (NSInteger i = 0 ; i < 2 ; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@", [NSThread currentThread]);
        }
    }];
    [queue addOperation:op_1];
    [queue addOperation:op_2];
}
@end

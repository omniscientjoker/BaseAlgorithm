//
//  JMOperation.m
//  BaseAlgorithm
//
//  Created by 姜淼 on 2019/1/11.
//  Copyright © 2019 joker. All rights reserved.
//

#import "JMOperation.h"

@implementation JMOperation
- (void)main {
    if (!self.isCancelled) {
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    }
}
@end

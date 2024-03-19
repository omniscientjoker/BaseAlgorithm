//
//  BlockSimpleCCode.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/19.
//  Copyright © 2024 joker. All rights reserved.
//

#import <Foundation/Foundation.h>

-(void)loadBlcok{
    void(^aBlock)(void) = ^{
      NSLog(@"Hello world");
    };
    aBlock();
}

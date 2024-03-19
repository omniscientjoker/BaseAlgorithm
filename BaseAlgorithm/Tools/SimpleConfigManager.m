//
//  SimpleConfigManager.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/19.
//  Copyright © 2024 joker. All rights reserved.
//

#import "SimpleConfigManager.h"

@implementation SimpleConfigManager
+ (instancetype)shareInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.globalBlockMessage = @"test mesage";
    }
    return self;
}
@end

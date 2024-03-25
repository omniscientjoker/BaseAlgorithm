//
//  Target_CTMediatorAVC.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/23.
//  Copyright © 2024 joker. All rights reserved.
//

#import "Target_CTMediatorAVC.h"
#import "CTMediatorAVC.h"

@implementation Target_CTMediatorAVC
- (UIViewController *)Action_nativeHomeViewController:(NSDictionary *)params{
    CTMediatorAVC *vc = [[CTMediatorAVC alloc] init];
    return vc;
}
@end

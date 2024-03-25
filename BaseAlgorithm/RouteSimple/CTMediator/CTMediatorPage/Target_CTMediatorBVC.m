//
//  Target_CTMediatorBVC.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/23.
//  Copyright © 2024 joker. All rights reserved.
//

#import "Target_CTMediatorBVC.h"
#import "CTMediatorBVC.h"

@implementation Target_CTMediatorBVC
- (UIViewController *)Action_nativeHomeViewController:(NSDictionary *)params{
    CTMediatorBVC *vc = [[CTMediatorBVC alloc] init];
    return vc;
}
@end

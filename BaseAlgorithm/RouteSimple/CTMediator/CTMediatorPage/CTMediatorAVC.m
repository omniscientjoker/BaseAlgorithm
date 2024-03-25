//
//  CTMediatorAViewController.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/23.
//  Copyright © 2024 joker. All rights reserved.
//

#import "CTMediatorAVC.h"

@interface CTMediatorAVC ()
@end

@implementation CTMediatorAVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"A";
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 200, 30)];
    lab.center = self.view.center;
    lab.text = @"APage";
    lab.font = [UIFont systemFontOfSize:24.0f];
    [self.view addSubview:lab];
}
@end

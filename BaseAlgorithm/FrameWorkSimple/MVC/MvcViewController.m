//
//  MvcViewController.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/22.
//  Copyright © 2024 joker. All rights reserved.
//


#import "MvcViewController.h"
#import "MvcView.h"
#import "MvcModel.h"

@interface MvcViewController ()
@property(nonatomic,strong)MvcView * mvcView;
@property(nonatomic,strong)MvcModel * mvcModel;
@end

@implementation MvcViewController
/*
 负责连接Model层跟View层，响应页面的事件和作为页面的代理以及界面跳转和生命周期的处理等任务
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.mvcView;
}


#pragma mark ---- get
-(MvcView *)mvcView{
    if (!_mvcView) {
        _mvcView = [[MvcView alloc] init];
    }
    return _mvcView;
}

-(MvcModel *)mvcModel{
    if (!_mvcModel) {
        _mvcModel = [[MvcModel alloc] init];
    }
    return _mvcModel;
}
@end

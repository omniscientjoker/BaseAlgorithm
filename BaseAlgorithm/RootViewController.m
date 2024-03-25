//
//  SortViewController.m
//  BaseAlgorithm
//
//  Created by joker on 2019/1/8.
//  Copyright © 2019 joker. All rights reserved.
//

#import "RootViewController.h"

#import "SortViewController.h"


@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray<NSArray*>* titleArr;
@property(nonatomic,strong)NSArray<NSString*>* titleHeadArr;
@end

@implementation RootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基础";
    self.titleArr = @[@[@"冒泡排序",@"插入排序",@"选择排序",@"归并排序",@"快速排序",@"堆排序",@"桶排序"],@[@"runtime-imp",@"MethodSwizzleA"],@[@"runloop"],@[@"kvoADD",@"kvoChanged"],@[@"blockTest"],@[@"simpleView"],@[@"CTMediatorJumpPageA",@"CTMediatorJumpPageB",@"CTMediatorToolFundication",@"ProtocolRoute"],@[@"AspectsSimpleNslog",@"AspectsSimpleLoad"]];
    self.titleHeadArr = @[@"算法",@"runtime",@"runloop",@"kvo",@"block",@"simpleView",@"CTMediator",@"AspectsSimple"];
    
    UITableView *  tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.sectionFooterHeight = 4.0;
    tableView.sectionHeaderHeight = 4.0;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
}
#pragma mark - tableview dataSoure and  delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleHeadArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc] init];
    cell.textLabel.text = self.titleHeadArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * list = self.titleArr[indexPath.row];
    SortViewController * sort = [[SortViewController alloc] initWithTitleArr:list];
    [self.navigationController pushViewController:sort animated:YES];
}
@end

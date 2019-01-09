//
//  SortViewController.m
//  BaseAlgorithm
//
//  Created by joker on 2019/1/8.
//  Copyright © 2019 joker. All rights reserved.
//

#import "SortViewController.h"
#import "SortAlgorithm/SortAlgorithm.h"
@interface SortViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray * titleArr;
@end

@implementation SortViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"算法基础";
    self.titleArr = [NSArray arrayWithObjects:@"冒泡排序",@"插入排序",@"选择排序",@"归并排序",@"快速排序",@"堆排序",@"桶排序",nil];
    UITableView *  tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
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
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc] init];
    cell.textLabel.text = _titleArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:@10,@11,@9,@13,@8,@5,@14,@4,@16,@6,@17,@1,@21,nil];
    switch (indexPath.row) {
        case 0:
            //冒泡排序
            [SortAlgorithm bubbleSortArr:arr];
            break;
        case 1:
            //插入排序
            [SortAlgorithm insertSortArr:arr];
            break;
        case 2:
            //选择排序
            [SortAlgorithm selectionSortArr:arr];
            break;
        case 3:
            //归并排序
            [SortAlgorithm megerSortArr:arr];
            break;
        case 4:
            //快速排序
            [SortAlgorithm quickSortArr:arr leftIndex:0 rightIndex:arr.count-1];
            break;
        case 5:
            //堆排序
            [SortAlgorithm heapSortArr:arr];
            break;
        case 6:
            //桶排序
            [SortAlgorithm radixSortArr:arr];
            break;
        default:
            break;
    }
    NSLog(@"%@",arr);
}
@end

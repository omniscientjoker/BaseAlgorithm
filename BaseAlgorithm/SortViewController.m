//
//  SortViewController.m
//  BaseAlgorithm
//
//  Created by joker on 2019/1/8.
//  Copyright © 2019 joker. All rights reserved.
//

#import "SortViewController.h"

#import "KVOSimple/KVOSimple.h"
#import "BlockSimple/BlockSimple.h"
#import "SortAlgorithm/SortAlgorithm.h"
#import "RuntimeSimple/RuntimrSimple.h"
#import "RunLoopSimple/RunloopSimple.h"
#import "SimpleView/SimpleViewController.h"

@interface SortViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray<NSArray*>* titleArr;
@property(nonatomic,strong)NSArray<NSString*>* titleHeadArr;
@property(nonatomic,strong)RuntimrSimple * runtimeSimple;
@property(nonatomic,strong)RunloopSimple * runloopSimple;
@property(nonatomic,strong)KVOSimple     * kvoSimple;
@property(nonatomic,strong)BlockSimple   * blockSimple;
@end

@implementation SortViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基础";
    self.titleArr = @[@[@"冒泡排序",@"插入排序",@"选择排序",@"归并排序",@"快速排序",@"堆排序",@"桶排序"],@[@"runtime-imp",@"MethodSwizzleA"],@[@"runloop"],@[@"kvoADD",@"kvoChanged"],@[@"blockTest"],@[@"simpleView"]];
    self.titleHeadArr = @[@"算法",@"runtime",@"runloop",@"kvo",@"block",@"simpleView"];
    
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
    return _titleArr[section].count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArr.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _titleHeadArr[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc] init];
    cell.textLabel.text = _titleArr[indexPath.section][indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
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
    } else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                [self.runtimeSimple test];
                break;
            case 1:
                [self.runtimeSimple changeMethodSwizzle2];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
                [self.runloopSimple testRunloop];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 3){
        switch (indexPath.row) {
            case 0:
                [self.kvoSimple testKVO];
                break;
            case 1:
                [self.kvoSimple changeValue];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 4){
        switch (indexPath.row) {
            case 0:
                [self.blockSimple testBlock];
                break;
            case 1:
                [self.kvoSimple changeValue];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 5){
        switch (indexPath.row) {
            case 0:
                [self jumpSimpleView];
                break;
            default:
                break;
        }
    }
}

#pragma mark ---- fun
- (void)jumpSimpleView{
    [self.navigationController pushViewController:[[SimpleViewController alloc] init] animated:YES];
}



#pragma mark ---- get
-(KVOSimple *)kvoSimple{
    if (!_kvoSimple) {
        _kvoSimple = [[KVOSimple alloc] init];
    }
    return _kvoSimple;
}

-(RunloopSimple *)runloopSimple{
    if (!_runloopSimple) {
        _runloopSimple = [[RunloopSimple alloc] init];
    }
    return _runloopSimple;
}

-(RuntimrSimple *)runtimeSimple{
    if (!_runtimeSimple) {
        _runtimeSimple = [[RuntimrSimple alloc] init];
    }
    return _runtimeSimple;
}

- (BlockSimple *)blockSimple{
    if (!_blockSimple) {
        _blockSimple = [[BlockSimple alloc] init];
    }
    return _blockSimple;
}
@end

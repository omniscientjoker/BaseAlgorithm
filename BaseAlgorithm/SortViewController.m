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

#import "CTMediator+Fundication.h"
#import "CTMediator+PageJump.h"

#import "ProtocolRouteMediator.h"
#import "ProtocolRouteMediatorProtocol.h"

#import "AspectsSimple.h"

@interface SortViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray* titleArr;
@property(nonatomic,strong)RuntimrSimple * runtimeSimple;
@property(nonatomic,strong)RunloopSimple * runloopSimple;
@property(nonatomic,strong)KVOSimple     * kvoSimple;
@property(nonatomic,strong)BlockSimple   * blockSimple;
@end

@implementation SortViewController
-(instancetype)initWithTitleArr:(NSArray*)titleArr{
    self = [super init];
    if (self) {
        self.titleArr = [NSArray arrayWithArray:titleArr];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基础";
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
    UITableViewCell * selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * cellTitle = selectedCell.textLabel.text;
    // 排序算法
    if ([cellTitle isEqualToString:@"冒泡排序"]) {
        NSMutableArray * arr = [NSMutableArray arrayWithObjects:@10,@11,@9,@13,@8,@5,@14,@4,@16,@6,@17,@1,@21,nil];
        [SortAlgorithm bubbleSortArr:arr];
    }
    if ([cellTitle isEqualToString:@"插入排序"]) {
        NSMutableArray * arr = [NSMutableArray arrayWithObjects:@10,@11,@9,@13,@8,@5,@14,@4,@16,@6,@17,@1,@21,nil];
        [SortAlgorithm insertSortArr:arr];
    }
    if ([cellTitle isEqualToString:@"选择排序"]) {
        NSMutableArray * arr = [NSMutableArray arrayWithObjects:@10,@11,@9,@13,@8,@5,@14,@4,@16,@6,@17,@1,@21,nil];
        [SortAlgorithm selectionSortArr:arr];
    }
    if ([cellTitle isEqualToString:@"归并排序"]) {
        NSMutableArray * arr = [NSMutableArray arrayWithObjects:@10,@11,@9,@13,@8,@5,@14,@4,@16,@6,@17,@1,@21,nil];
        [SortAlgorithm megerSortArr:arr];
    }
    if ([cellTitle isEqualToString:@"快速排序"]) {
        NSMutableArray * arr = [NSMutableArray arrayWithObjects:@10,@11,@9,@13,@8,@5,@14,@4,@16,@6,@17,@1,@21,nil];
        [SortAlgorithm quickSortArr:arr leftIndex:0 rightIndex:arr.count-1];
    }
    if ([cellTitle isEqualToString:@"堆排序"]) {
        NSMutableArray * arr = [NSMutableArray arrayWithObjects:@10,@11,@9,@13,@8,@5,@14,@4,@16,@6,@17,@1,@21,nil];
        [SortAlgorithm heapSortArr:arr];
    }
    if ([cellTitle isEqualToString:@"桶排序"]) {
        NSMutableArray * arr = [NSMutableArray arrayWithObjects:@10,@11,@9,@13,@8,@5,@14,@4,@16,@6,@17,@1,@21,nil];
        [SortAlgorithm radixSortArr:arr];
    }
    
    // runtime
    if ([cellTitle isEqualToString:@"runtime-imp"]) {
        [self.runtimeSimple test];
    }
    if ([cellTitle isEqualToString:@"MethodSwizzleA"]) {
        [self.runtimeSimple changeMethodSwizzle2];
    }
    
    // runloop
    if ([cellTitle isEqualToString:@"runloop"]) {
        [self.runloopSimple testRunloop];
    }
    
    // kvo
    if ([cellTitle isEqualToString:@"kvoADD"]) {
        [self.kvoSimple testKVO];
    }
    if ([cellTitle isEqualToString:@"kvoChanged"]) {
        [self.kvoSimple changeValue];
    }
    
    // blockTest
    if ([cellTitle isEqualToString:@"blockTest"]) {
        [self.blockSimple testBlock];
    }
    
    // simpleView
    if ([cellTitle isEqualToString:@"simpleView"]) {
        [self jumpSimpleView];
    }
    
    // CTMediator
    if ([cellTitle isEqualToString:@"CTMediatorJumpPageA"]) {
        UIViewController *vc = [[CTMediator sharedInstance] mediator_viewControllerForPageAWithParams:@{@"id": @"1101"}];
        [self presentViewController:vc animated:YES completion:nil];
    }
    if ([cellTitle isEqualToString:@"CTMediatorJumpPageB"]) {
        UIViewController *vc = [[CTMediator sharedInstance] mediator_viewControllerForPageBWithParams:@{@"id": @"1101"}];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([cellTitle isEqualToString:@"CTMediatorToolFundication"]) {
        [[CTMediator sharedInstance] mediator_createMessageForAWithParams:@{}];
    }
    
    // ProtocolRoute
    if ([cellTitle isEqualToString:@"ProtocolRouteJumpPage"]){
        Class cls = [[ProtocolRouteMediator sharedInstance] classForProtocol:@protocol(ProtocolPageRouteProtocol)];
        UIViewController<ProtocolPageRouteProtocol> *B_VC = [[cls alloc] init];
        [B_VC action_B:@"param1" para2:222 para3:333 para4:444];
        [self presentViewController:B_VC animated:YES completion:nil];
    }
    
    // AspectsSimple
    if ([cellTitle isEqualToString:@"AspectsSimpleNslog"]){
        AspectsSimple * simple = [[AspectsSimple alloc] init];
        [simple prientMessage];
    }
    if ([cellTitle isEqualToString:@"AspectsSimpleLoad"]){
        AspectsSimple * simple = [[AspectsSimple alloc] init];
        [simple exampleLoad];
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

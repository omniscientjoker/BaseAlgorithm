//
//  SecondViewController.m
//  BaseAlgorithm
//
//  Created by joker on 2019/1/8.
//  Copyright © 2019 joker. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray * titleArr;
@end

@implementation SecondViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArr = [NSArray arrayWithObjects:@"冒泡排序",@"插入排序",@"选择排序",@"归并排序",@"快速排序",nil];
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
            [self bubbleSortArr:arr];
            break;
        case 1:
            [self insertSortArr:arr];
            break;
        case 2:
            [self selectionSortArr:arr];
            break;
        case 3:
            [self megerSortArr:arr];
            break;
        case 4:
            [self quickSortArr:arr leftIndex:0 rightIndex:arr.count-1];
            break;
        default:
            break;
    }
    NSLog(@"%@",arr);
    
}

#pragma mark
//冒泡排序
-(void)bubbleSortArr:(NSMutableArray *)arr{
    if (arr.count == 0) return;
    BOOL sortCheck = NO;
    NSInteger tempnum;
    for (NSInteger i = 0 ; i < arr.count-1 ; i ++) {
        if ([arr[i] integerValue] > [arr[i+1] integerValue]) {
            //每次都和后一项比较，如果大于后一项，互相交换
            tempnum = [arr[i] integerValue];
            arr[i] = arr[i+1];
            arr[i+1] = @(tempnum);
            sortCheck = YES;
            //判断是否有顺序改动，如果没有改动，不再循环
        }
    }
    if (sortCheck) {
        [self bubbleSortArr:arr];
    }
}
//插入排序
-(void)insertSortArr:(NSMutableArray *)arr{
    if (arr.count == 0) return;
    for (NSInteger i = 1; i < arr.count; i ++) {
        NSInteger tempnum = [arr[i] integerValue];
        NSInteger j = i - 1;
        while (j >= 0 && [arr[j] integerValue]>tempnum) {
            [arr replaceObjectAtIndex:j+1 withObject:arr[j]];
            //当前下标对应的值大于temp时，当前值往前移动一位
            j--;
            //开始判断前一下标值
        }
        [arr replaceObjectAtIndex:j+1 withObject:@(tempnum)];
        //判断j结束，根据循环结果 插入temp
    }
}
//选择排序
-(void)selectionSortArr:(NSMutableArray *)arr{
    if (arr.count == 0) return;
    for (NSInteger i = 0; i < arr.count; i ++) {
        for (NSInteger j = i+1; j < arr.count; j++) {
            //和数组后续的所有元素挨个对比，交换，获取最小值
            if ([arr[i] integerValue]>[arr[j] integerValue]) {
                NSInteger temp = [arr[i] integerValue];
                arr[i] = arr[j];
                arr[j] = @(temp);
            }
        }
    }
}
//堆排序
- (void)heapSort:(NSMutableArray *)list{
    NSInteger i ,size;
    size = list.count;
    //找出最大的元素放到堆顶
    for (i= list.count/2-1; i>=0; i--) {
        [self createBiggesHeap:list withSize:size beIndex:i];
    }
    
    while(size > 0){
        [list exchangeObjectAtIndex:size-1 withObjectAtIndex:0]; //将根(最大) 与数组最末交换
        size -- ;//树大小减小
        [self createBiggesHeap:list withSize:size beIndex:0];
    }
    NSLog(@"%@",list);
}

- (void)createBiggesHeap:(NSMutableArray *)list withSize:(NSInteger) size beIndex:(NSInteger)element{
    NSInteger lchild = element *2 + 1;
    NSInteger rchild = lchild+1; //左右子树
    
    while (rchild < size) { //子树均在范围内
        if (list[element]>=list[lchild] && list[element]>=list[rchild]) return; //如果比左右子树都大，完成整理
        if (list[lchild] > list[rchild]) { //如果左边最大
            [list exchangeObjectAtIndex:element withObjectAtIndex:lchild]; //把左面的提到上面
            element = lchild; //循环时整理子树
        }else{//否则右面最大
            [list exchangeObjectAtIndex:element withObjectAtIndex:rchild];
            element = rchild;
        }
        
        lchild = element * 2 +1;
        rchild = lchild + 1; //重新计算子树位置
    }
    //只有左子树且子树大于自己
    if (lchild < size && list[lchild] > list[element]) {
        [list exchangeObjectAtIndex:lchild withObjectAtIndex:element];
    }
}
//归并排序
-(void)megerSortArr:(NSMutableArray *)arr{
    //拆分数组，拆分成n个数组，每个里面有一个元素
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
    for (NSNumber *num in arr) {
        NSMutableArray *subArray = [NSMutableArray arrayWithObject:num];
        [tempArray addObject:subArray];
    }
    //开始合并为一个数组
    while (tempArray.count != 1) {
        NSInteger i = 0;
        while (i < tempArray.count - 1) {
            tempArray[i] = [self mergeArrayFirstList:tempArray[i] secondList:tempArray[i + 1]];
            [tempArray removeObjectAtIndex:i + 1];
            i++;
        }
    }
    [arr removeAllObjects];
    [arr addObjectsFromArray:tempArray[0]];
}
- (NSArray *)mergeArrayFirstList:(NSArray *)arrayFirst secondList:(NSArray *)arraySecond{
    NSMutableArray *resultArray = [NSMutableArray array];
    NSInteger firstIndex  = 0;
    NSInteger secondIndex = 0;
    //设定初始下标
    while (firstIndex < arrayFirst.count && secondIndex < arraySecond.count) {
        //循环判断下标在数组范围内
        if ([arrayFirst[firstIndex] integerValue] < [arraySecond[secondIndex] integerValue]) {
            [resultArray addObject:arrayFirst[firstIndex]];
            firstIndex++;
        } else {
            [resultArray addObject:arraySecond[secondIndex]];
            secondIndex++;
        }
        //两个数组每个值进行比对，按照大小顺序加入结果数组
    }
    //特殊情况，当两边数组个数不想同
    while (firstIndex < arrayFirst.count) {
        [resultArray addObject:arrayFirst[firstIndex]];
        firstIndex++;
    }
    while (secondIndex < arraySecond.count) {
        [resultArray addObject:arraySecond[secondIndex]];
        secondIndex++;
    }
    return resultArray.copy;
}

//快速排序
-(void)quickSortArr:(NSMutableArray *)arr leftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex{
    if (leftIndex >= rightIndex ) {
        return;
    }
    NSInteger left = leftIndex;
    NSInteger right = rightIndex;
    //获取当前待排序的数组边界
    NSInteger piovt = [arr[leftIndex] integerValue];
    //获取当前比较值
    while (left < right) {
        while (left < right && [arr[right] integerValue] >= piovt) {
            //从右边界，判断当前元素不小于比较值时，继续对比前一个元素
            right--;
        }
        arr[left] = arr[right];
        //当前元素小于比较值时，交换
        while (left < right && [arr[left] integerValue] <= piovt) {
            //从左边界，判断当前元素不大于比较值时，继续对比后一元素
            left++;
        }
        arr[right] = arr[left];
        //当前元素大于比较值时，交换
    }
    arr[left] = @(piovt);
    [self quickSortArr:arr leftIndex:leftIndex rightIndex:left-1];
    [self quickSortArr:arr leftIndex:left+1 rightIndex:rightIndex];
    //递归，继续分割数组交换
}

//基数排序，桶排序，分配排序
-(void)radixSortArr:(NSMutableArray *)arr{
    /**
     　　“多关键字排序”的思想实现“单关键字排序”。对数字型或字符型的单关键字，可以看作由多个数位或多个字符构成的多关键字，此时可以采用“分配-收集”的方法进行排序，这一过程称作基数排序法，其中每个数字或字符可能的取值个数称为基数。比如，扑克牌的花色基数为4，面值基数为13。在整理扑克牌时，既可以先按花色整理，也可以先按面值整理。按花色整理时，先按红、黑、方、花的顺序分成4摞（分配），再按此顺序再叠放在一起（收集），然后按面值的顺序分成13摞（分配），再按此顺序叠放在一起（收集），如此进行二次分配和收集即可将扑克牌排列有序。
     基数排序:
     是按照低位先排序，然后收集；再按照高位排序，然后再收集；依次类推，直到最高位。有时候有些属性是有优先级顺序的，先按低优先级排序，再按高优先级排序。最后的次序就是高优先级高的在前，高优先级相同的低优先级高的在前。基数排序基于分别排序，分别收集，所以是稳定的。
     */
    //创建空桶
    NSMutableArray *buckt = [NSMutableArray array];
    for (int index = 0; index < 10; index++) {
        NSMutableArray *array = [NSMutableArray array];
        [buckt addObject:array];
    }
    //待排数组的最大数值
    NSNumber *maxNumber = arr[0];
    for (NSNumber *number in arr) {
        if ([maxNumber integerValue] < [number integerValue]) {
            maxNumber = number;
        }
    }
    //最大数值的数字位数
    NSInteger maxLength = numberLength(maxNumber);
    
    //按照从低位到高位的顺序执行排序过程
    for (int digit = 1; digit <= maxLength; digit++) {
        // 入桶
        for (NSNumber *item in arr) {
            //确定item 归属哪个桶 以digit位数为基数
            NSInteger baseNumber = [self fetchBaseNumber:item digit:digit];
            NSMutableArray *mutArray = buckt[baseNumber];
            //将数据放入空桶上
            [mutArray addObject:item];
        }
        NSInteger index = 0;
        //出桶
        for (int i = 0; i < buckt.count; i++) {
            NSMutableArray *array = buckt[i];
            //将桶的数据放回待排数组中
            while (array.count != 0) {
                NSNumber *number = [array objectAtIndex:0];
                array[index] = number;
                [array removeObjectAtIndex:0];
                index++;
            }
        }
    }
}
//数字的位数
NSInteger numberLength(NSNumber *number) {
    NSString *string = [NSString stringWithFormat:@"%ld", (long)[number integerValue]];
    return string.length;
}
-(NSInteger)fetchBaseNumber:(NSNumber *)number digit:(NSInteger)digit {
    //digit为基数位数
    if (digit > 0 && digit <= numberLength(number)) {
        NSMutableArray *numbersArray = [NSMutableArray array];
        //        number的位数确定
        NSString *string = [NSString stringWithFormat:@"%ld", [number integerValue]];
        for (int index = 0; index < numberLength(number); index++) {
            [numbersArray addObject:[string substringWithRange:NSMakeRange(index, 1)]];
        }
        //        number的位数 是几位数的
        NSString *str = numbersArray[numbersArray.count - digit];
        return [str integerValue];
    }
    return 0;
}
@end

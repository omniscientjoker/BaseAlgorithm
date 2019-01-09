//
//  SortAlgorithm.m
//  BaseAlgorithm
//
//  Created by joker on 2019/1/9.
//  Copyright © 2019 joker. All rights reserved.
//

#import "SortAlgorithm.h"

@implementation SortAlgorithm
//冒泡排序
+(void)bubbleSortArr:(NSMutableArray *)arr{
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
+(void)insertSortArr:(NSMutableArray *)arr{
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
+(void)selectionSortArr:(NSMutableArray *)arr{
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

//归并排序
+(void)megerSortArr:(NSMutableArray *)arr{
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
+(NSArray *)mergeArrayFirstList:(NSArray *)arrayFirst secondList:(NSArray *)arraySecond{
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
+(void)quickSortArr:(NSMutableArray *)arr leftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex{
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

//堆排序
+(void)heapSortArr:(NSMutableArray *)arr{
    NSInteger size = arr.count;
    //找出最大的元素放到堆顶，判断会有多少个子堆
    for (NSInteger i= arr.count/2-1; i>=0; i--) {
        //获取二叉树
        [self createSmallestHeap:arr Size:size Index:i];
    }
    while(size > 0){
        [arr exchangeObjectAtIndex:size-1 withObjectAtIndex:0]; //将根(最小) 与数组最末交换
        size -- ;//树大小减小
        //取出最大或最小值后，剩余子树重新调整，获取新的完全二叉树
        [self createSmallestHeap:arr Size:size Index:0];
    }
}
//小顶堆 降序排列
+(void)createSmallestHeap:(NSMutableArray *)arr Size:(NSInteger)size Index:(NSInteger)parentIndex{
    //获取两个子节点数组下标
    NSInteger L_Child = parentIndex*2+1;
    NSInteger R_Child = L_Child+1;
    //子树在数组范围内
    while (R_Child<size) {
        //左右子树都大于父节点，不需更改
        if ([arr[L_Child] integerValue]>[arr[parentIndex] integerValue]&& [arr[R_Child] integerValue]>[arr[parentIndex] integerValue]) return;
        //右子树是最小值，交换右子树和父节点
        if ([arr[L_Child] integerValue]>[arr[R_Child] integerValue]) {
            [arr exchangeObjectAtIndex:parentIndex withObjectAtIndex:R_Child];
            //由于右子树值更改了，重新排序右子树的下属两个节点
            parentIndex = R_Child;
        }else{
            //左子树是最小值，交换左子树和父节点
            [arr exchangeObjectAtIndex:parentIndex withObjectAtIndex:L_Child];
            //由于左子树值更改了，重新排序左子树的下属两个节点
            parentIndex = L_Child;
        }
        L_Child = parentIndex*2+1;
        R_Child = L_Child+1;
    }
    //只有左子树 且在数组范围内 且左子树小于父节点 交换左子树和父节点
    if (L_Child < size && [arr[L_Child] integerValue] < [arr[parentIndex] integerValue]) {
        [arr exchangeObjectAtIndex:parentIndex withObjectAtIndex:L_Child];
    }
}
//大顶堆 升序排列
+(void)createBiggesHeap:(NSMutableArray *)arr Size:(NSInteger)size Index:(NSInteger)parentIndex{
    //获取左右子树的所在数组下标
    NSInteger L_Child = parentIndex*2+1;
    NSInteger R_Child = L_Child+1;
    //判断子树均在数组范围内
    while (R_Child < size) {
        //如果父节点比左右子树都大，完成整理
        if ([arr[parentIndex] integerValue]>=[arr[L_Child] integerValue] && [arr[parentIndex] integerValue]>=[arr[R_Child] integerValue]) return;
        //如果左边最大,交换左子树和父节点
        if ([arr[L_Child] integerValue] > [arr[R_Child] integerValue]) {
            [arr exchangeObjectAtIndex:parentIndex withObjectAtIndex:L_Child];
            //由于左子树值更改了，重新排序左子树的下属两个节点
            parentIndex = L_Child;
        }else{
            //否则右面最大，交换右子树和父节点
            [arr exchangeObjectAtIndex:parentIndex withObjectAtIndex:R_Child];
            parentIndex = R_Child;
        }
        //重新计算子树位置
        L_Child = parentIndex*2+1;
        R_Child = L_Child+1;
    }
    //只有左子树且子树大于自己
    if (L_Child < size && [arr[L_Child] integerValue] > [arr[parentIndex] integerValue]) {
        [arr exchangeObjectAtIndex:parentIndex withObjectAtIndex:L_Child];
    }
}

//基数排序，桶排序，分配排序
+(void)radixSortArr:(NSMutableArray *)arr{
    //创建空桶
    NSMutableArray *buckt = [NSMutableArray array];
    for (int index = 0; index < 10; index++) {
        NSMutableArray *array = [NSMutableArray array];
        [buckt addObject:array];
    }
    //待排数组的最大数值
    NSNumber *maxNumber = @(0);
    for (NSNumber *number in arr) {
        if ([maxNumber integerValue] < [number integerValue]) {
            maxNumber = number;
        }
    }
    //最大数值的数字位数
    NSInteger maxLength = numberLength(maxNumber);
    //按照从低位到高位的顺序执行排序过程
    for (NSInteger digit = 1; digit <= maxLength; digit++) {
        // 入桶
        for (NSNumber *item in arr) {
            //确定item 归属哪个桶 以digit位数为基数
            NSInteger baseNumber = [self fetchBaseNumber:item digit:digit];
            NSMutableArray *mutArray = buckt[baseNumber];
            //将数据放入空桶上
            [mutArray addObject:item];
        }
        [arr removeAllObjects];
        //出桶
        for (int i = 0; i < buckt.count; i++) {
            NSMutableArray *array = buckt[i];
            for (NSInteger j = 0 ; j < array.count ; j++) {
                [arr addObject:array[j]];
            }
            [array removeAllObjects];
        }
    }
}
//获取当前位数上的值
+(NSInteger)fetchBaseNumber:(NSNumber *)number digit:(NSInteger)digit {
    if (digit <= numberLength(number)) {
        NSString *string = [NSString stringWithFormat:@"%ld", [number integerValue]];
        NSString *str = [string substringWithRange:NSMakeRange(string.length-digit, 1)];
        return [str integerValue];
    }else{
        return 0;
    }
}
//获取当前数字的位数
NSInteger numberLength(NSNumber *number) {
    NSString *string = [NSString stringWithFormat:@"%ld", (long)[number integerValue]];
    return string.length;
}
@end

//
//  SortAlgorithm.h
//  BaseAlgorithm
//
//  Created by joker on 2019/1/9.
//  Copyright © 2019 joker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SortAlgorithm : NSObject
//冒泡排序
+(void)bubbleSortArr:(NSMutableArray *)arr;
//插入排序
+(void)insertSortArr:(NSMutableArray *)arr;
//选择排序
+(void)selectionSortArr:(NSMutableArray *)arr;
//归并排序
+(void)megerSortArr:(NSMutableArray *)arr;
//快速排序
+(void)quickSortArr:(NSMutableArray *)arr leftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex;
//堆排序
+(void)heapSortArr:(NSMutableArray *)arr;
//基数排序，桶排序，分配排序
+(void)radixSortArr:(NSMutableArray *)arr;
@end

NS_ASSUME_NONNULL_END

//
//  BlockSimpleCode.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/19.
//  Copyright © 2024 joker. All rights reserved.
//

#import "BlockSimpleCode.h"
@interface BlockSimpleCode()
@property(nonatomic,assign)int       propertyNum;
@property(nonatomic,strong)NSString *propertyStr;
@property(nonatomic,strong)NSObject *object;
@end

@implementation BlockSimpleCode
-(void)loadBlcok{
    static int staticNum = 1;
    static NSString * staticStr = @"1";
    int num = 1;
    NSString * str = @"1";
    NSObject * obj = [[NSObject alloc] init];
    self.propertyNum = 2;
    self.propertyStr = @"2";
    self.object = [[NSObject alloc] init];
    __block int blockNum = 3;
    __block NSString * blockStr = @"3";
    void(^aBlock)(void) = ^{
        NSLog(@"Hello world %@",obj);
        NSLog(@"Hello world %d == %@",num,str);
        NSLog(@"Hello world %d == %@",blockNum,blockStr);
        NSLog(@"Hello world %d == %@",staticNum,staticStr);
        NSLog(@"Hello world %@",self.object);
        NSLog(@"Hello world %d == %@",self.propertyNum,self.propertyStr);
    };
    aBlock();
}
@end

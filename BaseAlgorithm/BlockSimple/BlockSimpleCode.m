//
//  BlockSimpleCode.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/19.
//  Copyright © 2024 joker. All rights reserved.
//

#import "BlockSimpleCode.h"
@interface BlockSimpleCode()
@property(nonatomic,strong)NSString *propertyStr;
@property(nonatomic,strong)NSObject *object;
@property(nonatomic,assign)int       propertyNum;
@end

@implementation BlockSimpleCode
-(void)loadBlcok{
    NSObject * obj = [[NSObject alloc] init];
    static int staticNum = 1;
    static NSString * staticStr = @"1";
    int num = 1;
    NSString * str = @"1";
    self.propertyNum = 1;
    self.propertyStr = @"1";
    self.object = [[NSObject alloc] init];
    __block int blockNum = 1;
    void(^aBlock)(void) = ^{
        NSLog(@"Hello world %@",obj);
        NSLog(@"Hello world %@",self.object);
        NSLog(@"Hello world %d == %@",staticNum,staticStr);
        NSLog(@"Hello world %d == %@ == %d",num,str,blockNum);
        NSLog(@"Hello world %d == %@",self.propertyNum,self.propertyStr);
    };
    aBlock();
}
@end

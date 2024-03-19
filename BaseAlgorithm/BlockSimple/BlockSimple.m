//
//  BlockSimple.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/19.
//  Copyright © 2024 joker. All rights reserved.
//

#import "BlockSimple.h"
#import "SimpleBaseMacros.h"
#import "SimpleMode.h"
#import "SimpleConfigManager.h"

typedef void(^emptyBlock)();// 定义一种无返回值无参数列表的Block类型
typedef int(^MySimpleBlock)(int, int);// 定义一种有返回值有参数列表的Block类型

@interface BlockSimple ()
@property(nonatomic,strong)NSArray<NSArray*>* titleArr;
@property(nonatomic,strong)NSString * blockMessage;
@property(nonatomic, copy)MySimpleBlock mySimpleBlock; // 使用定义的block 作为属性
@end


@implementation BlockSimple
- (void)testBlock{
//    [self globalBlock];
//    [self stackBlock];
//    [self mallocBlock];
    
//    [self blockTest];
    
    [self blockTestAuto];
    [self blockTestStaticAuto];
}

- (void)globalBlock{
    // NSGlobalBlock：存储于全局数据区，由系统管理
    // 没有访问auto变量(也叫自动变量，离开作用域就销毁的变量)
    // 如：没有访问任何变量 或 访问了全局变量 或 访问了静态局部变量
    static int localCount = 0; // 静态局部变量
    void(^blockA)(int) = ^(int inputNum){
        NSLog(@"%d", inputNum); // 没有访问任何变量 外部传递参数
        NSLog(@"%@", [SimpleConfigManager shareInstance].globalBlockMessage); // 访问了全局变量
        NSLog(@"%d", localCount); // 访问了静态局部变量
    };
    blockA(3);
    NSLog(@"blockA globalBlock: %@", [blockA class]);
}

-(void)stackBlock{
    // NSStackBlock 栈
    // 访问了auto变量(即：栈区变量/局部变量), 并且 没有被`强指针`引用
    // arc 模式下 使用 __weak 修饰 不会被 arc 自动从栈copy到堆
    int count = 0; // 局部变量
    SimpleMode * model = [[SimpleMode alloc] init];
    __weak void(^blockB)(void) = ^{
        NSLog(@"%d", count); // 访问了局部变量
        NSLog(@"%@", model.modeMessage); // 访问了局部变量
        NSLog(@"%@", self.blockMessage); // 访问了局部变量
    };
    blockB();
    NSLog(@"blockB stackBlock: %@",[blockB class]);
}

-(void)mallocBlock{
    int count = 0; // 局部变量
    SimpleMode * model = [[SimpleMode alloc] init];
    void(^blockC)(void) = ^{
        NSLog(@"%d", count); // 访问了局部变量
        NSLog(@"%@", model.modeMessage); // 访问了局部变量
        NSLog(@"%@", self.blockMessage); // 访问了局部变量
    };
    blockC();
    NSLog(@"blockC mallocBlock: %@", [blockC class]);
}

- (void)blockTest{
    NSMutableArray * mutArr = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    NSArray * arr = [NSArray arrayWithObjects:@"A",@"B",nil];
    void(^block)(void) = ^{
        [mutArr addObject:@"4"];
        NSLog(@"mutArr : %@",mutArr);
        NSLog(@"arr : %@",arr);
        
    };
    [mutArr addObject:@"3"];
    arr = @[@"A",@"B",@"C"];
    block();
}

- (void)blockTestAuto{
    SimpleMode * model = [[SimpleMode alloc] init];
    model.modeMessage = @"111";
    model.modeMessage2 = @"AAA";
    void(^block)(void) = ^{
        model.modeMessage = @"222";
        NSLog(@"blockTestAuto : %@ == %@",model.modeMessage,model.modeMessage2);
    };
    model.modeMessage2 = @"BBB";
    block();
}

- (void)blockTestStaticAuto{
    static NSInteger num = 3;
    NSInteger(^block)(NSInteger) = ^NSInteger(NSInteger n){
        return n*num;
    };
    num = 1;
    NSLog(@"blockTestStaticAuto %zd",block(2));
}

- (void)blockCopy{
    static int localCount = 0; // 静态局部变量
    int count = 0; // 局部变量
    SimpleMode *obj = [[SimpleMode alloc] init];
    NSMutableArray *arr = [NSMutableArray array];

    __block int blockCount = count;
    __block SimpleMode *blockObj = obj;
    __block typeof(arr) blockArr = arr;

    void (^aBlock)(void) = ^{
      // 直接访问
      NSLog(@"%d", localCount); // 访问静态局部变量：拷贝指针 到block的结构体 中使用
      NSLog(@"%d", count); // 访问局部基本数据类型：拷贝值 到block的结构体 中使用
      NSLog(@"%@", obj.modeMessage); // 访问alloc对象：拷贝指针 到block的结构体 中使用
      NSLog(@"%@", arr); // 访问alloc对象：拷贝指针 到block的结构体 中使用

      // 可直接修改的变量：
      localCount = 2; // 静态局部变量
      obj.modeMessage = @"momo"; // 局部变量的属性 (仅修改，而不是重指向)
      [arr addObject:@1]; // 局部可变collection(仅修改，而不是重指向)
      
      // 需要__block修饰，才能修改的
      // 会创建__Block_byref_XX_0结构体包装该变量，将此对象的指针拷贝到block结构体中使用
      blockCount = 3; // 局部基本数据类型
      blockObj = [[SimpleMode alloc] init]; // 局部alloc变量
      blockArr = [NSMutableArray array];
    };
    aBlock();
}
@end

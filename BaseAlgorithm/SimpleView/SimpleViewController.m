//
//  SimpleViewController.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/20.
//  Copyright © 2024 joker. All rights reserved.
//

#import "SimpleViewController.h"
#import "SimpleView.h"
#import "SimpleBaseMacros.h"

@interface SimpleViewController ()
@property(nonatomic,strong)CALayer *colorLayer;
@end

@implementation SimpleViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_1];
    [self test_2];
    [self test_3];
    [self test_4];
    
    [self testAnimation];
}


#pragma mark ---- testAnimation
- (void)testAnimation{
    _colorLayer = [[CALayer alloc] init];
    _colorLayer.frame = CGRectMake(30, Screen_NAV_Height+30, Screen_Width - 60, 200);
    [self.view.layer addSublayer:_colorLayer];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(30, Screen_NAV_Height+280, Screen_Width - 60, 30);
    [btn setBackgroundColor:[UIColor purpleColor]];
    [btn setTitle:@"changeColor" forState:UIControlStateNormal];
    btn.accessibilityIdentifier = @"";
    [self.view addSubview:btn];
}
- (void)changeColor:(UIButton *)sender{
    CGFloat red = arc4random() % 255 / 255.0;
    CGFloat green = arc4random() % 255 / 255.0;
    CGFloat blue = arc4random() % 255 / 255.0;
    UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    _colorLayer.backgroundColor = randomColor.CGColor;
    
    [UIView animateWithDuration:2 animations:^{
        CGFloat red = arc4random() % 255 / 255.0;
        CGFloat green = arc4random() % 255 / 255.0;
        CGFloat blue = arc4random() % 255 / 255.0;
        UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        _colorLayer.backgroundColor = randomColor.CGColor;
    }];
}


#pragma mark ---- test
- (void)test_1{
    // init初始化不会触发layoutSubviews
    SimpleView *test = [[SimpleView alloc] initWithViewName:@"test_1_noAdd"];
    test.frame = CGRectMake(0, 0, 100, 100);
}

- (void)test_2{
    // init初始化没有设置frame 不会触发layoutSubviews
    SimpleView *test = [[SimpleView alloc] initWithViewName:@"test_2_noFrame"];
    [self.view addSubview:test];
}

- (void)test_3{
    // init初始化且设置frame 触发layoutSubviews
    SimpleView *test = [[SimpleView alloc] initWithViewName:@"test_3_normal"];
    test.frame = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:test];
}

- (void)test_4{
    // init初始化且设置frame 触发layoutSubviews 修改 frame 再次触发 layoutSubviews
    SimpleView *test = [[SimpleView alloc] initWithViewName:@"test_4_changeFrame"];
    test.frame = CGRectMake(0, 300, 100, 100);
    [self.view addSubview:test];
    test.frame = CGRectMake(0, 300, 200, 100);
}






#pragma mark ---- previte
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   // 将事件传递给下一响应者
   [self.nextResponder touchesBegan:touches withEvent:event];
   // 调用父类的touch方法 和上面的方法效果一样 这两句只需要其中一句
   [super touchesBegan:touches withEvent:event];
}

-(void)viewWillLayoutSubviews{
    
}
@end

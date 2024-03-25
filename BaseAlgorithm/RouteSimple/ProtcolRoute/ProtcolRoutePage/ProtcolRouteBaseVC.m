//
//  ProtcolRouteBaseVC.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/25.
//  Copyright © 2024 joker. All rights reserved.
//

#import "ProtcolRouteBaseVC.h"
#import "ProtocolRouteMediator.h"

@interface ProtcolRouteBaseVC ()
@end

@implementation ProtcolRouteBaseVC
+ (void)load{
    [[ProtocolRouteMediator sharedInstance] registerProtocol:@protocol(ProtocolPageRouteProtocol) forClass:[self class]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)action_A:(NSString *)para1 { 
    
}

- (void)action_B:(NSString *)para para2:(NSInteger)para2 para3:(NSInteger)para3 para4:(NSInteger)para4 { 
    NSLog(@"B 协议的方法 - %@ - %ld - %ld",para,(long)para2,para3);
}
@end

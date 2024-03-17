//
//  testManager.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/14.
//  Copyright © 2024 joker. All rights reserved.
//

#import "testManager.h"

@implementation testManager
-(void)justTest:(NSString*)message{
    NSLog(@"testManager instance method %@",message);
}

+(void)justTest:(NSString*)message{
    
    NSLog(@"testManager class method %@",message);
}
@end

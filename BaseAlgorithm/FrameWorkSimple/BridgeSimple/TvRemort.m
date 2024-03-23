//
//  ImageDraw.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/22.
//  Copyright © 2024 joker. All rights reserved.
//

#import "TvRemort.h"

@implementation TvRemort
- (instancetype)initWithTvRemortImp:(TvRemortImp)tvRemortImp {
    self = [super init];
    if (self) {
        _tvRemortImp = tvRemortImp;
    }
    return self;
}

- (void)showDifferentImage {}
@end


@implementation SonyTvImp
-(void)powerOn{
    NSLog(@"打开 SonyTv");
}
-(void)powerOff{
    NSLog(@"关闭 SonyTv");
}
-(void)changeValue{
    NSLog(@"换屏道 SonyTv");
}
@end

@implementation SamgTvImp
-(void)powerOn{
    NSLog(@"打开 SamgTv");
}
-(void)powerOff{
    NSLog(@"关闭 SamgTv");
}
-(void)changeValue{
    NSLog(@"换屏道 SamgTv");
}
@end

@implementation UnivTvImp
-(void)powerOn{
    NSLog(@"打开 UnivTv");
}
-(void)powerOff{
    NSLog(@"关闭 UnivTv");
}
-(void)changeValue{
    NSLog(@"换屏道 UnivTv");
}
@end

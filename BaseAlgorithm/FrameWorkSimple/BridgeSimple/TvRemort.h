//
//  ImageDraw.h
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/22.
//  Copyright © 2024 joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TvRemortImp.h"

NS_ASSUME_NONNULL_BEGIN
@interface TvRemort : NSObject
@property(nonatomic, strong) TvRemortImp tvRemortImp;
- (instancetype)initWithTvRemortImp:(TvRemortImp)TvRemortImp;
- (void)showDifferentImage;
@end


// WindowsImp
@interface SonyTvImp : NSObject<TvRemortImp>
@end


// LinuxImp
@interface SamgTvImp : NSObject<TvRemortImp>
@end


// UnixImp
@interface UnivTvImp : NSObject<TvRemortImp>
@end
NS_ASSUME_NONNULL_END

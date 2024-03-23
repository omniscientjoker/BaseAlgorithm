//
//  ImageImp.h
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/22.
//  Copyright © 2024 joker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TvRemortImp <NSObject>
- (void)powerOn;
- (void)powerOff;
- (void)changeValue;
@end

typedef id<TvRemortImp> TvRemortImp;

NS_ASSUME_NONNULL_END

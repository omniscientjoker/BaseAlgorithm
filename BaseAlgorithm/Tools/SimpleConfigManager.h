//
//  SimpleConfigManager.h
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/19.
//  Copyright © 2024 joker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleConfigManager : NSObject
@property(nonatomic,strong)NSString * globalBlockMessage;

+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END

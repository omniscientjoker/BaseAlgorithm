//
//  MethodClassB.h
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/17.
//  Copyright © 2024 joker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MethodClassBDelegate <NSObject>
- (void)getOriginalBName:(NSString *)name;
@end
@interface MethodClassB : NSObject
@property (weak, nonatomic) id<MethodClassBDelegate> delegate;
-(void)methodB;
@end

NS_ASSUME_NONNULL_END

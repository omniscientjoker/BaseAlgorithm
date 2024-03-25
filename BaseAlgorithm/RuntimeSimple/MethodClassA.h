//
//  MethodClassA.h
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/17.
//  Copyright © 2024 joker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MethodClassADelegate <NSObject>
- (void)getOriginalAName:(NSString *)name;
@end
@interface MethodClassA : NSObject
@property (weak, nonatomic) id<MethodClassADelegate> delegate;
-(void)methodA;
@end
NS_ASSUME_NONNULL_END

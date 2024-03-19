//
//  KVOSimple.h
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/18.
//  Copyright © 2024 joker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SimpleClass : NSObject
@property(assign,nonatomic)int simplePropertyA;
@property(strong,nonatomic)NSString * simplePropertyB;
@end


@interface KVOSimple : NSObject
@property(strong,nonatomic)SimpleClass *simpleClassA;
@property(strong,nonatomic)SimpleClass *simpleClassB;
- (void)testKVO;
- (void)changeValue;
@end

NS_ASSUME_NONNULL_END

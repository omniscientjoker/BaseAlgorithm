//
//  JsonEvalTokenReader.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/15.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JsonEvalToken;

@interface JsonEvalTokenReader : NSObject

@property (nonatomic, copy) NSArray *tokens;
@property (nonatomic, readonly) NSUInteger offset;

- (instancetype)initWithTokens:(NSArray *)tokens;

- (JsonEvalToken *)current;
- (JsonEvalToken *)read;

- (void)unread;
- (void)unread:(NSUInteger)count;

@end

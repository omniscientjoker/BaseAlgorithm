//
//  JsonEvalLexer.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/14.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

@import UIKit;
@class JsonEvalToken;
@class JsonEvalLexer;

@interface JsonEvalLexer : NSObject

@property (nonatomic, copy) NSString *string;
@property (nonatomic, readonly) NSUInteger lineNumber;

+ (JsonEvalLexer *)lexer;
+ (JsonEvalLexer *)lexerWithString:(NSString *)str;
- (instancetype)initWithString:(NSString *)str;

- (JsonEvalToken *)nextToken;

- (NSArray *)allTokens;
- (NSArray *)allTokens:(BOOL)withWhiteSpace;

@end


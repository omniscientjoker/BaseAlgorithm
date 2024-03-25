//
//  JsonEvalTokenReader.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/15.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalTokenReader.h"
#import "JsonEvalToken.h"

@interface JsonEvalTokenReader()
@property (nonatomic) NSUInteger offset;
@property (nonatomic) NSUInteger length;
@end


@implementation JsonEvalTokenReader
- (instancetype)initWithTokens:(NSArray *)tokens{
    if (self = [super init]) {
        self.tokens = tokens;
    }
    return self;
}

- (void)setTokens:(NSArray *)tokens{
    _tokens = tokens;
    self.length = tokens.count;
    self.offset = 0;
}

- (JsonEvalToken *)read{
    JsonEvalToken *result = [JsonEvalToken EOFToken];
    if (_length && _offset < _length) {
        result = [self.tokens objectAtIndex:self.offset];
    }
    self.offset ++;
    return result;
}

- (JsonEvalToken *)current{
    JsonEvalToken *result = [JsonEvalToken EOFToken];
    if (_length && _offset < _length) {
        result = [self.tokens objectAtIndex:self.offset];
    }
    return result;
}

- (void)unread {
    self.offset = (0 == _offset) ? 0 : _offset - 1;
}

- (void)unread:(NSUInteger)count {
    for (NSUInteger i = 0; i < count; i++) {
        [self unread];
    }
}
@end

//
//  JsonEvalReader.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/14.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalReader.h"

@interface JsonEvalReader()
@property (nonatomic) NSUInteger offset;
@property (nonatomic) NSUInteger length;
@end


@implementation JsonEvalReader
- (instancetype)initWithString:(NSString *)sss {
    self = [super init];
    if (self) {
        self.string = sss;
    }
    return self;
}

- (NSString *)debugDescription {
    NSString *buff = [NSString stringWithFormat:@"%@^%@", [_string substringToIndex:_offset], [_string substringFromIndex:_offset]];
    return [NSString stringWithFormat:@"<%@ %p `%@`>", [self class], self, buff];
}

- (void)setString:(NSString *)sss {
    NSAssert(sss, @"sss != nil");
    if (_string != sss) {
        _string = [sss copy];
        self.length = [_string length];
    }
    // reset cursor
    self.offset = 0;
}

- (char)read {
    char result = EOF;
    
    if (_length && _offset < _length) {
        result = [_string characterAtIndex:self.offset];
    }
    self.offset ++;
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

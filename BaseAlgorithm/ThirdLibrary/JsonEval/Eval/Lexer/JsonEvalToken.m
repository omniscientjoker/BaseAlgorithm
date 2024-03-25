//
//  JsonEvalToken.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/14.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalToken.h"
#import "NSString+Subsection.h"

@interface JsonEvalTokenEOF : JsonEvalToken
@property (nonatomic,strong) NSDictionary *subTypeDictionary;
+ (JsonEvalTokenEOF *)instance;
@end


@implementation JsonEvalTokenEOF

static JsonEvalTokenEOF *EOFToken = nil;

+ (JsonEvalTokenEOF *)instance {
    @synchronized(self) {
        if (!EOFToken) {
            EOFToken = [[self alloc] initWithTokenType:JsonEvalTokenTypeEOF stringValue:@"«EOF»" doubleValue:0.0];
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
            [SUB_TYPES enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                mutDic[obj]=@(idx + 1);
            }];
            EOFToken.subTypeDictionary = [mutDic copy];
        }
    }
    return EOFToken;
}
- (NSString *)description {
    return [self stringValue];
}
- (NSString *)debugDescription {
    return [self description];
}
@end


@interface JsonEvalToken ()
@property (nonatomic, readwrite) double doubleValue;
@property (nonatomic, readwrite, copy) NSString *stringValue;
@property (nonatomic, readwrite) JsonEvalTokenType tokenType;
@property (nonatomic, readwrite, copy) id value;
- (BOOL)isEqual:(id)obj ignoringCase:(BOOL)ignoringCase;
@end


@implementation JsonEvalToken
+ (JsonEvalToken *)EOFToken {
    return [JsonEvalTokenEOF instance];
}

+ (instancetype)tokenWithTokenType:(JsonEvalTokenType)ttt stringValue:(NSString *)sss doubleValue:(double)nnn {
    return [[self alloc] initWithTokenType:ttt stringValue:sss doubleValue:nnn]; // 解决汉字编码问题
}

// designated initializer
- (instancetype)initWithTokenType:(JsonEvalTokenType)ttt stringValue:(NSString *)sss doubleValue:(double)nnn {
    //NSParameterAssert(s);
    self = [super init];
    if (self) {
        self.tokenType   = ttt;
        self.stringValue = (ttt == JsonEvalTokenTypeString && [sss includeChinese]) ? [sss stringByRemovingPercentEncoding] : sss; // 解决汉字编码问题
        self.doubleValue = nnn;
        self.offset      = NSNotFound;
        self.lineNumber  = NSNotFound;
        if (ttt == JsonEvalTokenTypeWord || ttt == JsonEvalTokenTypeSymbol) {
            NSNumber *subType = [[JsonEvalTokenEOF instance].subTypeDictionary objectForKey:sss];
            if (subType) {
                self.tokenSubType = [subType integerValue];
            }
        }
    }
    return self;
}

- (NSUInteger)hash {
    return [_stringValue hash];
}

- (BOOL)isEqual:(id)obj {
    return [self isEqual:obj ignoringCase:NO];
}

- (BOOL)isEqualIgnoringCase:(id)obj {
    return [self isEqual:obj ignoringCase:YES];
}

- (BOOL)isEqual:(id)obj ignoringCase:(BOOL)ignoringCase {
    if (![obj isMemberOfClass:[JsonEvalToken class]]) {
        return NO;
    }
    JsonEvalToken *tok = (JsonEvalToken *)obj;
    if (_tokenType != tok->_tokenType) {
        return NO;
    }
    
    if (self.tokenType == JsonEvalTokenTypeNumber) {
        return _doubleValue == tok->_doubleValue;
    }
    if (ignoringCase) {
        return (NSOrderedSame == [_stringValue caseInsensitiveCompare:tok->_stringValue]);
    }
    return [_stringValue isEqualToString:tok->_stringValue];
}

- (BOOL)isEOF {
    return NO;
}

- (id)value {
    if (!_value) {
        id vvv = nil;
        if (self.tokenType == JsonEvalTokenTypeNumber) {
            vvv = [NSNumber numberWithDouble:_doubleValue];
        } else {
            vvv = _stringValue;
        }
        self.value = vvv;
    }
    return _value;
}

- (NSString *)debugDescription {
    NSString *typeString = [@(self.tokenType) stringValue];
    return [NSString stringWithFormat:@"%@ %C%@%C", typeString, (unichar)0x00AB, self.value, (unichar)0x00BB];
}

- (NSString *)description {
    NSArray *types = @[@"EOF",@"Number",@"String",@"Symbol",@"Word",@"WhiteSpace",@"Comment"];
    return [NSString stringWithFormat:@"%@ - %@ - ", types[self.tokenType], self.value];
}
@end

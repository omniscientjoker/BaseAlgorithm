//
//  JsonEvalLexer.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/14.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalLexer.h"
#import "JsonEvalReader.h"
#import "JsonEvalToken.h"

@interface JsonEvalLexer()
@property (nonatomic, strong) JsonEvalReader *reader;
@property (nonatomic, readwrite) NSUInteger lineNumber;

@property (nonatomic, assign) JsonEvalTokenType lastTokenType;
@property (nonatomic, assign) JsonEvalTokenType currentTokenType;
@property (nonatomic, strong) NSMutableString *stringbuf;
@end

@implementation JsonEvalLexer
+ (JsonEvalLexer *)lexer {
    return [self lexerWithString:nil];
}

+ (JsonEvalLexer *)lexerWithString:(NSString *)str{
    return [[self alloc] initWithString:str];
}

- (instancetype)init {
    return [self initWithString:nil];
}

- (instancetype)initWithString:(NSString *)str {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.string = str;
    self.reader = [[JsonEvalReader alloc] init];
    return self;
}

- (void)setReader:(JsonEvalReader *)reader{
    if (_reader != reader) {
        _reader = reader;
        _reader.string = _string;
    }
}

- (void)setString:(NSString *)str {
    if (_string != str) {
        _string = [str copy];
    }
    _reader.string = _string;
}

- (JsonEvalToken *)nextToken {
    NSAssert(_reader, @"");
    char code = [_reader read];
    
    JsonEvalToken *result = nil;
    
    if (EOF == code) {
        result = [JsonEvalToken EOFToken];
    } else {
        result = [self tokenFor:code];
    }
    
    return result;
}

- (NSArray *)allTokens{
    return [self allTokens:YES];
}

- (NSArray *)allTokens:(BOOL)withWhiteSpace{
    NSMutableArray *allTokens = [[NSMutableArray alloc] init];
    JsonEvalToken *token;
    while (token != [JsonEvalToken EOFToken]){
        token = [self nextToken];
        token.lineNumber = self.lineNumber;
        token.offset = self.reader.offset;
        if (token != [JsonEvalToken EOFToken] && (withWhiteSpace || token.tokenType != JsonEvalTokenTypeWhitespace)) {
            [allTokens addObject:token];
        }
    }
    return [allTokens copy];
}


#pragma mark -
- (JsonEvalToken *)tokenFor:(unichar)ccc{
    self.stringbuf = [[NSMutableString alloc] init];
    [self.stringbuf appendFormat:@"%C", (unichar)ccc];
    switch (ccc) {
        case '0': case '1': case '2': case '3': case '4':
        case '5': case '6': case '7': case '8': case '9':
            //读取后面是小数点的情况。
            return [self readNumberToken];
            
        case 'A': case 'B': case 'C': case 'D': case 'E': case 'F': case 'G':
        case 'H': case 'I': case 'J': case 'K': case 'L': case 'M': case 'N':
        case 'O': case 'P': case 'Q': case 'R': case 'S': case 'T': case 'U':
        case 'V': case 'W': case 'X': case 'Y': case 'Z':
        case 'a': case 'b': case 'c': case 'd': case 'e': case 'f': case 'g':
        case 'h': case 'i': case 'j': case 'k': case 'l': case 'm': case 'n':
        case 'o': case 'p': case 'q': case 'r': case 's': case 't': case 'u':
        case 'v': case 'w': case 'x': case 'y': case 'z':
        case '_':
            //考虑为词
            return [self readWordToken];
            
        case '"': case '\'':
            self.stringbuf = [[NSMutableString alloc] init];
            return [self readQuote:ccc];
            
        case'?': case'[': case']':case '(':case ')':case '{':case '}':
        case '.'://肯定不为数字，考虑为. 语法
        case '%': case ',':case '@':case '~':case ';':
            //都是单一symbol
            return [JsonEvalToken tokenWithTokenType:JsonEvalTokenTypeSymbol stringValue:self.stringbuf doubleValue:0];
            
        case '*': case '+': case '-':  case '^'://考虑++，+= 和单独+的情况。
        case '/'://可以是除法，可以是注释。二期考虑注释。
        case '<': case '>': case '!':            //考虑单独出现和等于出现的情况。考虑位移计算的情况。
        case '|': case '&': //考虑为指针转换和逻辑运算符情况。
        case ':': //单独出现和连续出现的情况
        case '=':
            return [self readSymbol:ccc];
        case ' ':
            return [self readWhiteSpace];
        case '\n':
            self.lineNumber += 1;
            return [self readWhiteSpace];
        default:
            break;
    }
    return [JsonEvalToken EOFToken];
}

- (JsonEvalToken *)readNumberToken{
    unichar ccc = [self.reader read];
    if (isdigit(ccc) || (ccc == '.')) { //二期区分
        [_stringbuf appendFormat:@"%C", (unichar)ccc];
        return [self readNumberToken];
    }
    [self.reader unread];
    return [JsonEvalToken tokenWithTokenType:JsonEvalTokenTypeNumber stringValue:self.stringbuf doubleValue:self.stringbuf.doubleValue];
}

- (JsonEvalToken *)readWordToken{
    unichar ccc = [self.reader read];
    if (ccc == '_' || [[NSCharacterSet alphanumericCharacterSet] characterIsMember:ccc]) {
        [_stringbuf appendFormat:@"%C", (unichar)ccc];
        return [self readWordToken];
    }
    [self.reader unread];
    return [JsonEvalToken tokenWithTokenType:JsonEvalTokenTypeWord stringValue:self.stringbuf doubleValue:0];
}

- (JsonEvalToken *)readQuote:(unichar)cc1{
    unichar cc2 = [self.reader read];
    if (cc2 == cc1) {
        return [JsonEvalToken tokenWithTokenType:JsonEvalTokenTypeString stringValue:self.stringbuf doubleValue:0];
    }
    [_stringbuf appendFormat:@"%C", (unichar)cc2];
    return [self readQuote:cc1];
}


- (JsonEvalToken *)readSymbol:(unichar)cc1{
    unichar cc2 = [self.reader read];
    if (cc2 == cc1 || cc2 == '=') {
        [_stringbuf appendFormat:@"%C", (unichar)cc2];
        return [JsonEvalToken tokenWithTokenType:JsonEvalTokenTypeSymbol stringValue:self.stringbuf doubleValue:0];
    }
    [self.reader unread];
    return [JsonEvalToken tokenWithTokenType:JsonEvalTokenTypeSymbol stringValue:self.stringbuf doubleValue:0];
}

- (JsonEvalToken *)readWhiteSpace{
    unichar ccc = [self.reader read];
    if (ccc == ' ' || ccc == '\n') {
        [_stringbuf appendFormat:@"%C", (unichar)ccc];
        if (ccc == '\n') {
            self.lineNumber += 1;
        }
        return [self readWhiteSpace];
    }
    [self.reader unread];
    return [JsonEvalToken tokenWithTokenType:JsonEvalTokenTypeWhitespace stringValue:self.stringbuf doubleValue:0];
}
@end

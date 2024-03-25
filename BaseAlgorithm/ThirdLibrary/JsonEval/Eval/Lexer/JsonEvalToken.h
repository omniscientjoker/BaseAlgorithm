//
//  JsonEvalToken.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/14.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JsonEvalTokenType) {
    JsonEvalTokenTypeEOF = 0,
    JsonEvalTokenTypeNumber = 1,
    JsonEvalTokenTypeString = 2,
    JsonEvalTokenTypeSymbol = 3,
    JsonEvalTokenTypeWord = 4,
    JsonEvalTokenTypeWhitespace = 5,
    JsonEvalTokenTypeComment = 6
};

#define SUB_TYPES @[@"if",@"else",@"do",@"while",@"for",@"in",@"continue",@"break",@"return",@"selector",@"self",@"super",@"nil",@"YES",@"NO",@"__weak",@"__strong",@"__block",@"_Nonnull",@"_Nullable",\
@"(",@")",@"[",@"]",@"{",@"}",@";",@"=",@".",@",",@":",@"+",@"-",@"*",@"/",@"&",@"|",@"!",@">",@">=",@"<",@"<=",@"==",@"!=",@"&&",@"||",@"@",@"^",@"++",@"--",@"+=",@"-="/*,@"%"*/\
]

typedef NS_ENUM(NSUInteger, JsonEvalTokenSubType) {
    JsonEvalTokenSubTypeNone = 0,
    JsonEvalWordSubTypeIf,
    JsonEvalWordSubTypeElse,
    JsonEvalWordSubTypeDo,
    JsonEvalWordSubTypeWhile,
    JsonEvalWordSubTypeFor,
    JsonEvalWordSubTypeIn,
    JsonEvalWordSubTypeContinue,
    JsonEvalWordSubTypeBreak,
    JsonEvalWordSubTypeReturn,
    JsonEvalWordSubTypeSelector,
    JsonEvalWordSubTypeSelf,
    JsonEvalWordSubTypeSuper,
    JsonEvalWordSubTypeNil,
    JsonEvalWordSubTypeYES,
    JsonEvalWordSubTypeNO,
    JsonEvalWordSubTypeWeak,
    JsonEvalWordSubTypeStrong,
    JsonEvalWordSubTypeBlock,
    JsonEvalWordSubTypeNonnull,
    JsonEvalWordSubTypenullable,
    JsonEvalSymbolSubTypeLeftParen,
    JsonEvalSymbolSubTypeRightParen,
    JsonEvalSymbolSubTypeLeftSquare,
    JsonEvalSymbolSubTypeRightSquare,
    JsonEvalSymbolSubTypeLeftBrace,
    JsonEvalSymbolSubTypeRightBrace,
    JsonEvalSymbolSubTypeSemi,
    JsonEvalSymbolSubTypeEqual,
    JsonEvalSymbolSubTypePoint,
    JsonEvalSymbolSubTypeComma,
    JsonEvalSymbolSubTypeColon,
    JsonEvalSymbolSubTypeAdd,
    JsonEvalSymbolSubTypeMinus,
    JsonEvalSymbolSubTypeStar,
    JsonEvalSymbolSubTypeSlash,
    JsonEvalSymbolSubTypeAmp,
    JsonEvalSymbolSubTypePipe,
    JsonEvalSymbolSubTypeExclaim,
    JsonEvalSymbolSubTypeGreaterThan,
    JsonEvalSymbolSubTypeGreaterThanOrEqual,
    JsonEvalSymbolSubTypeLessThan,
    JsonEvalSymbolSubTypeLessThanOrEqual,
    JsonEvalSymbolSubTypeEqualEqual,
    JsonEvalSymbolSubTypeExclaimEqual,
    JsonEvalSymbolSubTypeAmpAmp,
    JsonEvalSymbolSubTypePipepipe,
    JsonEvalSymbolSubTypeAt,
    JsonEvalSymbolSubTypeCaret,
    JsonEvalSymbolSubTypeAddAdd,
    JsonEvalSymbolSubTypeMinusMinus,
    JsonEvalSymbolSubTypeAddEqual,
    JsonEvalSymbolSubTypeMinusEqual,
    JsonEvalWordSubTypeElseIf,
};



@interface JsonEvalToken : NSObject
@property (nonatomic, readonly) JsonEvalTokenType tokenType;
@property (nonatomic, assign) JsonEvalTokenSubType tokenSubType;
@property (nonatomic, readonly) double doubleValue;
@property (nonatomic, readonly, copy) NSString *stringValue;
@property (nonatomic, readonly, copy) id value;
@property (nonatomic, assign) NSUInteger offset;
@property (nonatomic, assign) NSUInteger lineNumber;

+ (JsonEvalToken *)EOFToken;

+ (instancetype)tokenWithTokenType:(JsonEvalTokenType)ttt stringValue:(NSString *)sss doubleValue:(double)nnn;
- (instancetype)initWithTokenType:(JsonEvalTokenType)ttt stringValue:(NSString *)sss doubleValue:(double)nnn;

- (BOOL)isEqualIgnoringCase:(id)obj;

- (NSString *)debugDescription;

@end


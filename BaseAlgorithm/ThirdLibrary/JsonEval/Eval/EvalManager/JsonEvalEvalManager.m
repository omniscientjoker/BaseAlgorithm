//
//  JsonEvalEvalManager.m
//  JsonEval
//
//  Created by jiangmiao on 2019/6/19.
//

#import "JsonEvalEvalManager.h"
#import "JsonEvalLexer.h"
#import "JsonEvalToken.h"
#import "JsonEvalScopeNode.h"
#import "JsonEvalTokenReader.h"
#import "JsonEvalMethodNode+invoke.h"

@implementation JsonEvalEvalManager

+ (id)eval:(NSString *)str {
    return [self eval:str context:[@{} mutableCopy]];
}

+ (id)eval:(NSString *)str context:(NSMutableDictionary *)context {
    for (NSInteger i = 0; i<str.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subStr = [str substringWithRange:range];
        const char *cStr = [subStr UTF8String];
        if (strlen(cStr) == 3) { // 汉字占3位，用此判断是否含有汉字，汉字需要编码，否则后面解析是会乱码
            str = [str stringByReplacingOccurrencesOfString:subStr
                                                 withString:[subStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        }
    }
    NSString *tempStr = [str copy];
    if (![[tempStr substringToIndex:1] isEqualToString:@"{"]) {
        tempStr = [NSString stringWithFormat:@"{%@}",tempStr];
    }
    JsonEvalLexer *lexer       = [JsonEvalLexer lexerWithString:tempStr];
    JsonEvalRootNode *rootNode = [[JsonEvalRootNode alloc] initWithReader:[[JsonEvalTokenReader alloc] initWithTokens:[lexer allTokens:NO]]];
    return [rootNode excuteWithCtx:context];
}

@end

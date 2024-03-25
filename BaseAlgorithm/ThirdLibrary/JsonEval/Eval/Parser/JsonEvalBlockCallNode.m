//
//  JsonEvalBlockCallNode.m
//  JsonEval
//
//  Created by jiangmiao on 2020/11/19.
//

#import "JsonEvalBlockCallNode.h"
#import "JsonEvalToken.h"
#import "JsonEvalMethodNode.h"
#import "JsonEvalMethodNode+invoke.h"
#import "JsonEvalLiteralNode.h"
@interface JsonEvalBlockCallNode()

@end

@implementation JsonEvalBlockCallNode
- (instancetype)initWithReader:(JsonEvalTokenReader *)reader {
    if (self = [super initWithReader:reader]) {
        self.reader = reader;
        [self readBlock];
    }
    return self;
}

- (void)readBlock {
    JsonEvalToken *token = [self.reader current];
    if (token.tokenType == JsonEvalTokenTypeNumber || token.tokenType == JsonEvalTokenTypeString) {
        [self addChild:[[JsonEvalSimpleNode alloc] initWithReader:self.reader]];
        [self readBlock];
    } else if (token.tokenSubType == JsonEvalSymbolSubTypeAt){
        // @() @[] @"" @{} @selector(), can not be used to caculate
        [self addChild:[[JsonEvalLiteralNode alloc] initWithReader:self.reader]];
        [self readBlock];
    } else if ((token.tokenSubType == JsonEvalSymbolSubTypeLeftParen || token.tokenSubType == JsonEvalSymbolSubTypeComma)){
        [self.reader read];
        [self readBlock];
    }
}

- (id)excuteWithCtx:(NSDictionary *)ctx {
    
    NSMutableArray *toBlock = [[NSMutableArray alloc] init];
    for (JsonEvalNode *node in self.children) {
        [toBlock addObject:[node excuteWithCtx:ctx]];
    }
    return toBlock;

}

@end

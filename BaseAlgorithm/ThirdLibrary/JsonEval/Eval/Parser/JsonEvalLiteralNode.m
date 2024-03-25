//
//  JsonEvalLiteralNode.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/17.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalLiteralNode.h"
#import "JsonEvalToken.h"
#import "JsonEvalReturnNode.h"
#import "JsonEvalMethodNode.h"

@interface JsonEvalLiteralNode()

@property (nonatomic,assign) JsonEvalLiteralNodeType type;

@end


@implementation JsonEvalLiteralNode

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader
{
    if (self = [super initWithReader:reader]) {
        [self.reader read];
        [self read];
    }
    return self;
}

- (void)read
{
    JsonEvalToken *token = [self.reader current];
    if (token.tokenType == JsonEvalTokenTypeNumber || token.tokenType == JsonEvalTokenTypeString) {
        self.type = JsonEvalLiteralNodeTypeSimple;
        [self addChild:[[JsonEvalSimpleNode alloc] initWithReader:self.reader]];
    }else if (token.tokenSubType == JsonEvalSymbolSubTypeLeftParen){
        self.type = JsonEvalLiteralNodeTypeExpression;
        [self addChild:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
    }else if (token.tokenSubType == JsonEvalSymbolSubTypeLeftSquare || token.tokenSubType == JsonEvalSymbolSubTypeLeftBrace){
        self.type = JsonEvalLiteralNodeTypeCollection;
        [self addChild:[[JsonEvalLiteralMethodNode alloc] initWithReader:self.reader]];
    }else if (token.tokenSubType == JsonEvalWordSubTypeSelector){
        self.type = JsonEvalLiteralNodeTypeSeletor;
    }
}

@end

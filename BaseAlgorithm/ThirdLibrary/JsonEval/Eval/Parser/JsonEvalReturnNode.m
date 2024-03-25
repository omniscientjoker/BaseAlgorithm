//
//  JsonEvalReturnNode.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/15.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalReturnNode.h"
#import "JsonEvalToken.h"
#import "JsonEvalTokenReader.h"
#import "JsonEvalMethodNode.h"
#import "JsonEvalPropertyNode.h"
#import "JsonEvalLiteralNode.h"

@interface JsonEvalReturnNode()

@property (nonatomic,assign) BOOL canBeWord;
@property (nonatomic,assign) BOOL hasParen;

@end

@implementation JsonEvalReturnNode

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader {
    if (self = [super initWithReader:reader]) {
        self.canBeWord = YES;
        while (!self.isFinished) {
            [self read];
        }
    }
    return self;
}

- (void)read {
    JsonEvalToken *token = [self.reader current];
    // return node read finished
    if (token.tokenSubType == JsonEvalSymbolSubTypeRightSquare || token.tokenSubType == JsonEvalSymbolSubTypeLeftBrace || token.tokenSubType == JsonEvalSymbolSubTypeSemi || token.tokenSubType == JsonEvalSymbolSubTypeColon || token.tokenSubType == JsonEvalSymbolSubTypeComma || token.tokenSubType == JsonEvalSymbolSubTypeRightBrace){
        self.finished = YES;
        return;
    } else if(token.tokenSubType == JsonEvalSymbolSubTypeRightParen) {
        if (self.hasParen) {
            [self.reader read];
        }
        self.finished = YES;
        return;
    } else if (token.tokenType == JsonEvalTokenTypeWord && !self.canBeWord) {
        self.finished = YES;
        return;
    }
    // read each child
    if (token.tokenSubType == JsonEvalSymbolSubTypeLeftParen) {
        self.hasParen = YES;
        // (a+b) + c, wrap (a + b) as a child
        [self.reader read];
        [self addChild:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
        self.canBeWord = NO;
        return;
    } else if (token.tokenSubType == JsonEvalSymbolSubTypeLeftSquare) {
        [self readTokenTypeSymbolSubTypeLeftSquare:token];
    } else if (token.tokenType == JsonEvalTokenTypeWord) {
        token = [self.reader read];
        JsonEvalToken *token2 = [self.reader current];
        [self.reader unread];
        if (token2.tokenSubType == JsonEvalSymbolSubTypePoint){
            // like a.b.c
            [self addChild:[[JsonEvalPropertyNode alloc] initWithReader:self.reader]];
            self.canBeWord = NO;
            return;
        } else if (token2.tokenSubType == JsonEvalSymbolSubTypeLeftParen) {
            // plan to support block type in next version...
            // call Cfuntion
            // [self addChild:[[JsonEvalBlockCallNode alloc] initWithReader:self.reader]];
            self.canBeWord = NO;
            return;
        }
        [self addChild:[[JsonEvalVariableNode alloc] initWithReader:self.reader]];
        self.canBeWord = NO;
        return;
    } else if (token.tokenType == JsonEvalTokenTypeNumber || token.tokenType == JsonEvalTokenTypeString) {
        [self addChild:[[JsonEvalSimpleNode alloc] initWithReader:self.reader]];
        self.canBeWord = NO;
    } else if (token.tokenType == JsonEvalTokenTypeSymbol){
        //支持%取余暂时先注释掉
//        if (token.tokenSubType == JsonEvalSymbolSubTypeRem) {
//            [self addChild:[[JsonEvalSymbolNode alloc] initWithReader:self.reader]];
//            self.type |= JsonEvalReturnNodeTypeRem;
//        } else {
            [self readTokenTypeSymbol:token];
//        }
    }
}

- (void)readTokenTypeSymbolSubTypeLeftSquare:(JsonEvalToken *)token{
    // method child
    if (self.canBeWord) {
        [self addChild:[[JsonEvalMethodNode alloc] initWithReader:self.reader]];
    } else {
        // like array[3]
        [self.reader read];
        JsonEvalReturnNode *node = [[JsonEvalReturnNode alloc] initWithReader:self.reader];
        JsonEvalSubscriptMethodNode *methodNode = [[JsonEvalSubscriptMethodNode alloc] init];
        [methodNode addChild:node];
        methodNode.caller = self.children.lastObject;
        [self replaceLastChild:methodNode];
        if ([self.reader read].tokenSubType != JsonEvalSymbolSubTypeRightSquare) {
            return;
        }
//        NSAssert([self.reader read].tokenSubType == JsonEvalSymbolSubTypeRightSquare,nil);
    }
    self.canBeWord = NO;
}

- (void)readTokenTypeSymbol:(JsonEvalToken *)token{
    if (token.tokenSubType == JsonEvalSymbolSubTypeAmp && self.children.count == 0) {
//        token = [self.reader read];
        [self.reader read];
        JsonEvalVariableNode *node = [[JsonEvalVariableNode alloc] initWithReader:self.reader];
        [self addChild:node];
        self.finished = YES;
        return;
    } else if ((token.tokenSubType <= JsonEvalSymbolSubTypePipe && token.tokenSubType >= JsonEvalSymbolSubTypeAdd)) {
        self.type |= JsonEvalReturnNodeTypeExpression;
    } else if (token.tokenSubType <= JsonEvalSymbolSubTypePipepipe && token.tokenSubType >= JsonEvalSymbolSubTypeExclaim){
        self.type |= JsonEvalReturnNodeTypeNSPredicate; // current not supports (a > 0)&&(b > 0)
    } else if (token.tokenSubType == JsonEvalTokenSubTypeNone){
        self.type |= JsonEvalReturnNodeTypeNSPredicate; // current not supports (a > 0)&&(b > 0)
    } else if (token.tokenSubType == JsonEvalSymbolSubTypeAt){
        // @() @[] @"" @{} @selector(), can not be used to caculate
        [self addChild:[[JsonEvalLiteralNode alloc] initWithReader:self.reader]];
        self.finished = YES;
        return;
    } else if (token.tokenSubType == JsonEvalSymbolSubTypeCaret) {
        // plan to support block type in next version...
        // block ^(){};
        // [self addChild:[[JsonEvalBlockNode alloc] initWithReader:self.reader]];
        return;
    } else{
        abort();
    }
    [self addChild:[[JsonEvalSymbolNode alloc] initWithReader:self.reader]];
    self.canBeWord = YES;
}


- (id)excuteWithCtx:(NSDictionary *)ctx {
    //支持%取余，暂时注释掉
//    if (self.type & JsonEvalReturnNodeTypeRem) {
//        if (self.children.count == 3) {
//            return @([((JsonEvalSimpleNode*)self.children[0]).token.stringValue integerValue]%[((JsonEvalSimpleNode*)self.children[2]).token.stringValue integerValue]);
//        }
//    }
    int  predicateValue =self.type & JsonEvalReturnNodeTypeNSPredicate;
    int  expressionValue = self.type & JsonEvalReturnNodeTypeExpression;
    if (!predicateValue && !expressionValue) {
         return [self.children[0] excuteWithCtx:ctx];
    }
    NSMutableString *mutablestr = [[NSMutableString alloc] init];
    for (JsonEvalNode *node in self.children) {
        id result = [node excuteWithCtx:ctx];
        if ([result isKindOfClass:[NSNumber class]] || [node isKindOfClass:[JsonEvalSymbolNode class]]) {
            [mutablestr appendFormat:@"%@ ",result];
        } else {
            //if not number and not symbol, then must be objects compare.Objects compare with address.
            [mutablestr appendFormat:@"%p ",result]; // a == nil
        }
    }
    if (predicateValue) {
        NSPredicate *pre = [NSPredicate predicateWithFormat:[mutablestr copy]];
        return @([pre evaluateWithObject:nil]);
    }
    NSExpression *exp = [NSExpression expressionWithFormat:[mutablestr copy]];
    return [exp expressionValueWithObject:nil context:nil];
}

@end

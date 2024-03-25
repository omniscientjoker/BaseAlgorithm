//
//  JsonEvalLineNode.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/15.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalLineNode.h"
#import "JsonEvalToken.h"
#import "JsonEvalMethodNode.h"
#import "JsonEvalReturnNode.h"
#import "JsonEvalPropertyNode.h"
#import "JsonEvalFastCalculateNode.h"

@interface JsonEvalLineNode()

@end

@implementation JsonEvalLineNode

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader {
    if (self = [super initWithReader:reader]) {
        while (!self.isFinished) {
            [self read];
        }
    }
    return self;
}

- (void)read {
    JsonEvalToken *token = [self.reader current];
    // end by semi ;
    if (token.tokenSubType == JsonEvalSymbolSubTypeSemi || token == [JsonEvalToken EOFToken] || token.tokenSubType == JsonEvalSymbolSubTypeRightParen) {
        [self.reader read];
        self.finished = YES;
        return;
    }
    if (token.tokenSubType == JsonEvalSymbolSubTypeLeftSquare) {
        self.type = JsonEvalLineNodeTypeCallMethod;
        [self addChild:[[JsonEvalMethodNode alloc] initWithReader:self.reader]];
    } else if (token.tokenSubType == JsonEvalWordSubTypeReturn){
        self.type = JsonEvalLineNodeTypeReturn;
        [self.reader read];
        [self addChild:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
    } else if (token.tokenSubType == JsonEvalSymbolSubTypeAddAdd || token.tokenSubType == JsonEvalSymbolSubTypeMinusMinus) {
        self.type = JsonEvalLineNodeTypeCallMethod;
        [self addChild:[[JsonEvalFastCalculateNode alloc] initWithReader:self.reader]];
    } else {
        [self readMethod];
    }
}

- (void)readMethod{
    JsonEvalToken *token1 = [self.reader read];
    if (token1.tokenSubType <= JsonEvalWordSubTypeBlock && token1.tokenSubType >= JsonEvalWordSubTypeWeak) {
        token1 = [self.reader read];
    }
    JsonEvalToken *token2 = [self.reader read];
    if (token2.tokenSubType == JsonEvalSymbolSubTypePoint){
        // method setter
        self.type = JsonEvalLineNodeTypeCallMethod;
        [self.reader unread:2];
        [self addChild:[[JsonEvalPointSetterNode alloc] initWithReader:self.reader]];
    }
    if (token2.tokenSubType == JsonEvalSymbolSubTypeStar) {
        token2 = [self.reader read];
    }
    // local variable setter
    if (token2.tokenType == JsonEvalTokenTypeWord) {
        self.type = JsonEvalLineNodeTypeAssign;
        self.assigneeName = token2.value;
        self.isStatement = YES;
//        NSAssert([self.reader read].tokenSubType == JsonEvalSymbolSubTypeEqual, nil);
        if ([self.reader read].tokenSubType != JsonEvalSymbolSubTypeEqual) {
            return;
        }
        [self addChild:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
    } else if (token2.tokenSubType == JsonEvalSymbolSubTypeEqual){
        self.type = JsonEvalLineNodeTypeAssign;
        self.assigneeName = token1.value;
        [self addChild:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
    } else if (token2.tokenSubType == JsonEvalSymbolSubTypeLeftSquare){
        // subscript setter like array[1] = ...
        [self readMethodWithSubTypeLeftSquare:token1];
    } else if (token2.tokenSubType == JsonEvalSymbolSubTypeLeftParen){
        [self readMethodWithSubTypeLeftParen];
    } else if (token2.tokenSubType >= JsonEvalSymbolSubTypeAddAdd || token2.tokenSubType <= JsonEvalSymbolSubTypeMinusEqual) {
        [self.reader unread:2];
        self.type = JsonEvalLineNodeTypeCallMethod;
        [self addChild:[[JsonEvalFastCalculateNode alloc] initWithReader:self.reader]];
    }
}


- (void)readMethodWithSubTypeLeftSquare:(JsonEvalToken *)token1{
    self.type = JsonEvalLineNodeTypeCallMethod;
    JsonEvalSubscriptMethodNode *methodNode = [[JsonEvalSubscriptMethodNode alloc] init];
    methodNode.isSetter = YES;
    JsonEvalVariableNode *variableNode = [[JsonEvalVariableNode alloc] init];
    variableNode.token = token1;
    methodNode.caller = variableNode;
    [methodNode addChild:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
    if ([self.reader read].tokenSubType != JsonEvalSymbolSubTypeRightSquare) {
        return;
    }
    if ([self.reader read].tokenSubType != JsonEvalSymbolSubTypeEqual) {
        return;
    }
//    NSAssert([self.reader read].tokenSubType == JsonEvalSymbolSubTypeRightSquare, nil);
//    NSAssert([self.reader read].tokenSubType == JsonEvalSymbolSubTypeEqual, nil);
    [methodNode addChild:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
    [self addChild:methodNode];
}

- (void)readMethodWithSubTypeLeftParen{
    if ([self.reader read].tokenSubType == JsonEvalSymbolSubTypeCaret) {
        self.assigneeName = [self.reader read].value;
        self.isStatement = YES;
        while ([self.reader read].tokenSubType != JsonEvalSymbolSubTypeEqual) {}
        self.type = JsonEvalLineNodeTypeAssign;
        [self addChild:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
    }else{
        [self.reader unread:3];
        self.type = JsonEvalLineNodeTypeCallMethod;
    }
}


- (id)excuteWithCtx:(NSDictionary *)ctx {
    if (self.children.count == 0) {
        return nil;
    }
    if (self.type == JsonEvalLineNodeTypeCallMethod) {
        [self.children[0] excuteWithCtx:ctx];
    } else if (self.type == JsonEvalLineNodeTypeReturn) {
        return [self.children[0] excuteWithCtx:ctx];
    } else if (self.type == JsonEvalLineNodeTypeAssign) {
        //set context.
        JsonEvalNode *node = self.children[0];
        id value = [node excuteWithCtx:ctx];
        [ctx setValue:value forKey:self.assigneeName];
    }
    return nil;
}

@end

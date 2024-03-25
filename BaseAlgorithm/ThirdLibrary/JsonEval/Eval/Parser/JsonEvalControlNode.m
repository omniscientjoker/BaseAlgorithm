//
//  JsonEvalControlNode.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/15.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalControlNode.h"
#import "JsonEvalToken.h"
#import "JsonEvalReturnNode.h"
#import "JsonEvalScopeNode.h"
#import "JsonEvalIterateNode.h"

@interface JsonEvalControlNode()

@property (nonatomic,strong) NSMutableArray *logics;
@property (nonatomic,strong) NSMutableArray *expressions;

@end

@implementation JsonEvalControlNode

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader
{
    if (self = [super initWithReader:reader]) {
        _expressions = [[NSMutableArray alloc] init];
        _logics = [[NSMutableArray alloc] init];
        while (!self.isFinished) {
            [self read];
        }
    }
    return self;
}

- (void)readIf
{
    [self.logics addObject:@(JsonEvalWordSubTypeIf)];
    JsonEvalReturnNode *returnNode = [[JsonEvalReturnNode alloc] initWithReader:self.reader];
    [self.expressions addObject:returnNode];
    [self addChild:[[JsonEvalScopeNode alloc] initWithReader:self.reader]];
}

- (void)readElseIf
{
    [self.logics addObject:@(JsonEvalWordSubTypeElseIf)];
    JsonEvalReturnNode *returnNode = [[JsonEvalReturnNode alloc] initWithReader:self.reader];
    [self.expressions addObject:returnNode];
    [self addChild:[[JsonEvalScopeNode alloc] initWithReader:self.reader]];
}

- (void)readElse
{
    [self.logics addObject:@(JsonEvalWordSubTypeElse)];
    [self.expressions addObject:[NSNull null]];
    [self addChild:[[JsonEvalScopeNode alloc] initWithReader:self.reader]];
}

- (void)readFor
{
    [self.logics addObject:@(JsonEvalWordSubTypeFor)];
    [self.expressions addObject:[JsonEvalIterateNode nodeWithReader:self.reader]];
    [self addChild:[[JsonEvalScopeNode alloc] initWithReader:self.reader]];
}


- (void)read
{
    JsonEvalToken *token = [self.reader read];
    if (token.tokenSubType == JsonEvalWordSubTypeIf) {
        [self readIf];
    }else if (token.tokenSubType == JsonEvalWordSubTypeElse){
        JsonEvalToken *token2 = [self.reader read];
        if (token2.tokenSubType == JsonEvalWordSubTypeIf) {
            [self readElseIf];
        }else{
            [self.reader unread];
            [self readElse];
        }
    }else if (token.tokenSubType == JsonEvalWordSubTypeFor){
        [self readFor];
    }else if (token.tokenSubType == JsonEvalWordSubTypeDo){
        [self.logics addObject:@(JsonEvalWordSubTypeDo)];
        [self addChild:[[JsonEvalScopeNode alloc] initWithReader:self.reader]];
        JsonEvalToken *token2 = [self.reader read];
        NSAssert(token2.tokenSubType == JsonEvalWordSubTypeWhile, nil); //do...while..
        [self.expressions addObject:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
    }else if (token.tokenSubType == JsonEvalWordSubTypeWhile){
        [self.logics addObject:@(JsonEvalWordSubTypeWhile)];
        [self.expressions addObject:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
        JsonEvalToken *token2 = [self.reader current];
        if (token2.tokenSubType == JsonEvalWordSubTypeDo) {
            [self.reader read];
        }
        [self addChild:[[JsonEvalScopeNode alloc] initWithReader:self.reader]];
    }else{
        [self.reader unread];
        self.finished = YES;
    }
}

- (id)excuteWithCtx:(NSDictionary *)ctx {
    // NSAssert(self.children.count == self.logics.count == self.expressions.count,nil);
    BOOL willDoElse = YES;
    for (int i = 0; i < self.logics.count; i++) {
        JsonEvalReturnNode *expression = self.expressions[i];
        JsonEvalNode *node             = self.children[i];
        NSInteger logicType             = [self.logics[i] integerValue];
        if (logicType == JsonEvalWordSubTypeIf) {
            id exp = [expression excuteWithCtx:ctx];
            if ([exp isKindOfClass:[NSNumber class]]) {
                if ([exp boolValue]) {
                    willDoElse = NO;
                    EXCUTE(node,ctx);
                } else {
                    willDoElse = YES;
                }
            } else {
                if (exp != nil) {
                    willDoElse = NO;
                    EXCUTE(node,ctx);
                } else {
                    willDoElse = YES;
                }
            }
        } else if (logicType == JsonEvalWordSubTypeElseIf) {
            id exp = [expression excuteWithCtx:ctx];
            if ([exp isKindOfClass:[NSNumber class]]) {
                if ([exp boolValue]) {
                    willDoElse = NO;
                    EXCUTE(node,ctx);
                }
            } else {
                if (exp != nil) {
                    willDoElse = NO;
                    EXCUTE(node,ctx);
                }
            }
        } else if (logicType == JsonEvalWordSubTypeElse) {
            if (willDoElse) {
                EXCUTE(node,ctx);
                willDoElse = YES;
            } else {
                willDoElse = YES;
            }
        } else if (logicType == JsonEvalWordSubTypeDo) {
            do {
                EXCUTE(node,ctx);
            } while ([[expression excuteWithCtx:ctx] boolValue]);
        } else if (logicType == JsonEvalWordSubTypeWhile || logicType == JsonEvalWordSubTypeFor) {
            while ([[expression excuteWithCtx:ctx] boolValue]) {
                EXCUTE(node,ctx);
            }
        }
    }
    return nil;
}

@end

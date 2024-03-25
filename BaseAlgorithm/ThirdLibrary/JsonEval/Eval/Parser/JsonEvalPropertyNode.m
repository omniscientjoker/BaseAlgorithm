//
//  JsonEvalPropertyNode.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/16.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalPropertyNode.h"
#import "JsonEvalTokenReader.h"
#import "JsonEvalToken.h"
#import "JsonEvalReturnNode.h"
#import "JsonEvalMethodNode.h"
#import "JsonEvalMethodNode+invoke.h"

@interface JsonEvalVariableNode()

@end

@implementation JsonEvalVariableNode

- (id)excuteWithCtx:(NSDictionary *)ctx {
    id variable = [ctx valueForKey:self.token.value];
    if (variable) {
        return variable;
    }
    switch (self.token.tokenSubType) {
        case JsonEvalWordSubTypeNil:
            return nil;
        case JsonEvalWordSubTypeYES:
            return @(YES);
        case JsonEvalWordSubTypeNO:
            return @(NO);
        case JsonEvalWordSubTypeSuper:
            return [ctx valueForKey:@"self"];
        default:
            break;
    }
    Class cls = NSClassFromString(self.token.value);
    if (cls) {
        return cls;
    }
    // abort();
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"VariableNode Name:%@",self.token.value];
}

@end

@interface JsonEvalPropertyNode()

@property (nonatomic,strong) NSMutableArray *propertyNames;
@property (nonatomic,assign) BOOL shouldBeWord; //The next token should be word or point.

@end

@implementation JsonEvalPropertyNode

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader {
    if (self = [super initWithReader:reader]) {
        self.reader = reader;
        self.propertyNames = [[NSMutableArray alloc] init];
        while (!self.isFinished) {
            [self readPropertys];
        }
    }
    return self;
}

- (void)readPropertys {
    JsonEvalToken *token = [self.reader read];
    if (token.tokenSubType == JsonEvalSymbolSubTypeEqual) {
        // end by equal, it must be a setter method
        self.finished = YES;
        [self.reader unread:2];
        [self.propertyNames removeLastObject];
        return;
    } else if (token.tokenType == JsonEvalTokenTypeWord && self.shouldBeWord){
        [self.propertyNames addObject:token.value];
        self.shouldBeWord = NO;
    } else if (token.tokenSubType == JsonEvalSymbolSubTypePoint && !self.shouldBeWord){
        self.shouldBeWord = YES;
    } else{
        [self.reader unread];
        self.finished = YES;
    }
}

- (id)excuteWithCtx:(NSDictionary *)ctx {
    id obj = ctx[self.token.value];
    for (NSString *propertyName in self.propertyNames) {
        obj = [JsonEvalMethodNode invokeWithCaller:obj selectorName:propertyName argments:@[]];
    }
    return obj;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"NodeName:%@.%@",self.token.value,self.propertyNames];
}

@end

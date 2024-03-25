//
//  JsonEvalIterateNode.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/16.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalIterateNode.h"
#import "JsonEvalToken.h"
#import "JsonEvalNode.h"
#import "JsonEvalReturnNode.h"
#import "JsonEvalLineNode.h"

@interface JsonEvalFastEnumIterateNode:JsonEvalIterateNode

@property (nonatomic,strong) NSString *variableName;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSArray *array;

@end

@implementation JsonEvalFastEnumIterateNode

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader
{
    if (self = [super initWithReader:reader]) {
        self.variableName = [reader read].value;
        if ([reader read].tokenSubType != JsonEvalWordSubTypeIn) {
            return nil;
        }
//        NSAssert([reader read].tokenSubType == JsonEvalWordSubTypeIn, nil);
        [self read];
        if ([reader read].tokenSubType != JsonEvalSymbolSubTypeRightParen) {
            return nil;
        }
//        NSAssert([reader read].tokenSubType == JsonEvalSymbolSubTypeRightParen, nil);
    }
    return self;
}

- (void)read
{
    [self addChild:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
}

- (id)excuteWithCtx:(NSDictionary *)ctx
{
    if (!self.array) {
        self.array = [self.children[0] excuteWithCtx:ctx];
    }
    BOOL valid = self.index < self.array.count;
    //task 1: set variable
    if (valid) {
        [ctx setValue:self.array[self.index] forKey:self.variableName];
    }
    self.index ++;
    //task 2: return BOOL
    return @(valid);
}

@end

@interface JsonEvalNormalEnumIterateNode:JsonEvalIterateNode

@property (nonatomic,assign) BOOL hasInit;

@end

@implementation JsonEvalNormalEnumIterateNode

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader
{
    if (self = [super initWithReader:reader]) {
        [self addChild:[[JsonEvalLineNode alloc] initWithReader:reader]];
        [self addChild:[[JsonEvalReturnNode alloc] initWithReader:reader]];
        if ([reader read].tokenSubType != JsonEvalSymbolSubTypeSemi) {
            return nil;
        }
//        NSAssert([reader read].tokenSubType == JsonEvalSymbolSubTypeSemi, nil);
        [self addChild:[[JsonEvalLineNode alloc] initWithReader:reader]];
    }
    return self;
}

- (id)excuteWithCtx:(NSDictionary *)ctx
{
    if (!self.hasInit) {
        [self.children[0] excuteWithCtx:ctx];
        self.hasInit = YES;
        return [self.children[1] excuteWithCtx:ctx];
    }
    [self.children[2] excuteWithCtx:ctx];
    NSNumber *result = [self.children[1] excuteWithCtx:ctx];
    return result;
}

@end


@interface JsonEvalIterateNode()

@end


@implementation JsonEvalIterateNode

+ (instancetype)nodeWithReader:(JsonEvalTokenReader *)reader
{
    if ([reader read].tokenSubType != JsonEvalSymbolSubTypeLeftParen) {
        return nil;
    }
//    NSAssert([reader read].tokenSubType == JsonEvalSymbolSubTypeLeftParen, nil);
    [reader read];
    JsonEvalToken *current = [reader read];
    if (current.tokenSubType == JsonEvalSymbolSubTypeStar){
        current = [reader read];
    }
    current = [reader read];
    if (current.tokenSubType == JsonEvalWordSubTypeIn) {
        [reader unread:2];
        return [[JsonEvalFastEnumIterateNode alloc] initWithReader:reader];
    }
    [reader unread:2];
    return [[JsonEvalNormalEnumIterateNode alloc] initWithReader:reader];
}

@end

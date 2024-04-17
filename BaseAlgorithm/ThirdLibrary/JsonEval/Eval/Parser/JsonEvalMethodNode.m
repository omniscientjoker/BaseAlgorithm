//
//  JsonEvalMethodNode.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/15.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalMethodNode.h"
#import "JsonEvalToken.h"
#import "JsonEvalTokenReader.h"
#import "JsonEvalPropertyNode.h"
#import "JsonEvalMethodNode+invoke.h"
#import "JsonEvalBlockCallNode.h"
#import "JsonEvalReturnNode.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface JsonEvalMethodNode()


@end


@implementation JsonEvalMethodNode


- (instancetype)initWithReader:(JsonEvalTokenReader *)reader
{
    self = [super initWithReader:reader];
    if (!self) {
        return nil;
    }
    _selectorName = [NSMutableString string];
    JsonEvalToken *token = [self.reader current];
    if (token.tokenSubType == JsonEvalSymbolSubTypeLeftSquare) {
        //call method
        [self.reader read];
        JsonEvalToken *current = [self.reader current];
        if (current.tokenSubType == JsonEvalWordSubTypeSuper) {
            self.isSuper = YES;
        }
        self.caller = [[JsonEvalReturnNode alloc] initWithReader:self.reader];
        while (!self.isFinished) {
            [self read];
        }
    }else if (token.tokenType == JsonEvalTokenTypeWord){
        [reader read];
        //method setter
        self.caller = [[JsonEvalReturnNode alloc] initWithReader:self.reader]; // read caller until it was equal symbol, and unread
        JsonEvalToken *token2 = [self.reader read];
        NSAssert(token2.tokenSubType == JsonEvalSymbolSubTypePoint,nil);
        JsonEvalToken *selName = [self.reader read];
        NSString *firstStr = [selName.value substringToIndex:1];
        _selectorName = [[NSString stringWithFormat:@"set%@%@:",firstStr.uppercaseString,[selName.value substringFromIndex:1]] mutableCopy];
        if ([self.reader read].tokenSubType != JsonEvalSymbolSubTypeEqual) {
            return nil;
        }
//        NSAssert([self.reader read].tokenSubType == JsonEvalSymbolSubTypeEqual,nil);
        JsonEvalReturnNode *param = [[JsonEvalReturnNode alloc] initWithReader:self.reader];
        [self addChild:param];
    }else{
        abort();
    }
    return self;
}

- (void)read
{
    JsonEvalToken *token = [self.reader read];
    if (token.tokenSubType == JsonEvalSymbolSubTypeRightSquare) {
        self.finished = YES;
        return;
    }else if (token.tokenSubType == JsonEvalSymbolSubTypeColon){
        JsonEvalReturnNode *param = [[JsonEvalReturnNode alloc] initWithReader:self.reader];
        [self addChild:param];
        [self.selectorName appendString:@":"];
    }else if (token.tokenSubType == JsonEvalSymbolSubTypeComma){
        JsonEvalReturnNode *param = [[JsonEvalReturnNode alloc] initWithReader:self.reader];
        [self addChild:param];
    }else{
        [self.selectorName appendString:token.value];
    }
}


- (id)excuteWithCtx:(NSDictionary *)ctx
{
    id caller = [self.caller excuteWithCtx:ctx];
    if (!self.isSuper) {
        NSMutableArray *argumentsList = [[NSMutableArray alloc] init];
        [self.children enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id result = [obj excuteWithCtx:ctx];
            if (result == nil) {
                result = [JsonEvalMethodNode nilObj];
            }
            [argumentsList addObject:result];
        }];
        // 处理新增方法逻辑
        NSArray *arr    = [ctx valueForKey:@"scout_add_method"];
        BOOL isExist    = NO;
        NSInteger index = 0;
        for (int i = 0; i < arr.count; i++) {
            if ([arr[i][@"name"] isEqualToString:self.selectorName]) {
                isExist = YES;
                index   = i;
                break;
            }
        }
        NSMethodSignature *methodSignature = [caller methodSignatureForSelector:NSSelectorFromString(self.selectorName)];
        if (!methodSignature && isExist) {
            SEL sel = NSSelectorFromString(self.selectorName);
            if (class_isMetaClass(object_getClass(caller))) {
                if ([[caller new] respondsToSelector:sel]) {
                    IMP imp = [[caller new] methodForSelector:sel];
                    void (*func)(id, SEL) = (void *)imp;
                    func([caller new], sel);
                }
            } else {
                if ([caller respondsToSelector:sel]) {
                    IMP imp = [caller methodForSelector:sel];
                    void (*func)(id, SEL) = (void *)imp;
                    func(caller, sel);
                }
                
            }
            return nil;
        }
        CFRunLoopGetMain();
        return [[self class] invokeWithCaller:caller selectorName:self.selectorName.copy argments:[argumentsList copy]];
    } else {
        SEL selector = NSSelectorFromString(self.selectorName);
        id obj = [ctx valueForKey:@"self"];
        Class cls = [obj class];
        NSString *superClassName = nil;
        NSString *superSelectorName = [NSString stringWithFormat:@"SUPER_%@", self.selectorName];
        SEL superSelector = NSSelectorFromString(superSelectorName);
        Class superCls = [cls superclass];
        Method superMethod = class_getInstanceMethod(superCls, selector); //only instance method?
        IMP superIMP = method_getImplementation(superMethod);
        class_addMethod(cls, superSelector, superIMP, method_getTypeEncoding(superMethod));
        selector = superSelector;
        superClassName = NSStringFromClass(superCls);
        NSMutableArray *argumentsList = [[NSMutableArray alloc] init];
        [self.children enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id result = [obj excuteWithCtx:ctx];
            if (result == nil) {
                result = [JsonEvalMethodNode nilObj];
            }
            [argumentsList addObject:result];
        }];
        return [[self class] invokeWithCaller:caller selectorName:superSelectorName argments:[argumentsList copy]];
    }
}
@end



@implementation JsonEvalSubscriptMethodNode


- (id)excuteWithCtx:(NSDictionary *)ctx
{
    id caller = [self.caller excuteWithCtx:ctx];
    BOOL isArray = [caller isKindOfClass:[NSArray class]];
    NSString *selectorName = isArray ? (self.isSetter ? @"setObject:atIndex:" : @"objectAtIndex:") : (self.isSetter ? @"setObject:forKey:" : @"objectForKey:");
    NSArray *argumentsList;
    if (self.children.count == 1) {
        argumentsList = @[[self.children[0] excuteWithCtx:ctx]];
    }else{
        argumentsList = @[[self.children[1] excuteWithCtx:ctx],[self.children[0] excuteWithCtx:ctx]];
    }
    return [[self class] invokeWithCaller:caller selectorName:selectorName argments:argumentsList];
}

@end


@interface JsonEvalLiteralMethodNode()

@property (nonatomic,assign) BOOL isArray;

@end


@implementation JsonEvalLiteralMethodNode

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader
{
    if (self = [super initWithReader:reader]) {
        JsonEvalToken *currentToken = [self.reader read];
        self.isArray = (currentToken.tokenSubType == JsonEvalSymbolSubTypeLeftSquare);
        [self addChild:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
        while (!self.isFinished) {
            [self read];
        }
    }
    return self;
}

- (void)read
{
    JsonEvalToken *currentToken = [self.reader read];
    if (currentToken.tokenSubType == JsonEvalSymbolSubTypeRightSquare || currentToken.tokenSubType == JsonEvalSymbolSubTypeRightBrace) {
        self.finished = YES;        return;
    }else if (currentToken.tokenSubType == JsonEvalSymbolSubTypeComma){
        [self addChild:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
    }else if (currentToken.tokenSubType == JsonEvalSymbolSubTypeColon){
        [self addChild:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
    }
}

- (id)excuteWithCtx:(NSDictionary *)ctx
{
    if (self.isArray) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (JsonEvalNode *node in self.children) {
            id result = [node excuteWithCtx:ctx];
            if (result == nil) {
                result = [JsonEvalMethodNode nilObj];
            }
            [array addObject:result];
        }
        return [array copy];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSInteger count = self.children.count / 2;
    for (int i = 0; i < count; i++) {
        id key = [self.children[i * 2] excuteWithCtx:ctx];
        id value = [self.children[i * 2 + 1] excuteWithCtx:ctx];
        [dic setValue:value forKey:key];
    }
    return [dic copy];
}


@end


@interface JsonEvalPointSetterNode()

@property (nonatomic,strong) JsonEvalReturnNode *returnNode;


@property(nonatomic, strong) JsonEvalBlockCallNode *blockNode;

@end


@implementation JsonEvalPointSetterNode

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader
{
    if (self = [super initWithReader:reader]) {
        [self addChild:[[JsonEvalVariableNode alloc] initWithReader:self.reader]];
        [self read];
    }
    return self;
}

- (void)read
{
    JsonEvalToken *current = [self.reader current];
    if (current.tokenType == JsonEvalTokenTypeWord) {
        [self addChild:[[JsonEvalSimpleNode alloc] initWithReader:self.reader]];
        [self read];
    }else if (current.tokenSubType == JsonEvalSymbolSubTypeEqual){
        [self.reader read];
        self.returnNode = [[JsonEvalReturnNode alloc] initWithReader:self.reader];
    }else if (current.tokenSubType == JsonEvalSymbolSubTypeLeftParen){
       self.blockNode = [[JsonEvalBlockCallNode alloc] initWithReader:self.reader];
        [self addChild:self.blockNode];
    }else if (current.tokenSubType == JsonEvalSymbolSubTypePoint){
        [self.reader read];
        [self read];
    }
}

- (id)excuteWithCtx:(NSDictionary *)ctx
{
    NSArray *children = self.children;
    id returnvalue = [self.returnNode excuteWithCtx:ctx];
    id setterResult = [self invokeSetterWithIndex:1 returnObj:returnvalue withCtx:ctx];
    if (setterResult==nil) {
        return nil;
    }
    if (children.count == 2) {
        //like origin.x = 1;
        JsonEvalVariableNode *variableNode = children[0];
        [ctx setValue:setterResult forKey:variableNode.token.value];
    }else{
        //like frame.origin.x = 1; or view.frame.origin = CGPoint(1,1);
        id setterResult2 = [self invokeSetterWithIndex:2 returnObj:setterResult withCtx:ctx];
        if (setterResult2 != nil) {
            if (children.count == 3) {
                //like origin.x = 1;
                JsonEvalVariableNode *variableNode = children[0];
                [ctx setValue:setterResult2 forKey:variableNode.token.value];
            }else{
                //like view.frame.origin.x = 1
                id setterResult3 = [self invokeSetterWithIndex:3 returnObj:setterResult2 withCtx:ctx];
                if (setterResult3 != nil) {
                    abort();
                }
            }
            // if gretter than 3 ? TODO//
        }
    }
    return nil;
}


- (id)invokeSetterWithIndex:(NSInteger)index returnObj:(id)returnObj withCtx:(NSDictionary *)ctx
{
    NSArray *children = self.children;
    id obj = [children[0] excuteWithCtx:ctx];
    if (children.count >= 3 && [children.lastObject isKindOfClass:[JsonEvalBlockCallNode class]]) {
        id blockValue = [self.blockNode excuteWithCtx:ctx];
        JsonEvalToken *selName = [children[1] token];
        NSString *selectorName = [[NSString stringWithFormat:@"%@",selName.value] mutableCopy];
        return [JsonEvalMethodNode invokeBlockWithCaller:obj blockName:selectorName argments:blockValue];
    }
    for (int i = 1; i < children.count - index; i++) {
        JsonEvalSimpleNode *node = children[i];
        obj = [JsonEvalMethodNode invokeWithCaller:obj selectorName:node.token.value argments:@[]];
    }
    JsonEvalToken *selName = [children[children.count - index] token];
    NSString *firstStr = [selName.value substringToIndex:1];
    NSString *selectorName = [[NSString stringWithFormat:@"set%@%@:",firstStr.uppercaseString,[selName.value substringFromIndex:1]] mutableCopy];
    return [JsonEvalMethodNode invokeWithCaller:obj selectorName:selectorName argments:@[returnObj]];
}

@end

//
//  JsonEvalNode.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/15.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalNode.h"
#import "JsonEvalToken.h"

@interface JsonEvalNode()

@property (nonatomic,strong) NSMutableArray *allChilds;

@end

@implementation JsonEvalNode

- (instancetype)init
{
    if (self = [super init]) {
        _allChilds = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader
{
    if (self = [super init]) {
        _allChilds = [[NSMutableArray alloc] init];
        _reader = reader;
    }
    return self;
}

- (void)read
{
    
}

- (void)addChild:(JsonEvalNode *)node
{
    [self.allChilds addObject:node];
}

- (void)replaceLastChild:(JsonEvalNode *)node
{
    self.allChilds[self.allChilds.count - 1] = node;
}

- (NSArray *)children
{
    return [self.allChilds copy];
}

- (id)excuteWithCtx:(NSDictionary *)ctx
{
    for (JsonEvalNode *node in self.children) {
        EXCUTE(node,ctx);
    }
    return nil;
}

- (NSString *)description
{
    if (![self.children count]) {
        return NSStringFromClass(self.class);
    }
    
    NSMutableString *mutableStr = [NSMutableString string];
    
    [mutableStr appendFormat:@"(%@ ", NSStringFromClass(self.class)];
    
    NSInteger index = 0;
    for (JsonEvalNode *child in self.children) {
        NSString *fmt = 0 == index++ ? @"%@" : @" %@";
        [mutableStr appendFormat:fmt, [child description]];
    }
    
    [mutableStr appendString:@")"];
    return [mutableStr copy];
}

@end


@implementation JsonEvalSimpleNode

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader
{
    if (self = [super init]) {
        self.token = [reader read];
    }
    return self;
}

- (id)excuteWithCtx:(NSDictionary *)ctx
{
    return self.token.value;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Node:%@",self.token.value];
}

@end


@implementation JsonEvalSymbolNode

@end

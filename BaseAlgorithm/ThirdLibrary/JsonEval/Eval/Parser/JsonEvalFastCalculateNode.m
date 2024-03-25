//
//  JsonEvalFastCalculateNode.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/26.
//

#import "JsonEvalFastCalculateNode.h"
#import "JsonEvalReturnNode.h"

@implementation JsonEvalFastCalculateNode

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader
{
    if (self = [super initWithReader:reader]) {
        [self read];
    }
    return self;
}


- (void)read
{
    JsonEvalToken *current = [self.reader read];
    if (current.tokenType == JsonEvalTokenTypeWord) {
        self.assigneeName = current.value;
        JsonEvalToken *current = [self.reader read];
        self.subType = current.tokenSubType;
        if (self.subType != JsonEvalSymbolSubTypeAddAdd && self.subType != JsonEvalSymbolSubTypeMinusMinus) {
            [self addChild:[[JsonEvalReturnNode alloc] initWithReader:self.reader]];
        }
    }else if(current.tokenType == JsonEvalTokenTypeSymbol){
        self.subType = current.tokenSubType;
        JsonEvalToken *current = [self.reader read];
        self.assigneeName = current.value;
    }
}

- (id)excuteWithCtx:(NSDictionary *)ctx
{
    NSNumber *base = [ctx valueForKey:self.assigneeName];
    switch (self.subType) {
        case JsonEvalSymbolSubTypeAddAdd:
            [ctx setValue:@(base.integerValue + 1) forKey:self.assigneeName];
            break;
        case JsonEvalSymbolSubTypeMinusMinus:
            [ctx setValue:@(base.integerValue - 1) forKey:self.assigneeName];
            break;
        case JsonEvalSymbolSubTypeAddEqual:
            [ctx setValue:@(base.doubleValue + [[self.children[0] excuteWithCtx:ctx] doubleValue]) forKey:self.assigneeName];
            break;
        case JsonEvalSymbolSubTypeMinusEqual:
            [ctx setValue:@(base.doubleValue - [[self.children[0] excuteWithCtx:ctx] doubleValue]) forKey:self.assigneeName];
            break;
        default:
            break;
    }
    return nil;
}

@end

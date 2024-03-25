//
//  JsonEvalScopeNode.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/15.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalScopeNode.h"
#import "JsonEvalToken.h"
#import "JsonEvalControlNode.h"
#import "JsonEvalLineNode.h"


@implementation JsonEvalScopeNode

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader
{
    if (self = [super initWithReader:reader]) {
        JsonEvalToken *token = [self.reader read];
        NSAssert(token.tokenSubType == JsonEvalSymbolSubTypeLeftBrace, nil);
        while (!self.isFinished) {
            [self read];
        }
    }
    return self;
}

- (void)read
{
    JsonEvalToken *token = [self.reader current];
    if (token.tokenSubType == JsonEvalSymbolSubTypeRightBrace || token == [JsonEvalToken EOFToken]) {
        self.finished = YES;
        [self.reader read];
        return;
    }else if (token.tokenSubType >= JsonEvalWordSubTypeIf && token.tokenSubType <= JsonEvalWordSubTypeFor) {
        JsonEvalControlNode *controlNode = [[JsonEvalControlNode alloc] initWithReader:self.reader];
        [self addChild:controlNode];
    }else{
        JsonEvalLineNode *lineNode = [[JsonEvalLineNode alloc] initWithReader:self.reader];
        [self addChild:lineNode];
    }
}

- (id)excuteWithCtx:(NSDictionary *)ctx
{
//    NSMutableArray *toRemove = [[NSMutableArray alloc] init];
    for (JsonEvalNode *node in self.children) {
//        if ([node isKindOfClass:[JsonEvalLineNode class]]) {
//            JsonEvalLineNode *lineNode = (JsonEvalLineNode *)node;
//            if (lineNode.isStatement == YES) {
//                [toRemove addObject:lineNode.assigneeName];
//            }
//        }
        EXCUTE(node,ctx);
        
//        id result = [node excuteWithCtx:ctx];
//        if (result) {
//            return result;
//        }
        
        
    }
    // block delays the object releasing
//    for (NSString *assigneeName in toRemove) {
//        [ctx setValue:nil forKey:assigneeName];
//    }
    return nil;
}


@end


@implementation JsonEvalRootNode

- (id)excuteWithCtx:(NSDictionary *)ctx
{
    return [super excuteWithCtx:ctx];
}

@end

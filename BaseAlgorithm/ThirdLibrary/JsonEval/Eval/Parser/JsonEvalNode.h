//
//  JsonEvalNode.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/15.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonEvalTokenReader.h"

#define EXCUTE(node,ctx)         id result = [node excuteWithCtx:ctx];\
if (result) {\
    [ctx setValue:result forKey:@"retval"]; \
    return result;\
}

@interface JsonEvalNode : NSObject

@property (nonatomic,strong) JsonEvalTokenReader *reader;
@property (nonatomic,assign,getter=isFinished) BOOL finished;

- (instancetype)initWithReader:(JsonEvalTokenReader *)reader;

- (void)read;

- (void)addChild:(JsonEvalNode *)node;
- (void)replaceLastChild:(JsonEvalNode *)node;

- (NSArray *)children;

- (id)excuteWithCtx:(NSDictionary *)ctx;

@end

@interface JsonEvalSimpleNode : JsonEvalNode

@property (nonatomic,strong) JsonEvalToken *token;

@end

@interface JsonEvalSymbolNode : JsonEvalSimpleNode

@end

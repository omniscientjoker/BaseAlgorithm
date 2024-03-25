//
//  JsonEvalMethodNode.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/15.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalNode.h"

@class JsonEvalReturnNode;

@interface JsonEvalMethodNode : JsonEvalNode

@property (nonatomic,strong) JsonEvalNode *caller;
@property (nonatomic,strong) NSMutableString *selectorName;
@property (nonatomic,assign) BOOL isSuper;

@end

@interface JsonEvalSubscriptMethodNode : JsonEvalMethodNode

@property (nonatomic,assign) BOOL isSetter;

@end

@interface JsonEvalLiteralMethodNode : JsonEvalNode


@end

@interface JsonEvalPointSetterNode : JsonEvalNode

@end

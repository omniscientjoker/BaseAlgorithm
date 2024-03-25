//
//  JsonEvalReturnNode.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/15.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalNode.h"

typedef NS_OPTIONS(NSUInteger, JsonEvalReturnNodeType) {
    JsonEvalReturnNodeTypeSimple = 1 << 0,
    JsonEvalReturnNodeTypeExpression = 1 << 1,
    JsonEvalReturnNodeTypeNSPredicate = 1 << 2,
    JsonEvalReturnNodeTypeObjectNotNil = 1 << 3,
//    JsonEvalReturnNodeTypeRem = 1 << 4,
};

@interface JsonEvalReturnNode : JsonEvalNode

@property (nonatomic,assign) JsonEvalReturnNodeType type;

@end

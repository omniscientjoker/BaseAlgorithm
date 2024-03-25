//
//  JsonEvalLiteralNode.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/17.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonEvalNode.h"

typedef NS_ENUM(NSUInteger, JsonEvalLiteralNodeType) {
    JsonEvalLiteralNodeTypeSimple = 0,
    JsonEvalLiteralNodeTypeExpression,
    JsonEvalLiteralNodeTypeCollection,
    JsonEvalLiteralNodeTypeSeletor // TODO
};


@interface JsonEvalLiteralNode : JsonEvalNode

@end

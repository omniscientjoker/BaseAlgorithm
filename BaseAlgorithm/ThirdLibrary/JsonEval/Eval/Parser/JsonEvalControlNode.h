//
//  JsonEvalControlNode.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/15.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalNode.h"

typedef NS_ENUM(NSUInteger, JsonEvalControlNodeType) {
    JsonEvalControlNodeTypeIfElse = 0,
    JsonEvalControlNodeTypeDoWhile = 1,
    JsonEvalControlNodeTypeForIn = 2,
    JsonEvalControlNodeTypeSwitchCase = 3,
};

@interface JsonEvalControlNode : JsonEvalNode



@end

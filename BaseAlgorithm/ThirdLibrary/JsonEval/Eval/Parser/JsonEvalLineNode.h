//
//  JsonEvalLineNode.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/15.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonEvalNode.h"

typedef NS_ENUM(NSUInteger, JsonEvalLineNodeType) {
    JsonEvalLineNodeTypeCallMethod = 0,
    JsonEvalLineNodeTypeAssign,
    JsonEvalLineNodeTypeAssignPoint,
    JsonEvalLineNodeTypeReturn,
    JsonEvalLineNodeTypeAddAdd,
    JsonEvalLineNodeTypeMinusMinus
};

@interface JsonEvalLineNode : JsonEvalNode

@property (nonatomic,assign) JsonEvalLineNodeType type;
@property (nonatomic,strong) NSString *assigneeName;
@property (nonatomic,assign) BOOL isStatement;

@end




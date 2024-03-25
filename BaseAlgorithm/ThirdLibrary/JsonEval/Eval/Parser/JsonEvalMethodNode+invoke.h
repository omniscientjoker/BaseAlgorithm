//
//  JsonEvalMethodNode+invoke.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/18.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonEvalMethodNode.h"

@interface JsonEvalMethodNode(invoke)

+ (id)nilObj;
+ (id)invokeBlockWithCaller:(id)caller blockName:(NSString *)blockName argments:(NSArray *)arguments;
+ (id)invokeWithCaller:(id)caller selectorName:(NSString *)selectorName argments:(NSArray *)arguments;

@end

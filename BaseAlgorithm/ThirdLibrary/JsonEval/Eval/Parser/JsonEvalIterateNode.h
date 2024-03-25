//
//  JsonEvalIterateNode.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/16.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import "JsonEvalNode.h"


@interface JsonEvalIterateNode : JsonEvalNode

+ (instancetype)nodeWithReader:(JsonEvalTokenReader *)reader;

@end

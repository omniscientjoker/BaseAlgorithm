//
//  JsonEvalFastCalculateNode.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/26.
//

#import "JsonEvalToken.h"
#import "JsonEvalNode.h"

@interface JsonEvalFastCalculateNode : JsonEvalNode

@property (nonatomic,assign) JsonEvalTokenSubType subType;
@property (nonatomic,strong) NSString *assigneeName;

@end



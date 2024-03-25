//
//  JsonEvalEvalManager.h
//  JsonEval
//
//  Created by jiangmiao on 2019/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JsonEvalEvalManager : NSObject

+ (id)eval:(NSString *)str;
+ (id)eval:(NSString *)str context:(NSMutableDictionary *)context;

@end

NS_ASSUME_NONNULL_END

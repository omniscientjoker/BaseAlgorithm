//
//  HookTool.h
//  JsonEval
//
//  Created by jiangmiao on 2020/7/21.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface HookTool : NSObject
//获取获取所有block 参数
+ (NSArray *)blcokParameter:(Class )class selector:(SEL)sel;
@end

NS_ASSUME_NONNULL_END

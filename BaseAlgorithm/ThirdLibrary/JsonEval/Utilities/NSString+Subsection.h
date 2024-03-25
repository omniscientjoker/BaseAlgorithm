//
//  NSString+Subsection.h
//  JsonEval
//
//  Created by jiangmiao on 2019/7/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Subsection)

// 按照限制字节长度及关键字将字符串分割
- (NSArray *)subsection:(NSInteger)length withKey:(NSString *)key;

// 判断是否包含汉字
- (BOOL)isChinese;      //判断是否是纯汉字
- (BOOL)includeChinese; //判断是否含有汉字

@end

NS_ASSUME_NONNULL_END

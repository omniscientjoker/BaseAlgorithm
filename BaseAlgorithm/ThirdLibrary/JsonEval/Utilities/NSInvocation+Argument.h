//
//  NSString+Subsection.h
//  JsonEval
//
//  Created by jiangmiao on 2019/7/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSInvocation (Argument)
@property (nonatomic,   copy, readwrite) NSArray *arguments;
@property (nonatomic, strong, readwrite) id       returnValue_obj;
@property (nonatomic,   copy, readonly ) NSArray *block_arguments;
@end

NS_ASSUME_NONNULL_END

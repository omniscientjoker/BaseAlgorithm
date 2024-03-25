//
//  JsonEvalReader.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/14.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonEvalReader : NSObject

@property (nonatomic, copy) NSString *string;
@property (nonatomic, readonly) NSUInteger offset;

- (instancetype)initWithString:(NSString *)sss;

- (char)read;

- (void)unread;
- (void)unread:(NSUInteger)count;

- (NSString *)debugDescription;

@end

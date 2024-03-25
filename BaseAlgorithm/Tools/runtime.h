//
//  runtime.h
//  ProjectExecises
//
//  Created by 姜淼 on 2019/1/17.
//  Copyright © 2019 姜淼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface runtime : NSObject
+(void)swizzleMethods:(Class)class originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel;
+(void)addMethodWithSEL:(SEL)methodSEL methodIMP:(SEL)methodIMP;
@end

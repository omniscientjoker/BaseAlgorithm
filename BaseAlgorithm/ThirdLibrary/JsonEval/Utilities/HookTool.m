//
//  HookTool.m
//  JsonEval
//
//  Created by jiangmiao on 2020/7/21.
//

#import "HookTool.h"

#import "Aspects.h"
#import <objc/runtime.h>

@implementation HookTool
//获取获取所有block 参数
+ (NSArray *)blcokParameter:(Class )class selector:(SEL)sel{
    NSMutableArray *blockArgIndex = [NSMutableArray array];
    Method originMethod = class_getInstanceMethod(class, sel);
    if (!originMethod) {
        return blockArgIndex;
    }
    const char *originType = (char *)method_getTypeEncoding(originMethod);
    if (![[NSString stringWithUTF8String:originType] containsString:@"@?"]) {
        return blockArgIndex;
    }
    int argIndex = 0;
    while(originType && *originType){
        originType = sizeAndAlignment(originType, NULL, NULL, NULL);
        if ([[NSString stringWithUTF8String:originType] hasPrefix:@"@?"]) {
            [blockArgIndex addObject:@(argIndex)];
        }
        argIndex++;
    }
    return blockArgIndex;
}

static const char *sizeAndAlignment(const char *str, NSUInteger *sizep, NSUInteger *alignp, long *lenp){
    const char *out = NSGetSizeAndAlignment(str, sizep, alignp);
    if (lenp) {
        *lenp = out - str;
    }
    while(*out == '}') {
        out++;
    }
    while(isdigit(*out)) {
        out++;
    }
    return out;
}
@end

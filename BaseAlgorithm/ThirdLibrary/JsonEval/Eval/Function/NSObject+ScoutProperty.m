//
//  NSObject+scoutProperty.m
//  JsonEval
//
//  Created by jiangmiao on 2020/7/21.
//

#import "NSObject+ScoutProperty.h"
#import <objc/runtime.h>


@implementation NSObject (ScoutProperty)

 - (void)setScoutPropertyName:(NSString *)name value:(id)value {
    objc_setAssociatedObject(self, NSSelectorFromString(name), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
 
 - (id)scoutPropertyValue:(NSString *)name {
    return objc_getAssociatedObject(self, NSSelectorFromString(name));
}

@end

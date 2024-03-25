//
//  JsonEvalEvalFunc.m
//  JsonEval
//
//  Created by jiangmiao on 2019/7/3.
//

#import "JsonEvalEvalFunc.h"
#import <objc/runtime.h>

@implementation JsonEvalEvalFunc

+ (CGFloat)heightOfRect:(CGRect)rect {
    return rect.size.height;
}

+ (CGFloat)widthOfRect:(CGRect)rect {
    return rect.size.width;
}

+ (CGFloat)xOfRect:(CGRect)rect {
    return rect.origin.x;
}

+ (CGFloat)yOfRect:(CGRect)rect {
    return rect.origin.y;
}

+ (CGFloat)heightOfSize:(CGSize)size {
    return size.height;
}

+ (CGFloat)widthOfSize:(CGSize)size {
    return size.width;
}

+ (CGFloat)xOfPoint:(CGPoint)point {
    return point.x;
}

+ (CGFloat)yOfPoint:(CGPoint)point {
    return point.y;
}

+ (CGFloat)topOfEdgeInset:(UIEdgeInsets)inset {
    return inset.top;
}

+ (CGFloat)leftOfEdgeInset:(UIEdgeInsets)inset {
    return inset.left;
}

+ (CGFloat)bottomOfEdgeInset:(UIEdgeInsets)inset {
    return inset.bottom;
}

+ (CGFloat)rightOfEdgeInset:(UIEdgeInsets)inset {
    return inset.right;
}

+ (NSString *)frameOfObject:(id)object {
    if ([object respondsToSelector:@selector(frame)]) {
        return NSStringFromCGRect([object frame]);
    }
    return nil;
}

+ (NSString *)contentSizeOfObject:(id)object {
    if ([object respondsToSelector:@selector(contentSize)]) {
        return NSStringFromCGSize([object contentSize]);
    }
    return nil;
}

+ (NSString *)contentOffsetOfObject:(id)object {
    if ([object respondsToSelector:@selector(contentOffset)]) {
        return NSStringFromCGPoint([object contentOffset]);
    }
    return nil;
}

+ (NSString *)contentInsetOfObject:(id)object {
    if ([object respondsToSelector:@selector(contentInset)]) {
        return NSStringFromUIEdgeInsets([object contentInset]);
    }
    return nil;
}

+ (BOOL)string:(NSString *)str1 equalTo:(NSString *)str2 {
    NSString *cc1 = [NSString stringWithString:[str1 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSString *cc2 = [NSString stringWithString:[str2 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    return [cc1 isEqualToString:cc2];
}

+ (void)performSelector:(id)object funcName:(NSString*)funcName param:(id)param{
    SEL sel = NSSelectorFromString(funcName);
    if ([object respondsToSelector:sel]) {
        IMP imp = [object methodForSelector:sel];
        void (*func)(id, SEL) = (void *)imp;
        func(object, sel);
    }
}

+ (Protocol*)protocolFromString:(NSString*)protocolName {
    return NSProtocolFromString(protocolName);
}

+ (SEL)selectorFromString:(NSString*)selectorName {
    return NSSelectorFromString(selectorName);
}

+ (Class)classFromString:(NSString*)className {
    return NSClassFromString(className);
}

+ (Class)objcGetClass:(NSString*)className {
    const char *objClassName = className.UTF8String;
    return objc_getClass(objClassName);
}

+ (void)printLog:(id)log {
    NSLog(@"JsonEval============%@",log);
}
///按钮添加点击方法
+ (void)addTarget:(id)object target:(id)target selectorName:(NSString*)selectorName forControlEvents:(long)forControlEvents {
    [object addTarget:target action:[self selectorFromString:selectorName] forControlEvents:forControlEvents];
}

///移除点击方法
+ (void)removeTarget:(id)object target:(id)target selectorName:(NSString*)selectorName forControlEvents:(long)forControlEvents {
    [object removeTarget:target action:[self selectorFromString:selectorName] forControlEvents:forControlEvents];
}
///添加NSOperationQueue子线程
+ (void)addOperationTarget:(id)target selectorName:(NSString*)selectorName takeObject:(nullable id)takeObject {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:target selector:[self selectorFromString:selectorName] object:takeObject];
    [queue addOperation:op1];
}
///添加NSOperationQueue线程依赖
+ (void)addOperationTarget:(id)target selectorNameArr:(NSArray*)selectorNameArr takeObjectArr:(NSArray*)takeObjectArr {
   
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSMutableArray *operationArr = [NSMutableArray array];
    for (int i = 0; i < selectorNameArr.count; i++) {
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:target selector:[self selectorFromString:selectorNameArr[i]] object:takeObjectArr[i]];
        [operationArr addObject:op];
    }
    for (int i = 0; i < operationArr.count; i++) {
        NSInvocationOperation *op = operationArr[i];
        if (i != 0) {
            NSInvocationOperation *op2 = operationArr[i-1];
            [op addDependency:op2];
        }
        [queue addOperation:op];
    }
    
}
///添加NSOperationQueue主线程
+ (void)addMainOperationTarget:(id)target selectorName:(NSString*)selectorName takeObject:(nullable id)takeObject {
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:target selector:[self selectorFromString:selectorName] object:takeObject];
    [queue addOperation:op1];
}
///添加NSThread子线程
+ (void)addThreadTarget:(id)target selectorName:(NSString*)selectorName takeObject:(nullable id)takeObject {
    
    NSThread *thread = [[NSThread alloc] initWithTarget:target selector:[self selectorFromString:selectorName] object:takeObject];
    [thread start];
}

///添加手势
+ (void)addGesture:(id)object target:(id)target selectorName:(NSString*)selectorName gestureName:(NSString*)gestureName{
    Class gestureClass = [self classFromString:gestureName];
    UIGestureRecognizer *gesture = [[gestureClass alloc] initWithTarget:target action:[self selectorFromString:selectorName]];
    [object addGestureRecognizer:gesture];
}
///移除手势
+ (void)removeGestureRecognizerTarget:(UIView *)object gestureName:(NSString*)gestureName {
    if (object.gestureRecognizers.count == 0) {
        return;
    }
    UIGestureRecognizer *matchedGes = nil;
    for (UIGestureRecognizer *ges in object.gestureRecognizers) {
        if ([ges isKindOfClass:[self classFromString:gestureName]]) {
            matchedGes = ges;
        }
    }
    if (matchedGes) {
        [object removeGestureRecognizer:matchedGes];
    }
}
///respond
+ (BOOL)respondsToSelector:(id)object selectorName:(NSString*)selectorName {
    return [object respondsToSelector:[self selectorFromString:selectorName]];
}
///添加观察
+ (void)addObserver:(id)object observerObject:(id)observerObject selectorName:(NSString*)selectorName name:(NSString*)name object1:(id)object1 {
    [object addObserver:observerObject selector:[self selectorFromString:selectorName] name:name object:object1];
}
///移除观察
+ (void)removeObserver:(id)object observerObject:(id)observerObject name:(NSString*)name object1:(id)object1 {
    [object removeObserver:observerObject name:name object:object1];
}
///NSTimer
+ (NSTimer*)scheduledTimerWithTimeInterval:(double)timeInterval target:(id)target selectorName:(NSString*)selectorName userInfo:(id)userInfo repeats:(BOOL)repeats {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:target selector:[self selectorFromString:selectorName] userInfo:userInfo repeats:repeats];
    return timer;
}

+ (NSString*)stringToUTF8String:(NSString*)str {
    return [NSString stringWithString:[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

+ (BOOL)conformsToProtocol:(id)object protocolName:(NSString*)protocolName {
    return [object conformsToProtocol:[self protocolFromString:protocolName]];
}

+ (UIEdgeInsets)edgeInsetWitTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
    return UIEdgeInsetsMake(top, left, bottom, right);
}

+ (NSString *)wrapChineseString:(NSString *)string {
    return [string stringByRemovingPercentEncoding];
}

//%与汉字读取解析存在冲突，所以用函数代替
+ (NSInteger)remResult:(NSInteger)number1 number2:(NSInteger)number2 {
    return number1%number2;
}

@end

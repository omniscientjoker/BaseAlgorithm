//
//  JsonEvalEvalFunc.h
//  JsonEval
//
//  Created by jiangmiao on 2019/7/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JsonEvalEvalFunc : NSObject

+ (CGFloat)heightOfRect:(CGRect)rect;
+ (CGFloat)widthOfRect:(CGRect)rect;
+ (CGFloat)xOfRect:(CGRect)rect;
+ (CGFloat)yOfRect:(CGRect)rect;

+ (CGFloat)heightOfSize:(CGSize)size;
+ (CGFloat)widthOfSize:(CGSize)size;

+ (CGFloat)xOfPoint:(CGPoint)point;
+ (CGFloat)yOfPoint:(CGPoint)point;

+ (CGFloat)topOfEdgeInset:(UIEdgeInsets)inset;
+ (CGFloat)leftOfEdgeInset:(UIEdgeInsets)inset;
+ (CGFloat)bottomOfEdgeInset:(UIEdgeInsets)inset;
+ (CGFloat)rightOfEdgeInset:(UIEdgeInsets)inset;

+ (NSString *)frameOfObject:(id)object;
+ (NSString *)contentSizeOfObject:(id)object;
+ (NSString *)contentInsetOfObject:(id)object;
+ (NSString *)contentOffsetOfObject:(id)object;

+ (BOOL)string:(NSString *)str1 equalTo:(NSString *)str2;
+ (void)performSelector:(id)object funcName:(NSString*)funcName param:(id)param;
+ (void)printLog:(id)log;
+ (Protocol*)protocolFromString:(NSString*)protocolName;
+ (SEL)selectorFromString:(NSString*)selectorName;
+ (Class)classFromString:(NSString*)className;
+ (Class)objcGetClass:(NSString*)className;
+ (BOOL)conformsToProtocol:(id)object protocolName:(NSString*)protocolName;
+ (NSInteger)remResult:(NSInteger)number1 number2:(NSInteger)number2;

+ (UIEdgeInsets)edgeInsetWitTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
+ (NSString *)wrapChineseString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END

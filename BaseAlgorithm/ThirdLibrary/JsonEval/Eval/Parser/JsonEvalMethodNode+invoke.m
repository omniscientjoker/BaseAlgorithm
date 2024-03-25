//
//  JsonEvalMethodNode+invoke.m
//  JsonEval
//
//  Created by jiangmiao on 2019/11/18.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

struct SCBlockLiteral {
    void *isa;
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct block_descriptor {
        unsigned long int reserved;    // NULL
        unsigned long int size;         // sizeof(struct Block_literal_1)
        void (*copy_helper)(void *dst, void *src);     // IFF (1<<25)
        void (*dispose_helper)(void *src);             // IFF (1<<25)
        const char *signature;                         // IFF (1<<30)
    } *descriptor;
};

enum {
     SCBlockDescriptionFlagsHasCopyDispose = (1 << 25),
     SCBlockDescriptionFlagsHasCtor = (1 << 26), // helpers have C++ code
     SCBlockDescriptionFlagsIsGlobal = (1 << 28),
     SCBlockDescriptionFlagsHasStret = (1 << 29), // IFF BLOCK_HAS_SIGNATURE
     SCBlockDescriptionFlagsHasSignature = (1 << 30)
 };

typedef int SCBlockDescriptionFlags;

#import "JsonEvalMethodNode+invoke.h"
#import <objc/message.h>
#import "JsonEvalExtension.h"
#import "NSInvocation+Argument.h"


@implementation JsonEvalMethodNode(invoke)

static NSObject *_nilObj;

+ (void)initialize {
    _nilObj = [[NSObject alloc] init];
}

+ (id)nilObj {
    return _nilObj;
}

+ (id)invokeBlockWithCaller:(id)caller blockName:(NSString *)blockName argments:(NSArray *)arguments {
    if (!caller) {
        NSLog(@"caller为空,blockName:%@,arguments:%@",blockName,arguments);
        return nil;
    }

    SEL block = NSSelectorFromString(blockName);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSMethodSignature *sign = [self getSignatureWithBlock:[caller performSelector:block]];
    if (sign) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sign];
        invocation.target = [caller performSelector:block];
        NSUInteger numberOfArguments = sign.numberOfArguments;
        if (arguments.count > numberOfArguments-1) {
            return nil;
        } else if (arguments.count == 0) {
            [invocation invoke];
            return invocation.returnValue_obj;
        }
        return [self invokeWithInvocation:invocation argments:arguments];

    }
    return  nil;
#pragma clang diagnostic pop
}

+ (NSMethodSignature *)getSignatureWithBlock:(id)block{
    if (!block) return nil;
    struct SCBlockLiteral *blockRef = (__bridge struct SCBlockLiteral *)block;
    SCBlockDescriptionFlags _flags = blockRef->flags;
      if (_flags & SCBlockDescriptionFlagsHasSignature) {
          void *signatureLocation = blockRef->descriptor;
          signatureLocation += sizeof(unsigned long int);
          signatureLocation += sizeof(unsigned long int);
 
        if (_flags & SCBlockDescriptionFlagsHasCopyDispose) {
             signatureLocation += sizeof(void(*)(void *dst, void *src));
             signatureLocation += sizeof(void (*)(void *src));
         }

         const char *signature = (*(const char **)signatureLocation);
         return [NSMethodSignature signatureWithObjCTypes:signature];
    }
     return nil;
}
+ (id)invokeWithCaller:(id)caller selectorName:(NSString *)selectorName argments:(NSArray *)arguments {
    if (!caller) {
        NSLog(@"caller为空,selectorName:%@,arguments:%@",selectorName,arguments);
        return nil;
    }
    
    SEL selector                       = NSSelectorFromString(selectorName);
    NSMethodSignature *methodSignature = [caller methodSignatureForSelector:selector];
    NSInvocation *invocation           = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setSelector:selector]; [invocation setTarget:caller];
    NSUInteger numberOfArguments = methodSignature.numberOfArguments;
    NSInteger inputArguments     = [arguments count];
    if (inputArguments > numberOfArguments - 2) {
        return invokeVariableParameterMethod(arguments, methodSignature, caller, selector);
    }
    return [self invokeWithInvocation:invocation argments:arguments];
    /**
    SEL sel = NSSelectorFromString(selectorName);
    
    if (arguments && ![arguments isKindOfClass:NSArray.class]) {
        arguments = @[arguments];
    }
    if ([caller instancesRespondToSelector:sel]) { // instance method
        id instance                  = [[caller alloc] init];
        NSMethodSignature *signature = [instance methodSignatureForSelector:sel];
        NSInvocation *invocation     = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector          = sel;
        invocation.arguments         = arguments;
        [invocation invokeWithTarget:instance];
        return invocation.returnValue_obj;
    } else if ([caller respondsToSelector:sel]) { // class method
        NSMethodSignature *signature = [caller methodSignatureForSelector:sel];
        NSInvocation *invocation     = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector          = sel;
        invocation.arguments         = arguments;
        [invocation invokeWithTarget:caller];
        return invocation.returnValue_obj;
    } else {
        NSMethodSignature *methodSignature = [caller methodSignatureForSelector:sel];
        NSInvocation *invocation           = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:caller];
        [invocation setSelector:sel];
        return [self invokeWithInvocation:invocation argments:arguments];
    }
     */
}

+ (id)invokeWithInvocation:(NSInvocation *)invocation argments:(NSArray *)arguments {
    // change NSValue, NSNumber to invocation type
    NSMethodSignature *methodSignature = invocation.methodSignature;
    NSString *selectorName = NSStringFromSelector(invocation.selector);
    NSUInteger adjustment = (selectorName == nil ? 1 : 0);
    for (NSUInteger i = 2; i < arguments.count + 2; i++) {
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:i - adjustment];
        id valObj = arguments[i-2];
        switch (argumentType[0] == 'r' ? argumentType[1] : argumentType[0]) {
                
#define JP_CALL_ARG_CASE(_typeString, _type, _selector) \
case _typeString: {                              \
_type value = [valObj _selector];                     \
[invocation setArgument:&value atIndex:i - adjustment];\
break; \
}
                
                JP_CALL_ARG_CASE('c', char, charValue)
                JP_CALL_ARG_CASE('C', unsigned char, unsignedCharValue)
                JP_CALL_ARG_CASE('s', short, shortValue)
                JP_CALL_ARG_CASE('S', unsigned short, unsignedShortValue)
                JP_CALL_ARG_CASE('i', int, intValue)
                JP_CALL_ARG_CASE('I', unsigned int, unsignedIntValue)
                JP_CALL_ARG_CASE('l', long, longValue)
                JP_CALL_ARG_CASE('L', unsigned long, unsignedLongValue)
                JP_CALL_ARG_CASE('q', long long, longLongValue)
                JP_CALL_ARG_CASE('Q', unsigned long long, unsignedLongLongValue)
                JP_CALL_ARG_CASE('f', float, floatValue)
                JP_CALL_ARG_CASE('d', double, doubleValue)
                JP_CALL_ARG_CASE('B', BOOL, boolValue)
                
            case ':': {
                SEL value = nil;
                if (valObj != _nilObj) {
                    value = NSSelectorFromString(valObj);
                }
                [invocation setArgument:&value atIndex:i - adjustment];
                break;
            }
            case '{': {
                void *pointer = NULL;
                [valObj getValue:&pointer];
                [invocation setArgument:&pointer atIndex:i - adjustment];
                break;
            }
            case '^': {
                char type = argumentType[1];
                if (type == '@') {
                    id __strong *error = &valObj;
                    [invocation setArgument:&error atIndex:i - adjustment];
                    break;
                }
            }
            default: {
                if (valObj == _nilObj ||
                    ([valObj isKindOfClass:[NSNumber class]] && strcmp([valObj objCType], "c") == 0 && ![valObj boolValue])) {
                    valObj = nil;
                    [invocation setArgument:&valObj atIndex:i - adjustment];
                    break;
                }
                [invocation setArgument:&valObj atIndex:i - adjustment];
            }
        }
    }
    
    [invocation invoke];
    
    char returnType[255];
    strcpy(returnType, [methodSignature methodReturnType]);
    
    id returnValue;
    if (strncmp(returnType, "v", 1) == 0) {
        return nil;
    }
    if (strncmp(returnType, "@", 1) == 0) {
                void *result;
                [invocation getReturnValue:&result];
                
                //For performance, ignore the other methods prefix with alloc/new/copy/mutableCopy
                if ([selectorName isEqualToString:@"alloc"] || [selectorName isEqualToString:@"new"] ||
                    [selectorName isEqualToString:@"copy"] || [selectorName isEqualToString:@"mutableCopy"]) {
                    returnValue = (__bridge_transfer id)result;
                } else {
                    returnValue = (__bridge id)result;
                }
                return returnValue;
                
            }
    switch (returnType[0] == 'r' ? returnType[1] : returnType[0]) {
                        
    #define JP_CALL_RET_CASE(_typeString, _type) \
    case _typeString: {                              \
    _type tempResultSet; \
    [invocation getReturnValue:&tempResultSet];\
    returnValue = @(tempResultSet); \
    break; \
    }
                        
                        JP_CALL_RET_CASE('c', char)
                        JP_CALL_RET_CASE('C', unsigned char)
                        JP_CALL_RET_CASE('s', short)
                        JP_CALL_RET_CASE('S', unsigned short)
                        JP_CALL_RET_CASE('i', int)
                        JP_CALL_RET_CASE('I', unsigned int)
                        JP_CALL_RET_CASE('l', long)
                        JP_CALL_RET_CASE('L', unsigned long)
                        JP_CALL_RET_CASE('q', long long)
                        JP_CALL_RET_CASE('Q', unsigned long long)
                        JP_CALL_RET_CASE('f', float)
                        JP_CALL_RET_CASE('d', double)
                        JP_CALL_RET_CASE('B', BOOL)
                    case '{': {
                        void *result;
                        [invocation getReturnValue:&result];
                        return  [NSValue value:&result withObjCType:returnType];
                    }
                    case '#': {
                        Class result;
                        [invocation getReturnValue:&result];
                        returnValue = result;
                        break;
                    }
                    default:
                        break;
                }
                return returnValue;
}

static id (*new_msgSend1)(id, SEL, id,...) = (id (*)(id, SEL, id,...)) objc_msgSend;
static id (*new_msgSend2)(id, SEL, id, id,...) = (id (*)(id, SEL, id, id,...)) objc_msgSend;
static id (*new_msgSend3)(id, SEL, id, id, id,...) = (id (*)(id, SEL, id, id, id,...)) objc_msgSend;
static id (*new_msgSend4)(id, SEL, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id,...)) objc_msgSend;
static id (*new_msgSend5)(id, SEL, id, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id, id,...)) objc_msgSend;
static id (*new_msgSend6)(id, SEL, id, id, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id, id, id,...)) objc_msgSend;
static id (*new_msgSend7)(id, SEL, id, id, id, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id, id, id,id,...)) objc_msgSend;
static id (*new_msgSend8)(id, SEL, id, id, id, id, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id, id, id, id, id,...)) objc_msgSend;
static id (*new_msgSend9)(id, SEL, id, id, id, id, id, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id, id, id, id, id, id, ...)) objc_msgSend;
static id (*new_msgSend10)(id, SEL, id, id, id, id, id, id, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id, id, id, id, id, id, id,...)) objc_msgSend;

static id invokeVariableParameterMethod(NSArray *origArgumentsList, NSMethodSignature *methodSignature, id sender, SEL selector) {
    
    NSInteger inputArguments = [(NSArray *)origArgumentsList count];
    NSUInteger numberOfArguments = methodSignature.numberOfArguments;
    
    NSMutableArray *argumentsList = [[NSMutableArray alloc] init];
    for (NSUInteger j = 0; j < inputArguments; j++) {
        NSInteger index = MIN(j + 2, numberOfArguments - 1);
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:index];
        id valObj = origArgumentsList[j];
        char argumentTypeChar = argumentType[0] == 'r' ? argumentType[1] : argumentType[0];
        if (argumentTypeChar == '@') {
            [argumentsList addObject:valObj];
        } else {
            return nil;
        }
    }
    
    id results = nil;
    numberOfArguments = numberOfArguments - 2;
    
    // If you want to debug the macro code below, replace it to the expanded code:
    // https://gist.github.com/bang590/ca3720ae1da594252a2e
#define JP_G_ARG(_idx) getArgument(argumentsList[_idx])
#define JP_CALL_MSGSEND_ARG1(_num) results = new_msgSend##_num(sender, selector, JP_G_ARG(0));
#define JP_CALL_MSGSEND_ARG2(_num) results = new_msgSend##_num(sender, selector, JP_G_ARG(0), JP_G_ARG(1));
#define JP_CALL_MSGSEND_ARG3(_num) results = new_msgSend##_num(sender, selector, JP_G_ARG(0), JP_G_ARG(1), JP_G_ARG(2));
#define JP_CALL_MSGSEND_ARG4(_num) results = new_msgSend##_num(sender, selector, JP_G_ARG(0), JP_G_ARG(1), JP_G_ARG(2), JP_G_ARG(3));
#define JP_CALL_MSGSEND_ARG5(_num) results = new_msgSend##_num(sender, selector, JP_G_ARG(0), JP_G_ARG(1), JP_G_ARG(2), JP_G_ARG(3), JP_G_ARG(4));
#define JP_CALL_MSGSEND_ARG6(_num) results = new_msgSend##_num(sender, selector, JP_G_ARG(0), JP_G_ARG(1), JP_G_ARG(2), JP_G_ARG(3), JP_G_ARG(4), JP_G_ARG(5));
#define JP_CALL_MSGSEND_ARG7(_num) results = new_msgSend##_num(sender, selector, JP_G_ARG(0), JP_G_ARG(1), JP_G_ARG(2), JP_G_ARG(3), JP_G_ARG(4), JP_G_ARG(5), JP_G_ARG(6));
#define JP_CALL_MSGSEND_ARG8(_num) results = new_msgSend##_num(sender, selector, JP_G_ARG(0), JP_G_ARG(1), JP_G_ARG(2), JP_G_ARG(3), JP_G_ARG(4), JP_G_ARG(5), JP_G_ARG(6), JP_G_ARG(7));
#define JP_CALL_MSGSEND_ARG9(_num) results = new_msgSend##_num(sender, selector, JP_G_ARG(0), JP_G_ARG(1), JP_G_ARG(2), JP_G_ARG(3), JP_G_ARG(4), JP_G_ARG(5), JP_G_ARG(6), JP_G_ARG(7), JP_G_ARG(8));
#define JP_CALL_MSGSEND_ARG10(_num) results = new_msgSend##_num(sender, selector, JP_G_ARG(0), JP_G_ARG(1), JP_G_ARG(2), JP_G_ARG(3), JP_G_ARG(4), JP_G_ARG(5), JP_G_ARG(6), JP_G_ARG(7), JP_G_ARG(8), JP_G_ARG(9));
#define JP_CALL_MSGSEND_ARG11(_num) results = new_msgSend##_num(sender, selector, JP_G_ARG(0), JP_G_ARG(1), JP_G_ARG(2), JP_G_ARG(3), JP_G_ARG(4), JP_G_ARG(5), JP_G_ARG(6), JP_G_ARG(7), JP_G_ARG(8), JP_G_ARG(9), JP_G_ARG(10));
    
#define JP_IF_REAL_ARG_COUNT(_num) if([argumentsList count] == _num)
    
#define JP_DEAL_MSGSEND(_realArgCount, _defineArgCount) \
if(numberOfArguments == _defineArgCount) { \
JP_CALL_MSGSEND_ARG##_realArgCount(_defineArgCount) \
}
    
    JP_IF_REAL_ARG_COUNT(1) { JP_CALL_MSGSEND_ARG1(1) }
    JP_IF_REAL_ARG_COUNT(2) { JP_DEAL_MSGSEND(2, 1) JP_DEAL_MSGSEND(2, 2) }
    JP_IF_REAL_ARG_COUNT(3) { JP_DEAL_MSGSEND(3, 1) JP_DEAL_MSGSEND(3, 2) JP_DEAL_MSGSEND(3, 3) }
    JP_IF_REAL_ARG_COUNT(4) { JP_DEAL_MSGSEND(4, 1) JP_DEAL_MSGSEND(4, 2) JP_DEAL_MSGSEND(4, 3) JP_DEAL_MSGSEND(4, 4) }
    JP_IF_REAL_ARG_COUNT(5) { JP_DEAL_MSGSEND(5, 1) JP_DEAL_MSGSEND(5, 2) JP_DEAL_MSGSEND(5, 3) JP_DEAL_MSGSEND(5, 4) JP_DEAL_MSGSEND(5, 5) }
    JP_IF_REAL_ARG_COUNT(6) { JP_DEAL_MSGSEND(6, 1) JP_DEAL_MSGSEND(6, 2) JP_DEAL_MSGSEND(6, 3) JP_DEAL_MSGSEND(6, 4) JP_DEAL_MSGSEND(6, 5) JP_DEAL_MSGSEND(6, 6) }
    JP_IF_REAL_ARG_COUNT(7) { JP_DEAL_MSGSEND(7, 1) JP_DEAL_MSGSEND(7, 2) JP_DEAL_MSGSEND(7, 3) JP_DEAL_MSGSEND(7, 4) JP_DEAL_MSGSEND(7, 5) JP_DEAL_MSGSEND(7, 6) JP_DEAL_MSGSEND(7, 7) }
    JP_IF_REAL_ARG_COUNT(8) { JP_DEAL_MSGSEND(8, 1) JP_DEAL_MSGSEND(8, 2) JP_DEAL_MSGSEND(8, 3) JP_DEAL_MSGSEND(8, 4) JP_DEAL_MSGSEND(8, 5) JP_DEAL_MSGSEND(8, 6) JP_DEAL_MSGSEND(8, 7) JP_DEAL_MSGSEND(8, 8) }
    JP_IF_REAL_ARG_COUNT(9) { JP_DEAL_MSGSEND(9, 1) JP_DEAL_MSGSEND(9, 2) JP_DEAL_MSGSEND(9, 3) JP_DEAL_MSGSEND(9, 4) JP_DEAL_MSGSEND(9, 5) JP_DEAL_MSGSEND(9, 6) JP_DEAL_MSGSEND(9, 7) JP_DEAL_MSGSEND(9, 8) JP_DEAL_MSGSEND(9, 9) }
    JP_IF_REAL_ARG_COUNT(10) { JP_DEAL_MSGSEND(10, 1) JP_DEAL_MSGSEND(10, 2) JP_DEAL_MSGSEND(10, 3) JP_DEAL_MSGSEND(10, 4) JP_DEAL_MSGSEND(10, 5) JP_DEAL_MSGSEND(10, 6) JP_DEAL_MSGSEND(10, 7) JP_DEAL_MSGSEND(10, 8) JP_DEAL_MSGSEND(10, 9) JP_DEAL_MSGSEND(10, 10) }
    
    return results;
}

static id getArgument(id valObj){
    if (valObj == _nilObj ||
        ([valObj isKindOfClass:[NSNumber class]] && strcmp([valObj objCType], "c") == 0 && ![valObj boolValue])) {
        return nil;
    }
    return valObj;
}

@end

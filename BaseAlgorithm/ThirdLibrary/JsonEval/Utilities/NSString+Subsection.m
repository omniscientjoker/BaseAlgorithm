//
//  NSString+Subsection.m
//  JsonEval
//
//  Created by jiangmiao on 2019/7/10.
//

#import "NSString+Subsection.h"

@implementation NSString (Subsection)
- (NSArray *)subsection:(NSInteger )length withKey:(NSString *)key{
    BOOL haveKey = false;
    NSInteger tureLength    = length;//"<key>:<content>"
    if (key != nil && key.length != 0) {
        tureLength = length - [self getToInt:key] -1;
        haveKey = true;
    }
    
    NSMutableArray *array   = [NSMutableArray array];
    NSString *remainStr     = self;
    while ([self getToInt:remainStr] > tureLength) {
        NSString *subStr = [self subStringWithString:remainStr withLength:tureLength];
        haveKey ? [array addObject:[NSString stringWithFormat:@"%@:%@",key,subStr]]:[array addObject:subStr];
        remainStr = [remainStr substringWithRange:NSMakeRange(subStr.length, remainStr.length-subStr.length)];
    }
    haveKey ? [array addObject:[NSString stringWithFormat:@"%@:%@",key,remainStr]] : [array addObject:remainStr];
    return array;
}

//获取字符串的字节数
- (NSUInteger )getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [[strtemp dataUsingEncoding:enc] length];
}
//切割字符串
-(NSString *)subStringWithString:(NSString *)string withLength:(NSInteger )count
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:enc];
    NSData * subData;
    if (data.length%2 == 0) {
        subData = [data subdataWithRange:NSMakeRange(0, count)];
    }else{
        subData = [data subdataWithRange:NSMakeRange(0, count - 1)];
    }
    return [[NSString alloc] initWithData:subData encoding:enc];
}

- (BOOL)isChinese {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)includeChinese {
    NSString *s = [self stringByRemovingPercentEncoding];
    for (int i = 0; i < [s length]; i++) {
        int a = [s characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

@end

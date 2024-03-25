//
//  HookTokenHandler.m
//  JsonEval
//
//  Created by jiangmiao on 2019/7/16.
//

#import "HookTokenHandler.h"
@implementation HookTokenHandler

-(NSMutableDictionary *)hookTokens{
    if (!_hookTokens) {
        _hookTokens = [NSMutableDictionary dictionary];
    }
    return _hookTokens;
}

+ (instancetype)sharedHandler{
    static HookTokenHandler *handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[HookTokenHandler alloc]init];
    });
    return handler;
}

- (instancetype)init{
    if ([super init]) {
        _hookTokens = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addTokenToLocalStore:(id<AspectToken>)token withId:(NSString *)identity isStore:(BOOL)store {
    /**
    [self.hookTokens setObject:@{ ASPECT_TOKEN_KEY    :  token,
                                  ASPECT_TOKEN_ISSTORE:@(store)}
                        forKey:identity];
     */
}

- (void)removeTokenFormLocalStoreWithId:(NSString *)identity {
    /**
    NSDictionary * dict = [self.hookTokens objectForKey:identity];
    if (!dict) {
        return;
    }
    id<AspectToken> token = [dict objectForKey:ASPECT_TOKEN_KEY];
    if (!token) {
        return;
    }
    if ([token remove]) {
        NSLog(@"aspects token 移除成功");
    }else{
        NSLog(@"aspects token 未能删除");
    }
     */
}


+(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end

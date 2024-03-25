//
//  AspectsSimple.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/25.
//  Copyright © 2024 joker. All rights reserved.
//

#import "AspectsSimple.h"
#import "Aspects.h"
#import "JsonEvalEvalManager.h"
#import "NSInvocation+Argument.h"
#import "HookTokenHandler.h"

@interface AspectsSimple()
@property(nonatomic,strong)NSString * message;
@end

@implementation AspectsSimple
-(instancetype)init{
    self = [super init];
    if (self) {
        self.message = @"121212";
    }
    return self;
}

- (void)exampleLoad{
    NSString * json = @"{\"scout_needstore\":1,\"scout_class\":\"AspectsSimple\",\"scout_method\":\"prientMessage\",\"scout_option\":2,\"scout_fix\":\"self.message=@\\\"测试\\\";\"}";
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    [self aspectChangeMethod:dic];
}

- (void)aspectChangeMethod:(NSDictionary *)snippet{
    SEL sel              = NSSelectorFromString(snippet[@"scout_method"]);
    AspectOptions option = [snippet[@"scout_option"] integerValue];
    Class instance       = NSClassFromString(snippet[@"scout_class"]);
    NSString *scode      = snippet[@"scout_fix"];
    NSString *queue      = snippet[@"scout_queue"];
    if (![instance instancesRespondToSelector:sel] && ![instance respondsToSelector:sel]) {
        return;
    }
    id class;
    if ([instance instancesRespondToSelector:sel]) {
        class = instance;
    }
    if ([instance respondsToSelector:sel]) {
        class = [instance new];
    }
    if (class == nil) {
        return;
    }
    id<AspectToken> token = [class aspect_hookSelector:sel 
                                           withOptions:option
                                            usingBlock:^(id<AspectInfo> aspectInfo){
        if(scode && scode.length > 0){
            NSMutableDictionary *context = [NSMutableDictionary dictionaryWithDictionary:@{@"originalInvocation": aspectInfo.originalInvocation,
                                                                                           @"arguments": aspectInfo.arguments,
                                                                                           @"self"     : aspectInfo.instance}];
            if ([queue isEqualToString:@"main"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [JsonEvalEvalManager eval:scode context:context];
                    id retval = [context valueForKey:@"retval"];
                    if (retval) {
                        [aspectInfo.originalInvocation setReturnValue_obj:retval];
                    }
                });
            } else if ([queue isEqualToString:@"global"]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [JsonEvalEvalManager eval:scode context:context];
                    id retval = [context valueForKey:@"retval"];
                    if (retval) {
                        [aspectInfo.originalInvocation setReturnValue_obj:retval];
                    }
                });
            } else {
                [JsonEvalEvalManager eval:scode context:context];
                id retval = [context valueForKey:@"retval"];
                if (retval) {
                    [aspectInfo.originalInvocation setReturnValue_obj:retval];
                }
            }
        }
    } error:nil];
    if (token) {
        [[HookTokenHandler sharedHandler] addTokenToLocalStore:token withId:snippet[@"scout_id"] isStore:[snippet[@"scout_needstore"] boolValue]];
    }
}

- (void)prientMessage{
    NSLog(@"test === %@",self.message);
}
@end

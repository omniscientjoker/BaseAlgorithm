//
//  HookTokenHandler.h
//  JsonEval
//
//  Created by jiangmiao on 2019/7/16.
//

#import <UIKit/UIKit.h>
#import "Aspects.h"

#define ASPECT_HOOK_TOKEN @"aspect_token_store"
#define ASPECT_TOKEN_KEY @"aspect_token_key"
#define ASPECT_TOKEN_ISSTORE @"aspect_token_isstore"
NS_ASSUME_NONNULL_BEGIN

@interface HookTokenHandler : NSUserDefaults

@property (nonatomic ,strong)NSMutableDictionary *hookTokens;
+ (instancetype)sharedHandler;

- (void)addTokenToLocalStore:(id<AspectToken>)token withId:(NSString *)identity isStore:(BOOL)store;
- (void)removeTokenFormLocalStoreWithId:(NSString *)identity;
@end

NS_ASSUME_NONNULL_END

//
//  ProtocolRouteMediator.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/25.
//  Copyright © 2024 joker. All rights reserved.
//

#import "ProtocolRouteMediator.h"
@interface ProtocolRouteMediator()
@property (nonatomic,strong) NSMutableDictionary *protocolCache;
@end


@implementation ProtocolRouteMediator
+ (instancetype)sharedInstance{
    static ProtocolRouteMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[ProtocolRouteMediator alloc] init];
    });
    return mediator;
}

-(NSMutableDictionary *)protocolCache{
    if (!_protocolCache) {
        _protocolCache = [NSMutableDictionary new];
    }
    return _protocolCache;
}

- (void)registerProtocol:(Protocol *)proto forClass:(Class)cls {
    [self.protocolCache setObject:cls forKey:NSStringFromProtocol(proto)];
}

- (Class)classForProtocol:(Protocol *)proto {
    return self.protocolCache[NSStringFromProtocol(proto)];
}
@end

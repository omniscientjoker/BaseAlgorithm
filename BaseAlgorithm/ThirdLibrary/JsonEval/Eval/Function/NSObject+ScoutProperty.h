//
//  NSObject+scoutProperty.h
//  JsonEval
//
//  Created by jiangmiao on 2020/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ScoutProperty)

- (void)setScoutPropertyName:(NSString *)name value:(id)value;
- (id)scoutPropertyValue:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

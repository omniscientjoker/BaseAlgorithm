//
//  JsonEvalExtension.h
//  JsonEval
//
//  Created by jiangmiao on 2019/11/21.
//  Copyright © 2019年 jiangmiao. All rights reserved.
//

@import UIKit;

@interface JsonEvalExtension : NSObject

+ (int)sizeOfStructTypes:(NSString *)structTypes;
+ (void)getStructDataWidthDict:(void *)structData dict:(NSDictionary *)dict structDefine:(NSDictionary *)structDefine;
+ (NSDictionary *)getDictOfStruct:(void *)structData structDefine:(NSDictionary *)structDefine;

+ (NSMutableDictionary *)registeredStruct;

+ (NSString *)extractStructName:(NSString *)typeEncodeString;
+ (void)defineStruct:(NSDictionary *)defineDict;

@end


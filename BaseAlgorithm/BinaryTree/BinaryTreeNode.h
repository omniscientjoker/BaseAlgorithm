//
//  BinaryTreeNode.h
//  BaseAlgorithm
//
//  Created by joker on 2019/1/9.
//  Copyright © 2019 joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinaryTreeNode : NSObject
@property (nonatomic, assign) NSInteger val;
@property (nonatomic, strong, nullable) BinaryTreeNode *leftTree;
@property (nonatomic, strong, nullable) BinaryTreeNode *rightTree;
+ (BinaryTreeNode *)invertTree:(BinaryTreeNode *)root;
@end


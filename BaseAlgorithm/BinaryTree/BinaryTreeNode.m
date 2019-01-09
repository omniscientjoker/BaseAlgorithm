//
//  BinaryTreeNode.m
//  BaseAlgorithm
//
//  Created by joker on 2019/1/9.
//  Copyright © 2019 joker. All rights reserved.
//

#import "BinaryTreeNode.h"

@implementation BinaryTreeNode
//反转二叉树
+ (BinaryTreeNode *)invertTree:(BinaryTreeNode *)root{
    if(!root) {
        return root;
    }
    [self invertTree:root.leftTree];
    [self invertTree:root.rightTree];
    [self exchangeNode:root];
    return root;
}
//判断是否为完全二叉树
+ (BOOL)compareTree:(BinaryTreeNode *)tree_1 Tree:(BinaryTreeNode *)tree_2{
    if (tree_1 && tree_2) {
        if (tree_1.val != tree_2.val) return NO;
    }
    if (!tree_1 || tree_2) return NO;
    if (!tree_2 || tree_1) return NO;
    BOOL a = [self compareTree:tree_1.leftTree Tree:tree_2.leftTree];
    BOOL b = [self compareTree:tree_1.rightTree Tree:tree_2.rightTree];
    if (a && b) {
        return YES;
    }else{
        return NO;
    }
}

#pragma private
+ (void)exchangeNode:(BinaryTreeNode *)node {
    if(node) {
        BinaryTreeNode *temp = node.leftTree;
        node.leftTree = node.rightTree;
        node.rightTree = temp;
    }
}
@end

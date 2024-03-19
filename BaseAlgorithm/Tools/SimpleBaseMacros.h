//
//  SimpleBaseMacros.h
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/19.
//  Copyright © 2024 joker. All rights reserved.
//

#ifndef SimpleBaseMacros_h
#define SimpleBaseMacros_h

/// 屏幕尺寸
#define Screen_Height [UIScreen mainScreen].bounds.size.height //当前屏幕高度
#define Screen_Width [UIScreen mainScreen].bounds.size.width  //当前屏幕宽度
#define Screen_Scale (MIN(Screen_Height, Screen_Width) / 375.0)  // 37屏幕比例
#define Screen_statusBar_Height [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏的高度
#define isiPhoneX  [UIScreen mainScreen].bounds.size.height >= 812 //是否是iPhone X
#define kNavBarHeight 44.0 // 屏幕navigation不含状态栏的高度
#define Screen_NAV_Height (Screen_statusBar_Height + kNavBarHeight) // 屏幕navigation的高度

#define BottomHeight (isiPhoneX ? 34 : 0)//iPhone X底部手势区域
#define NavTopHeight (isiPhoneX ? 88 : 64)//导航栏高度
#define isiPhone5s  Screen_Width == 320

#define ONEPX           (1.0f / [UIScreen mainScreen].scale)  //1像素
#define kScaleWidth(length) ((length/375.0f) * [[UIScreen mainScreen] bounds].size.width)

/// 转化为String
#define GetString(string) string ? [NSString stringWithFormat:@"%@",string] ? [NSString stringWithFormat:@"%@",string] : @"" : @""

/// 引用
#define WEAK_SELF __weak __typeof(&*self)weakSelf = self;
#define STRONG_SELF  __strong __typeof(&*weakSelf) strongSelf = weakSelf;
#define CHECK_WEAK_SELF if (weakSelf == nil) { return; }

#endif /* SimpleBaseMacros_h */

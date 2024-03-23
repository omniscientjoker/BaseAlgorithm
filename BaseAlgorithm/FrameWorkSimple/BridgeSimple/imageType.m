//
//  imageType.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/22.
//  Copyright © 2024 joker. All rights reserved.
//

#import "imageType.h"

@implementation JPGImage
- (void)showDifferentImage {
    [self.tvRemortImp powerOn];
    NSLog(@"图片格式是：JPG格式");
}
@end

@implementation PNGImage
- (void)showDifferentImage {
    [self.tvRemortImp powerOn];
    NSLog(@"图片格式是：PNG格式");
}
@end

@implementation GIFImage
- (void)showDifferentImage {
    [self.tvRemortImp powerOn];
    NSLog(@"图片格式是：GIF格式");
}
@end

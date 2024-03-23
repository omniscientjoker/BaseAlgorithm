//
//  SimpleView.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/20.
//  Copyright © 2024 joker. All rights reserved.
//

#import "SimpleView.h"

@interface SimpleView ()
@property(nonatomic,strong)NSString * viewName;
@end


@implementation SimpleView
-(instancetype)initWithViewName:(NSString *)viewName{
    self = [super init];
    if (self) {
        self.viewName = viewName;
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    NSLog(@"%@ === drawRect",self.viewName);
}
-(void)layoutSubviews{
    NSLog(@"%@ === layoutSubviews",self.viewName);
    [super layoutSubviews];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return YES;
}
@end

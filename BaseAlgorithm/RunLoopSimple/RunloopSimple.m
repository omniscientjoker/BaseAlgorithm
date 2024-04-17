//
//  RunloopSimple.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/18.
//  Copyright © 2024 joker. All rights reserved.
//

#import "RunloopSimple.h"
@interface RunloopSimple()
@property(nonatomic,assign)NSInteger timeCount;
@end

@implementation RunloopSimple
-(void)testRunloop{
    [self addObserver];
    NSLog(@"1");
    [self performSelector:@selector(testPerform:) withObject:@"dispatch_main runloop" afterDelay:0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"2");
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [self performSelector:@selector(testPerform:) withObject:@"dispatch_async runloop" afterDelay:0];
        [[NSRunLoop currentRunLoop] run];
        NSLog(@"3");
    });
    NSLog(@"4");
}

-(void)testRunloop2{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    });
}

- (void)testPerform:(NSString*)message{
    NSLog(@"testPerform=%@",message);
    NSLog(@"----------testcurrentThread----%@", [NSThread currentThread]);
    NSLog(@"----------testmainThread----%@", [NSThread mainThread]);
}


// 添加 observer
- (void)addObserver{
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:{
                NSLog(@"进入runloop");
            } break;
            case kCFRunLoopBeforeTimers:{
                NSLog(@"即将执行 timers");
            } break;
            case kCFRunLoopBeforeSources:{
                NSLog(@"即将执行 sources");
            } break;
            case kCFRunLoopBeforeWaiting:{
                NSLog(@"即将休眠");
            } break;
            case kCFRunLoopAfterWaiting:{
                NSLog(@"唤醒");
            } break;
            case kCFRunLoopExit:{
                NSLog(@"退出");
            } break;
            default: break;
        }
    });
    //将观察者添加到common模式下，这样当default模式和UITrackingRunLoopMode两种模式下都有回调。
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}


// 添加 source
- (void)cfSource {
    //创建上下文
    CFRunLoopSourceContext context = {};
    context.perform = runLoopSourceCallback;
    context.info = (__bridge void *)self;
    //创建source
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    //添加source
    CFRunLoopAddSource(runLoop, source, kCFRunLoopCommonModes);
    //延迟3秒 执行source相关事件
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CFRunLoopSourceSignal(source);
        CFRunLoopWakeUp(runLoop);
        CFRelease(source);
    });
}
static void runLoopSourceCallback(void *info) {
    NSLog(@"reiceive source in %@", [NSDate date]);
}


// 添加 CFRunLoopTimerRef
- (void)addTimeRef{
    /**
     CFRunLoopTimerRef CFRunLoopTimerCreate(CFAllocatorRef allocator, // 用于分配内存，通常使用kCFAllocatorDefault即可
                                            CFAbsoluteTime fireDate,  // 第一次触发调用的时间
                                            CFTimeInterval interval,  // 回调间隔
                                            CFOptionFlags flags,      // 苹果备用参数，传0即可
                                            CFIndex order,            // RunLoop执行事件的优先级，对于Timer是无用的，传0即可
                                            CFRunLoopTimerCallBack callout, // 回调callback
                                            CFRunLoopTimerContext *context); // 用于与callback联系的上下文context
     */
    CFRunLoopTimerContext context = {};
    context.info = (__bridge void*)self; //将当前对象作为参数传入
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault,
                                                   CFAbsoluteTimeGetCurrent() + 1,
                                                   3,
                                                   0, 0, &timerFiredCallback, &context);
    CFRunLoopTimerSetTolerance(timer, 0.01);// 设置运行时间误差范围
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes);
    CFRelease(timer);
}
static void timerFiredCallback(CFRunLoopTimerRef timer, void *info) {
    RunloopSimple *objc = (__bridge RunloopSimple *)info;
    NSLog(@"recieve timer event with count: %@, in %@", @(objc.timeCount), [NSDate date]);
    if (++objc.timeCount == 5) {
        CFRunLoopTimerInvalidate(timer); //关闭定时器
    }
}
@end

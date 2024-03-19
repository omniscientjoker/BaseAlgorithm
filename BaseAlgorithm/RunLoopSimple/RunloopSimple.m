//
//  RunloopSimple.m
//  BaseAlgorithm
//
//  Created by jiangmiao on 2024/3/18.
//  Copyright © 2024 joker. All rights reserved.
//

#import "RunloopSimple.h"

@implementation RunloopSimple
-(void)testRunloop{
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

- (void)addObserver{
    /*
     kCFRunLoopEntry = (1UL << 0),1
     kCFRunLoopBeforeTimers = (1UL << 1),2
     kCFRunLoopBeforeSources = (1UL << 2), 4
     kCFRunLoopBeforeWaiting = (1UL << 5), 32
     kCFRunLoopAfterWaiting = (1UL << 6), 64
     kCFRunLoopExit = (1UL << 7),128
     kCFRunLoopAllActivities = 0x0FFFFFFFU
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:{
                NSLog(@"进入runloop");
            }
                break;
            case kCFRunLoopBeforeTimers:{
                NSLog(@"timers");
            }
                break;
            case kCFRunLoopBeforeSources:{
                NSLog(@"sources");
            }
                break;
            case kCFRunLoopBeforeWaiting:{
                NSLog(@"即将进入休眠");
            }
                break;
            case kCFRunLoopAfterWaiting:{
                NSLog(@"唤醒");
            }
                break;
            case kCFRunLoopExit:{
                NSLog(@"退出");
            }
                break;
            default:
                break;
        }
    });
    //将观察者添加到common模式下，这样当default模式和UITrackingRunLoopMode两种模式下都有回调。
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}
@end

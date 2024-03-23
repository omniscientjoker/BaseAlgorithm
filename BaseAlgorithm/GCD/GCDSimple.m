//
//  GCDSimple.m
//  BaseAlgorithm
//
//  Created by 姜淼 on 2019/1/11.
//  Copyright © 2019 joker. All rights reserved.
//

#import "GCDSimple.h"


#import <libkern/OSAtomic.h>
#import <os/lock.h>
#import <pthread.h>

@interface GCDSimple(){
    dispatch_semaphore_t semaphoreLock;
    pthread_mutex_t mutex;/// mutex 锁
    pthread_cond_t cond;/// 条件变量
    NSMutableArray      *shop;/// 用于保存数据
}
@property(nonatomic,assign)NSInteger ticketSurplusCount;
@end

@implementation GCDSimple
#pragma mark ---- 创建列队
//串行列队
-(dispatch_queue_t)createSerialQueue{
    dispatch_queue_t queue = dispatch_queue_create("10900900",DISPATCH_QUEUE_SERIAL);
    return queue;
}
//并行列队
-(dispatch_queue_t)createConcurrentQueue{
    dispatch_queue_t queue = dispatch_queue_create("10900901",DISPATCH_QUEUE_CONCURRENT);
    return queue;
}
//主列队 串行
-(dispatch_queue_t)getMainQueue{
    dispatch_queue_t queue = dispatch_get_main_queue();
    return queue;
}
//全局并行列队
-(dispatch_queue_t)createGlobalConcurrentQueue{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    return queue;
}


#pragma mark 创建任务
// 同步
-(void)createSyncWithQueue:(dispatch_queue_t)queue mission:(NSString *)mission{
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"%@---%@",mission,[NSThread currentThread]);      // 打印当前线程
        }
    });
}
// 异步
-(void)createAsyncWithQueue:(dispatch_queue_t)queue mission:(NSString *)mission{
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"%@---%@",mission,[NSThread currentThread]);      // 打印当前线程
        }
    });
}
// 列队加入任务 回主线程执行
- (void)communication {
    // 获取全局并发队列 获取主队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        // 异步追加任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
}


#pragma mark ---- 特殊应用 栅栏 once apply after
// 栅栏
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("testbarrier", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2---%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"barrier---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3---%@",[NSThread currentThread]);
    });
}
// after
-(void)excuteAfterSecond:(NSInteger)second{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // second秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
    });
}
// once
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
    });
}
// apply
- (void)applyTime:(NSInteger)time {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"apply---begin");
    dispatch_apply(time, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
}


#pragma mark 列队组
-(void)createGroup{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_sync(queue, ^{
        // 追加任务A
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        dispatch_group_leave(group);
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"dispatch_group_wait---%@",[NSThread currentThread]);
}
-(void)groupNotify{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务A
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务B
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 追加任务Main
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"main---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
}
-(void)groupWait{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务B
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}


#pragma mark 信号量
- (void)semaphoreSync {
    NSLog(@"semaphore---begin");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务A
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        number = 100;
        dispatch_semaphore_signal(semaphore);
    });
    //原任务B
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore---end,number = %d",number);
}

- (void)semaphoreSyncLimit {
    NSLog(@"semaphore---begin");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    __block int number = 100;
    while (number == 0) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:2];
            number -= 1;
            NSLog(@"1---%@ -- %d",[NSThread currentThread],number);
            dispatch_semaphore_signal(semaphore);
        });
    }
}

#pragma mark ---- 线程安全
- (void)initTicketStatusSave {
    semaphoreLock = dispatch_semaphore_create(1);
    self.ticketSurplusCount = 50;
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("100900100", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("900100900", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    //异步执行
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

- (void)saleTicketSafe {
    while (1) {
        // 相当于加锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            // 相当于解锁
            dispatch_semaphore_signal(semaphoreLock);
            break;
        }
        // 相当于解锁
        dispatch_semaphore_signal(semaphoreLock);
    }
}


#pragma mark ---- 同步执行
// 串行列队 异步任务
- (void)createDispatchAsync{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.gcd.serial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        sleep(2);
        NSLog(@"async1...%@",[NSThread currentThread]);
    });
    dispatch_async(serialQueue, ^{
        sleep(2);
        NSLog(@"async2...%@",[NSThread currentThread]);
    });
    dispatch_async(serialQueue, ^{
        sleep(2);
        NSLog(@"async3...%@",[NSThread currentThread]);
    });
}

// 信号量
- (void)createSemaphore{
    // 创建并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.gcd.concurrent", DISPATCH_QUEUE_CONCURRENT);    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(concurrentQueue, ^{
        sleep(2);
        NSLog(@"async1...%@",[NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_async(concurrentQueue, ^{
        sleep(2);
        NSLog(@"async2...%@",[NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_async(concurrentQueue, ^{
        sleep(2);
        NSLog(@"async3...%@",[NSThread currentThread]);
    });
}

// 列队组
- (void)createDispatchGroup{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务B
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

// 栅栏数据同步
- (void)createDispatchBarrier {
    dispatch_queue_t queue = dispatch_queue_create("testbarrier", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2---%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"barrier---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3---%@",[NSThread currentThread]);
    });
}




#pragma mark ---- 死锁
// 主线程 同步任务
-(void)mainSync{
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"线程死锁");
    });
}
//异步任务只要任务队列是串行队列，在串行队列的任务中再向队列添加同步任务，就会造成死锁
-(void)mainSync2{
    NSLog(@"创建串行");
    dispatch_queue_t queue = dispatch_queue_create("10900900",DISPATCH_QUEUE_SERIAL);
    NSLog(@"串行添加 异步任务");
    dispatch_async(queue, ^{
        NSLog(@"异步任务中 给串行添加同步任务");
        dispatch_sync(queue, ^{
            NSLog(@"线程死锁");
        });
    });
}


#pragma mark ---- 线程锁
// 自旋锁
- (void)createOSSPinLock{
    OSSpinLock theOSSpinLock = OS_SPINLOCK_INIT;
    /// @abstract 上锁
    /// @param __lock ： OSSpinLock 的地址
    OSSpinLockLock(&theOSSpinLock);

    /// @abstract 解锁
    /// @param __lock : OSSpinLock 的地址
    OSSpinLockUnlock(&theOSSpinLock);

    /// @abstract 上锁
    /// @discussion 尝试加锁，可以加锁理解加锁并返回 YES，否则返回 NO
    /// @param __lock :OSSpinLock 的地址
    OSSpinLockTry(&theOSSpinLock);
}

// 互斥锁 - os_ufair_lock
- (void)createOsUfairLock{
    /// 初始化 os_unfair_lock
    os_unfair_lock theOs_unfair_lock = OS_UNFAIR_LOCK_INIT;

    /// @abstract 上锁
    /// @param lock : os_unfair_lock 的地址
    os_unfair_lock_lock(&theOs_unfair_lock);

    /// @abstract 解锁
    /// @param lock : os_unfair_lock 的地址
    os_unfair_lock_unlock(&theOs_unfair_lock);

    /// @abstract 上锁
    /// @discussion 尝试加锁，可以加锁理解加锁并返回 YES，否则返回 NO
    /// @param lock : os_unfair_lock 的地址
    bool result = os_unfair_lock_trylock(&theOs_unfair_lock);
    NSLog(@"%ld",result);
}

// 互斥锁 递归锁 条件锁 pthread_mutex pthread_mutex(recursive) pthread_mutex(cond)
//- (void)createPthreadMutex{
//    /// 定义一个属性变量
//    pthread_mutexattr_t attr;
//    pthread_mutexattr_init(&attr);
//
//    /// 设置属性类型为 PTHREAD_MUTEX_NORMAL
//    /*
//     #define PTHREAD_MUTEX_NORMAL        0                    /// 普通的锁
//     #define PTHREAD_MUTEX_ERRORCHECK    1                    /// 错误检查
//     #define PTHREAD_MUTEX_RECURSIVE     2                    /// 递归锁
//     #define PTHREAD_MUTEX_DEFAULT            /// 默认的锁，也就是 PTHREAD_MUTEX_NORMAL
//     */
//    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
//    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
//
//    /// 定义一个锁变量
//    pthread_mutex_(&_mutex, &attr);
//    
//    /// 设置以后销毁属性
//    pthread_mutexattr_destroy(&attr);
//    
//    
//    /// ==== 递归锁 ==== ///
//    [self test_PTHREAD_MUTEX_RECURSIVE];
//    
//    /// ==== 条件锁 ==== ///
//    /// 定义一个条件 == 条件锁
//    pthread_cond_init(&_cond, NULL);
//    /// 唤醒所有正在等待该条件的线程
//    pthread_cond_broadcast(&_cond);
//    /// 初始化判断参数
//    shop = [NSMutableArray array];
//    dispatch_queue_t theQueue = dispatch_get_global_queue(0, 0);
//    dispatch_async(theQueue, ^{
//        [self produce];
//    });
//
//    dispatch_async(theQueue, ^{
//        [self buy];
//    });
//    
//
//    /// @abstract 上锁
////    pthread_mutex_lock(&mutex);
//
//    /// @abstract 解锁
////    pthread_mutex_unlock(&mutex);
//
//    /// @abstract 销毁 pthread_mutex
////    pthread_mutex_destroy(&mutex);
//}
///// 递归
//- (void)test_PTHREAD_MUTEX_RECURSIVE {
//    static int count = 5;
//    // 第一次进来直接加锁，第二次进来，已经加锁了。还能递归继续加锁
//    pthread_mutex_lock(&_mutex);
//    NSLog(@"加锁 %@", [NSThread currentThread]);
//    if (count > 0) {
//        count--;
//        [self test_PTHREAD_MUTEX_RECURSIVE];
//    }
//    NSLog(@"解锁 %@", [NSThread currentThread]);
//    pthread_mutex_unlock(&_mutex);
//}
///// 假装是生产者
//- (void)produce {
//    while (true) {
//        pthread_mutex_lock(&_mutex);
//        /// 生产需要时间（doge）
//        sleep(0.1);
//        if (shop.count > 5) {
//            NSLog(@"商店满了，不能再生产了");
//            pthread_cond_wait(&_cond, &_mutex);
//        }
//        /// 将生产的产品丢进商店
//        [shop addObject:@"fan"];
//        NSLog(@"生产了一个 fan");
//        /// 唤醒一个正在等待的线程
//        pthread_cond_signal(&_cond);
//        pthread_mutex_unlock(&_mutex);
//    }
//}
///// 假装是消费者
//- (void)buy {
//    while (true) {
//        pthread_mutex_lock(&mutex);
//        /// shop 内没有存货，买不到
//        /// 进入等待（进入休眠，放开 _mutex；被唤醒时，会重新对 _mutex 加锁）
//        if (shop.count < 1) {
//            NSLog(@"现在买不到， 我等一下吧");
//            pthread_cond_wait(&cond, &mutex);
//        }
//        [shop removeObjectAtIndex:0];
//        NSLog(@"终于买到了，不容易");
//        pthread_cond_signal(&cond);
//        pthread_mutex_unlock(&mutex);
//    }
//}

// 递归锁 NSRecursiveLock
- (void)creatLock{
    __block int i = 0;
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    static void (^YZBlock)(NSString *);
    void (^aBlock)(NSString *) = ^(NSString *str) {
        [lock lock];
        sleep(2);
        i += 1;
        NSLog(@"%@  %@",str,[NSThread currentThread]);
        if (i < 5) {// 给定一个结束递归的条件
            YZBlock(@"sync 1 ....");
        }
        NSLog(@"释放锁");
        [lock unlock];
    };
}

// 条件锁 NSCondition 不仅用到了条件锁（signal、wait），还用到了互斥锁(lock、unlock)，
- (void)conditionLock {
    NSCondition *conditionLock = [[NSCondition alloc] init];
    __block NSString *food;
    // 消费者1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [conditionLock lock];
        if (!food) {// 没有现成的菜（判断是否满足线程阻塞条件）
            NSLog(@"等待上菜");
            [conditionLock wait];// 没有菜，等着吧！（满足条件，阻塞线程）
        }
        // 菜做好了，可以用餐！（线程畅通，继续执行）
        NSLog(@"开始用餐：%@",food);
        [conditionLock unlock];
    });
    // 消费者2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [conditionLock lock];
        if (!food) {
            NSLog(@"等待上菜2");
            [conditionLock wait];
        }
        NSLog(@"开始用餐2：%@",food);
        [conditionLock unlock];
    });

    // 生产者
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [conditionLock lock];
        NSLog(@"厨师做菜中...");
        sleep(5);
        food = @"四菜一汤";
        NSLog(@"厨师做好了菜：%@",food);
        [conditionLock signal];
        [conditionLock broadcast];//方法是以广播的形式通知所有满足条件且等待中的线程可以继续执行任务了
        [conditionLock unlock];
    });
}
@end

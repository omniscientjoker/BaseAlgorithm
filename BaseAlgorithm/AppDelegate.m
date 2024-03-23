//
//  AppDelegate.m
//  BaseAlgorithm
//
//  Created by joker on 2019/1/8.
//  Copyright © 2019 joker. All rights reserved.
//

#import "AppDelegate.h"
#import "SortViewController.h"

@interface AppDelegate ()
@end


@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[[SortViewController alloc]init]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}
@end

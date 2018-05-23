/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"
#import "AppDelegate+Config.h"
#import "ZXBaseNavigationController.h"
#import "HomeMainViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.launchOptions = launchOptions;
    
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    //在此处做控制开关 如果不行就用他们的
    BOOL shenxian = YES;
    if (shenxian)
    {
        self.window.rootViewController = [[ZXBaseNavigationController alloc] initWithRootViewController:[[HomeMainViewController alloc] init]];
    }
    else
    {
        [self config];
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UIViewController *)nativeController {
    if (!_nativeController) {
        
        // TODO: 在此处将根控制器修改成套壳的控制器，例如: _nativeController = [[UITabBarController alloc] init];
        _nativeController = [[NativeViewController alloc] init];
    }
    return _nativeController;
}

@end

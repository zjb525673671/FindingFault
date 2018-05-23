/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>

#import "NativeViewController.h"
#import "ReactNativeViewController.h"
#import "WebViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NSDictionary *launchOptions;

@property (nonatomic, strong) UIViewController *nativeController;
@property (nonatomic, strong) ReactNativeViewController *reactNativeController;
@property (nonatomic, strong) UIViewController *webController;

@end

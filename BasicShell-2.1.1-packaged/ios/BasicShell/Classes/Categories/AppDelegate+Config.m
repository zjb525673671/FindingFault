//
//  AppDelegate+Config.m
//  hatsune
//
//  Created by Mike on 17/10/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "AppDelegate+Config.h"
#import "HQNetWorkingApi+GetBasicsInfo.h"
#import "CodePush.h"
#import "AppDelegate+Service.h"
#import <CoreTelephony/CTCellularData.h>
#import "ReactNativeViewController.h"
#import "AppConfigurationModule.h"
#import "WebViewController.h"
#import "PromptViewController.h"
#import "LoadingViewController.h"
#import "NSData+KKAES.h"

@implementation AppDelegate (Config)

- (void)config {
//    [self customizeActionBeforeConfig];
    [self showContentWithConfigrationInstance];
    [self registerServerWithConfigrationInstance];
    [self handleWithCellularDataState:^(CTCellularDataRestrictedState state) {
        
        if (state==kCTCellularDataRestrictedStateUnknown) { // 未知
            
            [self updateConfigrationWithHandler:^(BOOL sucessed) {
                if (sucessed) {
                    [self showContentWithConfigrationInstance];
                    [self registerServerWithConfigrationInstance];
                }
            }];
            
        } else if (state==kCTCellularDataNotRestricted) { // 允许
            
            // 提示正在加载
            
            [self updateConfigrationWithHandler:^(BOOL sucessed) { // 请求
                if (sucessed) {
                    [self showContentWithConfigrationInstance];
                    [self registerServerWithConfigrationInstance];
                } else {
                    
                    AppConfigurationModule *config = [AppConfigurationModule sharedInstance];
                    BOOL notInited = config.reviewStatus==0;
                    if (notInited) {
                        [self showPromptController];
                        if ([self.window.rootViewController isKindOfClass:[PromptViewController class]]) {
                            PromptViewController *vc = (PromptViewController *)self.window.rootViewController;
                            [vc changeToLoadingMode];
                        }
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 等待2秒
                        [self updateConfigrationWithHandler:^(BOOL sucessed) { // 请求一次
                            if (sucessed) {
                                [self showContentWithConfigrationInstance];
                                [self registerServerWithConfigrationInstance];
                            } else {
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 等待2秒
                                    [self updateConfigrationWithHandler:^(BOOL sucessed) { // 请求两次
                                        if (sucessed) {
                                            [self showContentWithConfigrationInstance];
                                            [self registerServerWithConfigrationInstance];
                                        } else {
                                            if ([self.window.rootViewController isKindOfClass:[PromptViewController class]]) {
                                                PromptViewController *vc = (PromptViewController *)self.window.rootViewController;
                                                [vc changeToFailedMode];
                                            }
                                        }
                                    }];
                                });
                            }
                        }];
                    });
                }
            }];
        }
    }];
}

- (void)showContentWithConfigrationInstance {
    AppConfigurationModule *config = [AppConfigurationModule sharedInstance];
    BOOL showContentForUsers = config.reviewStatus==2 && config.isInAvailableArea;
    BOOL isFirstTime = config.reviewStatus==0;
    if (showContentForUsers) {
        if (config.appMode<=1) {
            [self showReactNativeControllerWithCodePushKey:config.codePushKey
                                codePushServerUrlServerUrl:config.codePushServerUrl
                                                moduleName:@"app"
                                                appVersion:@"1.0.0"];
        } else if (config.appMode==2) {
            [self showWebControllerWithUrl:config.wapUrl];
        } else {
            [self showNativeController];
        }
    }else if (isFirstTime) {
        [self showLoadingController];
    }  else {
        // 展示壳
        [self showNativeController];
    }
}

- (void)registerServerWithConfigrationInstance {
    AppConfigurationModule *config = [AppConfigurationModule sharedInstance];
    BOOL hasEnoughKeysForServer = (config.umengAppKey.length>0 || config.jpushAppKey.length>0) && config.channel.length>0;
    if (hasEnoughKeysForServer) {
        [self configService];
    }
}

- (void)updateConfigrationWithHandler:(void(^)(BOOL sucessed))handler {
    [HQNetWorkingApi requestBasicInfoWithCompletionHandler:^(NSDictionary *allHeaderFields, NSDictionary *responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            NSString *base64Encoded = responseObject[@"data"];
            NSData *base64EncodedData = [[NSData alloc] initWithBase64EncodedString:base64Encoded options:0];
            NSData *key32 = [@"e2a93cf0acdf470d617c088cbd11586b" dataUsingEncoding:NSUTF8StringEncoding];
            NSData *edec32 = [base64EncodedData  AES_ECB_DecryptWith:key32];
            NSString *string = [[NSString alloc] initWithData:edec32 encoding:NSUTF8StringEncoding];
            
            NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *configs = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            AppConfigurationModule *module = [AppConfigurationModule sharedInstance];
            module.configs = configs;
            if (configs.allKeys.count<1) {
                // 没有匹配到配置
                module.reviewStatus = 1;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(YES);
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(NO);
                }
            });
        }
    }];
}

- (void)showReactNativeControllerWithCodePushKey:(NSString *)codePushKey
                      codePushServerUrlServerUrl:(NSString *)codePushServerURL
                                      moduleName:(NSString *)moduleName
                                      appVersion:(NSString *)appVersion {
    
    void (^allocNewReactNativeController)() = ^(){
            self.reactNativeController = [[ReactNativeViewController alloc] initWithCodePushKey:codePushKey
                                                                              codePushServerUrl:codePushServerURL
                                                                                     moduleName:moduleName
                                                                                  andAppVersion:appVersion];
    };
    
    if (self.reactNativeController) {
        NSString *currentCodePushKey = self.reactNativeController.codePushKey;
        NSString *currentCodePushServerUrl = self.reactNativeController.codePushServerUrl;
        NSString *currtntReactNativeModuleName = self.reactNativeController.moduleName;
        BOOL needAllocNewReactNativeController = ![currentCodePushKey isEqualToString:codePushKey] || ![currentCodePushServerUrl isEqualToString:codePushServerURL] || ![currtntReactNativeModuleName isEqualToString:moduleName];
        if (needAllocNewReactNativeController) {
            allocNewReactNativeController();
        }
    } else {
        allocNewReactNativeController();
    }
    self.window.rootViewController = self.reactNativeController;
}

- (void)showNativeController {
    self.window.rootViewController = self.nativeController;
}

- (void)showWebControllerWithUrl:(NSString *)url {
    if (!self.webController) {
        WebViewController *rootController = [[WebViewController alloc] init];
        rootController.urlString = url;
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:rootController];
        self.webController = naviController;
        
    }
    self.window.rootViewController = self.webController;
}

- (void)showPromptController {
    PromptViewController *promptController = [[PromptViewController alloc] init];
    self.window.rootViewController = promptController;
}

- (void)showLoadingController {
    LoadingViewController *loadingController = [[LoadingViewController alloc] init];
    self.window.rootViewController = loadingController;
}

- (void)handleWithCellularDataState:(void(^)(CTCellularDataRestrictedState state))handler {
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        //获取联网状态，解决中国特色社会主义问题
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(state);
        });
    };
    handler(state);
}

@end

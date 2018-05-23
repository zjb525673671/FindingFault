//
//  HQNetWorkingApi+GetBasicsInfo.m
//  BasicShell
//
//  Created by Mike on 30/12/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HQNetWorkingApi+GetBasicsInfo.h"

@implementation HQNetWorkingApi (GetBasicsInfo)

+ (void)requestBasicInfoWithBundleID:(NSString *)bundleId buildCode:(NSString *)code andCompletionHandler:(ResponseHandler)handler {
    [HQNetworking postWithUrl:HQNerworkingBasicUrl paramsHandler:^(NSMutableDictionary *allHeaderFields, NSMutableDictionary *params) {
        params[@"uniqueId"] = bundleId;
        params[@"buildVersionCode"] = code;
        params[@"platform"] = @"1";
        params[@"sourceCodeVersion"] = @"2.0.8";
    } handler:handler];
}

+ (void)requestBasicInfoWithCompletionHandler:(ResponseHandler)handler {
    NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
    NSString *bundleIdentifier = infoDic[@"CFBundleIdentifier"];
    NSString *bundleVersion = infoDic[@"CFBundleVersion"];
#ifdef DEBUG
    bundleIdentifier = @"com.ios.basicshell";
#endif
    [self requestBasicInfoWithBundleID:bundleIdentifier buildCode:bundleVersion andCompletionHandler:handler];
}

@end

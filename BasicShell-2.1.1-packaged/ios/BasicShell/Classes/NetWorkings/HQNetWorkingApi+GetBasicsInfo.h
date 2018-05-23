//
//  HQNetWorkingApi+GetBasicsInfo.h
//  BasicShell
//
//  Created by Mike on 30/12/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HQNetWorkingApi.h"

@interface HQNetWorkingApi (GetBasicsInfo)

+ (void)requestBasicInfoWithCompletionHandler:(ResponseHandler)handler;
+ (void)requestBasicInfoWithBundleID:(NSString *)bundleId buildCode:(NSString *)code andCompletionHandler:(ResponseHandler)handler;

@end

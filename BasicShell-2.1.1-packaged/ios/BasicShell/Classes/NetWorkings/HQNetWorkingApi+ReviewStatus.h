//
//  HQNetWorkingApi+ReviewStatus.h
//  hatsune
//
//  Created by Mike on 21/10/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HQNetWorkingApi.h"

@interface HQNetWorkingApi (ReviewStatus)

/**
 查询审核情况
 
 @param platform 用户设备平台:(1:iOS, 2:android)
 @param uniqueId 应用唯一标识, iOS为BundleID, android为packageID
 @param version 应用内部构件版本, ios为BuildVersion, android为VersionCode
 @param handler 成功回调
 */
+ (void)requestReviewInfoWithPlatform:(NSString *)platform appUniqueId:(NSString *)uniqueId version:(NSString *)version handler:(ResponseHandler)handler;

@end

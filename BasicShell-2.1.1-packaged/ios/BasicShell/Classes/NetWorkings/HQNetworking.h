//
//  HQNetworking.h
//  hatsune
//
//  Created by Mike Leong on 02/05/2017.
//  Copyright © 2017 Kosun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResponseHandler)(NSDictionary *allHeaderFields, NSDictionary *responseObject);
typedef void(^ParamsHandler)(NSMutableDictionary *allHeaderFields, NSMutableDictionary *params);

extern NSString *const HQNetworkingApiUrl;
extern NSString *const HQNetworkingReviewUrl;
extern NSString *const HQNetworkingConfigUrl;
extern NSString *const HQNerworkingBasicUrl;

@interface HQNetworking : NSObject

+ (void)postWithUrl:(NSString *)HQNetworkingUrl paramsHandler:(ParamsHandler)paramsHandler handler:(ResponseHandler)handler;
+ (void)getWithUrl:(NSString *)HQNetworkingUrl paramsHandler:(ParamsHandler)paramsHandler handler:(ResponseHandler)handler;

@end

//
//  ConfigurationKeys.m
//  angelia
//
//  Created by Mike on 05/12/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "AppConfigurationModule.h"
#import <React/RCTConvert.h>
#import <React/RCTEventDispatcher.h>

@interface AppConfigurationModule ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation AppConfigurationModule

RCT_EXPORT_MODULE();

@synthesize configs = _configs;

- (NSDictionary<NSString *, id> *)constantsToExport {
    AppConfigurationModule *module = [AppConfigurationModule sharedInstance];
    return module.configs;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"⚠️ undefine %@", key);
}

- (void)setConfigs:(NSDictionary *)configs {
    _configs = configs;
    [self.userDefaults setObject:configs forKey:@"configs"];
    [self setValuesForKeysWithDictionary:configs];
}

- (NSDictionary *)configs {
    _configs = [self.userDefaults dictionaryForKey:@"configs"];
    return _configs;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AppConfigurationModule *module;
    dispatch_once(&onceToken, ^{
        module = [[AppConfigurationModule alloc] init];
        module.userDefaults = [NSUserDefaults standardUserDefaults];
        [module setValuesForKeysWithDictionary:module.configs];
    });
    return module;
}

@end

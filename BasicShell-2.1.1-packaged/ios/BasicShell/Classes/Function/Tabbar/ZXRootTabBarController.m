//
//  ZXRootTabBarController.m
//  BasicShell
//
//  Created by 周结兵 on 2018/5/23.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "ZXRootTabBarController.h"
#import "ZXBaseNavigationController.h"

@interface ZXRootTabBarController ()

@end

@implementation ZXRootTabBarController

#pragma mark - ♻️life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self xn_initData];
    [self xn_initSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


#pragma mark - 🔒private

- (void)xn_initData
{
    
}

- (void)xn_initSubViews
{
    
}

- (void)addChildViewControllers
{
    [self setupChildViewControllerWithVcString:@"HomeMainViewController" imageName:@"tab_loan" selectedImage:@"tab_loan_sel" title:@"首页" tag:1];
}

- (void)setupChildViewControllerWithVcString:(NSString *)vcString imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage title:(NSString *)title  tag:(NSInteger)tag{
    Class cls = NSClassFromString(vcString);
    UIViewController *vc = [[cls alloc] init];
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.tag = tag;
    
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x252222)} forState:UIControlStateSelected];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x7C7A7A)} forState:UIControlStateNormal];
    ZXBaseNavigationController *nav = [[ZXBaseNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}


#pragma mark - 🔄overwrite

#pragma mark - 🚪public

#pragma mark - 🍐delegate

#pragma mark - - TableView Delegate and DataSource

#pragma mark - ☎️notification

#pragma mark - 🎬event response

#pragma mark - ☸getter and setter


@end

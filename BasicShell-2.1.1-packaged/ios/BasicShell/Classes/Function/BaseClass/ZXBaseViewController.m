//
//  ZXBaseViewController.m
//  BasicShell
//
//  Created by 周结兵 on 2018/5/23.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXBaseViewController ()

@end

@implementation ZXBaseViewController

#pragma mark - ♻️life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self base_initData];
    [self base_initSubViews];
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

- (void)base_initData
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)base_initSubViews
{
    
}

#pragma mark - 🔄overwrite

#pragma mark - 🚪public

#pragma mark - 🍐delegate

#pragma mark - - TableView Delegate and DataSource

#pragma mark - ☎️notification

#pragma mark - 🎬event response

#pragma mark - ☸getter and setter


@end

//
//  TrancluentNavigationController.m
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/25.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "TrancluentNavigationController.h"

@interface TrancluentNavigationController ()

@end

@implementation TrancluentNavigationController

//+ (void)initialize
//{
//    UINavigationBar *navbar = [UINavigationBar appearance];
//    [navbar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [navbar setShadowImage:[[UIImage alloc] init]];
//    [navbar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]; // 255,252,230
//    [navbar setTintColor:[UIColor whiteColor]];
//    
//    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
//    [barItem setTintColor:[UIColor whiteColor]];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINavigationBar *navbar = [UINavigationBar appearance];
    [navbar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navbar setShadowImage:[[UIImage alloc] init]];
    [navbar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]; // 255,252,230
    [navbar setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    [barItem setTintColor:[UIColor whiteColor]];
}

@end

//
//  NavigationController.m
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/14.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

//+ (void)initialize
//{
//    UINavigationBar *navbar = [UINavigationBar appearance];
//    [navbar setBackgroundImage:[UIImage imageNamed:@"NavigationBar"] forBarMetrics:UIBarMetricsDefault];
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
    [navbar setBackgroundImage:[UIImage imageNamed:@"NavigationBar"] forBarMetrics:UIBarMetricsDefault];
    [navbar setShadowImage:[[UIImage alloc] init]];
    [navbar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]; // 255,252,230
    [navbar setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    [barItem setTintColor:[UIColor whiteColor]];
}

@end

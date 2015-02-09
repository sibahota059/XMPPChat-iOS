//
//  TabBarViewController.m
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/14.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

+ (void)initialize
{
    UITabBar *tabbar = [UITabBar appearance];
//    [tabbar setBackgroundImage:[UIImage imageNamed:@"TabBar"]];
    [tabbar setTintColor:[UIColor colorWithRed:79/255.0 green:167/255.0 blue:105/255.0 alpha:1.0]];
    
//    UITabBarItem *tabbarItem = [UITabBarItem appearance];
//    [tabbarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]} forState:UIControlStateNormal];   // 非选中tabbaritem的颜色
//    [tabbarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:79/255.0 green:167/255.0 blue:105/255.0 alpha:1.0]} forState:UIControlStateSelected];    // 选中的tabbaritem的颜色

}

//- (void)viewDidLoad
//{
//    self.tabBar
//}

@end

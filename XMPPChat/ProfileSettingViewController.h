//
//  ProfileSettingViewController.h
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/18.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileSettingViewController;
@protocol ProfileSettingViewControllerDelegate <NSObject>

- (void)profileSettingViewControllerDidModifyProfile:(ProfileSettingViewController *)profileSettingViewController;

@end

@interface ProfileSettingViewController : UIViewController

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, weak) UILabel *editText;  // 新的传参方式，与ProfileViewController指向同一块内存区域

@property (nonatomic, assign, getter=isUpdatingDescription) BOOL updatingDescription;

@property (nonatomic, weak) id <ProfileSettingViewControllerDelegate> delegate;

@end

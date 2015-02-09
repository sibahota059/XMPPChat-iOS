//
//  JZNotificationView.h
//  JZNotificationView
//
//  Created by Joshua Zhou on 14/11/24.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZNotificationView : UIView

+ (void)showWithIconName:(NSString *)imageName headline:(NSString *)headline message:(NSString *)message;
+ (void)showSuccessWithHeadline:(NSString *)headline message:(NSString *)message;
+ (void)showFailureWithHeadline:(NSString *)headline message:(NSString *)message;
+ (void)showWarningWithHeadline:(NSString *)headline message:(NSString *)message;

@end

//
//  JZNotificationView.m
//  JZNotificationView
//
//  Created by Joshua Zhou on 14/11/24.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "JZNotificationView.h"

#define margin                  8
#define iconViewLeadingPadding  16
#define iconViewWidth           25
#define iconViewHeight          iconViewWidth

#define headlineLabelTopPadding      20
#define headlineLabelTrailingPadding 8
#define headlineLabelHeight          15
#define messageLabelTrailingPadding  headlineLabelTrailingPadding

#define notificationStayTime    2.0

@interface JZNotificationView ()

@property (nonatomic, weak) UIVisualEffectView *blurView;
@property (nonatomic, weak) UIVisualEffectView *vibrancyView;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *headlineLabel;
@property (nonatomic, weak) UILabel *messageLabel;

@end

@implementation JZNotificationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:247/255.0 alpha:1.0];
        
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        self.blurView = blurView;
//        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
//        UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
//        self.vibrancyView = vibrancyView;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *headlineLabel = [[UILabel alloc] init];
        headlineLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [self addSubview:headlineLabel];
        self.headlineLabel = headlineLabel;
        
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:messageLabel];
        self.messageLabel = messageLabel;
        
//        [blurView.contentView addSubview:vibrancyView];
//        [self addSubview:blurView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, 64);
    
    self.blurView.frame = self.frame;
//    self.vibrancyView.frame = self.frame;
    
//    CGFloat iconViewY = (self.bounds.size.height - iconViewHeight) / 2;
    self.iconView.frame = CGRectMake(iconViewLeadingPadding, iconViewLeadingPadding, iconViewWidth, iconViewHeight);
    self.iconView.center = CGPointMake(iconViewLeadingPadding + iconViewWidth / 2, (self.bounds.size.height + iconViewLeadingPadding) / 2);
    
    CGFloat headlineLabelX = iconViewLeadingPadding + iconViewWidth + margin;
    CGFloat headlineLabelWidth = self.bounds.size.width - headlineLabelTrailingPadding - headlineLabelX;
    self.headlineLabel.frame = CGRectMake(headlineLabelX, headlineLabelTopPadding, headlineLabelWidth, headlineLabelHeight);
    
    CGFloat messageLabelY = CGRectGetMaxY(self.headlineLabel.frame) + margin;
    self.messageLabel.frame = CGRectMake(headlineLabelX, messageLabelY, headlineLabelWidth, self.bounds.size.height - messageLabelY - margin);
}

- (UIColor *)labelColorWithImageName:(NSString *)imageName
{
    if ([imageName isEqualToString:@"Success"]) {
        return [UIColor colorWithRed:25/255.0 green:200/255.0 blue:62/255.0 alpha:1.0];
    } else if ([imageName isEqualToString:@"Warning"]) {
        return [UIColor colorWithRed:245/255.0 green:166/255.0 blue:60/255.0 alpha:1.0];
    } else {
        return [UIColor colorWithRed:234/255.0 green:33/255.0 blue:33/255.0 alpha:1.0];
    }
}

+ (void)showWithIconName:(NSString *)imageName headline:(NSString *)headline message:(NSString *)message
{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    
    JZNotificationView *notificationView = [[JZNotificationView alloc] initWithFrame:CGRectMake(0, -64, view.bounds.size.width, 64)];
    notificationView.iconView.image = [UIImage imageNamed:imageName];
    notificationView.headlineLabel.text = headline;
    notificationView.headlineLabel.textColor = [notificationView labelColorWithImageName:imageName];
    notificationView.messageLabel.text = message;
    notificationView.messageLabel.textColor = [notificationView labelColorWithImageName:imageName];
    
    [view addSubview:notificationView];
    [UIView animateWithDuration:0.8 animations:^{
        notificationView.transform = CGAffineTransformMakeTranslation(0, 64);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.8 delay:notificationStayTime options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            notificationView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

+ (void)showSuccessWithHeadline:(NSString *)headline message:(NSString *)message
{
    [JZNotificationView showWithIconName:@"Success" headline:headline message:message];
}

+ (void)showFailureWithHeadline:(NSString *)headline message:(NSString *)message
{
    [JZNotificationView showWithIconName:@"Failure" headline:headline message:message];
}

+ (void)showWarningWithHeadline:(NSString *)headline message:(NSString *)message
{
    [JZNotificationView showWithIconName:@"Warning" headline:headline message:message];
}

@end

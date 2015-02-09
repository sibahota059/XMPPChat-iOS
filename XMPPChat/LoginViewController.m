//
//  LoginViewController.m
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/13.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "JZNotificationView.h"
#import "JNWSpringAnimation.h"
#import  "POP.h"

#define adaptKeyboardHeight         120
#define translationDistanceFactor   8
@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *declarationTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;

@end

@implementation LoginViewController


- (AppDelegate *)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupUI
{
    self.errorMessageLabel.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 1.0f);
    self.errorMessageLabel.layer.opacity = 0;
    
    self.accountTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
 
    
    CGFloat initialDelay = 0.5f;
    CGFloat i = 0;
    for (UIView *view in self.loginView.subviews) {
        if ([view isEqual:self.userActivity] || [view isEqual:self.errorMessageLabel]) {
            continue;
        }
        [self setupUIAnimationWithView:view delay:initialDelay + i];
        i += 0.1f;
    }
    [self setupUIAnimationWithView:self.declarationTextField delay:initialDelay + i];
}

- (void)setupUIAnimationWithView:(UIView *)animatedView delay:(CGFloat)delayInterval
{
    animatedView.transform = CGAffineTransformMakeTranslation(0, self.loginButton.frame.origin.y);
    [UIView animateWithDuration:2.5 delay:delayInterval usingSpringWithDamping:0.5 initialSpringVelocity:0 options:0 animations:^{
        animatedView.transform = CGAffineTransformIdentity;
        animatedView.alpha = 1.0f;
    } completion:nil];
}

- (IBAction)loginOrRegister:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    [self hideErrorLabel];
    
    if ([self.accountTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showErrorMessage];
        });
        return;
    }
    
    [self appDelegate].registration = sender.tag ? YES : NO;
    
    [[self appDelegate] connectWithAccountName:self.accountTextField.text Password:self.passwordTextField.text ServerName:@"virus-found.local" Success:^(NSString *message) {
        NSLog(@"%@", message);
        
        CGFloat initialDelay = 0.5f;
        CGFloat i = 0;
        for (UIView *view in self.loginView.subviews) {
            [self transitionAnimationWithView:view delay:initialDelay + i];
            i += 0.1f;
        }
        [UIView animateWithDuration:0.25 delay:initialDelay + i options:0 animations:^{
            self.declarationTextField.alpha = 0;
            self.declarationTextField.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished)
         {
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             UITabBarController *tabBarController = [storyboard instantiateInitialViewController];
             [[self appDelegate].window setRootViewController:tabBarController];
         }];
        
    } Failure:^(NSString *message) {
        [self showErrorMessage];
    }];
}


- (void)transitionAnimationWithView:(UIView *)animatedView delay:(CGFloat)delayInterval
{
    [UIView animateWithDuration:0.25 delay:delayInterval options:0 animations:^{
        animatedView.alpha = 0;
        animatedView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:nil];
}



- (void)showErrorMessage
{
    POPSpringAnimation *positionXAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionXAnimation.velocity = @2000;
    positionXAnimation.springBounciness = 20;
    [self.loginButton.layer pop_addAnimation:positionXAnimation forKey:@"layerPositionXAnimation"];
    
    self.errorMessageLabel.layer.opacity = 1.0f;
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 18;
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    [self.errorMessageLabel.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleXYAnimation"];
    
    POPSpringAnimation *positionYAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionYAnimation.springBounciness = 12;
    positionYAnimation.toValue = @(self.loginButton.layer.position.y + self.loginButton.intrinsicContentSize.height);
    [self.errorMessageLabel.layer pop_addAnimation:positionYAnimation forKey:@"layerPositionYAnimation"];
    
    self.loginButton.userInteractionEnabled = YES;
    [self.activityIndicator stopAnimating];
}

- (void)hideErrorLabel
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    [self.errorMessageLabel.layer pop_addAnimation:scaleAnimation forKey:nil];
    
    POPBasicAnimation *positionYAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionYAnimation.toValue = @(self.loginButton.layer.position.y);
    [self.errorMessageLabel.layer pop_addAnimation:positionYAnimation forKey:nil];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.errorMessageLabel.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [self.activityIndicator startAnimating];
    }];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat translationDistance = self.view.bounds.size.height / translationDistanceFactor;
    self.loginView.transform = CGAffineTransformMakeTranslation(0, -translationDistance);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.loginView.transform = CGAffineTransformIdentity;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self loginOrRegister:self.loginButton];
    }

    return YES;
}


@end

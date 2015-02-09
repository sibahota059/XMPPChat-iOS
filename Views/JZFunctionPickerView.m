//
//  JZFunctionPickerView.m
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/28.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "JZFunctionPickerView.h"

@interface JZFunctionPickerView ()


@end

#define numberOfButton  1;
@implementation JZFunctionPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:252/255.0 blue:230/255.0 alpha:1.0];
        
        [self setupUI];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:252/255.0 blue:230/255.0 alpha:1.0];
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"FunctionPickerView_Photo"] forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 20, 44, 44);
    [button addTarget:self action:@selector(finishPicking:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 0;
    [self addSubview:button];
    
    UILabel *buttonTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(button.frame) + 4, 44, 18)];
    buttonTitle.text = @"相片";
    buttonTitle.textColor = [UIColor darkTextColor];
    buttonTitle.textAlignment = NSTextAlignmentCenter;
    buttonTitle.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:buttonTitle];
}

- (void)finishPicking:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(functionPickerView:didPickFunction:)]) {
        [self.delegate functionPickerView:self didPickFunction:(JZFunctionPickerViewFunctionType)sender.tag];
    }
}

@end

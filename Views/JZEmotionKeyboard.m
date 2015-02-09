//
//  JZEmotionKeyboard.m
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/27.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "JZEmotionKeyboard.h"

static unichar emotionCodeArray[28] =   // 编码大全 http://web.archive.org/web/20091030230412/http://pukupi.com/post/1964/
{
    0xe415,	0xe056, 0xe057, 0xe414, 0xe405,	0xe106, 0xe418,
    0xe417, 0xe40d, 0xe40a, 0xe404, 0xe105, 0xe409, 0xe40e,
    0xe402,	0xe108,	0xe403,	0xe058,	0xe407,	0xe401,	0xe40f,
    0xe40b,	0xe406,	0xe413,	0xe411,	0xe412,	0xe410,	0xe107,
};

@implementation JZEmotionKeyboard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:252/255.0 blue:230/255.0 alpha:1.0];
        
        [self setupEmotionButton];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:252/255.0 blue:230/255.0 alpha:1.0];
        
        [self setupEmotionButton];
    }
    
    return self;
}

- (void)setupEmotionButton
{
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 7; column++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            int index = 7 * row + column;
            
            if (index == 27) {   // 最后一个是删除按钮
                [button setImage:[UIImage imageNamed:@"EmotionView_Delete"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"EmotionView_DeleteHL"] forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(deleteEmotion) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(6 + 6 * 44, 20 + 3 * 44, 44, 44);
                [self addSubview:button];
                break;
            }
            
            [button setTitle:[NSString stringWithFormat:@"%C", emotionCodeArray[index]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pickEmotion:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(6 + column * 44, 20 + row * 44, 44, 44);
            [self addSubview:button];
        }
    }
}

- (void)pickEmotion:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(emotionKeyboard:didPickEmotion:)]) {
        [self.delegate emotionKeyboard:self didPickEmotion:sender.titleLabel.text];
    }
}

- (void)deleteEmotion
{
    if ([self.delegate respondsToSelector:@selector(emotionKeyboardDidDeleteEmotion:)]) {
        [self.delegate emotionKeyboardDidDeleteEmotion:self];
    }
}

@end

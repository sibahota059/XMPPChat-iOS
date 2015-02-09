//
//  JZEmotionKeyboard.h
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/27.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JZEmotionKeyboard;
@protocol JZEmotionKeyboardDelegate <NSObject>

- (void)emotionKeyboard:(JZEmotionKeyboard *)emotionKeyboard didPickEmotion:(NSString *)emotion;
- (void)emotionKeyboardDidDeleteEmotion:(JZEmotionKeyboard *)emotionKeyboard;

@end

@interface JZEmotionKeyboard : UIView

@property (nonatomic, weak) id <JZEmotionKeyboardDelegate> delegate;

@end

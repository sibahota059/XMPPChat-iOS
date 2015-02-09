//
//  JZFunctionPickerView.h
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/28.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    JZFunctionPickerViewFunctionTypePhoto,
} JZFunctionPickerViewFunctionType;

@class JZFunctionPickerView;
@protocol JZFunctionPickerViewDelegate <NSObject>

- (void)functionPickerView:(JZFunctionPickerView *)functionPickerView didPickFunction:(JZFunctionPickerViewFunctionType)type;

@end

@interface JZFunctionPickerView : UIView

@property (nonatomic, weak) id <JZFunctionPickerViewDelegate> delegate;

@end

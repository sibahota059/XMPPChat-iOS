//
//  UIImage+Joshua.h
//  走着
//
//  Created by Joshua Zhou on 14-9-29.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Joshua)

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name leftCapWidth:(CGFloat)widthFactor topCapHeight:(CGFloat)heightFactor;
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (instancetype)circleImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end

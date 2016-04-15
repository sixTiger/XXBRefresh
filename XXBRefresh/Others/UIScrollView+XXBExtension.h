//
//  UIScrollView+XXBExtension.h
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (XXBExtension)

@property (assign, nonatomic) CGFloat xxb_contentInsetTop;
@property (assign, nonatomic) CGFloat xxb_contentInsetBottom;
@property (assign, nonatomic) CGFloat xxb_contentInsetLeft;
@property (assign, nonatomic) CGFloat xxb_contentInsetRight;

@property (assign, nonatomic) CGFloat xxb_contentOffsetX;
@property (assign, nonatomic) CGFloat xxb_contentOffsetY;

@property (assign, nonatomic) CGFloat xxb_contentSizeWidth;
@property (assign, nonatomic) CGFloat xxb_contentSizeHeight;
@end

//
//  XXBRefreshConsts.h
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

// objc_msgSend
#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define msgTarget(target) (__bridge void *)(target)
/**
 *  刷新控件的边距
 */
UIKIT_EXTERN const CGFloat XXBRefreshMarginInset;

/**
 *  控件之间的边距
 */
UIKIT_EXTERN const CGFloat XXBRefreshMarginView;

/**
 *  刷新控件的默认高度
 */
UIKIT_EXTERN const CGFloat XXBRefreshViewHeight;

/**
 *  默认动画时间
 */
UIKIT_EXTERN const CGFloat XXBRefreshAnimationDuration;

/**
 *  比较慢的动画时间
 */
UIKIT_EXTERN const CGFloat XXBRefreshAnimationDurationSlow;

/**
 *  contentOffset
 */
UIKIT_EXTERN NSString *const XXBRefreshContentOffset;

/**
 *  contentSize
 */
UIKIT_EXTERN NSString *const XXBRefreshContentSize;


/**
 *  下拉刷新
 */
UIKIT_EXTERN NSString *const XXBRefreshDropDown;
/**
 *  上拉刷新
 */
UIKIT_EXTERN NSString *const XXBRefreshDropUp;
/**
 *  松开刷新
 */
UIKIT_EXTERN NSString *const XXBRefreshDropEnd;
/**
 *  正在刷新
 */
UIKIT_EXTERN NSString *const XXBRefreshing;





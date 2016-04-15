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
 *  刷新控件的默认高度
 */
UIKIT_EXTERN const CGFloat XXBRefreshViewHeight;
UIKIT_EXTERN const CGFloat XXBRefreshAnimationDuration;
UIKIT_EXTERN const CGFloat XXBRefreshAnimationDurationSlow;
UIKIT_EXTERN NSString *const XXBRefreshContentOffset;
UIKIT_EXTERN NSString *const XXBRefreshContentSize;

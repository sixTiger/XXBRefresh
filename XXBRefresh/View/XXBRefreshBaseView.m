//
//  XXBRefreshBaseView.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBRefreshBaseView.h"
#import "XXBRefreshConsts.h"
#import "UIView+XXBExtension.h"

@interface XXBRefreshBaseView ()

@end

@implementation XXBRefreshBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

/**
 *  初始化数据
 */
- (void)_init {
    self.refreshState = XXBRefreshStateDefault;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self.superview removeObserver:self forKeyPath:XXBRefreshContentOffset context:nil];
    if (newSuperview) { // 新的父控件
        
        [newSuperview addObserver:self forKeyPath:XXBRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        self.xxb_width = newSuperview.xxb_width;
        _scrollView = (UIScrollView *)newSuperview;
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

- (void)willRemoveSubview:(UIView *)subview {
    [self.superview removeObserver:self forKeyPath:XXBRefreshContentOffset context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
}

- (void)beginRefreshing {
    if (self.refreshState == XXBRefreshStateRefreshing) {
        // 回调
        if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
            msgSend(msgTarget(self.beginRefreshingTaget), self.beginRefreshingAction, self);
        }
        
    } else {
        if (self.window) {
            self.refreshState = XXBRefreshStateRefreshing;
        } else {
            _refreshState = XXBRefreshStateWillRefreshing;
            [self setNeedsDisplay];
        }
    }
    
}

- (void)endRefreshing {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(XXBRefreshAnimationDuration * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.refreshState = XXBRefreshStateDefault;
    });
}

- (void)setRefreshState:(XXBRefreshState)refreshState {
    
    if (_refreshState == refreshState) {
        return;
    }
    
    if (_refreshState != XXBRefreshStateRefreshing) {
        _scrollViewOriginalInset = self.scrollView.contentInset;
    }
    
    _refreshState = refreshState;
    switch (refreshState) {
        case XXBRefreshStateDefault: {
            break;
        }
            
        case XXBRefreshStatePulling: {
            break;
        }
            
        case XXBRefreshStateRefreshing: {
            // 回调
            if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
                msgSend(msgTarget(self.beginRefreshingTaget), self.beginRefreshingAction, self);
            }
            break;
        }
        default:
            break;
    }
}
@end

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
        [self prepare];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self prepare];
    }
    return self;
}

- (void)prepare {
    self.refreshState = XXBRefreshStateDefault;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self _removeObserber];
    if (newSuperview) { // 新的父控件
        self.xxb_x = 0;
        self.xxb_width = newSuperview.xxb_width;
        _scrollView = (UIScrollView *)newSuperview;
        _scrollViewOriginalInset = _scrollView.contentInset;
        [self _addObserver];
    }
}

- (void)_addObserver {
    [self.scrollView addObserver:self forKeyPath:XXBRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:XXBRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
}

- (void)_removeObserber {
    [self.superview removeObserver:self forKeyPath:XXBRefreshContentOffset];
    [self.superview removeObserver:self forKeyPath:XXBRefreshContentSize];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) {
        return;
    }
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:XXBRefreshContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    if (self.hidden) {
        return;
    }
    if ([keyPath isEqualToString:XXBRefreshContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)beginRefreshing {
    if (self.refreshState == XXBRefreshStateRefreshing) {
        // 回调
        if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
            msgSend(msgTarget(self.beginRefreshingTaget), self.beginRefreshingAction, self);
        }
        
    } else {
        
        self.refreshState = XXBRefreshStateStartWillShow;
        self.refreshState = XXBRefreshStateWillRefreshing;
        if (self.window) {
            self.refreshState = XXBRefreshStateRefreshing;
        } else {
            [self setNeedsDisplay];
        }
    }
    
}

- (void)endRefreshing {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(XXBRefreshAnimationDuration * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.refreshState = XXBRefreshStateEndRefreshing;
    });
}

- (void)setRefreshState:(XXBRefreshState)refreshState {
    
    if (_refreshState == refreshState) {
        return;
    }
    _refreshState = refreshState;
    
    if (_refreshState == XXBRefreshStateRefreshing) {
        _scrollViewOriginalInset = self.scrollView.contentInset;
    }
    switch (refreshState) {
        case XXBRefreshStateDefault: {
            break;
        }
        case XXBRefreshStatePulling: {
            break;
        }
        case XXBRefreshStateRefreshing: {
            if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
                msgSend(msgTarget(self.beginRefreshingTaget), self.beginRefreshingAction, self);
            }
            break;
        }
        default:
            break;
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    self.xxb_x = 0;
    self.xxb_width = self.superview.xxb_width;
}
@end

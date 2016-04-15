//
//  XXBRefreshHeaderView.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBRefreshHeaderView.h"

@implementation XXBRefreshHeaderView

+ (instancetype)headerView {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, XXBRefreshViewHeight, XXBRefreshViewHeight)];
}

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

- (void)_init {
    
    self.backgroundColor = [UIColor yellowColor];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    // 不能跟用户交互就直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    if ([XXBRefreshContentOffset isEqualToString:keyPath]) {
        // 如果正在刷新，直接返回
        if (self.refreshState == XXBRefreshStateRefreshing) {
            return;
        }
        [self _adjustStateWithContentOffset];
    }
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    self.xxb_y -= self.xxb_height;
    if (self.allowContentInset) {
        self.xxb_y -= self.scrollView.xxb_contentInsetTop;
    }
}

/**
 *  调整状态
 */
- (void)_adjustStateWithContentOffset {
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.xxb_contentOffsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    // 如果是向上滚动到看不见头部控件，直接返回
    if (currentOffsetY >= happenOffsetY) {
        return;
    }
    
    if (self.scrollView.isDragging) {
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY - self.xxb_height;
        if (self.refreshState == XXBRefreshStateDefault && currentOffsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.refreshState = XXBRefreshStatePulling;
        } else {
            if (self.refreshState == XXBRefreshStatePulling && currentOffsetY >= normal2pullingOffsetY) {
                // 转为普通状态
                self.refreshState = XXBRefreshStateDefault;
            }
        }
    } else {
        if (self.refreshState == XXBRefreshStatePulling) {
            // 即将刷新 && 手松开
            // 开始刷新
            self.refreshState = XXBRefreshStateRefreshing;
        }
    }
}

- (void)setRefreshState:(XXBRefreshState)refreshState {
    // 1.一样的就直接返回
    if (self.refreshState == refreshState) {
        return;
    }
    // 2.保存旧状态
    XXBRefreshState oldState = self.refreshState;
    // 3.调用父类方法
    [super setRefreshState:refreshState];
    // 4.根据状态执行不同的操作
    switch (refreshState) {
        case XXBRefreshStateDefault: {
            // 下拉可以刷新
            // 刷新完毕
            if (XXBRefreshStateRefreshing == oldState) {
                [UIView animateWithDuration:XXBRefreshAnimationDurationSlow animations:^{
                    self.scrollView.xxb_contentInsetTop -= self.xxb_height;
                }];
            } else {
                
            }
            break;
        }
        case XXBRefreshStatePulling: {
            // 松开可立即刷新
            break;
        }
        case XXBRefreshStateRefreshing: {
            // 正在刷新中
            // 执行动画
            [UIView animateWithDuration:XXBRefreshAnimationDuration animations:^{
                // 1.增加滚动区域
                CGFloat top = self.scrollViewOriginalInset.top + self.xxb_height;
                self.scrollView.xxb_contentInsetTop = top;
                
                // 2.设置滚动位置
                self.scrollView.xxb_contentOffsetY = - top;
            }];
            break;
        }
        default:
            break;
    }
}
@end

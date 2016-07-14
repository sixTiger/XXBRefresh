//
//  XXBRefreshHeaderView.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBRefreshHeaderView.h"

@interface XXBRefreshHeaderView ()
@property (assign, nonatomic) CGFloat   insetTDelta;
@end

@implementation XXBRefreshHeaderView

+ (instancetype)headerView {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, XXBRefreshViewHeight, XXBRefreshViewHeight)];
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    XXBRefreshHeaderView *header = [self headerView];
    header.beginRefreshingTaget = target;
    header.beginRefreshingAction = action;
    return header;
}

- (void)prepare {
    [super prepare];
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
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    if (self.refreshState == XXBRefreshStateRefreshing) {
        if (self.window == nil) {
            return;
        }
        // sectionheader停留解决
        CGFloat insetTop = MAX(- self.scrollView.xxb_contentOffsetY, self.scrollViewOriginalInset.top);
        insetTop = MIN(insetTop, self.xxb_height + self.scrollViewOriginalInset.top);
        self.scrollView.xxb_contentInsetTop = insetTop;
        self.insetTDelta = self.scrollViewOriginalInset.top - insetTop;
        return;
    }
    self.scrollViewOriginalInset = self.scrollView.contentInset;
    CGFloat currentOffsetY = self.scrollView.xxb_contentOffsetY;
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    if (currentOffsetY >= happenOffsetY) {
        return;
    } else {
        if (!self.show && self.scrollView.isDragging) {
            self.show = YES;
            self.refreshState = XXBRefreshStateStartWillShow;
            self.refreshState = XXBRefreshStateDefault;
        }
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
            self.refreshState = XXBRefreshStateWillRefreshing;
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
    // 2.调用父类方法
    [super setRefreshState:refreshState];
    // 3.根据状态执行不同的操作
    switch (refreshState) {
        case XXBRefreshStateDefault:
        {
            break;
        }
        case XXBRefreshStatePulling:
        {
            // 松开可立即刷新
            break;
        }
        case XXBRefreshStateRefreshing:
        {
            NSLog(@"++");
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
        case XXBRefreshStateEndRefreshing:
        {
            __weak typeof(self) weakSelf = self;
            self.scrollView.scrollEnabled = NO;
            [UIView animateWithDuration:XXBRefreshAnimationDurationSlow animations:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.scrollView.xxb_contentInsetTop -= self.xxb_height;
            } completion:^(BOOL finished) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.show = NO;
                strongSelf.refreshState = XXBRefreshStateStartWillHiden;
                strongSelf.refreshState = XXBRefreshStateDefault;
                strongSelf.scrollView.scrollEnabled = YES;
            }];
                    
            
            
//            self.scrollView.scrollEnabled = NO;
//            [UIView animateWithDuration:XXBRefreshAnimationDurationSlow animations:^{
//                __strong typeof(weakSelf) strongSelf = weakSelf;
//                [strongSelf.scrollView setContentOffset:CGPointZero];
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:XXBRefreshAnimationDurationSlow animations:^{
//                    __strong typeof(weakSelf) strongSelf = weakSelf;
//                    strongSelf.scrollView.xxb_contentInsetTop -= self.xxb_height;
//                } completion:^(BOOL finished) {
//                    __strong typeof(weakSelf) strongSelf = weakSelf;
//                    strongSelf.show = NO;
//                    strongSelf.refreshState = XXBRefreshStateStartWillHiden;
//                    strongSelf.refreshState = XXBRefreshStateDefault;
//                    strongSelf.scrollView.scrollEnabled = YES;
//                }];
//                
//            }];
            
            break;
        }
        default:
            break;
    }
}
@end

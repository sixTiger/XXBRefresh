//
//  XXBAutoRefreshFooterView.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/25.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBAutoRefreshFooterView.h"

@interface XXBAutoRefreshFooterView ()
@property (assign, nonatomic) NSInteger         lastRefreshCount;
@end

@implementation XXBAutoRefreshFooterView

+ (instancetype)footerView {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
}

- (void)prepare {
    _autoCallRefresh = YES;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        // 新的父控件
        [newSuperview addObserver:self forKeyPath:XXBRefreshKeyPathPanState options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
        // 监听
        [newSuperview addObserver:self forKeyPath:XXBRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
        // 重新调整frame
        if (self.hidden == NO) {
            self.scrollView.xxb_contentInsetBottom += self.xxb_height;
        }
        [self _adjustFrameWithContentSize];
        
    } else {
        // 被移除了
        if (self.hidden == NO) {
            self.scrollView.xxb_contentInsetBottom -= self.xxb_height;
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([XXBRefreshContentSize isEqualToString:keyPath]) {
        [self _adjustFrameWithContentSize];
    } else if ([XXBRefreshContentOffset isEqualToString:keyPath]) {
        if (self.refreshState == XXBRefreshStateRefreshing) {
            return;
        }
        [self _adjustStateWithContentOffset:change];
    } else if([XXBRefreshKeyPathPanState isEqualToString:keyPath]) {
        [self _scrollViewPanStateDidChange:change];
    }
}

- (void)_adjustFrameWithContentSize {
    self.xxb_y = self.scrollView.xxb_contentSizeHeight;
}
/**
 *  调整状态
 */
- (void)_adjustStateWithContentOffset:(NSDictionary *)change {
    if (self.scrollView.xxb_contentInsetTop + self.scrollView.xxb_contentSizeHeight > self.scrollView.xxb_height) { // 内容超过一个屏幕
        if (self.scrollView.xxb_contentOffsetY >= self.scrollView.xxb_contentSizeHeight - self.scrollView.xxb_height + self.scrollView.xxb_contentInsetBottom - self.triggerAutoRefreshMarginBottom) {
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) {
                return;
            }
            NSLog(@"%@ >>> %@ >>> %@",@(self.scrollView.xxb_contentOffsetY),@(self.scrollView.xxb_contentSizeHeight),@(self.xxb_height));
            [self beginRefreshing];
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
                
            }
            CGFloat deltaH = [self heightForContentBreakView];
            // 刚刷新完毕
            NSInteger currentCount = [self totalDataCountInScrollView];
            if (XXBRefreshStateRefreshing == oldState && deltaH > 0 && currentCount == self.lastRefreshCount) {
                [UIView animateWithDuration:XXBRefreshAnimationDurationSlow animations:^{
                    self.scrollView.xxb_contentOffsetY = self.scrollView.xxb_contentOffsetY - self.xxb_height;
                }];
            }
            break;
        }
        case XXBRefreshStatePulling: {
            // 松开可立即刷新
            break;
        }
        case XXBRefreshStateRefreshing: {
            break;
        }
        default:
            break;
    }
    
}
- (void)_scrollViewPanStateDidChange:(NSDictionary *)change
{
    if (self.refreshState != XXBRefreshStateDefault)
        return;
    
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if (self.scrollView.xxb_contentInsetTop + self.scrollView.xxb_contentSizeHeight <= self.scrollView.xxb_height) {  // 不够一个屏幕
            if (self.scrollView.xxb_contentOffsetY >= - self.scrollView.xxb_contentInsetTop) { // 向上拽
                [self beginRefreshing];
            }
        } else { // 超出一个屏幕
            if (self.scrollView.xxb_contentOffsetY >= self.scrollView.xxb_contentSizeHeight + self.scrollView.xxb_contentInsetBottom - self.scrollView.xxb_height) {
                [self beginRefreshing];
            }
        }
    }
}
- (NSInteger)totalDataCountInScrollView
{
    NSInteger totalCount = 0;
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}
@end

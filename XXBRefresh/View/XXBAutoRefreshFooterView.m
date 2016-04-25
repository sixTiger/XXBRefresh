//
//  XXBAutoRefreshFooterView.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/25.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBAutoRefreshFooterView.h"

@implementation XXBAutoRefreshFooterView

- (void)prepare {
    _autoCallRefresh = YES;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [newSuperview addObserver:self forKeyPath:XXBRefreshKeyPathPanState options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
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
    CGFloat contentHeight = self.scrollView.xxb_contentSizeHeight ;
    CGFloat scrollHeight = self.scrollView.xxb_height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.scrollView.xxb_contentInsetBottom;
    // 设置位置和尺寸
    self.xxb_y = MAX(contentHeight, scrollHeight);
    if (self.allowContentInset) {
        self.xxb_y += self.scrollViewOriginalInset.bottom;
    }
}
/**
 *  调整状态
 */
- (void)_adjustStateWithContentOffset:(NSDictionary *)change {
    CGFloat currentOffsetY = self.scrollView.xxb_contentOffsetY;
    CGFloat happenOffsetY = [self happenOffsetY];
    if (self.scrollView.isDragging) {
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + self.xxb_height;
        
        if (self.refreshState == XXBRefreshStateDefault && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.refreshState = XXBRefreshStatePulling;
        } else if (self.refreshState == XXBRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.refreshState = XXBRefreshStateDefault;
        }
    } else{
        if (self.refreshState == XXBRefreshStatePulling) {// 即将刷新 && 手松开
            // 开始刷新
            self.refreshState = XXBRefreshStateRefreshing;
        }
    }
    
    if (self.refreshState != XXBRefreshStateDefault || !self.autoCallRefresh || self.xxb_y == 0) {
        return;
    }
    
    if (self.scrollView.xxb_contentInsetTop + self.scrollView.xxb_contentSizeHeight > self.scrollView.xxb_height) { // 内容超过一个屏幕
        if (self.scrollView.xxb_contentOffsetY >= self.scrollView.xxb_contentSizeHeight - self.scrollView.xxb_height + self.scrollView.xxb_contentInsetBottom + self.xxb_height - self.triggerAutoRefreshMarginBottom) {
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

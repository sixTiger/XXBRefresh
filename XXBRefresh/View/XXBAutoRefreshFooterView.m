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
    return [[self alloc] initWithFrame:CGRectMake(0, 0, XXBRefreshViewHeight, XXBRefreshViewHeight)];
}

- (void)prepare {
    _autoCallRefresh = YES;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        // 重新调整frame
        if (self.hidden == NO) {
            self.scrollView.xxb_contentInsetBottom += self.xxb_height;
        }
        [self scrollViewContentSizeDidChange:nil];
        
    } else {
        // 被移除了
        if (self.hidden == NO) {
            self.scrollView.xxb_contentInsetBottom -= self.xxb_height;
        }
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    self.xxb_y = self.scrollView.xxb_contentSizeHeight;
}
/**
 *  调整状态
 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    if (self.refreshState == XXBRefreshStateRefreshing) {
        return;
    }
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
                    self.scrollView.xxb_contentOffsetY = self.scrollView.xxb_contentSizeHeight - self.scrollView.xxb_height;
                }];
            }
            break;
        }
        case XXBRefreshStatePulling: {
            // 松开可立即刷新
            break;
        }
        case XXBRefreshStateRefreshing: {
            self.lastRefreshCount = [self totalDataCountInScrollView];
            break;
        }
        default:
            break;
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

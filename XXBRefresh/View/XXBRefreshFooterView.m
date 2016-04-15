//
//  XXBRefreshFooterView.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBRefreshFooterView.h"

@interface XXBRefreshFooterView ()
@property (assign, nonatomic) NSInteger         lastRefreshCount;
@end

@implementation XXBRefreshFooterView
+ (instancetype)footerView {
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
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) {
        return;
    }
    if ([XXBRefreshContentSize isEqualToString:keyPath]) {
        [self _adjustFrameWithContentSize];
    } else if ([XXBRefreshContentOffset isEqualToString:keyPath]) {
        if (self.refreshState == XXBRefreshStateRefreshing) {
            return;
        }
        [self _adjustStateWithContentOffset];
    }
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:XXBRefreshContentSize context:nil];
    if (newSuperview) {
        // 监听
        [newSuperview addObserver:self forKeyPath:XXBRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
        // 重新调整frame
        [self _adjustFrameWithContentSize];
    }
    
}

- (void)willRemoveSubview:(UIView *)subview {
    [super willRemoveSubview:subview];
    [self.superview removeObserver:self forKeyPath:XXBRefreshContentSize context:nil];
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
- (void)_adjustStateWithContentOffset {
    CGFloat currentOffsetY = self.scrollView.xxb_contentOffsetY;
    CGFloat happenOffsetY = [self happenOffsetY];
    if (currentOffsetY <= happenOffsetY){
        return;
    }
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
                    self.scrollView.xxb_contentInsetBottom = self.scrollViewOriginalInset.bottom;
                }];
            } else {
                
            }
            
            CGFloat deltaH = [self heightForContentBreakView];
            NSInteger currentCount = [self totalDataCountInScrollView];
            // 刚刷新完毕
            if (XXBRefreshStateRefreshing == oldState && deltaH > 0 && currentCount != self.lastRefreshCount) {
                self.scrollView.xxb_contentOffsetY = self.scrollView.xxb_contentOffsetY;
            }
            break;
        }
        case XXBRefreshStatePulling: {
            // 松开可立即刷新
            break;
        }
        case XXBRefreshStateRefreshing: {
            // 正在刷新中
            // 记录刷新前的数量
            self.lastRefreshCount = [self totalDataCountInScrollView];
            
            [UIView animateWithDuration:XXBRefreshAnimationDuration animations:^{
                CGFloat bottom = self.xxb_height + self.scrollViewOriginalInset.bottom;
                CGFloat deltaH = [self heightForContentBreakView];
                if (deltaH < 0) { // 如果内容高度小于view的高度
                    bottom -= deltaH;
                }
                self.scrollView.xxb_contentInsetBottom = bottom;
            }];
            
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

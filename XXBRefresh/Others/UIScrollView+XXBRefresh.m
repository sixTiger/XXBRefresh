//
//  UIScrollView+XXBRefresh.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "UIScrollView+XXBRefresh.h"
#import "XXBRefreshHeaderUIView.h"
#import "XXBRefreshFooterUIView.h"
#import <objc/runtime.h>

@implementation UIScrollView (XXBRefresh)

#pragma mark - 运行时相关
static char XXBRefreshHeaderViewKey;
static char XXBRefreshFooterViewKey;


- (void)setHeader:(XXBRefreshBaseView *)header {
    if(self.header == header) {
        return;
    }
    
    if ( header.beginRefreshingTaget == nil || header.beginRefreshingAction == nil) {
        header.beginRefreshingAction = self.header.beginRefreshingAction;
        header.beginRefreshingTaget = self.header.beginRefreshingTaget;
    }
    
    [self.header removeFromSuperview];
    [self willChangeValueForKey:@"XXBRefreshHeaderViewKey"];
    objc_setAssociatedObject(self, &XXBRefreshHeaderViewKey,
                             header,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"XXBRefreshHeaderViewKey"];
    [self addSubview:header];
}

- (XXBRefreshBaseView *)header {
    return objc_getAssociatedObject(self, &XXBRefreshHeaderViewKey);
}

- (void)setFooter:(XXBRefreshBaseView *)footer {
    if(self.footer == footer) {
        return;
    }
    if ( footer.beginRefreshingTaget == nil || footer.beginRefreshingAction == nil) {
        footer.beginRefreshingAction = self.footer.beginRefreshingAction;
        footer.beginRefreshingTaget = self.footer.beginRefreshingTaget;
    }
    [self.footer removeFromSuperview];
    [self willChangeValueForKey:@"XXBRefreshFooterViewKey"];
    objc_setAssociatedObject(self, &XXBRefreshFooterViewKey,
                             footer,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"XXBRefreshFooterViewKey"];
    [self insertSubview:footer atIndex:0];
}

- (XXBRefreshBaseView *)footer {
    return objc_getAssociatedObject(self, &XXBRefreshFooterViewKey);
}

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action {
    if(self.header == nil) {
        XXBRefreshHeaderView *refreshHeaderView = [XXBRefreshHeaderUIView headerView];
        [self addSubview:refreshHeaderView];
        self.header = refreshHeaderView;
    }
    self.header.beginRefreshingTaget = target;
    self.header.beginRefreshingAction = action;
}

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader {
    [self.header removeFromSuperview];
    self.header = nil;
}

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing {
    [self.header beginRefreshing];
}

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing {
    [self.header endRefreshing];
}

/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addFooterWithTarget:(id)target action:(SEL)action {
    if(self.footer == nil) {
        XXBRefreshFooterUIView *refreshFooterView = [XXBRefreshFooterUIView footerView];
        [self addSubview:refreshFooterView];
        self.footer = refreshFooterView;
    }
    self.footer.beginRefreshingTaget = target;
    self.footer.beginRefreshingAction = action;
}

/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter {
    [self.footer removeFromSuperview];
    self.footer = nil;
}

/**
 *  主动让上拉刷新尾部控件进入刷新状态
 */
- (void)footerBeginRefreshing {
    [self.footer beginRefreshing];
}

/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)footerEndRefreshing {
    [self.footer endRefreshing];
}
@end

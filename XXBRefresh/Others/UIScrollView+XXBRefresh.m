//
//  UIScrollView+XXBRefresh.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "UIScrollView+XXBRefresh.h"
#import "XXBRefreshBaseView.h"
#import "XXBRefreshHeaderView.h"
#import <objc/runtime.h>

@interface UIScrollView ()

@property (weak, nonatomic) XXBRefreshHeaderView    *header;
@property (weak, nonatomic) XXBRefreshBaseView      *footer;
@end

@implementation UIScrollView (XXBRefresh)

#pragma mark - 运行时相关
static char XXBRefreshHeaderViewKey;
static char XXBRefreshFooterViewKey;


- (void)setHeader:(XXBRefreshBaseView *)header {
    [self willChangeValueForKey:@"XXBRefreshHeaderViewKey"];
    objc_setAssociatedObject(self, &XXBRefreshHeaderViewKey,
                             header,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"XXBRefreshHeaderViewKey"];
}

- (XXBRefreshBaseView *)header {
    return objc_getAssociatedObject(self, &XXBRefreshHeaderViewKey);
}
- (void)setFooter:(XXBRefreshBaseView *)footer {
    [self willChangeValueForKey:@"XXBRefreshFooterViewKey"];
    objc_setAssociatedObject(self, &XXBRefreshFooterViewKey,
                             footer,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"XXBRefreshFooterViewKey"];
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
    
    [self addHeaderWithTarget:target action:action dateKey:nil];
}

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 *  @param dateKey 刷新时间保存的key值
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action dateKey:(NSString*)dateKey {
    if(self.header == nil) {
        XXBRefreshHeaderView *refreshHeaderView = [XXBRefreshHeaderView headerView];
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
@end

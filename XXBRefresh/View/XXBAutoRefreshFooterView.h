//
//  XXBAutoRefreshFooterView.h
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/25.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBRefreshBaseView.h"

@interface XXBAutoRefreshFooterView : XXBRefreshBaseView

/**
 *  是否自动刷新 默认是Yes
 */
@property(nonatomic , assign) BOOL      autoCallRefresh;

/**
 *  footer距离底部多少的时候开始刷新  默认是footer 完全现实的时候
 */
@property (assign, nonatomic) CGFloat   triggerAutoRefreshMarginBottom;

NS_ASSUME_NONNULL_BEGIN

/**
 *  快速创建一个 autoRefreshFooter
 *
 *  @return autoRefreshFooter
 */
+ (instancetype)autoRefreshFooter;

/**
 *  快速创建一个autoRefreshFooter
 *
 *  @param target 回调的对象
 *  @param action 回调的事件
 *
 *  @return 创建好的autoRefreshFooter
 */
+ (instancetype)autoRefreshFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
NS_ASSUME_NONNULL_END
@end

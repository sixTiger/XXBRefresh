//
//  XXBRefreshHeaderView.h
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

/**
 *  负责下拉刷新的逻辑处理
 */
#import "XXBRefreshBaseView.h"

@interface XXBRefreshHeaderView : XXBRefreshBaseView
NS_ASSUME_NONNULL_BEGIN

/**
 *  快速创建一个Header
 *
 *  @return 创建好的Header
 */
+ (instancetype)headerView;

/**
 *  快速创建一个Header
 *
 *  @param target 回调的对象
 *  @param action 回调的事件
 *
 *  @return 创建好的header
 */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
NS_ASSUME_NONNULL_END
@end

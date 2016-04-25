//
//  XXBRefreshFooterView.h
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBRefreshBaseView.h"

@interface XXBRefreshFooterView : XXBRefreshBaseView

NS_ASSUME_NONNULL_BEGIN

/**
 *  快速创建一个footerView
 *
 *  @return 创建好的footerView
 */
+ (instancetype)footerView;


/**
 *  快速创建一个footerView
 *
 *  @param target 回调的对象
 *  @param action 回调的事件
 *
 *  @return 创建好的footerView
 */
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
NS_ASSUME_NONNULL_END
@end

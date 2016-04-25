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

+ (instancetype)footerView;
@end

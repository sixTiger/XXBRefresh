//
//  XXBRefreshBaseView.h
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBRefreshConsts.h"
#import "UIView+XXBExtension.h"
#import "UIScrollView+XXBExtension.h"

typedef enum {
    XXBRefreshStateDefault,         //默认状态
    XXBRefreshStatePulling ,        //松开就可以进入刷新状态
    XXBRefreshStateRefreshing,      //正在刷新状态
    XXBRefreshStateWillRefreshing   //即将刷新状态
} XXBRefreshState;


@interface XXBRefreshBaseView : UIView

/**
 *  开始进入刷新状态的监听器
 */
@property (weak, nonatomic) id                              beginRefreshingTaget;

/**
 *  开始进入刷新状态的监听方法
 */
@property (assign, nonatomic) SEL                           beginRefreshingAction;

/**
 *  当前的刷新状态
 */
@property(nonatomic, assign) XXBRefreshState                refreshState;

/**
 *  是否正在刷新
 */
@property (nonatomic, readonly, getter=isRefreshing) BOOL   refreshing;


/**
 *  是否允许刷新空间和scrollview之间有间隔(默认不允许）
 *  ps：tableView的cell个数比较少但是依然想要上拉加载更多的时候为了避免footer紧挨着最后的一个cell 
 *  可以将这个属性设置YES
 */
@property(nonatomic , assign) BOOL                          allowContentInset;

@property (nonatomic, weak, readonly) UIScrollView          *scrollView;
@property (nonatomic, assign, readonly) UIEdgeInsets        scrollViewOriginalInset;
/**
 *  开始刷新
 */
- (void)beginRefreshing;
/**
 *  结束刷新
 */
- (void)endRefreshing;

/**
 *  检测 UIScrollView 的 contentoffset 的变化 并且回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context;
@end

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
#import "XXBRefreshRseources.h"

typedef enum {
    XXBRefreshStateDefault,         //默认状态
    XXBRefreshStatePulling ,        //松开就可以进入刷新状态
    XXBRefreshStateRefreshing,      //正在刷新状态
    XXBRefreshStateWillRefreshing,  //即将刷新状态
    XXBRefreshStateEndRefreshing,   //刷新结束
    XXBRefreshStateStartWillShow,   //将要显示
    XXBRefreshStateStartWillHiden,  //将要消失
} XXBRefreshState;


@interface XXBRefreshBaseView : UIView {
    XXBRefreshState         _refreshState;
}

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
@property (nonatomic, assign) UIEdgeInsets                  scrollViewOriginalInset;

/**
 *  是否正在显示
 */
@property (assign, nonatomic) BOOL                          show;

/**
 *  预设相关属性
 */
- (void)prepare NS_REQUIRES_SUPER;

/**
 *  开始刷新
 */
- (void)beginRefreshing NS_REQUIRES_SUPER;

/**
 *  结束刷新
 */
- (void)endRefreshing NS_REQUIRES_SUPER;

/**
 *  KVO方式检测scrollView的相关属性的变化
 *
 *  默认监听scrollview的contentoffset
 *
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context NS_REQUIRES_SUPER;


/**
 *  @param change 当scrollView的contentOffset发生改变的时候调用
 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;

/**
 *  @param change 当scrollView的contentOffset发生改变的时候调用
 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;

@end

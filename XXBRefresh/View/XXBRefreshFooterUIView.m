//
//  XXBRefreshFooterUIView.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/7/13.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBRefreshFooterUIView.h"


@interface XXBRefreshFooterUIView ()
{
    //    UILabel *_messageLabel;
    NSDate  *_lastUpdateTime;
}
@property(nonatomic ,weak) UILabel                  *messageLabel;
@property(nonatomic ,weak) UIActivityIndicatorView  *activityIndicatorView;
@property(nonatomic ,weak) UIImageView              *activityImageView;

/**
 *  上次更新的时间
 */
@property (nonatomic, strong) NSDate                *lastUpdateTime;
@end

@implementation XXBRefreshFooterUIView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.messageLabel sizeToFit];
    self.messageLabel.xxb_x = XXBRefreshMarginInset;
    self.messageLabel.xxb_y = XXBRefreshMarginInset;
    self.messageLabel.xxb_width = self.xxb_width - 2 * XXBRefreshMarginInset;
    self.messageLabel.center = CGPointMake(self.xxb_width * 0.5, self.xxb_height * 0.5);
    self.activityImageView.xxb_x = XXBRefreshMarginInset ;
    self.activityImageView.xxb_y = (self.xxb_height - self.activityImageView.xxb_height) * 0.5;
    self.activityIndicatorView.frame = self.activityImageView.frame;
    
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = [UIColor grayColor];
        messageLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:messageLabel];
        _messageLabel = messageLabel;
    }
    return _messageLabel;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:activityIndicatorView];
        activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView = activityIndicatorView;
    }
    return _activityIndicatorView;
}

- (UIImageView *)activityImageView {
    if (_activityImageView == nil) {
        UIImageView *activityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        activityImageView.image = [XXBRefreshRseources imageNamed:@"arrow" withExtension:@"png"];
        activityImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:activityImageView];
        _activityImageView = activityImageView;
        
    }
    return _activityImageView;
}

- (void)setRefreshState:(XXBRefreshState)refreshState {
    [super setRefreshState:refreshState];
    switch (refreshState) {
        case XXBRefreshStateDefault:
        {
            [self.activityIndicatorView stopAnimating];
            self.messageLabel.text = XXBRefreshDropUp;
            // 执行动画
            [UIView animateWithDuration:XXBRefreshAnimationDuration animations:^{
                self.activityImageView.transform = CGAffineTransformMakeRotation(M_PI);
                self.activityImageView.alpha = 1.0;
            }];
            break;
        }
        case XXBRefreshStatePulling:
        {
            [self.activityIndicatorView stopAnimating];
            self.messageLabel.text = XXBFooterRefreshDropEnd;
            // 执行动画
            [UIView animateWithDuration:XXBRefreshAnimationDuration animations:^{
                self.activityImageView.transform = CGAffineTransformIdentity;
            }];
            break;
        }
        case XXBRefreshStateRefreshing:
        {
            [UIView animateWithDuration:XXBRefreshAnimationDuration animations:^{
                self.activityImageView.alpha = 0.0;
            }];
            [self.activityIndicatorView startAnimating];
            self.messageLabel.text = XXBFooterRefreshing;
            break;
        }
        case XXBRefreshStateEndRefreshing:
        {
            [UIView animateWithDuration:XXBRefreshAnimationDuration animations:^{
                self.activityImageView.alpha = 1.0;
            }];
            [self.activityIndicatorView startAnimating];
            self.messageLabel.text = XXBFooterRefreshDropEnd;
            break;
        }
        case XXBRefreshStateWillRefreshing:
        {
            [self.activityIndicatorView stopAnimating];
            self.messageLabel.text = XXBFooterRefreshDropEnd;
            break;
        }
        case XXBRefreshStateStartWillShow:
        {
            [self.activityIndicatorView stopAnimating];
            self.messageLabel.text = XXBRefreshDropUp;
            break;
        }
        case XXBRefreshStateStartWillHiden:
        {
            [self.activityIndicatorView stopAnimating];
            self.messageLabel.text = XXBRefreshDropUp;
            break;
        }
            
        default:
        {
            [self.activityIndicatorView stopAnimating];
            self.messageLabel.text = XXBRefreshDropUp;
        }
            break;
    }
    [self layoutIfNeeded];
}

@end

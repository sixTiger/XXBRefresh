//
//  XXBAutoRefreshFooterUIView.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/7/13.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBAutoRefreshFooterUIView.h"

@interface XXBAutoRefreshFooterUIView ()
@property (weak, nonatomic) UILabel                 *messageLabel;
@property(nonatomic ,weak) UIActivityIndicatorView  *activityIndicatorView;
@end
@implementation XXBAutoRefreshFooterUIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.activityIndicatorView.xxb_x = XXBRefreshMarginInset;
    self.activityIndicatorView.xxb_y = (self.xxb_height - self.activityIndicatorView.xxb_height) * 0.5;
}
- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:messageLabel];
        messageLabel.autoresizingMask = (1 << 6) - 1;
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
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

- (void)setRefreshState:(XXBRefreshState)refreshState {
    [super setRefreshState:refreshState];
    switch (refreshState) {
        case XXBRefreshStateDefault:
        {
            self.messageLabel.text = XXBRefreshDropUp;
            break;
        }
        case XXBRefreshStateRefreshing:
        {
            [self.activityIndicatorView startAnimating];
            self.messageLabel.text = XXBRefreshing;
            break;
        }
        case XXBRefreshStateEndRefreshing:
        {
            [self.activityIndicatorView stopAnimating];
            self.messageLabel.text = XXBRefreshDropUp;
            break;
        }
            
        default:
            break;
    }
}
@end

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
@property(nonatomic ,weak) UILabel                  *lastRefreshTimeLabel;
@property(nonatomic ,weak) UILabel                  *messageLabel;
@property(nonatomic ,weak) UIActivityIndicatorView  *activityIndicatorView;
@property(nonatomic ,weak) UIImageView              *activityImageView;

/**
 *  上次更新的时间
 */
@property (nonatomic, strong) NSDate                *lastUpdateTime;
@end

@implementation XXBRefreshFooterUIView

static NSString *XXBRefreshFooterUIViewLastRefreshTime = @"XXBRefreshFooterUIViewLastRefreshTime";
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.lastRefreshTimeLabel sizeToFit];
    self.lastRefreshTimeLabel.xxb_x = XXBRefreshMarginInset;
    self.lastRefreshTimeLabel.xxb_y = XXBRefreshMarginInset;
    self.lastRefreshTimeLabel.xxb_width = self.xxb_width - 2 * XXBRefreshMarginInset;
    
    [self.messageLabel sizeToFit];
    self.messageLabel.xxb_x = XXBRefreshMarginInset;
    self.messageLabel.xxb_y = self.lastRefreshTimeLabel.xxb_y + self.lastRefreshTimeLabel.xxb_height + XXBRefreshMarginView;
    self.messageLabel.xxb_width = self.xxb_width - 2 * XXBRefreshMarginInset;
    //    self.messageLabel.center = CGPointMake(self.xxb_width * 0.5, self.xxb_height * 0.5);
    self.activityImageView.xxb_x = XXBRefreshMarginInset ;
    self.activityImageView.xxb_y = (self.xxb_height - self.activityImageView.xxb_height) * 0.5;
    self.activityIndicatorView.frame = self.activityImageView.frame;
    
}

- (UILabel *)lastRefreshTimeLabel {
    if (_lastRefreshTimeLabel == nil) {
        UILabel *lastRefreshTimeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        lastRefreshTimeLabel.textAlignment = NSTextAlignmentCenter;
        lastRefreshTimeLabel.textColor = [UIColor grayColor];
        lastRefreshTimeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:lastRefreshTimeLabel];
        _lastRefreshTimeLabel = lastRefreshTimeLabel;
    }
    return _lastRefreshTimeLabel;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = [UIColor grayColor];
        messageLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:messageLabel];
        [self updateTimeLabel];
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

- (void)setLastUpdateTime:(NSDate *)lastUpdateTime {
    
    if (![lastUpdateTime isKindOfClass:[NSDate class]]) {
        return;
    }
    
    if (lastUpdateTime == nil) {
        [self updateTimeLabel];
        return;
    }
    _lastUpdateTime = lastUpdateTime;
    // 1.归档
    [[NSUserDefaults standardUserDefaults] setObject:lastUpdateTime forKey:XXBRefreshFooterUIViewLastRefreshTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 2.更新时间
    [self updateTimeLabel];
}

- (NSDate *)lastUpdateTime {
    if (_lastUpdateTime == nil) {
        _lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:XXBRefreshFooterUIViewLastRefreshTime];
    }
    return _lastUpdateTime;
}

/**
 *  更新时间
 */
- (void)updateTimeLabel {
    if (!self.lastUpdateTime) return;
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp = [calendar components:unitFlags fromDate:self.lastUpdateTime toDate:[NSDate date] options:0];
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(cmp.year == 0) {
        if (cmp.month ==0 ) {
            if (cmp.day == 0) {
                if (cmp.hour == 0) {
                    if(cmp.minute > 30) {
                        formatter.dateFormat = @"今天 HH:mm";
                    } else {
                        if (cmp.minute == 0) {
                            formatter.dateFormat = @"刚刚";
                        } else {
                            formatter.dateFormat = [NSString stringWithFormat:@"%@分钟前",@(cmp.minute)];
                        }
                    }
                } else {
                    formatter.dateFormat = @"今天 HH:mm";
                }
            } else if (cmp.day == 1) {
                formatter.dateFormat = @"昨天 HH:mm";
            } else  if (cmp.day == 2){
                formatter.dateFormat = @"前天 HH:mm";
            } else {
                formatter.dateFormat = @"yyyy-MM-dd HH:mm";
            }
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:self.lastUpdateTime];
    // 3.显示日期
    self.lastRefreshTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
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
            self.messageLabel.text = XXBRefreshDropEnd;
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
            self.messageLabel.text = XXBRefreshing;
            break;
        }
        case XXBRefreshStateEndRefreshing:
        {
            [UIView animateWithDuration:XXBRefreshAnimationDuration animations:^{
                self.activityImageView.alpha = 1.0;
            }];
            [self.activityIndicatorView startAnimating];
            self.messageLabel.text = XXBRefreshDropEnd;
            self.lastUpdateTime = [NSDate date];
            break;
        }
        case XXBRefreshStateWillRefreshing:
        {
            [self.activityIndicatorView stopAnimating];
            self.messageLabel.text = XXBRefreshDropEnd;
            break;
        }
        case XXBRefreshStateStartWillShow:
        {
            [self.activityIndicatorView stopAnimating];
            self.messageLabel.text = XXBRefreshDropUp;
            [self updateTimeLabel];
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

//
//  XXBRefreshHeaderPicView.m
//  XXBRefreshDemo
//
//  Created by baidu on 16/7/14.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBRefreshHeaderPicView.h"


@interface XXBRefreshHeaderPicView ()

@property(nonatomic ,weak) UIImageView *imageView;

@end
@implementation XXBRefreshHeaderPicView

- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    CGFloat currentOffsetY = self.scrollView.xxb_contentOffsetY;
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    if (currentOffsetY >= happenOffsetY) {
        return;
    } else {
        if (-currentOffsetY <= self.xxb_height) {
            self.imageView.frame = self.bounds;
        } else {
            self.imageView.frame = CGRectMake(0,self.xxb_height + currentOffsetY,self.xxb_width, -currentOffsetY);
        }
    }

}

- (UIImageView *)imageView {
    if(_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self  insertSubview:imageView atIndex:0];
        imageView.image = [UIImage imageNamed:@"3"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _imageView = imageView;
    }
    return _imageView;
}
@end

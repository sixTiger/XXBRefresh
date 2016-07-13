//
//  UIScrollView+XXBExtension.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "UIScrollView+XXBExtension.h"

@implementation UIScrollView (XXBExtension)
- (void)setXxb_contentInsetTop:(CGFloat)xxb_contentInsetTop {
    UIEdgeInsets inset = self.contentInset;
    inset.top = xxb_contentInsetTop;
    self.contentInset = inset;
}

- (CGFloat)xxb_contentInsetTop {
    return self.contentInset.top;
}

- (void)setXxb_contentInsetBottom:(CGFloat)xxb_contentInsetBottom {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = xxb_contentInsetBottom;
    self.contentInset = inset;
}

- (CGFloat)xxb_contentInsetBottom {
    return self.contentInset.bottom;
}

- (void)setXxb_contentInsetLeft:(CGFloat)xxb_contentInsetLeft {
    UIEdgeInsets inset = self.contentInset;
    inset.left = xxb_contentInsetLeft;
    self.contentInset = inset;
}

- (CGFloat)xxb_contentInsetLeft {
    return self.contentInset.left;
}

- (void)setXxb_contentInsetRight:(CGFloat)xxb_contentInsetRight {
    UIEdgeInsets inset = self.contentInset;
    inset.right = xxb_contentInsetRight;
    self.contentInset = inset;
}

- (CGFloat)xxb_contentInsetRight {
    return self.contentInset.right;
}

- (void)setXxb_contentOffsetX:(CGFloat)xxb_contentOffsetX {
    CGPoint offset = self.contentOffset;
    offset.x = xxb_contentOffsetX;
    self.contentOffset = offset;
}

- (CGFloat)xxb_contentOffsetX {
    return self.contentOffset.x;
}

- (void)setXxb_contentOffsetY:(CGFloat)xxb_contentOffsetY {
    CGPoint offset = self.contentOffset;
    offset.y = xxb_contentOffsetY;
    self.contentOffset = offset;
}

- (CGFloat)xxb_contentOffsetY {
    return self.contentOffset.y;
}

- (void)setXxb_contentSizeWidth:(CGFloat)xxb_contentSizeWidth {
    CGSize size = self.contentSize;
    size.width = xxb_contentSizeWidth;
    self.contentSize = size;
}

- (CGFloat)xxb_contentSizeWidth {
    return self.contentSize.width;
}

- (void)setXxb_contentSizeHeight:(CGFloat)xxb_contentSizeHeight {
    CGSize size = self.contentSize;
    size.height = xxb_contentSizeHeight;
    self.contentSize = size;
}

- (CGFloat)xxb_contentSizeHeight {
    return self.contentSize.height;
}

@end

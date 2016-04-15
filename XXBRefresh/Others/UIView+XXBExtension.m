//
//  UIView+XXBExtension.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "UIView+XXBExtension.h"

@implementation UIView (XXBExtension)

- (void)setXxb_x:(CGFloat)xxb_x {
    CGRect frame = self.frame;
    frame.origin.x = xxb_x;
    self.frame = frame;
}

- (CGFloat)xxb_x {
    return self.frame.origin.x;
}

- (void)setXxb_y:(CGFloat)xxb_y {
    CGRect frame = self.frame;
    frame.origin.y = xxb_y;
    self.frame = frame;
}

- (CGFloat)xxb_y {
    return self.frame.origin.y;
}

- (void)setXxb_width:(CGFloat)xxb_width {
    CGRect frame = self.frame;
    frame.size.width = xxb_width;
    self.frame = frame;
}

- (CGFloat)xxb_width {
    return self.frame.size.width;
}

- (void)setXxb_height:(CGFloat)xxb_height {
    CGRect frame = self.frame;
    frame.size.height = xxb_height;
    self.frame = frame;
}

- (CGFloat)xxb_height {
    return self.frame.size.height;
}

- (void)setXxb_size:(CGSize)xxb_size {
    CGRect frame = self.frame;
    frame.size = xxb_size;
    self.frame = frame;
}

- (CGSize)xxb_size {
    return self.frame.size;
}

- (void)setXxb_origin:(CGPoint)xxb_origin {
    CGRect frame = self.frame;
    frame.origin = xxb_origin;
    self.frame = frame;
}

- (CGPoint)xxb_origin {
    return self.frame.origin;
}
@end

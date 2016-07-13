//
//  XXBRefreshRseources.h
//  XXBRefreshDemo
//
//  Created by baidu on 16/7/13.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XXBRefreshRseources : NSObject

/**
 *  获取XXBRefresh的bundle
 *
 *  @return 获取的bundle
 */
+ (NSBundle *)resourceBundle;

/**
 *  根据图片的名字和后缀名创建图片
 *
 *  @param imageName 图片的名字
 *  @param extension 图片的后缀名
 *
 *  @return 创建好的图片
 */
+ (UIImage *)imageNamed:(NSString *)imageName withExtension:(NSString *)extension;
@end

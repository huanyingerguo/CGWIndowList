//
//  CNCustomScroller.h
//  Mac Hi
//
//  Created by jinglin sun on 16/1/5.
//  Copyright (c) 2016年 baidu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, ScrollerSizeType) {
    ScrollerSizeType_Regular = 0,
    ScrollerSizeType_Small   = 1,
};

//自定义滚动条
//去除白色背景
@interface CNCustomScroller : NSScroller


+(void)mockScrollerWidth:(BOOL)enable;

@property (nonatomic, copy) NSColor *color;

@property (nonatomic, assign) ScrollerSizeType sizeType;

@end

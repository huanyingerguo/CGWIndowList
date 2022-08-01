//
//  CNCustomScrollView.m
//  CNCustomScrollView
//
//  Created by jinglin sun on 31.12.12.
//  Copyright (c) 2012 Rheinfabrik. All rights reserved.
//

#import <objc/objc-class.h>
#import "CNCustomScrollView.h"
#import "CNCustomScroller.h"

@implementation CNCustomScrollView

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self initSettings];
    }
    return self;
}

-(void)awakeFromNib
{
    [self initSettings];
}

-(void)initSettings
{
    self.wantsLayer = YES;
    //禁用横向滚动
    self.hasHorizontalScroller = NO;
    self.horizontalScrollElasticity = NSScrollElasticityNone;
}

-(void)scrollWheel:(NSEvent *)event
{
    if(self.disableScroll)return;
    [super scrollWheel:event];
}

- (void)tile
{
    [CNCustomScroller mockScrollerWidth:YES];
    [super tile];
    // Restore original scroller width
    [CNCustomScroller mockScrollerWidth:NO];
    
    // Resize vertical scroller
    CGFloat width = [CNCustomScroller scrollerWidthForControlSize:self.verticalScroller.controlSize
                                                    scrollerStyle:self.verticalScroller.scrollerStyle];
    [self.verticalScroller setFrame:(NSRect){
        self.bounds.size.width - width,
        0,
        width,
        self.bounds.size.height
    }];
    
    [[self contentView] setFrame:self.bounds];
}

@end

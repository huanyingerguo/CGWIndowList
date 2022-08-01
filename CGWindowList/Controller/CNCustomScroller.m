//
//  CNCustomScroller.m
//  Mac Hi
//
//  Created by jinglin sun on 16/1/5.
//  Copyright (c) 2016年 baidu. All rights reserved.
//

#import "CNCustomScroller.h"
#import <objc/runtime.h>

@implementation CNCustomScroller

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self == nil) {
        return nil;
    }
    [self commonInitializer];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInitializer];
}

- (void)drawKnob {
    if (self.color) {
        //自定义滚动条颜色
        NSRect knobRect = [self rectForPart:NSScrollerKnob];
        knobRect.origin.x += 5;
        knobRect.size.width = 7;
        NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:knobRect xRadius:4 yRadius:4];
        [self.color set];
        [bezierPath fill];
    } else {
        [super drawKnob];
    }
}

- (void)commonInitializer
{
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                                options:(
                                                                         NSTrackingMouseEnteredAndExited
                                                                         | NSTrackingActiveInActiveApp
                                                                         | NSTrackingMouseMoved
                                                                         )
                                                                  owner:self
                                                               userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Only draw the knob. drawRect: should only be invoked when overlay scrollers are not used
    [self drawKnob];
}

- (void)drawKnobSlotInRect:(NSRect)slotRect highlight:(BOOL)flag
{
    // Don't draw the background. Should only be invoked when using overlay scrollers
}

- (void)setFloatValue:(float)aFloat
{
    [super setFloatValue:aFloat];
    [self setAlphaValue:1.0f];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOut) object:nil];
    [self performSelector:@selector(fadeOut) withObject:nil afterDelay:1.5f];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [super mouseExited:theEvent];
    [self fadeOut];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [super mouseEntered:theEvent];
    [self setAlphaValue:1.0f];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOut) object:nil];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    [super mouseMoved:theEvent];
    self.alphaValue = 1.0f;
}

- (void)fadeOut
{
    NSScrollView *scrollView = (NSScrollView *)self.superview;
    if ([scrollView isKindOfClass:[NSScrollView class]]) {
        if (!scrollView.autohidesScrollers && scrollView.scrollerStyle == NSScrollerStyleLegacy) {
            return;
        }
    }
    
    [self setAlphaValue:0.0f];
}

+ (BOOL)isCompatibleWithOverlayScrollers
{
    return self == [CNCustomScroller class];
}

+ (CGFloat)zeroWidth
{
    return 0.0f;
}
+(void)mockScrollerWidth:(BOOL)enable
{
    static BOOL isMocked=NO;
    if ((enable&&!isMocked)
        ||(!enable&&isMocked)) {
        isMocked=!isMocked;
        method_exchangeImplementations(class_getClassMethod([CNCustomScroller class], @selector(scrollerWidthForControlSize:scrollerStyle:)),
                                       class_getClassMethod([CNCustomScroller class], @selector(zeroWidth)));
    }
}

- (NSControlSize)controlSize {
    if (self.sizeType == ScrollerSizeType_Small) {
        return NSControlSizeSmall;
    }
    return NSControlSizeRegular;
}

@end

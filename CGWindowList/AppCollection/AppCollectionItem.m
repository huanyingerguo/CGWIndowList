//
//  AppCollectionItem.m
//  CGWindowList
//
//  Created by sunjinglin on 2020/1/13.
//  Copyright © 2020 sunjinglin. All rights reserved.
//

#import "AppCollectionItem.h"

@interface AppCollectionItem ()
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *appName;

@end

@implementation AppCollectionItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor redColor].CGColor;
}

- (void)setItemDetail:(NSDictionary *)itemDetail {
    _itemDetail = itemDetail;
    [self captureScrenImage:itemDetail];
}

- (void)captureScrenImage:(NSDictionary *)windowDict {
    CGRect windowRect;
    CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)(windowDict[(id)kCGWindowBounds]), &windowRect);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGWindowID windowID = (CGWindowID)[windowDict[(id)kCGWindowNumber] unsignedLongLongValue];
        CGImageRef cgImage = CGWindowListCreateImage(windowRect,  kCGWindowListOptionIncludingWindow, windowID, kCGWindowImageDefault);
        NSImage *image = [self imageFromCGImageRef:cgImage];
        CGImageRelease(cgImage);
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    });

    
    NSString *appName = windowDict[(id)kCGWindowName];
    self.appName.stringValue = appName ?: @"";
    if (!self.appName.stringValue.length
        || [self.appName.stringValue isEqualToString:@"Window"]) {
        NSString *appParantName = windowDict[(id)kCGWindowOwnerName];
        self.appName.stringValue = [NSString stringWithFormat:@"parent-%@", appParantName ?: @""];
    }
}

- (NSImage *)imageFromCGImageRef:(CGImageRef)image {
    NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0);
    
    // Get the image dimensions.
    imageRect.size.height = CGImageGetHeight(image);
    imageRect.size.width = CGImageGetWidth(image);
    
    // Create a new image to receive the Quartz image data.
    NSImage *newImage = [[NSImage alloc] initWithCGImage:image size:imageRect.size];
    return newImage;
}

- (NSRect)cgWindowRectToScreenRect:(CGRect)windowRect {
    NSRect mainRect = [NSScreen mainScreen].frame;
    for (NSScreen *screen in [NSScreen screens]) {
        if ((int) screen.frame.origin.x == 0 && (int) screen.frame.origin.y == 0) {
            mainRect = screen.frame;
        }
    }
    
    NSRect rect = NSMakeRect(windowRect.origin.x, mainRect.size.height - windowRect.size.height - windowRect.origin.y, windowRect.size.width, windowRect.size.height);
    return rect;
}
@end

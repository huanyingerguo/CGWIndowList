//
//  ViewController.m
//  CGWindowList
//
//  Created by sunjinglin on 2020/1/9.
//  Copyright © 2020 sunjinglin. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)onDisplayBtnClicked:(id)sender {
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSImageView class]]) {
            [obj removeFromSuperview];
        }
    }];
    [self getWindowsInfoOnScreens];
}

- (void)getWindowsInfoOnScreens {
    NSArray<NSRunningApplication *> *openWindows = [[NSWorkspace sharedWorkspace] runningApplications];
    
    NSMutableArray *details = [NSMutableArray arrayWithCapacity:openWindows.count];
    [openWindows enumerateObjectsUsingBlock:^(NSRunningApplication * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *detail = @{@"localizedName": obj.localizedName,
                                 @"processIdentifier": @(obj.processIdentifier),
                                 };
        [self imageView:obj.icon atIndex:idx];
        [details addObject:detail];
    }];
    
    NSLog(@"应用信息个数:%ld", details.count);
    self.applications.stringValue = [self jsonStringFromObject:details];

    
    NSArray *arrs = (__bridge NSArray*) CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    NSMutableArray *filtered = [NSMutableArray arrayWithCapacity:arrs.count];
    [arrs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull windowDict, NSUInteger idx, BOOL * _Nonnull stop) {
        CGWindowID windowID = (CGWindowID)[windowDict[(id)kCGWindowNumber] unsignedLongLongValue];
        
        int layer = 0;
        CFNumberRef numberRef = (__bridge CFNumberRef) windowDict[(id) kCGWindowLayer];
        CFNumberGetValue(numberRef, kCFNumberSInt32Type, &layer);
        
        if (layer >=0 ) {
            CGRect windowRect;
            CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)(windowDict[(id)kCGWindowBounds]), &windowRect);
            
            //windowRect = [self cgWindowRectToScreenRect:windowRect];
            
            CGImageRef cgImage = CGWindowListCreateImage(windowRect,  kCGWindowListOptionIncludingWindow, windowID, kCGWindowImageDefault);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSImage *image = [self imageFromCGImageRef:cgImage];
                if (image) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self imageView2:image atIndex:idx];
                    });
                }
            });
            
            [filtered addObject:windowDict];
        }
    }];
    
    self.windInfo.stringValue = [self jsonStringFromObject:arrs];
    NSLog(@"窗口信息个数:%ld", arrs.count);
    
    NSLog(@"过滤掉的窗口个数:%ld, 详情：%@", filtered.count, filtered);

}

- (NSRect)cgWindowRectToScreenRect:(CGRect)windowRect
{
    NSRect mainRect = [NSScreen mainScreen].frame;
    //NSRect snipRect = screen.frame;
    for (NSScreen *screen in [NSScreen screens]) {
        if ((int) screen.frame.origin.x == 0 && (int) screen.frame.origin.y == 0) {
            mainRect = screen.frame;
        }
    }
    NSRect rect = NSMakeRect(windowRect.origin.x, mainRect.size.height - windowRect.size.height - windowRect.origin.y, windowRect.size.width, windowRect.size.height);
    return rect;
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

- (void )imageView:(NSImage *)image atIndex:(long)atIndex {
    NSImageView *imageView = [NSImageView imageViewWithImage:image];
    long colum = (int)(atIndex/10) + 1;
    [imageView setFrame:NSMakeRect(50*colum, 50*(atIndex%10), 50, 50)];

    [self.view addSubview:imageView];
}

- (void )imageView2:(NSImage *)image atIndex:(long)atIndex {
    NSImageView *imageView = [NSImageView imageViewWithImage:image];
    long colum = (int)(atIndex/5) + 3;
    [imageView setFrame:NSMakeRect(200*colum, 200*(atIndex%5), 200, 200)];
    
    [self.view addSubview:imageView];
}

- (NSString *)jsonStringFromObject:(id)object {
    if (!object) {
        return @"";
    }
    NSError *error = nil;
    NSData *objectData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    if (error) {
        NSLog(@"对象转Json字符串失败:%@", error);
        return @"";
    }
    return [[NSString alloc] initWithData:objectData encoding:NSUTF8StringEncoding];
}
@end

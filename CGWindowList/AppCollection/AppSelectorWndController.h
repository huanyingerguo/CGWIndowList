//
//  AppSelectorWndController.h
//  CGWindowList
//
//  Created by sunjinglin on 2020/1/13.
//  Copyright © 2020 sunjinglin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppSelectorWndController : NSWindowController
@property (weak) NSWindow *hostWindow;

- (NSArray *)applicaitons;
@end

NS_ASSUME_NONNULL_END

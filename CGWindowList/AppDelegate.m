//
//  AppDelegate.m
//  CGWindowList
//
//  Created by sunjinglin on 2020/1/9.
//  Copyright © 2020 sunjinglin. All rights reserved.
//

#import "AppDelegate.h"
#import "AppSelectorWndController.h"
#import "SystemInfoFetcher.h"

@interface AppDelegate ()
@property (strong) AppSelectorWndController *windCtrl;
@property (strong, nonatomic) SystemInfoFetcher *fetcher;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    self.windCtrl = [[AppSelectorWndController alloc] initWithWindowNibName:@"AppSelectorWndController"];
//    [self.windCtrl.window center];
//    [self.windCtrl showWindow:nil];
//    self.fetcher = [[SystemInfoFetcher alloc] init];
//    [self.fetcher startFetchingAppInfoForAppName:@"Google Chrome"];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end

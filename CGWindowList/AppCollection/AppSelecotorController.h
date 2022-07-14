//
//  AppSelecotorController.h
//  CGWindowList
//
//  Created by sunjinglin on 2020/1/13.
//  Copyright © 2020 sunjinglin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppSelecotorController : NSViewController
@property (assign) NSInteger curPage;
@property (assign) NSInteger totalPage;
@property (strong) NSMutableArray *applications;

- (void)setNextPage;
- (void)setPrePage;
- (void)refreshViews:(int)numbers;
- (void)updateLayout;
@end

NS_ASSUME_NONNULL_END

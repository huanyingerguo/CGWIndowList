//
//  AppSelecotorController.m
//  CGWindowList
//
//  Created by sunjinglin on 2020/1/13.
//  Copyright © 2020 sunjinglin. All rights reserved.
//

#import "AppSelecotorController.h"
#import "AppCollectionItem.h"
#import "CNCollectionViewGridLayout.h"
#import "CNCollectionViewFlowLayout.h"
#import <Masonry/Masonry.h>


@interface AppSelecotorController () <NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout>
@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) IBOutlet NSScrollView *baseScrollView;

@property (strong) NSArray *_apps;
@property (assign) NSUInteger maxAppNumbers;
@property (assign) NSUInteger perPageSize;
@property (assign) BOOL isCanRecord;
@end

@implementation AppSelecotorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    if (!_applications) {
        _applications = [NSMutableArray arrayWithCapacity:1];
    }
    self.perPageSize = 9;
    [self initSubview];
}

- (void)setNextPage {
    if ((self.curPage + 1) * self.perPageSize >= self.applications.count) {
        return;
    }
    
    self.curPage++;
    [self reloadData];
}

- (void)setPrePage {
    if (self.curPage <= 0) {
        return;
    }
    
    self.curPage--;
    [self reloadData];
}

- (void)refreshViews:(int)numbers {
    self.maxAppNumbers = numbers;
    [self.applications removeAllObjects];
    [self getWindowsInfoOnScreens];
    if (@available(macOS 10.11, *)) {
        self.curPage = 0; //重新加载
        [self reloadData];
    }
}

-(void)initSubview{
    self.collectionView.enclosingScrollView.backgroundColor = [NSColor yellowColor];
    self.collectionView.enclosingScrollView.verticalScroller.hidden = YES;
    self.collectionView.enclosingScrollView.horizontalScroller.hidden = YES;
    //[self.collectionView.enclosingScrollView setHorizontalScroller:nil];
    //[self.collectionView.enclosingScrollView setVerticalScroller:nil];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

#pragma mark- Capture Application Views
- (void)getWindowsInfoOnScreens {
    NSArray<NSRunningApplication *> *openWindows = [[NSWorkspace sharedWorkspace] runningApplications];
    
    NSMutableArray *details = [NSMutableArray arrayWithCapacity:openWindows.count];
    [openWindows enumerateObjectsUsingBlock:^(NSRunningApplication * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *detail = @{@"localizedName": obj.localizedName,
                                 @"processIdentifier": @(obj.processIdentifier),
                                 };
        [details addObject:detail];
    }];
    
    NSLog(@"应用信息个数:%ld", details.count);
    NSArray *arrs = (__bridge NSArray*) CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
    for (NSDictionary *windowDict in arrs) {
        int layer = 0;
        CFNumberRef numberRef = (__bridge CFNumberRef) windowDict[(id) kCGWindowLayer];
        CFNumberGetValue(numberRef, kCFNumberSInt32Type, &layer);
        if (layer < 0) {
            continue;
        }
        
        NSString *windowName = windowDict[(id)kCGWindowName];
        NSString *ownerName = windowDict[(id)kCGWindowOwnerName];
        if (nil == ownerName){
            continue;
        }
        
        if (windowName.length == 0
            || [windowName isEqualToString:@"Window"]) {
            windowName = ownerName;
        }
        
        if (layer == 18
            && [windowName isEqualToString:@"Banners and Alerts"]) {
            continue;
        }
        
        if (layer == 23
            && [windowName isEqualToString:@"Notification Center"]) {
            continue;
        }
        
        CGRect windowRect;
        CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)(windowDict[(id)kCGWindowBounds]), &windowRect);
        
        if (windowRect.size.height <= 100
            && windowRect.size.width <= 100) {
            continue;
        }
        
        BOOL isOnScreen = [windowDict[(id)kCGWindowIsOnscreen] boolValue];
        BOOL isFullScreenWindow = NO;
        if (!isOnScreen) {
            isFullScreenWindow = [self isFullScreenWindow:windowDict];
            if (!isFullScreenWindow) {
                NSLog(@"窗口不在屏幕上:%@, windowName=%@", ownerName, windowName);
                continue;
            } else {
                
            }
        }
        
        CGWindowID windowId = [windowDict[(id)kCGWindowNumber] unsignedIntValue];
        CGImageRef imgRef = CGWindowListCreateImage(CGRectNull, kCGWindowListOptionIncludingWindow, windowId, kCGWindowImageBoundsIgnoreFraming|kCGWindowImageNominalResolution);
        if (!imgRef) {
            if (isOnScreen) {
                self.isCanRecord = NO;
            }
           // continue;
        }
        
        if (isFullScreenWindow) {
            if (CGImageGetWidth(imgRef) <= 100 || CGImageGetHeight(imgRef) <= 100) {
                NSLog(@"抓取到全屏1*1窗口:%@, windowName=%@", ownerName, windowName);
                CGImageRelease(imgRef);
                continue;
            }
        }
        
        CGImageRelease(imgRef);
        [self.applications addObject:windowDict];

        if (self.applications.count == self.maxAppNumbers) {
            break;
        }
    }
    
    [self.applications sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger pid1 = [obj1[(id)kCGWindowOwnerPID] unsignedIntValue];
        NSInteger pid2 = [obj2[(id)kCGWindowOwnerPID] unsignedIntValue];

        return pid1 >= pid2;
    }];
    
    NSLog(@"有效的窗口个数:%ld, 详情：%@", self.applications.count, self.applications);
}

- (BOOL)isFullScreenWindow:(NSDictionary *)windowDict {
    BOOL isFullScreenWindow = NO;

    NSRect otherRect;
    CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)(windowDict[(id)kCGWindowBounds]), &otherRect);
    otherRect = [[self class] cgWindowRectToScreenRect:otherRect];
    for (NSScreen *screen in [NSScreen screens]) {
        if (NSEqualRects(screen.frame, otherRect)) {
            isFullScreenWindow = YES;
            break;
        }
    }
   
    return isFullScreenWindow;
}

+ (NSRect)cgWindowRectToScreenRect:(CGRect)windowRect {
    NSRect mainRect = [NSScreen mainScreen].frame;
    for (NSScreen *screen in [NSScreen screens]) {
        if ((int) screen.frame.origin.x == 0 && (int) screen.frame.origin.y == 0) {
            mainRect = screen.frame;
        }
    }
    
    NSRect rect = NSMakeRect(windowRect.origin.x,
                             mainRect.size.height - (windowRect.size.height + windowRect.origin.y),
                             windowRect.size.width,
                             windowRect.size.height);
    return rect;
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

#pragma mark- NSCollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView  {
    return 1;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = self._apps.count;
    if (count > self.perPageSize) {
        count = self.perPageSize;
    }
    return count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    if (@available(macOS 10.11, *)) {
        AppCollectionItem *item = [collectionView makeItemWithIdentifier:@"AppCollectionItem" forIndexPath:indexPath];
        item.itemDetail = self._apps[indexPath.item];
        return item;
    }
    
    return nil;
}

#pragma mark- NSCollectionViewDelegate
//- (CGFloat)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//}

#pragma mark- Util
- (void)reloadData {
    [self refreshApps];
    [self updateLayout];
    [self.collectionView reloadData];
}

- (void)refreshApps {
    NSUInteger count = self.applications.count;
    if (count <= self.perPageSize) {
        self.curPage = 0;
        self.totalPage = 1;
        self._apps = [self.applications copy];
        return;
    }
    
    //计算总的页数
    NSUInteger newPage = count / self.perPageSize;
    if (count % self.perPageSize) {
        newPage += 1;
    }
    self.totalPage = newPage;
    
    //校准当前页数
    self.curPage = MIN(self.curPage, self.totalPage - 1);
    
    NSUInteger length = self.perPageSize;
    NSUInteger remainCnt = count - self.curPage * self.perPageSize;
    if (remainCnt < self.perPageSize) {
        length = remainCnt;
    }
    
    self._apps = [self.applications subarrayWithRange:NSMakeRange(self.curPage * self.perPageSize, length)];
}

- (void)updateLayout {
    id<CNCollectionViewLayout> layout = self.collectionView.collectionViewLayout;
    if (!layout) {
        layout = [[CNCollectionViewGridLayout alloc] init];
        self.collectionView.collectionViewLayout = (NSCollectionViewLayout *)layout;
    }

    layout.totalCount = self.applications.count;
    NSSize  size = self.view.superview.frame.size;
    [layout updateElementSize:size];
    
    CGFloat cellWidth = layout.size.width;
    CGFloat cellheight = layout.size.height;
    if (layout.cellRefer == ECellRefer_Height) {
        cellWidth += 0.2;
    } else if (layout.cellRefer == ECellRefer_Width) {
        cellheight += 0.2;
    }
    
    [self.collectionView.enclosingScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
//        make.width.mas_equalTo(size.width + 4);
//        make.height.mas_equalTo(size.height + 4);
        make.width.mas_equalTo(cellWidth * 3 + 4);
        make.height.mas_equalTo(cellheight * 3 + 4);
    }];
}
@end

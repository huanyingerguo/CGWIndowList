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

static int kNumberOfItemsInSection = 5;

@interface AppSelecotorController () <NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout>
@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) IBOutlet NSScrollView *baseScrollView;

@property (strong) NSArray *_apps;
@property (assign) NSUInteger maxAppNumbers;
@property (assign) NSUInteger numPerpage;
@end

@implementation AppSelecotorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    if (!_applications) {
        _applications = [NSMutableArray arrayWithCapacity:1];
    }
    self.numPerpage = 9;
    [self initSubview];
}

- (void)setNextPage {
    if ((self.curPage + 1) * self.numPerpage >= self.applications.count) {
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
        self._apps = [self.applications copy]; //默认全部数据
        [self updateLayout];
        [self.collectionView reloadData];
    }
}

-(void)initSubview{
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
    NSArray *arrs = (__bridge NSArray*) CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    [arrs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull windowDict, NSUInteger idx, BOOL * _Nonnull stop) {
        int layer = 0;
        CFNumberRef numberRef = (__bridge CFNumberRef) windowDict[(id) kCGWindowLayer];
        CFNumberGetValue(numberRef, kCFNumberSInt32Type, &layer);
        
        if (layer <10 ) {
            [self.applications addObject:windowDict];
        }
        
        if (self.applications.count == self.maxAppNumbers) {
            *stop = YES;
        }
    }];
    
    NSLog(@"有效的窗口个数:%ld, 详情：%@", self.applications.count, self.applications);
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
    if (count > self.numPerpage) {
        count = self.numPerpage;
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

#pragma mark- Util
- (void)reloadData {
    [self refreshApps];
    [self updateLayout];
    [self.collectionView reloadData];
}

- (void)refreshApps {
    NSUInteger count = self.applications.count;
    if (count <= self.numPerpage) {
        self._apps = [self.applications copy];
        return;
    }
    
    NSUInteger remainCnt = count - self.curPage * self.numPerpage;
    NSUInteger length = self.numPerpage;
    if (remainCnt < self.numPerpage) {
        length = remainCnt;
    }
    
    self._apps = [self.applications subarrayWithRange:NSMakeRange(self.curPage * self.numPerpage, length)];
}

- (void)updateLayout {
    id<CNCollectionViewLayout> layout = self.collectionView.collectionViewLayout;
    if (!layout) {
        layout = [[CNCollectionViewFlowLayout alloc] init];
        self.collectionView.collectionViewLayout = (NSCollectionViewLayout *)layout;
    }

    layout.totalCount = self.applications.count;
    NSSize  size = self.view.superview.frame.size;
    [layout updateElementSize:size];
}
@end

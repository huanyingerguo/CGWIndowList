//
//  AppSelecotorController.m
//  CGWindowList
//
//  Created by sunjinglin on 2020/1/13.
//  Copyright © 2020 sunjinglin. All rights reserved.
//

#import "AppSelecotorController.h"
#import "AppCollectionItem.h"
#import "CNCollectionViewLayout.h"

static int kNumberOfItemsInSection = 5;

@interface AppSelecotorController () <NSCollectionViewDataSource, NSCollectionViewDelegate>
@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) IBOutlet NSScrollView *baseScrollView;

@property (strong) NSMutableArray *applications;

@end

@implementation AppSelecotorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    if (!_applications) {
        _applications = [NSMutableArray arrayWithCapacity:1];
    }
    [self initSubview];
}

- (void)refreshViews {
    [self.applications removeAllObjects];
    [self getWindowsInfoOnScreens];
    if (@available(macOS 10.11, *)) {
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

- (void)updateLayout {
    CNCollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    if (!layout) {
        layout = [[CNCollectionViewLayout alloc] init];
    }
    
    layout.maximumNumberOfRows = 3;
    //layout.maximumNumberOfColumns = 3;
    
    NSSize size = self.view.superview.frame.size;
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    layout.minimumItemSize = NSMakeSize((size.width - 2*layout.minimumInteritemSpacing) / 3.0, (size.height - 2 * layout.minimumLineSpacing) / 3.0);
    self.collectionView.collectionViewLayout = layout;
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
        
        if (layer >=0 ) {
            [self.applications addObject:windowDict];
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
    return self.applications.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    if (@available(macOS 10.11, *)) {
        AppCollectionItem *item = [collectionView makeItemWithIdentifier:@"AppCollectionItem" forIndexPath:indexPath];
        item.itemDetail = self.applications[indexPath.item];
        return item;
    }
    
    return nil;
}

#pragma mark- NSCollectionViewDelegate

@end

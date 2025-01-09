//
//  AppSelectorWndController.m
//  CGWindowList
//
//  Created by sunjinglin on 2020/1/13.
//  Copyright © 2020 sunjinglin. All rights reserved.
//

#import "AppSelectorWndController.h"
#import "AppSelecotorController.h"
#import <Masonry/Masonry.h>

@interface AppSelectorWndController () <NSWindowDelegate>
@property (strong) AppSelecotorController *seletor;
@property (weak) IBOutlet NSView *collectionView;
@property (weak) IBOutlet NSTextField *maxAppNums;
@property (weak) IBOutlet NSButton *preButton;
@property (weak) IBOutlet NSButton *nextButton;
@property (weak) IBOutlet NSTextField *pageLabel;

@end

@implementation AppSelectorWndController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self initSubViews];
    self.window.delegate = self;
    self.maxAppNums.stringValue = @(INT_MAX).stringValue;
}

- (void)initSubViews {
    self.seletor = [[AppSelecotorController alloc] initWithNibName:@"AppSelecotorController" bundle:nil];
    [self.collectionView addSubview:self.seletor.view];
    
    [self.seletor.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.collectionView);
    }];
}

- (void)showWindow:(id)sender {
    [self.window center];
    [self onOKClicked:nil];
}

- (void)setHostWindow:(NSWindow *)hostWindow {
    _hostWindow = hostWindow;
}

- (int)numbers {
    int num = [self.maxAppNums.stringValue intValue];
    if (num <=0 ) {
        return INT_MAX;
    }
    
    return num;
}

- (NSArray *)applicaitons {
    return self.seletor.applications;
}

#pragma mark- Window Delegate
- (void)windowDidResize:(NSNotification *)notification {
    [self.seletor updateLayout];
}

#pragma mark- IBACTION
- (IBAction)onCancelClicked:(id)sender {
    if (self.hostWindow) {
        [self.hostWindow endSheet:self.window];
    }
    
    [self close];
}

- (IBAction)onOKClicked:(id)sender {
    [self.seletor refreshViews:[self numbers]];
    [self updateButtonState];
}

- (IBAction)onPrevClicked:(id)sender {
    [self.seletor setPrePage];
    [self updateButtonState];
}

- (IBAction)onNextClicked:(id)sender {
    [self.seletor setNextPage];
    [self updateButtonState];
}

- (void)updateButtonState {
    NSUInteger appNums = self.seletor.applications.count;
    self.pageLabel.stringValue = [NSString stringWithFormat:@"%ld/%ld", self.seletor.curPage + 1, self.seletor.totalPage];
    self.maxAppNums.stringValue = @(appNums).stringValue;
    
    if (self.seletor.curPage <= 0 ) {
        self.preButton.enabled = NO;
    } else {
        self.preButton.enabled = YES;
    }
    
    if (self.seletor.curPage >= self.seletor.totalPage - 1 ) {
        self.nextButton.enabled = NO;
    } else {
        self.nextButton.enabled = YES;
    }
}

@end

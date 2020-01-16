//
//  AppSelectorWndController.m
//  CGWindowList
//
//  Created by sunjinglin on 2020/1/13.
//  Copyright © 2020 sunjinglin. All rights reserved.
//

#import "AppSelectorWndController.h"
#import "AppSelecotorController.h"

@interface AppSelectorWndController ()
@property (strong) AppSelecotorController *seletor;
@property (weak) IBOutlet NSView *collectionView;

@end

@implementation AppSelectorWndController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self initSubViews];
}

- (void)initSubViews {
    self.seletor = [[AppSelecotorController alloc] initWithNibName:@"AppSelecotorController" bundle:nil];
    [self.collectionView addSubview:self.seletor.view];
}

- (void)showWindow:(id)sender {
    [self.window center];
    [self.seletor refreshViews];
}

- (void)setHostWindow:(NSWindow *)hostWindow {
    _hostWindow = hostWindow;
    [self.seletor refreshViews];
}

#pragma mark- IBACTION
- (IBAction)onCancelClicked:(id)sender {
    if (self.hostWindow) {
        [self.hostWindow endSheet:self.window];
    }
}

- (IBAction)onOKClicked:(id)sender {
    if (self.hostWindow) {
        [self.hostWindow endSheet:self.window];
    }
}

@end

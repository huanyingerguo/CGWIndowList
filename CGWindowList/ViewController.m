//
//  ViewController.m
//  CGWindowList
//
//  Created by sunjinglin on 2020/1/9.
//  Copyright © 2020 sunjinglin. All rights reserved.
//

#import "ViewController.h"
#import "AppSelectorWndController.h"

@interface ViewController()
@property (strong) AppSelectorWndController *selecotor;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.selecotor = [[AppSelectorWndController alloc] initWithWindowNibName:@"AppSelectorWndController"];
    [self.selecotor.window center];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)onDisplayBtnClicked:(id)sender {
    self.selecotor.hostWindow = self.view.window;
    [self.view.window beginSheet:self.selecotor.window completionHandler:^(NSModalResponse returnCode) {
    }];
}
@end

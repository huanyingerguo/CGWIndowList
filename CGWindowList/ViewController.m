//
//  ViewController.m
//  CGWindowList
//
//  Created by sunjinglin on 2020/1/9.
//  Copyright © 2020 sunjinglin. All rights reserved.
//

#import "ViewController.h"
#import "AppSelectorWndController.h"
#import "AppSelecotorController.h"

@interface ViewController()
@property (strong) AppSelectorWndController *selecotor;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    //[self.selecotor.window center];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self onDisplayBtnClicked:nil];
    });
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)onDisplayBtnClicked:(id)sender {
    if (!self.selecotor) {
        [self.selecotor close];
        self.selecotor = nil;
    }
    self.selecotor = [[AppSelectorWndController alloc] initWithWindowNibName:@"AppSelectorWndController"];
    
    [self.selecotor.window center];
    [self.selecotor showWindow:nil];
}
@end

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
@property (weak) IBOutlet NSTextField *output;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    //[self.selecotor.window center];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [self onDisplayBtnClicked:nil];
//    });
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 7*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [self onDisplayBtnClicked:nil];
//    });
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)onDisplayBtnClicked:(id)sender {
    if (self.selecotor) {
        [self.selecotor close];
        self.selecotor = nil;
    }
    self.selecotor = [[AppSelectorWndController alloc] initWithWindowNibName:@"AppSelectorWndController"];
    
    [self.selecotor.window center];
    [self.selecotor showWindow:nil];
    
    __weak ViewController* weak_self = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            __strong ViewController* self = weak_self;
            NSString *result = [[self.selecotor applicaitons] description];
            self.output.stringValue = result;
        });
}
@end

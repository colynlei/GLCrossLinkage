//
//  ViewController.m
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/15.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import "ViewController.h"
#import "GLMainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)enterBtnAction:(UIButton *)sender {
    [self.navigationController pushViewController:[[GLMainViewController alloc] init] animated:YES];
}

@end

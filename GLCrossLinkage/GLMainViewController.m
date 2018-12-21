//
//  GLMainViewController.m
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/19.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import "GLMainViewController.h"
#import "GLFirstViewController.h"
#import "GLSecondViewController.h"
#import "GLThirdViewController.h"
#import "GLHeaderHoverView.h"

@interface GLMainViewController ()

//@property (nonatomic, strong) GLHeaderHoverView *headerHoverView;

@end

@implementation GLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mainScrollViewFrame = CGRectMake(0, gl_NavbarHeight, self.view.frame.size.width, self.view.frame.size.height-gl_NavbarHeight);
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)];
    self.headerView.backgroundColor = [UIColor yellowColor];
    
    GLHeaderHoverView *hoverView = [[GLHeaderHoverView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    hoverView.segmentedControl.selectedIndex = 0;
    hoverView.backgroundColor = [UIColor greenColor];
    gl_WeakSelf(self);
    hoverView.itemSelectedBlock = ^(NSInteger index) {
        weakself.selectedIndex = index;
    };
    self.headerHoverView = hoverView;
    self.selectedIndex = hoverView.segmentedControl.selectedIndex;
    
    self.subViewControllers = @[[[GLFirstViewController alloc] init],
                                [[GLSecondViewController alloc] init],
                                [[GLThirdViewController alloc] init]];
    
    
    
}

- (void)selectedIndexChange {
    [super selectedIndexChange];
    GLHeaderHoverView *hoverView = (GLHeaderHoverView *)self.headerHoverView;
    hoverView.segmentedControl.selectedIndex = self.selectedIndex;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

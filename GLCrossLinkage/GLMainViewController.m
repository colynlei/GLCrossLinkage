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
    
    gl_WeakSelf(self);
    self.gl_mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉刷新");
        gl_StrongSelf(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"刷新结束1");
            [strongSelf.gl_mj_header endRefreshingWithCompletionBlock:^{
                NSLog(@"刷新结束2");
            }];
        });
    }];
    
    self.selectedIndex = 1;
    self.HoverViewOffsetY = 0;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)];
    self.headerView.backgroundColor = [UIColor yellowColor];
    
    GLHeaderHoverView *hoverView = [[GLHeaderHoverView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    hoverView.segmentedControl.selectedIndex = 1;
    hoverView.backgroundColor = [UIColor greenColor];

    hoverView.itemSelectedBlock = ^(NSInteger index) {
        weakself.selectedIndex = index;
    };
    self.headerHoverView = hoverView;
    
    self.subViewControllers = @[[[GLFirstViewController alloc] init],
                                [[GLSecondViewController alloc] init],
                                [[GLThirdViewController alloc] init]];
}

- (void)selectedIndexChange {
    [super selectedIndexChange];
    GLHeaderHoverView *hoverView = (GLHeaderHoverView *)self.headerHoverView;
    if ([hoverView isKindOfClass:GLHeaderHoverView.class]) {
        hoverView.segmentedControl.selectedIndex = self.selectedIndex;
    }
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

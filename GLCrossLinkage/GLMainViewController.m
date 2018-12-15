//
//  GLMainViewController.m
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/15.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import "GLMainViewController.h"
#import "GLFirstViewController.h"
#import "GLSecondViewController.h"
#import "GLThirdViewController.h"

@interface GLMainViewController ()

@end

@implementation GLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    GLFirstViewController *vc1 = [[GLFirstViewController alloc] init];
    GLSecondViewController *vc2 = [[GLSecondViewController alloc] init];
    GLThirdViewController *vc3 = [[GLThirdViewController alloc] init];
    
    self.subViewControllers = @[vc1,vc2,vc3];
    
    self.contentViewFrame = CGRectMake(0, gl_NavbarHeight, self.view.frame.size.width, self.view.frame.size.height-gl_NavbarHeight);

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentViewFrame.size.width, 150)];
    headerView.backgroundColor = [UIColor redColor];
    self.headerView = headerView;
    
    UIView *headerHoverView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), headerView.frame.size.width, 50)];
    headerHoverView.backgroundColor = [UIColor greenColor];
    self.headerHoverView = headerHoverView;

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

//
//  GLCrossLinkageMainViewController.m
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/15.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import "GLCrossLinkageMainViewController.h"

#define subView_tag 862736

@interface GLCrossLinkageMainViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIView *topView;

@end

@implementation GLCrossLinkageMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.contentViewFrame = self.view.bounds;
    [self.view addSubview:self.contentView];
    
    [self.contentView addSubview:self.topView];
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:self.contentViewFrame];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.pagingEnabled = YES;
        _contentView.bounces = NO;
        _contentView.delegate = self;
        if (@available (iOS 11.0, *)) {
            _contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _contentView;
}

- (void)setContentViewFrame:(CGRect)contentViewFrame {
    _contentViewFrame = contentViewFrame;
    self.contentView.frame = contentViewFrame;
    self.contentView.contentSize = CGSizeMake(self.subViewControllers.count*contentViewFrame.size.width, contentViewFrame.size.height);
    
    if (self.subViewControllers.count) {
        CGFloat w = self.contentViewFrame.size.width;
        CGFloat h = self.contentViewFrame.size.height;
        for (NSInteger i = 0; i < self.subViewControllers.count; i++) {
            UIView *view = [self.contentView viewWithTag:subView_tag+i];
            view.frame = CGRectMake(i*w, 0, w, h);
        }
    }
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.clipsToBounds = YES;
    }
    return _topView;
}

- (void)resetTopViewFrame {
    CGFloat h1 = self.headerView?CGRectGetMaxY(self.headerView.frame):0;
    CGFloat h2 = self.headerView?CGRectGetMaxY(self.headerHoverView.frame):0;
    self.topView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, (h1>h2)?h1:h2);
}

- (void)setHeaderView:(UIView *)headerView {
    [_headerView removeFromSuperview];
    
    _headerView = headerView;
    if (!headerView) return;
    
    [self.topView addSubview:headerView];
    [self resetTopViewFrame];
}

- (void)setHeaderHoverView:(UIView *)headerHoverView {
    [_headerHoverView removeFromSuperview];
    _headerHoverView = headerHoverView;
    if (!headerHoverView) return;
    
    headerHoverView.tag = HoverView_tag;
    [self.topView addSubview:headerHoverView];
    [self resetTopViewFrame];
}

- (void)setSubViewControllers:(NSArray<GLCrossLinkageSubViewController *> *)subViewControllers {
    _subViewControllers = subViewControllers;
    if (!subViewControllers || !subViewControllers.count) return;
    CGFloat w = self.contentViewFrame.size.width;
    CGFloat h = self.contentViewFrame.size.height;
    for (NSInteger i = 0; i < subViewControllers.count; i++) {
        GLCrossLinkageSubViewController *vc = subViewControllers[i];
        vc.view.frame = CGRectMake(i*w, 0, w, h);
        vc.topView = self.topView;
        vc.view.tag = subView_tag +i;
        [self.contentView addSubview:vc.view];
        [self addChildViewController:vc];
    }
    self.contentView.contentSize = CGSizeMake(subViewControllers.count*w, h);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.topView) {
        CGRect rect = self.topView.frame;
        rect.origin.x = scrollView.contentOffset.x;
        self.topView.frame = rect;
    }
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.contentView bringSubviewToFront:self.topView];
}

- (void)dealloc {

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

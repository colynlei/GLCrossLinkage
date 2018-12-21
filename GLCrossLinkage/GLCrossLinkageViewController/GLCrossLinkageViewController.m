//
//  GLCrossLinkageViewController.m
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/19.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import "GLCrossLinkageViewController.h"


@interface GLDynamicItem : NSObject<UIDynamicItem>

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign, readonly) CGRect bounds;
@property (nonatomic, assign) CGAffineTransform transform;

@end

@implementation GLDynamicItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _bounds = CGRectMake(0, 0, 1, 1);
    }
    return self;
}

@end


@interface GLCrossLinkageViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>{
    BOOL _isVertical;
    CGFloat _lastContentOffsetY;
}

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) GLDynamicItem *dynamicItem;

@property (nonatomic, strong) UIScrollView *subScrollView;

@end

@implementation GLCrossLinkageViewController
@synthesize headerView = _headerView,headerHoverView = _headerHoverView,subScrollView = _subScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.mainScrollViewFrame = self.view.bounds;
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.contentScrollView];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.dynamicItem = [[GLDynamicItem alloc] init];
    
    [self resetMainScrollViewContentSize];
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.mainScrollViewFrame];
        _mainScrollView.backgroundColor = [UIColor redColor];
        _mainScrollView.delegate = self;
        _mainScrollView.scrollEnabled = NO;
        if (@available (iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesturerRecognizerAction:)];
        pan.delegate = self;
        [_mainScrollView addGestureRecognizer:pan];
        
    }
    return _mainScrollView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.backgroundColor = [UIColor clearColor];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    if (!headerView) return;
    [_headerView removeFromSuperview];
    [self.mainScrollView addSubview:self.headerView];
    [self resetMainScrollViewContentSize];
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _headerView;
}

- (void)setHeaderHoverView:(UIView *)headerHoverView {
    _headerHoverView = headerHoverView;
    if (!headerHoverView) return;
    [_headerHoverView removeFromSuperview];
    [self.mainScrollView addSubview:self.headerHoverView];
    [self resetMainScrollViewContentSize];
}

- (UIView *)headerHoverView {
    if (!_headerHoverView) {
        CGFloat y = self.headerView.frame.origin.y+self.headerView.frame.size.height;
        _headerHoverView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.mainScrollView.frame.size.width, 0)];
    }
    return _headerHoverView;
}

- (void)setMainScrollViewFrame:(CGRect)mainScrollViewFrame {
    _mainScrollViewFrame = mainScrollViewFrame;
    self.mainScrollView.frame = mainScrollViewFrame;
    [self resetMainScrollViewContentSize];
}

- (void)setSubViewControllers:(NSArray<GLCrossLinkageSubViewController *> *)subViewControllers {
    _subViewControllers = subViewControllers;
    if (subViewControllers == nil || subViewControllers.count == 0) return;
    CGFloat w = self.mainScrollView.frame.size.width;
    CGFloat h = self.contentScrollView.frame.size.height;
    for (NSInteger i = 0; i < subViewControllers.count; i++) {
        GLCrossLinkageSubViewController *vc = subViewControllers[i];
        vc.view.frame = CGRectMake(i*w, 0, w, h);
        vc.scrollView.scrollEnabled = NO;
        [self.contentScrollView addSubview:vc.view];
        vc.view.backgroundColor = gl_ColorRandomAlpha(0.4);
        [self addChildViewController:vc];
    }
    self.contentScrollView.contentSize = CGSizeMake(subViewControllers.count*w, h);
    [self.contentScrollView setContentOffset:CGPointMake(self.selectedIndex*self.contentScrollView.frame.size.width, 0) animated:NO];
    [self setSelectedIndex:self.selectedIndex];
}


- (void)resetMainScrollViewContentSize {
    self.headerView.frame = CGRectMake(0, 0, self.mainScrollView.frame.size.width, self.headerView.frame.size.height);
    self.headerHoverView.frame = CGRectMake(0, self.headerView.frame.size.height, self.mainScrollView.frame.size.width, self.headerHoverView.frame.size.height);
    self.contentScrollView.frame = CGRectMake(0, self.headerHoverView.frame.origin.y+self.headerHoverView.frame.size.height, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height-self.headerHoverView.frame.size.height);
    
    CGFloat contentSize_h = self.headerHoverView.frame.origin.y+self.mainScrollView.frame.size.height;
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, contentSize_h);
}



- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self selectedIndexChange];
    if (self.subViewControllers && self.subViewControllers.count) {
        [self.contentScrollView setContentOffset:CGPointMake(selectedIndex*self.contentScrollView.frame.size.width, 0) animated:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGFloat panx = [pan translationInView:self.mainScrollView].x;
        CGFloat pany = [pan translationInView:self.mainScrollView].y;
        if (pany == 0) {
            _isVertical = NO;
        } else {
            if (fabs(panx)/fabs(pany) >= 5) {
                _isVertical = NO;
            } else {
                _isVertical = YES;
            }
        }
        return !_isVertical;
    }
    return NO;
}

- (void)panGesturerRecognizerAction:(UIPanGestureRecognizer *)pan {
    self.isStopAnimation = NO;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            _lastContentOffsetY = self.mainScrollView.contentOffset.y;
            [self.animator removeAllBehaviors];
//            [[NSNotificationCenter defaultCenter] postNotificationName:GLMainScrollViewGestureRecognizerStateBegan object:self.mainScrollView];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (_isVertical) {
                CGFloat distanceY = [pan translationInView:self.mainScrollView].y;
                NSLog(@"移动的距离：%f",distanceY);
                [self scrollControlWithVerticalDistance:distanceY];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            
        }
            break;
            
        default:
            break;
    }
    [pan setTranslation:CGPointZero inView:self.mainScrollView];
}

- (void)scrollControlWithVerticalDistance:(CGFloat)distanceY {
    if (self.mainScrollView.contentOffset.y >= self.headerHoverView.frame.origin.y) {
        NSLog(@"111");
    } else {
        if (self.subScrollView.contentOffset.y != 0 && distanceY >= 0) {
            NSLog(@"222");
        } else {
            NSLog(@"333");
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        NSInteger a = scrollView.contentOffset.x/scrollView.frame.size.width;
        _selectedIndex = a;
        [self selectedIndexChange];
    }
}

- (void)setSubScrollView:(UIScrollView *)subScrollView {
    
}

- (UIScrollView *)subScrollView {
    if (self.subViewControllers && self.subViewControllers.count) {
        GLCrossLinkageSubViewController *vc = self.subViewControllers[self.selectedIndex];
        vc.scrollView.scrollEnabled = NO;
        return vc.scrollView;
    }
    return nil;
}

- (void)selectedIndexChange{
    
    if (self.subViewControllers && self.subViewControllers.count) {
        for (NSInteger i = 0; i < self.subViewControllers.count; i++) {
            GLCrossLinkageSubViewController *vc = self.subViewControllers[self.selectedIndex];
            vc.currentIndex = i;
            vc.selectedIndex = self.selectedIndex;
            if (i == self.selectedIndex) {
                [vc currentSelected];
            }
        }
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

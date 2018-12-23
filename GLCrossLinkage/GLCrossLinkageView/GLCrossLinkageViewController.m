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


static CGFloat rubberBandDistance(CGFloat offset, CGFloat dimension) {
    const CGFloat constant = 0.55f;
    CGFloat result = (constant * fabs(offset) * dimension) / (dimension + constant * fabs(offset));
    // The algorithm expects a positive offset, so we have to negate the result if the offset was negative.
    return offset < 0.0f ? -result : result;
}

@interface GLCrossLinkageViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>{
    BOOL _isVertical;
    CGFloat _lastContentOffsetY;
    CGFloat _mainMaxOffsetY;
}

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIScrollView *subScrollView;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) GLDynamicItem *dynamicItem;
@property (nonatomic, weak) UIDynamicItemBehavior *decelerationBehavior;
@property (nonatomic, weak) UIAttachmentBehavior *springBehavior;

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
        _mainScrollView.backgroundColor = [UIColor clearColor];
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

- (void)setGl_mj_header:(MJRefreshHeader *)gl_mj_header {
    _gl_mj_header = gl_mj_header;
    self.mainScrollView.mj_header = gl_mj_header;
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

- (void)setHoverViewOffsetY:(CGFloat)HoverViewOffsetY {
    _HoverViewOffsetY = HoverViewOffsetY;
    _mainMaxOffsetY = self.headerView.frame.size.height-HoverViewOffsetY;
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
        vc.currentIndex = i;
        [self.contentScrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
    self.contentScrollView.contentSize = CGSizeMake(subViewControllers.count*w, h);
    [self.contentScrollView setContentOffset:CGPointMake(self.selectedIndex*self.contentScrollView.frame.size.width, 0) animated:NO];
    [self setSelectedIndex:self.selectedIndex];
}


- (void)resetMainScrollViewContentSize {
//    _mainMaxOffsetY = self.headerView.frame.size.height+self.HoverViewOffsetY;
    [self setHoverViewOffsetY:self.HoverViewOffsetY];
    self.headerView.frame = CGRectMake(0, 0, self.mainScrollView.frame.size.width, self.headerView.frame.size.height);
    self.headerHoverView.frame = CGRectMake(0, self.headerView.frame.size.height, self.mainScrollView.frame.size.width, self.headerHoverView.frame.size.height);
    self.contentScrollView.frame = CGRectMake(0, self.headerHoverView.frame.origin.y+self.headerHoverView.frame.size.height, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height-self.headerHoverView.frame.size.height-self.HoverViewOffsetY);

    CGFloat contentSize_h = self.headerHoverView.frame.origin.y+self.mainScrollView.frame.size.height;
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, contentSize_h);
    
    if (self.subViewControllers) {
        CGFloat w = self.mainScrollView.frame.size.width;
        CGFloat h = self.contentScrollView.frame.size.height;
        for (NSInteger i = 0; i < self.subViewControllers.count; i++) {
            GLCrossLinkageSubViewController *vc = self.subViewControllers[i];
            vc.view.frame = CGRectMake(i*w, 0, w, h);
        }
        self.contentScrollView.contentSize = CGSizeMake(self.subViewControllers.count*w, h);
        [self.contentScrollView setContentOffset:CGPointMake(self.selectedIndex*self.contentScrollView.frame.size.width, 0) animated:NO];
    }
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
//                NSLog(@"移动的距离：%f",distanceY);
                [self scrollControlWithVerticalDistance:distanceY state:pan.state];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (_isVertical) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:GLMainScrollViewGestureRecognizerStateEnded object:self.mainScrollView];
                if (self.mainScrollView.contentOffset.y <= self.mainScrollView.mj_header.frame.origin.y) {
//                    UIEdgeInsets inset = self.mainScrollView.contentInset;
//                    inset.top = 100;
//                    self.mainScrollView.contentInset = inset;
                    if (!self.mainScrollView.mj_header.refreshing) {
                        [self.mainScrollView.mj_header beginRefreshing];
                        NSLog(@"开始刷新");
                    }
                }

                {
                    self.dynamicItem.center = CGPointZero;
                    CGPoint velocity = [pan velocityInView:self.mainScrollView];
                    UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicItem]];
                    [inertialBehavior addLinearVelocity:CGPointMake(0, velocity.y) forItem:self.dynamicItem];
                    inertialBehavior.resistance = 5.0;
                    
                    __block CGPoint lastCenter = CGPointZero;
                    gl_WeakSelf(self);
                    inertialBehavior.action = ^{
                        if (self->_isVertical) {
                            CGFloat currentY = weakself.dynamicItem.center.y - lastCenter.y;
                            [weakself scrollControlWithVerticalDistance:currentY state:pan.state];
                        }
                        lastCenter = weakself.dynamicItem.center;
                    };
                    [self.animator addBehavior:inertialBehavior];
                    self.decelerationBehavior = inertialBehavior;
                }
            }
        }
            break;
            
        default:
            break;
    }
    [pan setTranslation:CGPointZero inView:self.mainScrollView];
}

- (void)scrollControlWithVerticalDistance:(CGFloat)distanceY state:(UIGestureRecognizerState)state{
    if (self.mainScrollView.contentOffset.y >= _mainMaxOffsetY || (self.subScrollView.contentOffset.y && distanceY >= 0)) {
//        NSLog(@"111");
        CGFloat subOffsetY = self.subScrollView.contentOffset.y - distanceY;
        if (subOffsetY < 0) {
            subOffsetY = 0;
            self.mainScrollView.contentOffset = CGPointMake(0, self.mainScrollView.contentOffset.y-distanceY);
        } else if (subOffsetY > (self.subScrollView.contentSize.height - self.subScrollView.frame.size.height)) {
            subOffsetY = self.subScrollView.contentOffset.y - rubberBandDistance(distanceY, self.mainScrollView.frame.size.height);
        }
        self.subScrollView.contentOffset = CGPointMake(0, subOffsetY);
    } else {
//        NSLog(@"333");
        CGFloat mainOffsetY = self.mainScrollView.contentOffset.y - distanceY;
        if (mainOffsetY < -self.mainScrollView.contentInset.top) {
            mainOffsetY = self.mainScrollView.contentOffset.y - rubberBandDistance(distanceY, self.mainScrollView.frame.size.height);
        } else if (mainOffsetY > _mainMaxOffsetY) {
            mainOffsetY = _mainMaxOffsetY;
        }
        self.mainScrollView.contentOffset = CGPointMake(0, mainOffsetY);
        if (mainOffsetY == 0) {
            self.subScrollView.contentOffset = CGPointZero;
        }
    }
    
    BOOL isOutside = self.mainScrollView.contentOffset.y < -self.mainScrollView.contentInset.top || self.subScrollView.contentOffset.y > (self.subScrollView.contentSize.height - self.subScrollView.frame.size.height);
    BOOL isMore = self.subScrollView.contentSize.height >= self.subScrollView.frame.size.height || self.mainScrollView.contentOffset.y >= _mainMaxOffsetY || self.mainScrollView.contentOffset.y < -self.mainScrollView.contentInset.top;
    if (isOutside && isMore && self.decelerationBehavior && !self.springBehavior) {
        CGPoint point = CGPointZero;
        BOOL isMain = NO;
        if (self.mainScrollView.contentOffset.y < -self.mainScrollView.contentInset.top) {
            self.dynamicItem.center = self.mainScrollView.contentOffset;
            point = CGPointMake(0, -self.mainScrollView.contentInset.top);
            isMain = YES;
        } else if (self.subScrollView.contentOffset.y > (self.subScrollView.contentSize.height-self.subScrollView.frame.size.height)) {
            self.dynamicItem.center = self.subScrollView.contentOffset;
            point = CGPointMake(self.subScrollView.contentOffset.x, self.subScrollView.contentSize.height-self.subScrollView.frame.size.height);
            if (self.subScrollView.contentSize.height <= self.subScrollView.frame.size.height) {
                point = CGPointMake(self.subScrollView.contentOffset.x, 0);
            }
            isMain = NO;
        }
        [self.animator removeBehavior:self.decelerationBehavior];
        
        gl_WeakSelf(self);
        UIAttachmentBehavior *springBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.dynamicItem attachedToAnchor:point];
        springBehavior.length = 0;
        springBehavior.damping = 1;
        springBehavior.frequency = 2;
        springBehavior.action = ^{
            if (isMain) {
                weakself.mainScrollView.contentOffset = weakself.dynamicItem.center;
                if (weakself.mainScrollView.contentOffset.y == 0) {
                    weakself.subScrollView.contentOffset = CGPointZero;
                }
            } else {
                weakself.subScrollView.contentOffset = weakself.dynamicItem.center;
            }
        };
        [self.animator addBehavior:springBehavior];
        self.springBehavior = springBehavior;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) {
//        NSLog(@"mainScrollView scroll");
        if (self.mainScrollView.contentOffset.y == 0) {
            [self.animator removeAllBehaviors];
        }
    } else if (scrollView == self.contentScrollView) {
//        NSLog(@"contentScrollView scroll");
    } else {
        
    }
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
            vc.selectedIndex = self.selectedIndex;
            if (i == self.selectedIndex) {
                [vc currentSelected];
            }
        }
    }
    
}

- (void)dealloc {
    NSLog(@"===== %@ release =====",NSStringFromClass(self.class));
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

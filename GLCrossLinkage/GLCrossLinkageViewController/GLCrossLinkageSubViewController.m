//
//  GLCrossLinkageSubViewController.m
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/15.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import "GLCrossLinkageSubViewController.h"

@interface GLCrossLinkageSubViewController ()

@property (nonatomic, assign) CGFloat lastContenOffsetY;
@property (nonatomic, assign) CGFloat lastTopViewFrameY;

@property (nonatomic, strong) UIView *tmpView;


@end

@implementation GLCrossLinkageSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addObserver:self forKeyPath:@"topView.frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"subScrollView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subScrollViewLastContentOffsetNotification:) name:[NSString stringWithFormat:@"%@%p",SubScrollViewLastContentOffset,self] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subScrollViewContentOffsetChangeNotification:) name:[NSString stringWithFormat:@"%@%p",SubScrollViewContentOffsetChange,self] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topViewFrameChangeNotification:) name:TopViewFrameChangeNotification object:nil];


}

- (UIView *)tmpView {
    if (!_tmpView) {
        _tmpView = [[UIView alloc] init];
        _tmpView.backgroundColor = [UIColor yellowColor];
    }
    return _tmpView;
}


- (void)setSubScrollView:(UIScrollView *)subScrollView {
    _subScrollView = subScrollView;
    if (!subScrollView) return;
    _subScrollView.contentInset = UIEdgeInsetsMake(self.topView.frame.size.height, 0, 0, 0);
    _subScrollView.contentOffset = CGPointMake(0, -self.topView.frame.size.height);
    self.lastContenOffsetY = _subScrollView.contentOffset.y;
    self.lastTopViewFrameY = self.topView.frame.origin.y;
    

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"topView.frame"]) {
        if (self.subScrollView) {
            CGRect old = CGRectZero;
            if (![change[@"old"] isKindOfClass:NSNull.class]) {
                old = [change[@"old"] CGRectValue];
            }
            CGRect new = CGRectZero;
            if (![change[@"new"] isKindOfClass:NSNull.class]) {
                new = [change[@"new"] CGRectValue];
            }
            if (self.index != self.selectedIndex) {                
                
                CGFloat a = self.topView.frame.origin.y-self.lastTopViewFrameY;
                
                self.subScrollView.contentOffset = CGPointMake(0, self.lastContenOffsetY-a);
            }
//            if (!self.tmpView) {
                [_subScrollView addSubview:self.tmpView];
                self.tmpView.frame = CGRectMake(0, -self.topView.frame.size.height, _subScrollView.frame.size.width, self.topView.frame.size.height);
//            }
        }
    } else if ([keyPath isEqualToString:@"subScrollView.contentOffset"]) {
        if (self.topView) {
            if (self.index != self.selectedIndex) return;
            CGFloat offsetY = self.subScrollView.contentOffset.y+self.topView.frame.size.height;
            NSLog(@"======%f",offsetY);
            UIView *hoverView = [self.topView viewWithTag:HoverView_tag];
            if (hoverView) {
                if (offsetY > hoverView.frame.origin.y) {
                    offsetY = hoverView.frame.origin.y;
                } 
//                else if (offsetY < self.topView.frame.size.height-hov)
            }
            
            CGRect rect = self.topView.frame;
            rect.origin.y = -offsetY;
            self.topView.frame = rect;
            
            
            
            
            
            if (self.topViewFrameChangeBlock) {
                self.topViewFrameChangeBlock(0);
            }
        }
    }
}

- (void)subScrollViewLastContentOffsetNotification:(NSNotification *)notif {
    self.lastContenOffsetY = self.subScrollView.contentOffset.y;
    self.lastTopViewFrameY = self.topView.frame.origin.y;
}

- (void)subScrollViewContentOffsetChangeNotification:(NSNotification *)notif {
//    CGFloat topViewChangeFrame = [notif.userInfo[@"topViewChangeFrame"] floatValue];
//    self.subScrollView.contentOffset = CGPointMake(0, self.lastContenOffsetY-topViewChangeFrame);
    
}

- (void)topViewFrameChangeNotification:(NSNotification *)notif {
    [self setSubScrollView:self.subScrollView];
}

- (void)resetContentOffset:(CGFloat)offsetH {
    NSLog(@"===%f===",offsetH);
//    self.subScrollView.contentOffset = CGPointMake(0, self.lastContenOffsetY.y-offsetH);
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"topView.frame"];
    [self removeObserver:self forKeyPath:@"subScrollView.contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

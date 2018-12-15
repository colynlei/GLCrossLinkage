//
//  GLCrossLinkageSubViewController.m
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/15.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import "GLCrossLinkageSubViewController.h"

@interface GLCrossLinkageSubViewController ()<UIScrollViewDelegate>


@end

@implementation GLCrossLinkageSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addObserver:self forKeyPath:@"topView.frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"subScrollView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)setSubScrollView:(UIScrollView *)subScrollView {
    _subScrollView = subScrollView;
    if (!subScrollView) return;
    subScrollView.delegate = self;
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
            if (old.size.height != new.size.height) {
                self.subScrollView.contentInset = UIEdgeInsetsMake(self.topView.frame.size.height, 0, 0, 0);
                self.subScrollView.contentOffset = CGPointMake(0, -self.topView.frame.size.height);
            }
        }
    } else if ([keyPath isEqualToString:@"subScrollView.contentOffset"]) {
        if (self.topView) {
            
            CGFloat offsetY = self.subScrollView.contentOffset.y+self.topView.frame.size.height;
            
            UIView *hoverView = [self.topView viewWithTag:HoverView_tag];
            if (hoverView) {
                if (offsetY > hoverView.frame.origin.y) {
                    offsetY = hoverView.frame.origin.y;
                }
            }
            
        
            
            NSLog(@"=%f%@",offsetY,NSStringFromCGRect(hoverView.frame));
            CGRect rect = self.topView.frame;
            rect.origin.y = -offsetY;
            self.topView.frame = rect;
            
            
            
        }
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"topView.frame"];
    [self removeObserver:self forKeyPath:@"subScrollView.contentOffset"];
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

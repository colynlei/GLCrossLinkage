//
//  GLHeaderHoverView.m
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/21.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import "GLHeaderHoverView.h"


@interface GLHeaderHoverView ()<GLSegmentedControlDelegate>


@end
@implementation GLHeaderHoverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.segmentedControl = [[GLSegmentedControl alloc] init];
        self.segmentedControl.titles = @[@"item1",@"item2",@"item3"];
        self.segmentedControl.titleGapType = GLSegmentedControlTitleGapTypeEqualGapBoth;
        self.segmentedControl.delegate = self;
        [self addSubview:self.segmentedControl];
        
    }
    return self;
}

- (void)segmentedControl:(GLSegmentedControl *)segmentedControl didSelectedIndex:(NSInteger)index {
    if (self.itemSelectedBlock) {
        self.itemSelectedBlock(index);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.segmentedControl.frame = self.bounds;
}

@end

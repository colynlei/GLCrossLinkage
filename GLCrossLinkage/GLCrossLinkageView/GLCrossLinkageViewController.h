//
//  GLCrossLinkageViewController.h
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/19.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCrossLinkageMacro.h"
#import "GLCrossLinkageSubViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLCrossLinkageViewController : UIViewController

//顶部视图，frame只取高度
@property (nonatomic, strong, nullable) UIView *headerView;

//悬停视图，frame只取高度
@property (nonatomic, strong, nullable) UIView *headerHoverView;

//主视图frame。默认self.view.bounds
@property (nonatomic, assign) CGRect mainScrollViewFrame;

//子控制器视图
@property (nonatomic, strong) NSArray <GLCrossLinkageSubViewController *>*subViewControllers;

@property (nonatomic, assign) BOOL isStopAnimation;//是否禁止动画

//页面当前显示的是哪一个view
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) CGFloat HoverViewOffsetY;//悬浮框悬停位置向下偏移量。一般是偏移导航栏的高度，默认0




- (void)selectedIndexChange;


@end

NS_ASSUME_NONNULL_END

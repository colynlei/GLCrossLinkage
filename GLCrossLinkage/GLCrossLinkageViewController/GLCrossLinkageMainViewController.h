//
//  GLCrossLinkageMainViewController.h
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/15.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCrossLinkageSubViewController.h"
#import "GLCrossLinkageMacro.h"


NS_ASSUME_NONNULL_BEGIN

@interface GLCrossLinkageMainViewController : UIViewController

//内容视图的frame，默认self.view.bounds
@property (nonatomic, assign) CGRect contentViewFrame;

//头部视图，不关心视图内容
@property (nonatomic, strong) UIView *headerView;

//悬停视图，不关心视图内容
@property (nonatomic, strong) UIView *headerHoverView;

//背景视图，顶部视图和悬停视图的背景视图,可以加载背景图片，透明效果，或者其他特殊效果的背景视图
@property (nonatomic, strong) UIView *headerBgView;

//所展示的分页视图
@property (nonatomic, strong) NSArray <GLCrossLinkageSubViewController *>*subViewControllers;


@end

NS_ASSUME_NONNULL_END

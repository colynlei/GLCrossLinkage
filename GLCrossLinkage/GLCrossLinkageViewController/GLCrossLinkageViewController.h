//
//  GLCrossLinkageViewController.h
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/19.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLCrossLinkageViewController : UIViewController

//顶部视图
@property (nonatomic, strong, ) UIView *headerView;

//悬停视图
@property (nonatomic, strong, nullable) UIView *headerHoverView;

//主视图frame。默认self.view.bounds
@property (nonatomic, assign) CGRect mainScrollViewFrame;

@end

NS_ASSUME_NONNULL_END

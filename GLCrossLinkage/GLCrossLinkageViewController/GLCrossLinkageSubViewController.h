//
//  GLCrossLinkageSubViewController.h
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/15.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCrossLinkageMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLCrossLinkageSubViewController : UIViewController

//子类自己创建的UIScrollView、UITableView、UICollectionView等。
@property (nonatomic, strong) UIScrollView *subScrollView;

//获取顶部视图指针
@property (nonatomic, strong) UIView *topView;

@end

NS_ASSUME_NONNULL_END

//
//  GLCrossLinkageSubViewController.h
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/19.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLCrossLinkageSubViewController : UIViewController

//自控制器UIScrollView、UITableView、UICollectionView等指针。
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) NSInteger selectedIndex;

- (void)currentSelected;//当前为选中

@end

NS_ASSUME_NONNULL_END

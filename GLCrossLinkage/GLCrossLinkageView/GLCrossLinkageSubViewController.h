//
//  GLCrossLinkageSubViewController.h
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/19.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCrossLinkageMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLCrossLinkageSubViewController : UIViewController

//自控制器UIScrollView、UITableView、UICollectionView等指针。
@property (nonatomic, strong) UIScrollView *scrollView;

//当前控制索引
@property (nonatomic, assign) NSInteger currentIndex;

//当前选中的控制器索引
@property (nonatomic, assign) NSInteger selectedIndex;

//下拉刷新，传入MJRefreshHeader
@property (nonatomic, strong) MJRefreshHeader *gl_mj_header;

//下拉刷新结束
@property (nonatomic, copy) void(^gl_mj_header_refreshEndBlock)(NSInteger currentIndex, UIScrollView *subScrollView);

//上拉加载更多，传入MJRefreshFooter
@property (nonatomic, strong) MJRefreshFooter *gl_mj_footer;

//上拉加载结束
@property (nonatomic, copy) void(^gl_mj_footer_refreshEndBlock)(NSInteger currentIndex, UIScrollView *subScrollView, SEL endAction);


- (void)currentSelected;//当前为选中

@end

NS_ASSUME_NONNULL_END

//
//  GLSegmentedControl.h
//  GLSegmentedControl
//
//  Created by 雷国林 on 2018/12/7.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, GLSegmentedControlTitleGapType) {//间距类型
    //无任何模式，无间距，无左右边距。宽度为等宽, 此模式一般为能容纳所有内容。
    //titleLeft、titleRight、titleGap无效。
    GLSegmentedControlTitleGapTypeNone,
    
    //等间距，间距可设置，距左右两边距离可设置，
    GLSegmentedControlTitleGapTypeDefault,
    
    //等间距，包括距左右两边距离，距左右两边距离不可设置，间距为自动计算, 此模式一般为能容纳所有内容。
    //titleLeft、titleRight、titleGap无效。
    GLSegmentedControlTitleGapTypeEqualGapBoth,
    
    //等间距，不包括距左右距离，距左右两边距离可设置，间距为自动计算, 此模式一般为能容纳所有内容
    //titleLeft、titleRight有效；titleGap无效。
    GLSegmentedControlTitleGapTypeEqualGapWithoutBoth,
};

@class GLSegmentedControl;
@protocol GLSegmentedControlDelegate <NSObject>

- (void)segmentedControl:(GLSegmentedControl *)segmentedControl didSelectedIndex:(NSInteger)index;

@end

@interface GLSegmentedControl : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>* _Nonnull )titles;

@property (nonatomic, weak) id<GLSegmentedControlDelegate> delegate;

@property (nonatomic, strong) NSArray <NSString *>*titles;//标题数组

@property (nonatomic, assign) GLSegmentedControlTitleGapType titleGapType;//默认为GLSegmentedControlTitleGapTypeDefault

@property (nonatomic, strong) UIFont  *selectedFont;//选中的字体
@property (nonatomic, strong) UIColor *selectedColor;//选中的颜色

@property (nonatomic, strong) UIFont  *normalFont;//默认的字体
@property (nonatomic, strong) UIColor *normalColor;;//默认的颜色

@property (nonatomic, assign) CGFloat titleLeft;//标题距离左边的距离，默认为0.
@property (nonatomic, assign) CGFloat titleRight;//标题距离右边的距离，默认为0.
@property (nonatomic, assign) CGFloat titleGap;//标题间距，默认10.

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIImage        *lineViewImage;//底部滑块图片，默认无图片
@property (nonatomic, assign) CGSize         lineViewSize;//底部滑块宽高，默认为CGSizeMake(0,5),当宽度为0时，自动计算为文字宽度。
@property (nonatomic, strong) UIColor        *lineViewBackgroundColor;//底部滑块背景色
@property (nonatomic, assign) NSTimeInterval lineViewAnimationDuration;//滑块动画时间

@end

NS_ASSUME_NONNULL_END

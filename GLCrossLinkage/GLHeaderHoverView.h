//
//  GLHeaderHoverView.h
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/21.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLSegmentedControl.h>


NS_ASSUME_NONNULL_BEGIN

@interface GLHeaderHoverView : UIView

@property (nonatomic, copy) void(^itemSelectedBlock)(NSInteger index);
@property (nonatomic, strong) GLSegmentedControl *segmentedControl;


@end

NS_ASSUME_NONNULL_END

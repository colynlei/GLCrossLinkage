//
//  GLSegmentedControl.m
//  GLSegmentedControl
//
//  Created by 雷国林 on 2018/12/7.
//  Copyright © 2018 雷国林. All rights reserved.
//

#import "GLSegmentedControl.h"

#define Self_W self.frame.size.width
#define Self_H self.frame.size.height

#define Title_tag 39572339

@interface GLLabel : UILabel

@property (nonatomic, assign) CGFloat titleW;//字体宽度

@end

@implementation GLLabel


@end



@interface GLSegmentedControl ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) GLLabel *selectedTitleLabel;
@property (nonatomic, strong) NSMutableArray *titleLabelWArray;

@property (nonatomic, assign) BOOL isLayoutSubViews;

@end

@implementation GLSegmentedControl

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initDataWithTitles:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame titles:@[]];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> * _Nonnull)titles {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initDataWithTitles:titles];
        
    }
    return self;
}

- (void)initDataWithTitles:(NSArray *)titles {
    [self initDefault];
    [self addsubviews];
    
    
    self.titles = titles;
}

- (void)initDefault {
    _lineViewSize = CGSizeMake(0, 5);
    _lineViewBackgroundColor = [UIColor greenColor];
    _lineViewAnimationDuration = 0.25;
    
    _selectedIndex = 0;
    _titleLeft = 0;
    _titleRight = 0;
    _titleGap = 10;
    _titleGapType = GLSegmentedControlTitleGapTypeDefault;
    
    _normalFont = [UIFont systemFontOfSize:14];
    _normalColor = [UIColor blackColor];
    
    _selectedFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _selectedColor = [UIColor redColor];
}

- (void)addsubviews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.lineView];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)lineView {
    if (!_lineView) {
        _lineView = [[UIImageView alloc] init];
        _lineView.backgroundColor = [UIColor greenColor];
    }
    return _lineView;
}

- (void)setLineViewBackgroundColor:(UIColor *)lineViewBackgroundColor {
    _lineViewBackgroundColor = lineViewBackgroundColor;
    self.lineView.backgroundColor = _lineViewBackgroundColor;
}

- (NSMutableArray *)titleLabelWArray {
    if (!_titleLabelWArray) {
        _titleLabelWArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _titleLabelWArray;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    GLLabel *label = [self.scrollView viewWithTag:Title_tag+selectedIndex];
    if (label) {
        [self currentSelectedTitleLabel:label];
    }
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    
    if (!titles || !titles.count) return;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        
        GLLabel *label = [self.scrollView viewWithTag:Title_tag+i];
        if (!label) {
            label = [[GLLabel alloc] init];
            label.tag = Title_tag+i;
            label.userInteractionEnabled = YES;
            label.textAlignment = NSTextAlignmentCenter;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleAction:)];
            [label addGestureRecognizer:tap];
        }
        label.text = titles[i];
        [self.scrollView addSubview:label];
    }
    [self setNeedsLayout];
}

- (void)titleAction:(UITapGestureRecognizer *)tap {
    
    GLLabel *label = (GLLabel *)tap.view;
    
    self.selectedIndex = label.tag-Title_tag;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:didSelectedIndex:)]) {
        [self.delegate segmentedControl:self didSelectedIndex:self.selectedIndex];
    }
    
//    if (label == self.selectedTitleLabel) return;
//    [self currentSelectedTitleLabel:label];
}

- (void)currentSelectedTitleLabel:(GLLabel *)label {
    if (label == nil) return;
    self.selectedTitleLabel.font = self.normalFont;
    self.selectedTitleLabel.textColor = self.normalColor;
    self.selectedTitleLabel = label;
    self.selectedTitleLabel.font = self.selectedFont;
    self.selectedTitleLabel.textColor = self.selectedColor;
    
    [self reloadFrame];

}

- (void)reloadFrame {
    
    [self.titleLabelWArray removeAllObjects];
    CGFloat all_w = 0;//计算出所有字体的宽度
    for (NSInteger i = 0; i < self.titles.count; i++) {
        GLLabel *label = [self.scrollView viewWithTag:Title_tag+i];
        if (label) {
            label.titleW = [self widthWithText:label.text font:label.font];
            [self.titleLabelWArray addObject:@(label.titleW)];
            all_w += label.titleW;
        }
    }
    
    CGFloat gap = self.titleGap;
    CGFloat left = self.titleLeft;
    CGFloat right = self.titleRight;
    BOOL isTitle_W = YES;
    
    switch (self.titleGapType) {
        case GLSegmentedControlTitleGapTypeNone:
        {
            if (all_w > Self_W) {
                if (self.isLayoutSubViews) {
                    NSLog(@"所有字体总宽度大于当前视图所容许宽度");
                }
            } else {
                gap = 0;
                left = 0;
                right = 0;
                isTitle_W = NO;
            }
        }
            break;
        case GLSegmentedControlTitleGapTypeDefault:
            break;
        case GLSegmentedControlTitleGapTypeEqualGapBoth:
        {
            
            if (all_w > Self_W) {
                if (self.isLayoutSubViews) {
                    NSLog(@"所有字体总宽度大于当前视图所容许宽度");
                }
            } else {
                gap = (Self_W-all_w)/(self.titles.count+1);
                left = gap;
                right = gap;
            }
        }
            break;
        case GLSegmentedControlTitleGapTypeEqualGapWithoutBoth:
        {
            if (all_w > Self_W-left-right) {
                if (self.isLayoutSubViews) {
                    NSLog(@"所有字体总宽度大于当前视图所容许宽度");
                }
            } else {
                gap = (Self_W-all_w-left-right)/(self.titles.count-1);
            }
        }
            break;
            
        default:
            break;
    }
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        GLLabel *label = [self.scrollView viewWithTag:Title_tag+i];
        if (label) {
            CGFloat x = left;
            CGFloat w = isTitle_W?[self.titleLabelWArray[i] floatValue]:(Self_W/self.titles.count);
            if (i > 0) {
                GLLabel *lastLabel = [self.scrollView viewWithTag:Title_tag+i-1];
                x = lastLabel.frame.origin.x+lastLabel.frame.size.width+gap;
            }
            
            label.frame = CGRectMake(x, 0, w, Self_H);
            
            if (i == self.titles.count-1) {
                self.scrollView.contentSize = CGSizeMake(label.frame.origin.x+w+right, Self_H);
            }
        }
    }
    
    CGFloat h = self.lineViewSize.height;
    CGFloat x = self.lineViewSize.width==0?(self.selectedTitleLabel.center.x-self.selectedTitleLabel.titleW/2):(self.selectedTitleLabel.center.x-self.lineViewSize.width/2);
    CGFloat y = Self_H-h;
    CGFloat w = self.lineViewSize.width==0?self.selectedTitleLabel.titleW:self.lineViewSize.width;
    NSTimeInterval duration = self.lineView.frame.origin.y == 0?0:self.lineViewAnimationDuration;
    [UIView animateWithDuration:duration animations:^{
        self.lineView.frame = CGRectMake(x, y, w, h);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.isLayoutSubViews = YES;
    [self.scrollView bringSubviewToFront:self.lineView];
    self.scrollView.frame = self.bounds;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        GLLabel *label = [self.scrollView viewWithTag:Title_tag+i];
        if (label) {
            label.textColor = self.normalColor;
            label.font = self.normalFont;
        }
    }
    [self setSelectedIndex:self.selectedIndex];
    
}

- (CGFloat)widthWithText:(NSString *)text font:(UIFont *)font {
    CGSize result;
    NSMutableDictionary *attr = [NSMutableDictionary new];
    attr[NSFontAttributeName] = font;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attr context:nil];
    result = rect.size;
    return rect.size.width;
}

- (void)dealloc {

}

@end

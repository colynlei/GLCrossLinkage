//
//  GLCrossLinkageMacro.h
//  GLCrossLinkage
//
//  Created by 雷国林 on 2018/12/16.
//  Copyright © 2018 雷国林. All rights reserved.
//

#ifndef GLCrossLinkageMacro_h
#define GLCrossLinkageMacro_h

//悬停视图标识
#define HoverView_tag 329875

static NSString *SubScrollViewContentOffsetChange = @"SubScrollViewContentOffsetChange";
static NSString *SubScrollViewLastContentOffset = @"SubScrollViewLastContentOffset";
static NSString *TopViewFrameChangeNotification = @"TopViewFrameChangeNotification";

//屏幕尺寸
#define gl_ScreenSize \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale, [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)
#define gl_ScreenWidth       kScreenSize.width
#define gl_ScreenHeight      kScreenSize.height
#define gl_ScreenScale       kScreenWidth/375
#define gl_ScreenFrame       CGRectMake(0, 0, kScreenWidth, kScreenHeight)

//判断是iphone几
#define gl_IsIphone4         (gl_ScreenWidth==320&&gl_ScreenHeight==480)
#define gl_IsIphone5         (gl_ScreenWidth==320&&gl_ScreenHeight==568)
#define gl_IsIphone6         (gl_ScreenWidth==375&&gl_ScreenHeight==667)
#define gl_IsIphone6Plus     (gl_ScreenWidth==414&&gl_ScreenHeight==736)
#define gl_IsIphone7         gl_IsIphone6
#define gl_IsIphone7Plus     gl_IsIphone6Plus
#define gl_IsIphone8         gl_IsIphone6
#define gl_IsIphone8Plus     gl_IsIphone6Plus
#define gl_IsIphoneX         [[UIScreen mainScreen] bounds].size.width >=375.0f && [[UIScreen mainScreen] bounds].size.height >=812.0f && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//状态栏、导航条、导航栏
#define gl_TopBarSafeHeight  (CGFloat)(gl_IsIphoneX?(44):(0)) // 顶部安全区域远离高度
#define gl_BottomSafeHeight  (CGFloat)(gl_IsIphoneX?(34):(0)) // 底部安全区域远离高度
#define gl_TopBarDifHeight   (CGFloat)(gl_IsIphoneX?(44):(20))  // iPhoneX的状态栏高度差值
#define gl_NavbarHeight      (CGFloat)(44+gl_TopBarDifHeight)   // 导航条高度
#define gl_TabbarHeight      (CGFloat)(49+gl_BottomSafeHeight)    //分栏高度

#endif /* GLCrossLinkageMacro_h */

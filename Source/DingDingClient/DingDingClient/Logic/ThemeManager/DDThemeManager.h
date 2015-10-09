//
//  DDThemeManager.h
//  DingDingClient
//
//  Created by phoenix on 15/9/28.
//  Copyright © 2015年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DD_THEME [DDThemeManager getInstance]

@interface DDThemeManager : NSObject
{
    
}

+ (DDThemeManager*)getInstance;

// 默认水平方向间距
@property (nonatomic, assign) CGFloat xMargin;
// 默认垂直方向间距
@property (nonatomic, assign) CGFloat yMargin;
// 屏幕宽度
@property (nonatomic, assign) CGFloat screenWidth;
// 屏幕高度
@property (nonatomic, assign) CGFloat screenHeight;
// 默认状态条高度
@property (nonatomic, assign) CGFloat statusBarHeight;
// 默认导航条高度
@property (nonatomic, assign) CGFloat navigationBarHeight;
// 默认tabBar高度
@property (nonatomic, assign) CGFloat tabBarHeight;
// 默认toolBar高度
@property (nonatomic, assign) CGFloat toolBarHeight;
// 默认keyboard高度
@property (nonatomic, assign) CGFloat keyboardHeight;
// 默认table section高度
@property (nonatomic, assign) CGFloat tableSectionHeight;
// 默认table行高度
@property (nonatomic, assign) CGFloat tableRowHeight;
// 默认table设置项高度
@property (nonatomic, assign) CGFloat tableItemHeight;
// 默认按钮高度
@property (nonatomic, assign) CGFloat buttonHeight;

/* 预置颜色 */
// 主色调
@property (nonatomic, strong) UIColor* colorTheme;
// 标题颜色
@property (nonatomic, strong) UIColor* colorTitle;
// 副标题颜色
@property (nonatomic, strong) UIColor* colorSubTitle;
// 普通内容文字颜色
@property (nonatomic, strong) UIColor* colorText;
// 红色
@property (nonatomic, strong) UIColor* colorRed;
// 绿色
@property (nonatomic, strong) UIColor* colorGreen;
// 白色
@property (nonatomic, strong) UIColor* colorWhite;
// 黑色
@property (nonatomic, strong) UIColor* colorBlack;
// 灰色
@property (nonatomic, strong) UIColor* colorGray;
// 浅灰色
@property (nonatomic, strong) UIColor* colorLightGray;
// 分割线颜色
@property (nonatomic, strong) UIColor* colorSeperateLine;
// 导航条颜色
@property (nonatomic, strong) UIColor* colorNavigationBar;
// 背景颜色
@property (nonatomic, strong) UIColor* colorBackground;

/* 系统字体大小 */
// 超大号字体
@property (nonatomic, assign) CGFloat fontSizeExtraLarge;
// 大号字体
@property (nonatomic, assign) CGFloat fontSizeLarge;
// 中号字体
@property (nonatomic, assign) CGFloat fontSizeMiddle;
// 小号字体
@property (nonatomic, assign) CGFloat fontSizeSmall;
// 超小号字体
@property (nonatomic, assign) CGFloat fontSizeExtraSmall;

@end

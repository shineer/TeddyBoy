//
//  DDThemeManager.m
//  DingDingClient
//
//  Created by phoenix on 15/9/28.
//  Copyright © 2015年 SEU. All rights reserved.
//

#import "DDThemeManager.h"

static DDThemeManager *_sharedThemeManager = nil;

@implementation DDThemeManager

+ (DDThemeManager*)getInstance
{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedThemeManager = [[DDThemeManager alloc] init];
    });
    
    return _sharedThemeManager;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        [self setupTheme];
    }
    return self;
}

- (void)dealloc
{

}

- (void)setupTheme
{
    // 默认水平方向间距
    self.xMargin = 10.0;
    // 默认垂直方向间距
    self.yMargin = 10.0;
    // 屏幕宽度
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    // 屏幕高度
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    // 默认状态条高度
    self.statusBarHeight = 20.0;
    // 默认导航条高度
    self.navigationBarHeight = 44.0;
    // 默认tabBar高度
    self.tabBarHeight = 60.0;
    // 默认toolBar高度
    self.toolBarHeight = 49.0;
    // 默认keyboard高度
    self.keyboardHeight = 216.0;
    // 默认table section高度
    self.tableSectionHeight = 14.0;
    // 默认table行高度
    self.tableRowHeight = 44.0;
    // 默认table设置项高度
    self.tableItemHeight = 64.0;
    // 默认按钮高度
    self.buttonHeight = 40.0;
    
    /* 预置颜色 */
    // 主色调
    self.colorTheme = RGBCOLORV(0xff7733);
    // 标题颜色
    self.colorTitle = RGBCOLORV(0x222222);
    // 副标题颜色
    self.colorSubTitle = RGBCOLORV(0x444444);
    // 普通内容文字颜色
    self.colorText = RGBCOLORV(0x333333);
    // 红色
    self.colorRed = RGBCOLORV(0xFF0000);
    // 绿色
    self.colorGreen = RGBCOLORV(0x00FF00);
    // 白色
    self.colorWhite = RGBCOLORV(0xFFFFFF);
    // 黑色
    self.colorBlack = RGBCOLORV(0x000000);
    // 灰色
    self.colorGray = RGBCOLORV(0x757575);
    // 浅灰色
    self.colorLightGray = RGBCOLORV(0xBCC4CD);
    // 分割线颜色
    self.colorSeperateLine = RGBCOLORV(0xC8CFD6);
    // 导航条颜色
    self.colorNavigationBar = RGBCOLORV(0xff7733);
    // 背景颜色
    self.colorBackground = RGBCOLORV(0xf1f1f1);
    
    /* 系统字体大小 */
    // 超大号字体
    self.fontSizeExtraLarge = 30.0;
    // 大号字体
    self.fontSizeLarge = 18.0;
    // 中号字体
    self.fontSizeMiddle = 16.0;
    // 小号字体
    self.fontSizeSmall = 14.0;
    // 超小号字体
    self.fontSizeExtraSmall = 12.0;

}

@end

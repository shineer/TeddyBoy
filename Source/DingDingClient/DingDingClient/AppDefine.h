//
//  APPDefine.h
//  DingDingClient
//
//  Created by phoenix on 14-1-3.
//  Copyright (c) 2014年 LiuQi. All rights reserved.
//

#ifndef DingDing_APPDefine_h
#define DingDing_APPDefine_h

/* 全局的宏定义 */
#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

/* 国际化 */
#define DDLocalizedString(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"ddlocalize"]

/* 功能开关 */

// 辅助微调UI间距,还原高保真开关,打开这个宏每个UIView控件都会出现红色边框和详细标注,只适用于IOS7或以上
#define NO_DEBUG_VIEW

// 应用程序的名字
#define APP_NAME    @"丁丁租房"

// 颜色帮助宏
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBCOLORV(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]
#define RGBCOLORVA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

/* 客户端所有通知定义 */

// 登陆监听
#define kNotificationLoginStateChanged              @"kNotificationLoginStateChanged"

// 网络状态改变
#define KNotifcationNetworkReachabilityChanged      @"KNotifcationNetworkReachabilityChanged"

// 程序进入后台
#define KNotifcationApplicationDidEnterBackground   @"KNotifcationApplicationDidEnterBackground"

// 程序切到前台
#define KNotifcationApplicationWillEnterForeground  @"KNotifcationApplicationWillEnterForeground"

// 程序突然退出时发送界面通知
#define kNotificationWillTerminate                  @"kNotificationWillTerminate"


//客户端所有枚举状态常量定义

// 模板
typedef enum
{
    EDD__XXXX__Type1 = 0,                           //模板一
    EDD__XXXX__Type2,                               //模板二
    EDD__XXXX__Type3,                               //模板三
    EDD__XXXX__Type4                                //模板四
}EDD__XXXX__Type;


#endif

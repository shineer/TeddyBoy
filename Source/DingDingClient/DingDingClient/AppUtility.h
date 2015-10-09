//
//  AppUtility.h
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_UTILITY [AppUtility getInstance]

/* ---------------应用程序设定值（可持久化）------------------- */
@interface DDAppSetting : NSObject
{
    
}

// 程序是否已经激活过
@property (nonatomic, assign) BOOL isActived;
// 是否需要显示闪屏页
@property (nonatomic, assign) BOOL isShowSplash;
// 闪屏页地址
@property (nonatomic, strong) NSString* splashImageUrl;
// 多账号数组
@property (nonatomic, strong) NSMutableDictionary* userAccountDic;
// host环境
@property (nonatomic, assign) EDDHostType hostType;

@end
/* --------------------------------------------------------- */

/* ---------------当前用户数据结构（可持久化）------------------- */
@interface DDCurrentUser : NSObject
{
    
}

// 登录账号(手机号)
@property (nonatomic, strong) NSString* account;
// 密码
@property (nonatomic, strong) NSString* password;
// userId
@property (nonatomic, strong) NSString* userId;
// 昵称
@property (nonatomic, strong) NSString* nickName;
// 性别(1－>男, 2->女)
@property (nonatomic, assign) int gender;
// 是否是第一次登录
@property (nonatomic, assign) int isFirstTimeLogin;

@end
/* --------------------------------------------------------- */

@interface AppUtility : NSObject

/* --------------- 属性 ------------------------------------ */
// 持久化
@property (nonatomic, strong) DDAppSetting* appSetting;
@property (nonatomic, strong) DDCurrentUser* currentUser;
// 缓存
@property (nonatomic, strong) NSDictionary* provinceDic;
@property (nonatomic, strong) NSArray* areaArray;
/* --------------------------------------------------------- */


+ (AppUtility*)getInstance;

+ (UIRemoteNotificationType)getPushNotificationType;
// 注册PUSH服务
+ (void)regPushServive;
// 取消注册PUSH服务
+ (void)unregPushService;

// 保存应用程序设置
- (void)saveAppSetting;

/* --------------- 当前用户相关操作 -------------------------- */
// 检查当前用户是否存在
- (BOOL)checkCurrentUser;
// 保存当前用户
- (void)saveCurrentUser;
// 注销当前用户
- (void)clearCurrentUser;
/* --------------------------------------------------------- */

/* --------------- 当前用户文件夹路径 ------------------------- */
// 当前用户路径
- (NSString*)userDocumentPath;
// 当前用户数据库路径
- (NSString*)userDatabasePath;
// 当前用户图片路径
- (NSString*)userImageFilePath;
// 当前用户录音路径
- (NSString*)userVoiceFilePath;
// 公共文件夹路径
- (NSString*)userCommonPath;
/* --------------------------------------------------------- */

/* --------------- 帮助类公共方法 ---------------------------- */
// 重置app环境变量(初次运行或者切换host环境)
- (void)resetAppEnvirement;
// 获取地理位置信息
- (void)getLoctaionInfo;
/* --------------------------------------------------------- */

@end

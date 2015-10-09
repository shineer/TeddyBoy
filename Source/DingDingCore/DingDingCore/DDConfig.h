//
//  DDConfig.h
//  DingDingCore
//
//  Created by phoenix on 14-10-16.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DD_CONFIG [DDConfig getInstance]

typedef enum
{
    EDDHostType_Development             = 0,                //测试环境
    EDDHostType_Production              = 1,                //生产环境
    EDDHostType_Other                   = 2                 //其他环境
}EDDHostType;

/* ---------------SDK参数（可持久化）------------------- */
@interface DDCoreSetting : NSObject
{
    
}

// token凭证
@property (nonatomic, copy) NSString* token;
// device token(验证设备唯一性)
@property (nonatomic, copy) NSString* deviceToken;
// userId
@property (nonatomic, copy) NSString* userId;
// appId
@property (nonatomic, copy) NSString* appId;
// appVersion
@property (nonatomic, copy) NSString* appVersion;
// cityId
@property (nonatomic, assign) NSInteger cityId;
// 经度
@property (nonatomic, assign) CGFloat longitude;
// 纬度
@property (nonatomic, assign) CGFloat latitude;

@end
/* --------------------------------------------------------- */

/* 服务器接口地址 */

/**
 * 获取服务器时间
 */
#define kGetSystemTimeUrl                   @"/GET/common/systemTime.do"

/**
 * 获取AppId
 */
#define kGetAppIdUrl                        @"/GET/common/appId.do"

/**
 * 获取验证码
 */
#define kLoginIdentityCodeUrl               @"/GET/account/loginIdentityCode.do"

/**
 * 用户登录
 */
#define kUserLoginUrl                       @"/GET/account/userLogin.do"

/**
 * 获取推荐房源
 */
#define kHotHouseListByClientUrl            @"/GET/search/hotHouseListByClient.do"


@interface DDConfig : NSObject

+ (DDConfig*)getInstance;

/* --------------- 属性 ------------------------------------ */
// 持久化
@property (nonatomic, strong) DDCoreSetting* coreSetting;
/* --------------------------------------------------------- */

@property (nonatomic, copy) NSString* hostUrl;//host接口导航地址
@property (nonatomic, copy) NSString* hostImageUrl;//host图片导航地址
@property (nonatomic, copy) NSString* getSystemTimeUrl;//获取服务器时间
@property (nonatomic, copy) NSString* getAppIdUrl;//获取AppId
@property (nonatomic, copy) NSString* loginIdentityCodeUrl;//获取验证码
@property (nonatomic, copy) NSString* userLoginUrl;//用户登录
@property (nonatomic, copy) NSString* hotHouseListByClientUrl;//获取推荐房源

// 保存core设置
- (void)saveCoreSetting;
// 切换core环境
- (void)switchHostWithType:(EDDHostType)type;
// 注销core
- (void)coreLogout;
// 获取baseInfo
- (NSDictionary*)getBaseInfo;

@end

//
//  DDLoginManager.h
//  DingDingClient
//
//  Created by phoenix on 14-11-8.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    EDDStatusNotLogin     =   -1,       //未登录
    EDDStatusLogining     =   0,        //登录中
    EDDStatusLogined      =   1,        //已登录
    
}EDDLoginState;

typedef enum
{
    
    EDDAppStateNone                 = 0,    //保留
    EDDAppStateDidEnterBackground   = 1,    //在后台
    EDDAppStateWillEnterForeground  = 2,    //到前台
    
}EDDAppState;

@interface DDLoginManager : NSObject
{
    
}

+ (DDLoginManager*)getInstance;

// 应用程序状态
@property (nonatomic, readonly, assign) EDDAppState appState;

// 用户登陆状态
@property (nonatomic, assign) EDDLoginState loginState;

// 用户开始登陆
- (void)startLogin:(NSString*)mobileNo password:(NSString*)password type:(int)type;

// 用户注销
- (void)logout;

@end

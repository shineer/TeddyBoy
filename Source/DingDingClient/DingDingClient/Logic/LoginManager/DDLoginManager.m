//
//  DDLoginManager.m
//  DingDingClient
//
//  Created by phoenix on 14-11-8.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDLoginManager.h"
#import "DDNavViewController.h"
#import "DDLoginViewController.h"

static DDLoginManager *_sharedLoginManager = nil;

@implementation DDLoginManager

@synthesize appState = _appState;
@synthesize loginState = _loginState;

+ (DDLoginManager*)getInstance
{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedLoginManager = [[DDLoginManager alloc] init];
    });
    
    return _sharedLoginManager;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didEnterBackground)
                                                     name:KNotifcationApplicationDidEnterBackground
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willEnterForeground)
                                                     name:KNotifcationApplicationWillEnterForeground
                                                   object:nil];
        
        _loginState = EDDStatusNotLogin;
        _appState = EDDAppStateWillEnterForeground;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setloginState:(EDDLoginState)state
{
    if(_loginState == state)
    {
        return;
    }
    
    // 状态机改变发出登录状态改变通知
    _loginState = state;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginStateChanged object:nil];
}

-(void)didEnterBackground
{
    _appState = EDDAppStateDidEnterBackground;
}

-(void)willEnterForeground
{
    _appState = EDDAppStateWillEnterForeground;
}

// 用户开始登陆
- (void)startLogin:(NSString*)mobileNo password:(NSString*)password type:(int)type;
{
    [self setloginState:EDDStatusLogining];
    
    UI_LOG(@"\n---- 开始登录 ----");
    
    // 后台静默登录不需要显示进度
    if(type == 0)
    {
        // 开始转圈动画
        [DDHUDVIEW startAnimatingWithTitle:@"登录中..."];
    }
    
    [DD_CORE.userService userLogin:mobileNo password:password resopnse:^(NSInteger result, NSDictionary *dict, DDError *error) {
        
        if(type == 0)
        {
            // 停止转圈动画
            [DDHUDVIEW stopAnimating];
        }
        
        // 登录成功
        if(result == EDDResponseResultSucceed)
        {
            UI_LOG(@"\n---- 登录成功 ----");

            // 更新状态机
            [self setloginState:EDDStatusLogined];
            
            // 取出data字典
            NSDictionary* dataDic = [dict objectForKey:@"data"];

            // 登录账号(手机号)
            APP_UTILITY.currentUser.account = mobileNo;
            // 密码
            APP_UTILITY.currentUser.password = password;
            // userId
            APP_UTILITY.currentUser.userId = [dataDic objectForKey:@"accountId"];
            // 昵称
            APP_UTILITY.currentUser.nickName = [dataDic objectForKey:@"name"];
            // 性别(1－>男, 2->女)
            APP_UTILITY.currentUser.gender = [[dataDic objectForKey:@"gender"] intValue];
            // 是否是第一次登录
            APP_UTILITY.currentUser.isFirstTimeLogin = [[dataDic objectForKey:@"isFirstTimeLogin"] intValue];
            // 更新并保存当前账号对象
            [APP_UTILITY saveCurrentUser];

            // 更新或添加该账号到账户数组
            [APP_UTILITY.appSetting.userAccountDic setObject:APP_UTILITY.currentUser.password forKey:APP_UTILITY.currentUser.account];
            [APP_UTILITY saveAppSetting];
            UI_LOG(@"APP_UTILITY.appSetting.userAccountDic = %@", APP_UTILITY.appSetting.userAccountDic);
            
            // 创建联系人(自己)
            DDContactData* me = [DDContactData newContact:APP_UTILITY.currentUser.userId];
            me.age = [[dataDic objectForKey:@"age"] intValue];
            me.cityId = [[dataDic objectForKey:@"cityId"] intValue];
            me.gender = [[dataDic objectForKey:@"gender"] intValue];
            me.industry = [[dataDic objectForKey:@"industry"] intValue];
            me.nickName = [dataDic objectForKey:@"name"];
            me.phone = [dataDic objectForKey:@"phone"];
            [me saveContact];

        }// end of 登录成功
        else
        {
            UI_LOG(@"\n---- 登录失败 %@ ----", error.errorMsg);
            // 更新状态机
            [self setloginState:EDDStatusNotLogin];
            // 通知上层登录出错
            if(error)
            {
                [DDHUDVIEW showTips:error.errorMsg autoHideTime:1];
            }
        }

    }];
}

- (void)logout
{
    UI_LOG(@"\n---- 注销 ----");
    
    // 重置登录状态
    [self setloginState:EDDStatusNotLogin];
    
    // 清空当前用户(包括数据库引用)
    [APP_UTILITY clearCurrentUser];
    
    // 清除底层Core的一些变量,例如token和userId
    [DD_CONFIG coreLogout];
    
    // 跳转到登录界面
    [AppNavigator openLoginViewController];
}

@end

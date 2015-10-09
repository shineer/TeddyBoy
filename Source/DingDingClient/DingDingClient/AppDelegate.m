//
//  AppDelegate.m
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 清空桌面icon上未读消息数
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 制定状态栏样式
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 重置app环境变量(初次运行或者切换host环境)
    [APP_UTILITY resetAppEnvirement];
    
    // 获取用户的地理位置信息
    [APP_UTILITY getLoctaionInfo];
    
    // 初始化数据库
    [DDCoreDataMgr getInstance];

    // 初始化登录管理器
    [DDLoginManager getInstance];
    
    // 初始化主题管理器
    [DDThemeManager getInstance];

    // 判断客户端是不是第一次运行
    if(APP_UTILITY.appSetting.isActived == NO)
    {
        // 首次运行需要激活
        APP_UTILITY.appSetting.isActived = YES;
        [APP_UTILITY saveAppSetting];
        
        // 首次安装运行,需要进入功能引导页面
        [AppNavigator openIntroductionViewController];
    }
    else
    {
        // 正常流程
        [self launchApp:launchOptions];
    }
    
    return YES;
}


- (void)launchApp:(NSDictionary *)launchOptions
{
    // 跳到登录界面
    [AppNavigator openMainViewController];
    
    // 显示闪屏广告页面
    [self showSplashPage];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifcationApplicationDidEnterBackground object:nil];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifcationApplicationWillEnterForeground object:nil];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWillTerminate object:nil];
    
    // 停止后台断点续传任务
    [[DDHttpTransferService getInstance] cancelAllBreakpointDownLoad];
}

- (void)showSplashPage
{
    // 是否要显示闪屏页
    UIImage* image = [[DDHttpTransferService getInstance] imageAtUrl:APP_UTILITY.appSetting.splashImageUrl];
    if(APP_UTILITY.appSetting.isShowSplash && image)
    {
        // 闪屏页面
        self.window.rootViewController.view.alpha = 0.0;
        CGRect rect = CGRectMake(0, 0, DD_THEME.screenWidth, DD_THEME.screenHeight);
        UIImageView *splashImageView = [[UIImageView alloc] initWithFrame:rect];
        splashImageView.contentMode = UIViewContentModeScaleToFill;
        splashImageView.image = image;
        [self.window addSubview:splashImageView];
        
        [UIView animateWithDuration:2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            splashImageView.alpha = 0.0;
            self.window.rootViewController.view.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            [splashImageView removeFromSuperview];
        }];
    }
}

// 控制哪些页面需要支持旋转
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([window.rootViewController isKindOfClass:NSClassFromString(@"UINavigationController")])
    {
        NSArray *arrays = [(UINavigationController *)window.rootViewController viewControllers];
        
        if([[arrays lastObject] isKindOfClass:NSClassFromString(@"DDTempleteViewController")])
        {
            // 这里需要支持旋转
            return UIInterfaceOrientationMaskAll;
        }
        else
        {
            // 只支持竖屏
            return UIInterfaceOrientationMaskPortrait;
        }
    }

    return UIInterfaceOrientationMaskPortrait;
}

@end

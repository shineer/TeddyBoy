//
//  AppNavigator.h
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_NAVIGATOR [AppNavigator getInstance]

@interface AppNavigator : NSObject

@property (nonatomic, strong) UINavigationController* mainNav;

+ (AppNavigator*)getInstance;

+ (void)showModalViewController:(UIViewController*)viewController animated:(BOOL)animated;
+ (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated;
+ (void)popToViewController:(UIViewController *) viewController animated:(BOOL)animated;
+ (void)popViewControllerAnimated:(BOOL)animated;
+ (void)popToRootViewControllerAnimated:(BOOL)animated;
+ (void)openMainNavControllerWithRoot:(UIViewController *)rootViewController;

/**
 *	打开登陆界面
 */
+ (void)openLoginViewController;

/**
 *	打开Splash界面
 */
+ (void)openSplashViewController;

/**
 *	打开引导页
 */
+ (void)openIntroductionViewController;

/**
 *	打开主界面
 */
+ (void)openMainViewController;


/**
 *	跳转(当前页面push进栈)到web界面根据当前传入的url
 */
+ (void)pushToWebViewController:(NSString*)url withNavTitle:(NSString*)title;


@end

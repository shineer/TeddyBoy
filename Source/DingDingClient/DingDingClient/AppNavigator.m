//
//  AppNavigator.m
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "AppNavigator.h"
#import "AppDelegate.h"
#import "DDNavViewController.h"
#import "DDMainViewController.h"
#import "DDLoginViewController.h"
#import "StrapBtnTestViewController.h"
#import "ZWIntroductionViewController.h"

static AppNavigator * navigator = nil;

@implementation AppNavigator

@synthesize mainNav = _mainNav;

#pragma mark - instance method

+ (AppNavigator*)getInstance
{
	@synchronized(self)
    {
		if (navigator == nil)
        {
			navigator = [[AppNavigator alloc] init];
		}
	}
	return navigator;
}


+ (void)showModalViewController:(UIViewController*)viewController animated:(BOOL)animated
{    
    UIViewController *presentCon = [[AppNavigator getInstance].mainNav presentedViewController];
    
    if (presentCon && [presentCon isKindOfClass:[DDNavViewController class]])
    {
        [(DDNavViewController*)presentCon presentViewController:viewController animated:animated completion:Nil];
    }
    else
    {
        [[AppNavigator getInstance].mainNav presentViewController:viewController animated:animated completion:Nil];
    }
    
}

+ (void)openMainNavControllerWithRoot:(UIViewController *)rootViewController
{
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromRight;
    [delegate.window.layer addAnimation:animation forKey:@"animation"];
    
    DDNavViewController* nav = [[DDNavViewController alloc] initWithRootViewController:rootViewController];
    delegate.window.rootViewController = nav;
    [AppNavigator getInstance].mainNav = nav;
}

+ (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    // 如果不使用系统默认动画的话那么就使用自定义的淡入淡出动画
    if(animated == NO)
    {
        AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionFade;
        animation.subtype = kCATransitionFromRight;
        
        [delegate.window.layer addAnimation:animation forKey:@"animation"];
    }
    
    UIViewController *presentCon = [[AppNavigator getInstance].mainNav presentedViewController];
    if (presentCon && [presentCon isKindOfClass:[DDNavViewController class]])
    {
        [(DDNavViewController*)presentCon pushViewController:viewController animated:animated];
    }
    else
    {
        [[AppNavigator getInstance].mainNav pushViewController:viewController animated:animated];
    }
}

+ (void)popViewControllerAnimated:(BOOL)animated
{
    // 如果不使用系统默认动画的话那么就使用自定义的淡入淡出动画
    if(animated == NO)
    {
        AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionFade;
        animation.subtype = kCATransitionFromRight;
        
        [delegate.window.layer addAnimation:animation forKey:@"animation"];
    }
    
    UIViewController *presentCon = [[AppNavigator getInstance].mainNav presentedViewController];
    if (presentCon && [presentCon isKindOfClass:[DDNavViewController class]])
    {
        [(DDNavViewController*)presentCon popViewControllerAnimated:animated];
    }
    else
    {
        [[AppNavigator getInstance].mainNav popViewControllerAnimated:animated];
    }
}

+ (void)popToRootViewControllerAnimated:(BOOL)animated
{
    [[AppNavigator getInstance].mainNav popToRootViewControllerAnimated:animated];
}

+ (void)popToViewController:(UIViewController *) viewController animated:(BOOL)animated
{
    [[AppNavigator getInstance].mainNav popToViewController:viewController animated:animated];
}


/**
 *	打开登陆界面
 */
+ (void)openLoginViewController
{
    DDLoginViewController* viewController = [[DDLoginViewController alloc] init];
    [AppNavigator showModalViewController:viewController animated:YES];
}

/**
 *	打开引导页
 */
+ (void)openIntroductionViewController
{
    // Added Introduction View Controller
    NSArray *coverImageNames = @[@"img_index_01txt", @"img_index_02txt", @"img_index_03txt"];
    NSArray *backgroundImageNames = @[@"img_index_01bg", @"img_index_02bg", @"img_index_03bg"];
    
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* imageNormal = [UIImage imageNamed:@"btn_enter_normal"];
    UIImage* imageHighlighted = [UIImage imageNamed:@"btn_enter_press"];
    [enterButton setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [enterButton setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
    
    __block ZWIntroductionViewController *viewController = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames button:enterButton];
    
    APP_DELEGATE.window.rootViewController = viewController;

    viewController.didSelectedEnter = ^() {
        
        [viewController.view removeFromSuperview];
        viewController = nil;
        
        // 打开登录页面
        [AppNavigator openMainViewController];
    };
}

/**
 *	打开主界面
 */
+ (void)openMainViewController
{
    DDMainViewController *viewController = [[DDMainViewController alloc] init];
    [AppNavigator openMainNavControllerWithRoot:viewController];
}

/**
 *	打开Strap Button测试页面
 */
+ (void)openStrapBtnTestViewController
{
    StrapBtnTestViewController *viewController = [[StrapBtnTestViewController alloc] initWithNibName:@"StrapBtnTestViewController" bundle:nil];
    [AppNavigator openMainNavControllerWithRoot:viewController];
}

@end

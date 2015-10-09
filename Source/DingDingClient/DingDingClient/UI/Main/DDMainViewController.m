//
//  DDMainViewController.m
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDMainViewController.h"
#import "RDVTabBarItem.h"
#import "StrapBtnTestViewController.h"
#import "DDTenantHouseViewController.h"

@implementation DDMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _tabNameArray = [NSArray arrayWithObjects:@"房子", @"消息", @"我的", nil];
        _selectedTabIndex = 0;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //显示默认tab标签
    [self.navigationTitleLabel setText:_tabNameArray[self.selectedIndex]];
    
    [self setupViewControllers];
    
    // 开启页面切换动画
    [self setAnimated:YES];
    
    self.delegate = self;
    
    [self registerNotifications];

}

#pragma mark - registerNotifications

-(void)registerNotifications
{
    [self unregisterNotifications];
    // todo...
}

-(void)unregisterNotifications
{
    // todo...
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unregisterNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];    
}

- (void)setupViewControllers
{
    DDTenantHouseViewController *firstViewController = [[DDTenantHouseViewController alloc] init];
    firstViewController.parentTabViewController = self;
    
    StrapBtnTestViewController *secondViewController = [[StrapBtnTestViewController alloc] init];
    
    StrapBtnTestViewController *thirdViewController = [[StrapBtnTestViewController alloc] init];
    
    //StrapBtnTestViewController *fiveViewController = [[StrapBtnTestViewController alloc] init];

    [self setViewControllers:@[firstViewController, secondViewController, thirdViewController]];
    
    [self customizeTabBar];
}

- (void)customizeTabBar
{
    // 去掉按下效果
    //UIImage *finishedImage = [UIImage imageNamed:@"tab_bg_selected"];
    UIImage *finishedImage = [UIImage imageNamed:@"tab_bg"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tab_bg"];
    NSArray *tabBarItemImages = @[@"tab_icon_house", @"tab_icon_message", @"tab_icon_self"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [self.tabBar items])
    {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        
        item.unselectedTitleAttributes = @{
                                           NSFontAttributeName: [UIFont systemFontOfSize:DD_THEME.fontSizeExtraSmall],
                                           NSForegroundColorAttributeName:DD_THEME.colorGray,
                                           };
        item.selectedTitleAttributes = @{
                                         NSFontAttributeName: [UIFont systemFontOfSize:DD_THEME.fontSizeExtraSmall],
                                         NSForegroundColorAttributeName:DD_THEME.colorTheme,
                                         };
        
        item.titlePositionAdjustment = UIOffsetMake(0, 0);
        item.title = [_tabNameArray objectAtIndex:index];
        
        item.badgeTextFont = [UIFont systemFontOfSize:9];
        // 气泡颜色值
        item.badgeBackgroundColor = DD_THEME.colorTheme;
        item.badgePositionAdjustment = UIOffsetMake(-4, 0);
        
        index++;
    }
}

#pragma mark - DDTabViewControllerDelegate

/**
 * Asks the delegate whether the specified view controller should be made active.
 */
- (BOOL)tabBarController:(DDTabViewController*)tabBarController shouldSelectViewController:(UIViewController*)viewController
{
    return YES;
}

/**
 * Tells the delegate that the user selected an item in the tab bar.
 */
- (void)tabBarController:(DDTabViewController*)tabBarController didSelectViewController:(UIViewController*)viewController
{
    if(self.selectedIndex == 0)
    {
        [self.navigationTitleLabel setText:@"房子"];
    }
    else if(self.selectedIndex == 1)
    {
        [self.navigationTitleLabel setText:@"消息"];
    }
    else
    {
        [self.navigationTitleLabel setText:@"我的"];
    }
}

#pragma mark - help function

- (void)addNavigationBarButton:(UIButton*)button
{
    [self.navigationController.navigationBar addSubview:button];
}

- (void)removeNavigationBarButton:(UIButton*)button
{
    [button removeFromSuperview];
}

- (void)updateTabBadge:(NSNotification*)notification
{
    int count = [notification.object intValue];

    RDVTabBarItem *messageBoxTabItem = [self.tabBar.items objectAtIndex:2];
    if(count > 99)
    {
        // 不要把badgeValue设置成99+或者...等非数字的字串,因为要在别的地方把这个数取出来转成int来做某些判断
        messageBoxTabItem.badgeValue = [NSString stringWithFormat:@"99"];
    }
    else
    {
        if(count == 0)
        {
            messageBoxTabItem.badgeValue = @"";
        }
        else
        {
            messageBoxTabItem.badgeValue = [NSString stringWithFormat:@"%d", count];
        }
    }
}

@end
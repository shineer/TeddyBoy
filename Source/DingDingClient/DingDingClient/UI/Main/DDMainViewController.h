//
//  DDMainViewController.h
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDTabViewController.h"

@interface DDMainViewController : DDTabViewController<DDTabViewControllerDelegate>
{
    NSArray*    _tabNameArray;
    
    // 当前高亮的tab页
    int         _selectedTabIndex;
}

@property (nonatomic, assign) int selectedTabIndex;

- (void)addNavigationBarButton:(UIButton*)button;

- (void)removeNavigationBarButton:(UIButton*)button;

- (void)updateTabBadge:(NSNotification*)notification;

@end

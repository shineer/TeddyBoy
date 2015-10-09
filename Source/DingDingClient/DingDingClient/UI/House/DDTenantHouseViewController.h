//
//  DDTenantHouseViewController.h
//  DingDingClient
//
//  Created by phoenix on 15/9/9.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBaseViewController.h"
#import "DDMainViewController.h"

@interface DDTenantHouseViewController : DDBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UIButton*               _naviRightButton;
    UITableView*            _tableView;
}

@property (nonatomic, weak) DDMainViewController *parentTabViewController;
@property (nonatomic, strong) UITableView *tableView;

@end

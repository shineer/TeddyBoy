//
//  DDTableViewController.h
//  DingDingClient
//
//  Created by phoenix on 14-10-21.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBaseViewController.h"
#import "AAPullToRefresh.h"

@interface DDTableViewController : DDBaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    AAPullToRefresh* _refreshView;
    AAPullToRefresh* _loadMoreView;
}

@property (nonatomic, weak) UITableView * tableView;
@property (nonatomic, readonly) UITableViewStyle tableViewStyle;
@property (nonatomic, strong) AAPullToRefresh * refreshView;
@property (nonatomic, strong) AAPullToRefresh * loadMoreView;

- (id)initWithStyle:(UITableViewStyle)style;

// 下拉刷新通知
- (void)pullToRefreshTriggered;
// 下拉刷新结束
- (void)pullToRefreshFinished;
// 上拉加载更多通知
- (void)pullToLoadMoreTriggered;
// 上拉加载更多结束
- (void)pullToLoadMoreFinished;

// 重新加载数据
- (void)reloadData;

@end

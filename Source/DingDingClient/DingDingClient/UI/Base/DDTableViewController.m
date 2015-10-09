//
//  DDTableViewController.m
//  DingDingClient
//
//  Created by phoenix on 14-10-21.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDTableViewController.h"

@interface DDTableViewController ()
{
    UITableViewStyle _tableViewStyle;
}

@end

@implementation DDTableViewController

- (id) init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

- (id) initWithStyle:(UITableViewStyle) style
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _tableViewStyle = style;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    CGRect bounds = self.view.bounds;

    CGRect tableRect = CGRectMake(0, 0, bounds.size.width, bounds.size.height);

    UITableView *tableView = [[UITableView alloc] initWithFrame:tableRect style:_tableViewStyle];
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = YES;
    [self.view addSubview:self.tableView];
    
    // 下拉刷新
    _refreshView = [self.tableView addPullToRefreshPosition:AAPullToRefreshPositionTop ActionHandler:^(AAPullToRefresh *v) {
        
        [self pullToRefreshTriggered];
    }];
    _refreshView.imageIcon = [UIImage imageNamed:@"launchpad"];
    _refreshView.borderWidth = 1;
    _refreshView.borderColor = DD_THEME.colorTheme;
   
     // 上拉加载更多
    _loadMoreView = [self.tableView addPullToRefreshPosition:AAPullToRefreshPositionBottom ActionHandler:^(AAPullToRefresh *v){
        
        [self pullToLoadMoreTriggered];
    }];
    _loadMoreView.imageIcon = [UIImage imageNamed:@"launchpad"];
    _loadMoreView.borderWidth = 1;
    _loadMoreView.borderColor = DD_THEME.colorTheme;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.tableView != nil)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tableView setEditing:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark 下拉刷新通知
- (void)pullToRefreshTriggered
{
    UI_LOG(@"pullToRefreshTriggered");
}

#pragma mark 上拉加载更多通知
- (void)pullToLoadMoreTriggered
{
    UI_LOG(@"pullToLoadMoreTriggered");
}

#pragma mark 下拉刷新结束

- (void)pullToRefreshFinished;
{
    UI_LOG(@"pullToRefreshFinished");
    [_refreshView stopIndicatorAnimation];
}

#pragma mark 上拉加载更多结束

- (void)pullToLoadMoreFinished
{
    UI_LOG(@"pullToLoadMoreTriggered");
    [_loadMoreView stopIndicatorAnimation];
}

#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

@end

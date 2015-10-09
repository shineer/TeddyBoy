//
//  DDTenantHouseViewController.m
//  DingDingClient
//
//  Created by phoenix on 15/9/9.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import "DDTenantHouseViewController.h"
#import "DDHotHouseItemCell.h"

@interface DDTenantHouseViewController ()
{
    NSMutableArray* _hotHouseArray;
}

@end

@implementation DDTenantHouseViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        _hotHouseArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customlizeNavigationRightBtn];
    
    [self layout];
}

- (void)layout
{
    CGRect bounds = self.view.bounds;
    
    // table view
    CGRect rect = CGRectMake(0, 0, bounds.size.width, bounds.size.height - DD_THEME.toolBarHeight - DD_THEME.statusBarHeight - DD_THEME.navigationBarHeight);
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.parentTabViewController addNavigationBarButton:_naviRightButton];
    
    // 刷新数据
    [self refreshRecommendHouseList];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.parentTabViewController removeNavigationBarButton:_naviRightButton];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark help function

- (void)customlizeNavigationRightBtn
{
    // 自定义“更多”按钮
    _naviRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _naviRightButton.frame = CGRectMake(DD_THEME.screenWidth - 50.0, 0.0, 50.0, 44.0);
    [_naviRightButton setImage:[UIImage imageNamed:@"nav_btn_filter"] forState:UIControlStateNormal];
    [_naviRightButton setImage:[UIImage imageNamed:@"nav_btn_filter"] forState:UIControlStateHighlighted];
    [_naviRightButton addTarget:self action:@selector(filterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[_naviRightButton setBackgroundColor:[UIColor yellowColor]];
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_naviRightButton];
    rightBarBtnItem.style = UIBarButtonItemStylePlain;
}

#pragma mark private help function

- (void)updateUI
{
    [_tableView reloadData];
}

- (void)refreshRecommendHouseList
{
    [DD_CORE.houseService getRecommendHouse:^(NSInteger result, NSDictionary *dict, DDError *error) {
        
        if(result == EDDResponseResultSucceed)
        {
            // 清空缓存数组
            [_hotHouseArray removeAllObjects];

            NSArray* hotHouseArray = [dict objectForKey:@"data"];
            [self updateHotHouseData:hotHouseArray];

        }
        else if (result == EDDResponseResultFailed)
        {
            if(error)
            {
                [DDHUDVIEW showTips:[NSString stringWithFormat:@"%@", error.errorMsg] autoHideTime:1];
            }
        }
    }];
}

- (void)updateHotHouseData:(NSArray*)array
{
    if([CommonUtils checkNull:array] == nil)
    {
        return;
    }
    
    for(NSDictionary* item in array)
    {
        if([CommonUtils checkNull:item] == nil)
            break;
        
        DDHotHouse* hotHouse = [[DDHouseParser getInstance] parseHotHouseObject:item];
        [_hotHouseArray addObject:hotHouse];
    }
    
    // 更新界面
    [self updateUI];
}


#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_hotHouseArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    height = 340;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* kHotHouseItemCellID = @"HotHouseItemCell";

    UITableViewCell* cell = nil;
    DDHotHouse* hotHouse = [_hotHouseArray objectAtIndex:indexPath.row];
    
    DDHotHouseItemCell* hotHouseItemCell = [tableView dequeueReusableCellWithIdentifier:kHotHouseItemCellID];
    if(hotHouseItemCell == nil)
    {
        hotHouseItemCell = [[DDHotHouseItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHotHouseItemCellID];
    }
    
    [hotHouseItemCell updateCellWithHotHouseObject:hotHouse];
    
    cell = hotHouseItemCell;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark action

- (void)filterBtnClicked:(id)sender
{
    // 筛选按钮
    [AppNavigator openLoginViewController];
}


@end

//
//  DDTableAlert.m
//  DingDingClient
//
//  Created by phoenix on 15-5-23.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import "DDTableAlert.h"

@implementation DDTableAlert

- (id)initWithTitle:(NSString *)title confirmButtonTitle:(NSString *)confirmTitle
{
    if ((self = [super init]))
    {
        _currentIndex = 0;
        
        CGRect rect = CGRectMake(0, 0, DD_THEME.screenWidth, DD_THEME.screenHeight);
        
        self.frame = rect;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        
        CGFloat height = DD_THEME.navigationBarHeight + 6 * DD_THEME.tableItemHeight + DD_THEME.buttonHeight;
        CGRect backgroundViewRect = [UtilFunc centerRect:rect width:DD_THEME.screenWidth - 2 * 25 height:height];
        _backgroundView = [[UIView alloc] initWithFrame:backgroundViewRect];
        _backgroundView.backgroundColor = DD_THEME.colorTheme;
        _backgroundView.layer.cornerRadius = 6;
        [self addSubview:_backgroundView];
        
        CGRect titleRect = [UtilFunc topRect:backgroundViewRect height:DD_THEME.navigationBarHeight offset:0];
        titleRect = CGRectInset(titleRect, 12, 4);
        _title = [[UILabel alloc] initWithFrame:titleRect];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:DD_THEME.fontSizeMiddle];
        _title.textColor = DD_THEME.colorTheme;
        _title.text = title;
        [self addSubview:_title];
        
        CGRect seperaterLineRect = [UtilFunc topRect:backgroundViewRect height:DD_THEME.navigationBarHeight offset:0];
        seperaterLineRect = [UtilFunc bottomRect:seperaterLineRect height:1 offset:0];
        _seperaterLine = [[UIImageView alloc] initWithFrame:seperaterLineRect];
        _seperaterLine.backgroundColor = DD_THEME.colorTheme;
        [self addSubview:_seperaterLine];
        
        height = 6 * DD_THEME.tableItemHeight;
        CGRect tableViewRect = [UtilFunc topRect:backgroundViewRect height:height offset:DD_THEME.navigationBarHeight];
        _tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //_tableView.backgroundColor = [UIColor yellowColor];
        _tableView.showsVerticalScrollIndicator = NO;
        //_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = YES;
        [self addSubview:_tableView];
    
        CGRect confirmBtnRect = [UtilFunc bottomRect:backgroundViewRect height:DD_THEME.buttonHeight offset:0];
        //CGRect confirmBtnRect = [UtilFunc bottomRect:bgView height:PHONE_DEFAULT_BUTTON_HEIGHT offset:0];
        
        UIImage* normalImage = [UIImage imageNamed:@"common_button_angle_normal"];
        normalImage = [normalImage stretchableImageWithLeftCapWidth:floorf(normalImage.size.width / 2) topCapHeight:floorf(normalImage.size.height / 2)];
        UIImage* highlightImage = [UIImage imageNamed:@"common_button_angle_press"];
        highlightImage = [highlightImage stretchableImageWithLeftCapWidth:floorf(highlightImage.size.width / 2) topCapHeight:floorf(highlightImage.size.height / 2)];
        
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = confirmBtnRect;
        [_confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmBtn];
    }
    
    return self;
}


#pragma mark -

- (void)show
{
    [_tableView reloadData];
    
    [APP_DELEGATE.window addSubview:self];
}

#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_dataSource respondsToSelector:@selector(numberOfSectionsInTableAlert:)])
    {
        return [_dataSource numberOfSectionsInTableAlert:self];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_dataSource respondsToSelector:@selector(tableAlert:numberOfRowsInSection:)])
    {
        return [_dataSource tableAlert:self numberOfRowsInSection:section];
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(tableAlert:heightForRowAtIndexPath:)])
    {
        return [_delegate tableAlert:self heightForRowAtIndexPath:indexPath];
    }
    
    return DD_THEME.tableItemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(tableAlert:cellForRowAtIndexPath:)])
    {
        UITableViewCell* cell = [_dataSource tableAlert:self cellForRowAtIndexPath:indexPath];
        
        UIImage* unCheckedImage = [UIImage imageNamed:@"common_icon_unchecked"];
        UIImage* checkedImage = [UIImage imageNamed:@"common_icon_checked"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, checkedImage.size.width, checkedImage.size.height);
        button.frame = frame;
        if(indexPath.row == _currentIndex)
        {
            [button setBackgroundImage:checkedImage forState:UIControlStateNormal];
        }
        else
        {
            [button setBackgroundImage:unCheckedImage forState:UIControlStateNormal];
        }
        
        //[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        cell.accessoryView = button;
        
        return cell;
    }
    
    return nil;
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.row == _currentIndex)
    {
        return;
    }
    
    UIImage* unCheckedImage = [UIImage imageNamed:@"common_icon_unchecked"];
    UIImage* checkedImage = [UIImage imageNamed:@"common_icon_checked"];
    
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:indexPath.section];
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton* button = (UIButton*)newCell.accessoryView;
    [button setBackgroundImage:checkedImage forState:UIControlStateNormal];
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    button = (UIButton*)oldCell.accessoryView;
    [button setBackgroundImage:unCheckedImage forState:UIControlStateNormal];
    
    _currentIndex = indexPath.row;
    
    if ([_delegate respondsToSelector:@selector(tableAlert:didSelectRowAtIndexPath:)])
    {
        [_delegate tableAlert:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark action

- (void)confirmBtnClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(tableAlertConfirm:withCurrentIndex:)])
    {
        [_delegate tableAlertConfirm:self withCurrentIndex:_currentIndex];
    }
    
    [self removeFromSuperview];
}

@end

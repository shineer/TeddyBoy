//
//  DDDropDownList.m
//  DingDingClient
//
//  Created by phoenix on 15-1-5.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import "DDDropDownList.h"
#import "DDDropDownItem.h"

@implementation DDDropDownList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup
{
    _contentArray = nil;
    _isEnableDelete = YES;
    
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 4;
    self.layer.shadowOffset = CGSizeMake(-2, 2);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    
    _maskView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_maskView addTarget:self action:@selector(maskViewClicked:) forControlEvents:UIControlEventTouchUpInside];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self addSubview:_tableView];
}

#pragma mark - Instance Methods

- (void)showInView:(UIView*)aView
{
    CGRect rect = self.frame;
    
    _maskView.frame = aView.bounds;
    //_maskView.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
    [aView addSubview:_maskView];
    [aView addSubview:self];
    
    _tableView.frame = CGRectMake(0, 0, rect.size.width, 0);
    self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 0);
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _tableView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        self.frame = rect;
        
    } completion:^(BOOL finished) {
        
        // do nothing
    }];
}

- (void)dismiss
{
    CGRect rect = self.frame;
     
    [UIView animateWithDuration:0.3 animations:^{
        
        _tableView.frame = CGRectMake(0, 0, rect.size.width, 0);
        self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 0);
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            [_maskView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DD_THEME.tableRowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contentArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DropDownListItemCell";
    
    DDDropDownItem *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[DDDropDownItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:indexPath forKey:@"indexPath"];
    [dict setObject:self forKey:@"dropDownList"];
    [dict setObject:[_contentArray objectAtIndex:indexPath.row] forKey:@"title"];
    [cell updateContent:dict withVC:nil];
    
    if(_isEnableDelete == NO)
    {
        cell.deleteBtn.hidden = YES;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // tell the delegate the selection
    if(self.delegate && [self.delegate respondsToSelector:@selector(dropDownList:didSelectedIndex:)])
    {
        [self.delegate dropDownList:self didSelectedIndex:indexPath.row];
    }

    // dismiss self
    [self dismiss];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - action

- (void)maskViewClicked:(id)sender
{
    // tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownListDidCancel)])
    {
        [self.delegate dropDownListDidCancel];
    }
    
    // dismiss self
    [self dismiss];
}

- (void)itemDeletedAtIndex:(NSInteger)index
{
    // tell the delegate the selection
    if(self.delegate && [self.delegate respondsToSelector:@selector(dropDownList:didDeleteIndex:)])
    {
        [self.delegate dropDownList:self didDeleteIndex:index];
    }

    [_tableView reloadData];
}

@end

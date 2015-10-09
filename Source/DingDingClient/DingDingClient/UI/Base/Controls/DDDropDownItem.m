//
//  DDDropDownItem.m
//  DingDingClient
//
//  Created by phoenix on 15-1-6.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import "DDDropDownItem.h"
#import "DDDropDownList.h"
#import "DDBaseViewController.h"

@implementation DDDropDownItem

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = DD_THEME.colorText;
        _titleLabel.font = [UIFont systemFontOfSize:DD_THEME.fontSizeMiddle];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"drop_down_list_item_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //_deleteBtn.backgroundColor = [UIColor yellowColor];
        [self addSubview:_deleteBtn];
        
        _seperateLine = [[UIImageView alloc] init];
        [_seperateLine setImage:[UIImage imageNamed:@"common_item_dividingline"]];
        [self addSubview:_seperateLine];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;

    CGRect titleRect = CGRectInset(rect, 4, 4);
    _titleLabel.frame = titleRect;
    
    CGRect deleteBtnRect = [UtilFunc rightRect:titleRect width:30 offset:0];
    _deleteBtn.frame = deleteBtnRect;
    
    CGRect seperateLineRect = CGRectMake(12, rect.size.height - 0.5, rect.size.width - 12 * 2, 0.5);
    _seperateLine.frame = seperateLineRect;

}

- (void)updateContent:(NSDictionary*)contentDict withVC:(DDBaseViewController*)viewController
{
    _indexPath = [contentDict objectForKey:@"indexPath"];
    _titleLabel.text = [contentDict objectForKey:@"title"];
    self.dropDownList = [contentDict objectForKey:@"dropDownList"];
}

- (void)deleteBtnClicked:(id)sender
{
    [self.dropDownList itemDeletedAtIndex:_indexPath.row];
}


@end

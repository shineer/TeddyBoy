//
//  DDHotHouseItemCell.m
//  DingDingClient
//
//  Created by phoenix on 15/9/15.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import "DDHotHouseItemCell.h"

@implementation DDHotHouseItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = DD_THEME.colorWhite;
        [self.contentView addSubview:_backgroundView];
        
        _coverImageView = [[DDImageView alloc] init];
        _coverImageView.placeholder = [UIImage imageNamed:@"house_placeholder"];
        [_backgroundView addSubview:_coverImageView];
        
        _priceBgView = [[UIView alloc] init];
        _priceBgView.backgroundColor = RGBCOLORVA(0x000000, 0.5);
        [_backgroundView addSubview:_priceBgView];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = DD_THEME.colorWhite;
        _priceLabel.font = [UIFont systemFontOfSize:DD_THEME.fontSizeMiddle];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [_backgroundView addSubview:_priceLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = DD_THEME.colorBlack;
        _detailLabel.font = [UIFont systemFontOfSize:DD_THEME.fontSizeMiddle];
        [_backgroundView addSubview:_detailLabel];
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = DD_THEME.colorBlack;
        _typeLabel.font = [UIFont systemFontOfSize:DD_THEME.fontSizeSmall];
        [_backgroundView addSubview:_typeLabel];
        
    }
    return self;
}

-(void)layoutSubviews
{
    // 一定要调用父类的函数
    [super layoutSubviews];

    CGRect rect = self.bounds;
    
    CGRect backgroundRect = CGRectInset(rect, DD_THEME.xMargin, DD_THEME.yMargin);
    _backgroundView.frame = backgroundRect;
    
    CGFloat height = 250;
    backgroundRect = _backgroundView.bounds;
    CGRect coverRect = [UtilFunc topRect:backgroundRect height:height offset:0];
    height = backgroundRect.size.height - height;
    CGRect contentRect = [UtilFunc bottomRect:backgroundRect height:height offset:0];
    
    _coverImageView.frame = coverRect;
    
    CGRect pricRect = [UtilFunc bottomRect:coverRect height:40 offset:20];
    pricRect = [UtilFunc leftRect:pricRect width:120 offset:0];
    _priceBgView.frame = pricRect;
    _priceLabel.frame = pricRect;
    
    contentRect = CGRectInset(contentRect, DD_THEME.xMargin, DD_THEME.yMargin);
    height = contentRect.size.height / 2;
    CGRect detailRect = [UtilFunc topRect:contentRect height:height offset:0];
    CGRect typeRect = [UtilFunc bottomRect:contentRect height:height offset:0];
    _detailLabel.frame = detailRect;
    _typeLabel.frame = typeRect;
}

- (void)updateCellWithHotHouseObject:(DDHotHouse*)houseObject
{
    [_coverImageView setImageUrl:houseObject.coverUrl];

    _priceLabel.text = [NSString stringWithFormat:@"%d元/月", houseObject.rent];
    
    NSString *tempStr = [NSString stringWithFormat:@"%d室%d厅", houseObject.roomCount , houseObject.hallCount];
    _detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@", houseObject.bizcircleName, houseObject.resblockName, tempStr];
    
    NSString* str = @"";
    for(id item in houseObject.houseTagList)
    {
        str = [NSString stringWithFormat:@"%@ %@", [APP_CONFIG.houseTagDict objectForKey:item], str];
    }
    _typeLabel.text = [NSString stringWithFormat:@"%@", str];
}


@end

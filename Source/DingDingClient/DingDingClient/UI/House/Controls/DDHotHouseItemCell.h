//
//  DDHotHouseItemCell.h
//  DingDingClient
//
//  Created by phoenix on 15/9/15.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDHotHouseItemCell : UITableViewCell
{
    UIView* _backgroundView;
    DDImageView* _coverImageView;
    UIView* _priceBgView;
    UILabel* _priceLabel;
    UILabel* _detailLabel;
    UILabel* _typeLabel;
}

- (void)updateCellWithHotHouseObject:(DDHotHouse*)houseObject;

@end
